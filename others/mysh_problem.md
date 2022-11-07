## 问题描述

下面是一段简易的 shell 实现 <u>sh.c</u> ：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAXN 1000
char buf[MAXN];
FILE *input;

int get_cmd() {
    if (fgets(buf, MAXN, input) == NULL) return 0;
    buf[strlen(buf) - 1] = '\0';  // trim \n
    return 1;
}

int main(int argc, char *argv[]) {
    input = stdin;
    if (argc > 1)
        input = fopen(argv[1], "r");

    while (1) {
        if (!get_cmd()) break;
        puts(buf);  // print cmd
        // fflush(input);
        int rc = fork();
        if (rc == 0) {
            // fclose(input);
            char *argv[] = {buf, NULL};
            execvp(buf, argv);
            perror("exec");
            // _exit(1);
            exit(1);
        }
        wait(NULL);
    }

    return 0;
}
```

对于输入文件 <u>test.in</u> ：

```
abcdefgh
uname

```

运行：

```
$ gcc sh.c -o sh -Wall -Werror
$ ./sh test.in
abcdefgh
exec: No such file or directory
uname
Linux
uname
Linux
```

似乎，第二行被重复读取了两次。

## 解决方案

根据 [这个回答](https://stackoverflow.com/a/55857907) ，下面两种方案都可以

1. 子进程中关闭输入文件 `fclose(input);`
2. 用 `_exit(1);` 替换 `exit(1);`

实际上，

3. 在 fork 之前 `fflush(input);` ，即刷新输入文件的缓冲区，也是可以的。

## 背景

### \_exit vs exit

`_exit` 是系统调用： `man 2 exit` ，直接进入操作系统

`exit` 是库函数： `man 3 exit` ，首先会做一些清理操作，包括**刷新缓冲区**和关闭文件等，然后再执行系统调用 `_exit`

### fflush 与缓冲区

`fflush` 会刷新（用户态）缓冲区。通常的使用场景： `fflush(output_stream)` 。网上大部分回答都说 `fflush(stdin)` 是未定义行为，然而在 [这个回答](https://stackoverflow.com/a/17320296) 的评论中提到最新的标准是良定义的……坑++

 [POSIX.1-2008](https://pubs.opengroup.org/onlinepubs/9699919799/functions/fflush.html) 中定义了 `fflush(input_stream)` 的行为：

> For a stream open for reading ... , the file offset of the underlying open file description shall be set to the file position of the stream.

`fflush` 的参数是 `FILE*` （buffered stream，`man stdio`，FILE pointer，fp），`FILE*` 的底层包含文件描述符（file descriptor，fd），两者的偏移量（offset）不一定相同，因为 `FILE*` 中包含（用户态）缓冲区。例如：

- 库函数 `fgets` 通过系统调用 `read` 从文件描述符中读取 4096B（缓冲区大小）的数据，存在（用户态）缓冲区中，然后取其中的第一行返回给用户，此时 fp 的 offset 在第一行结尾，fd 的 offset 在第一页（4096B）结尾。
- 库函数 `printf` 将输出写入（用户态）缓冲区，待时机成熟~~（略 100 字）~~，通过 `write` 系统调用写入底层 fd

`FILE*` 中的（用户态）缓冲区是在库函数中（用户态）维护的，而文件描述符的 offset 是由操作系统（内核态）维护的。

`fflush` 会使两者 offset 同步（把 fd 的 offset 修改为 stream 的 offset，通过 `lseek` 系统调用修改 fd 的 offset）。

## 为什么是未定义

根据 [标准 2.5.1 节](https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html) ，在子进程中， `exit` 的刷新缓冲区的操作，与父进程的文件指针冲突，是未定义行为（ [undefined behavior](https://en.wikipedia.org/wiki/Undefined_behavior) ，UB）。

因为 `fork` 会复制文件指针/文件描述符（在标准中称为 handle），导致父子进程之间的 handle 产生冲突。所以：

1. 要么，确保子进程（或者父进程）不会影响到文件偏移量（offset），于是不影响另一个进程的文件操作，不产生冲突。

   - > A file descriptor that is never used in an operation that could affect the file offset (for example, [*read*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/read.html) , [*write*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html) , or [*lseek*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/lseek.html) ) is not considered a handle for this discussion, ...

2. 要么，（由于不能保证父子进程哪一个先执行）在 `fork` 之前，执行指定的操作，以使得新的进程可以安全地接手 handle。

   - > Note that after a [*fork*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/fork.html) , two handles exist where one existed before. The application shall ensure that, if both handles can ever be accessed, they are both in a state where the other could become the active handle first. The application shall prepare for a [*fork*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/fork.html) exactly as if it were a change of active handle.

否则，后续文件操作的结果是未定义的。

具体来说：

1. 如果 `fork()` 之后，子进程只会 `exec` 或 `_exit()` ，那么不会影响到 offset

  - > If the only action performed by one of the processes is one of the * [exec](https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html) * functions or [*_exit*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/_exit.html) (not [*exit*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/exit.html) ), the handle is never accessed in that process.

  - `exec` 对应 `execvp` 成功执行的情况，根据 `man execvp`，如果函数成功执行，则不会返回。标准中提到， `exec` 会使所有 handle 不可达（这就是为什么成功执行的命令不会有影响）

    - > The * [exec](https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html) * functions make inaccessible all streams that are open at the time they are called, independent of which streams or file descriptors may be available to the new process image.

  - `_exit` 对应 `execvp` 执行失败的情况，`execvp` 失败后，函数返回，需要通过 `_exit` 正确地退出（这就是解决方案#2）。标准中明确指出不能用 `exit` ，库函数 `exit` 内部执行的 `fflush` 修改了缓冲区，影响到文件描述符的 offset，引发未定义行为。

2. 在 `fork()` 之前，手动刷新缓冲区 `fflush(input_stream)` （解决方案#3），或者确保缓冲区已经刷新，或者关闭文件（这一点不是为 `fork` 的情况写的）。

   - > If the stream is open with a mode that allows reading ... , the application shall either perform an [*fflush*()](https://pubs.opengroup.org/onlinepubs/9699919799/functions/fflush.html) , or the stream shall be closed.

TODO：我在标准中找不到为什么子进程关闭文件可行（可能是我的理解不对）

## 未定义的结果

通常不会去探讨某个未定义行为的具体表现，未定义行为的具体表现取决于（库函数的）实现——标准没有“定义”这些情况下，库函数有什么行为，所以换个版本就有可能有不同的行为。

不过我发现，在 [我的库函数版本](https://stackoverflow.com/questions/9705660/check-glibc-version-for-a-particular-gcc-compiler) 下（Ubuntu GLIBC 2.35-0ubuntu3.1），这些表现是可以理解的。

考虑 `fork` 之后，文件指针/描述符的行为：

- `FILE*` 是**用户（库函数）**维护的， `fork` 之后复制，但不共享，各自独立。
- 文件描述符（及其 offset）是**内核**维护的（通过 `read write lseek` 接口暴露给用户）， `fork` 之后共享同一个（内核中的）file description。由操作系统管理：`man fork` `man dup`（当然，操作系统会保证读写操作的原子性，不会有并发问题）。

看到吗？fd 共享，fp 不共享。一旦子进程触发 `fflush` ，前文提到，`fd.offset = fp.offset` 。于是子进程修改了共享的 fd，父进程受到影响。

以开头的输入文件为例：

- 父进程调用 `fgets`：
  - `fgets` 通过系统调用 `read` 读取到整个文件（实际上是读取缓冲区大小 4096B，但文件小于缓冲区大小），放入缓冲区，然后选取第一行 `abcdefgh \n`，作为 `fgets` 读取到的内容，返回给用户。
  - 此时 fp.offset 在第一行结尾，fd.offset 在文件结尾（第二行结尾）
- 子进程：
  - 通过系统调用 `execvp` 执行 `abcdefgh` 命令，由于命令不存在，`execvp` 返回
  - 执行 `exit`：
    - 库函数 `exit` 内调用 `fflush`：
      - 库函数 `fflush` 通过系统调用 `lseek` 修改 fd.offset 为 fp.offset，而 fp.offset 是第一行结尾（子进程复制了父进程 offset）。
    - `exit` 执行其他操作，最后调用 `_exit` 系统调用，子进程退出。没有人关心子进程的 fp 是什么情况，但是
- 父进程的 fd 被子进程通过 `lseek` 修改为第一行结尾。现在父进程看到了什么？父进程的缓冲区内有 uname（第二行），而且 fd 没有读完（还剩 `uname \n`）。于是父进程最终可以读到 `abcdefgh \n uname \n uname \n`。具体是：
  - 父进程第二次调用 `fgets`，库函数 `fgets` 发现缓冲区内还有一行，将该行返回给用户。（然后父进程创建子进程，执行 `uname`）
  - 父进程第三次调用 `fgets`，缓冲区为空，`fgets` 尝试 `read`，成功读取到一行 `uname \n`，返回给用户（然后再次执行 `uname`）
  - 父进程第四次调用 `fgets`，缓冲区为空，`fgets` 尝试 `read`，读取到 EOF，`fgets` 返回 `NULL` 表示 EOF
  - 父进程结束

以上行为是肉眼可见的（字面意思）。`strace` 可以监控某个命令的系统调用流程，如：

```bash
strace -f ./sh test.in
```

表示执行 `./sh test.in`，并监控这次执行中的所有系统调用。`-f` 表示跟踪子进程。

有一些系统调用我们并不关心，所以可以筛选出我们想要的系统调用：

```bash
strace -f ./sh test.in 2>&1 >/dev/null | grep --color=always -E 'read\(|write|open|dup|close|fcntl|clone|wait|exec|exit|lseek'
```

从 trace 中可以看到：

- 父进程中 `fgets` 的调用过程，以及用户态缓冲区状态（通过 `read` 推断）
- 第一次子进程执行过程中，确实有一个 `lseek(3, -6, SEEK_CUR) = 9`，这恰好是第一行末尾，也是用户态 offset 的位置（3 是输入文件 fd）
- ……

修改代码重新 trace，可以看到不同情况下的系统调用序列，证实每个解决方案的底层原理。

也可以从 trace 中看到一些其他行为：

- execvp 反复调用 execve，探测命令是否存在
- 成功执行的子进程中不涉及 close(3)，因为标准说不可见，但是 fd=3 仍然在子进程中存在，因为 open 的下一个文件是 fd=4
- ……

最后需要说明，虽然可以看到并稳定复现上述行为，但是 `lseek` 仍然是未定义行为，标准规定文件 handle 不能冲突，库函数甚至可以将这一点作为基本假设，进行优化，做出意料之外的举动。所以任何程序不能依赖未定义行为。

## 延伸

一切都是 `fork` 的锅 [A fork() in the road](https://dl.acm.org/doi/10.1145/3317550.3321435) （ [jyy](http://jyywiki.cn/OS/2022/slides/26.slides#/4/6) 推荐阅读）

`fork` 设计地很好，但也有很多局限性。
