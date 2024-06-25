Famous long context models

- [[@2023ExtendingContextWindowChen|RoPE-PI]] + direct fine-tuning:
    - [[@2023ExtendingContextWindowChen|RoPE-PI]] (up to 32K)
        - base model: Llama1. Data: the Pile. Task: language modeling
        - Eval data: PG-19 / proof-pile. Sliding Window eval stride 256
        - FT 32k, 128 x A100, 1000 steps, 4B token for 32K
    - [LongChat-7B/13B-16K](https://lmsys.org/blog/2023-06-29-longchat/#step-2-finetuning-on-curated-conversation-data)
        - base model: Llama1. Data: Vicuna + [FastChat](https://github.com/lm-sys/FastChat) pipeline. Task: language modeling
        - FT&test 16k
        - cost: A100 \$3/h 7B: \$300 13B: \$700
    - [[@2024LongLoRAEfficientFinetuningChen|LongLoRA]]
        - base model: Llama2
        - settings: 8 x A100, 1000 steps, 2B token for 32K
- [[@2023EffectiveLongContextScalingXiong|ABF]]
    - [[@2023YaRNEfficientContextPeng|YaRN]]
        - base model: Llama2
        - FT 64k, test 128k, 400+200 steps, 2.5B token
    - [[@2023EffectiveLongContextScalingXiong|ABF]]: $b'=\mathrm{500k}=50b$
        - base model: Llama2
        - PT 4k, FT 16k/32k, 100k steps, 400B tokens
    - [[@2024CodeLlamaOpenRoziere|CodeLlama]]：$b'=\mathrm{1M}=100b$
        - base model: Llama2
        - PT 4k, FT 16k, test 100k+, 10k steps, 20B tokens for 13B model
    - [[@2024YiOpenFoundationAI|Yi]]：$b'=\mathrm{5M}=500b$
        - PT 4k, FT 200k (50x)
        - 5B tokens (1-2B就已经足够好)
    - [[@2024ExtendingLLMsContextZhanga|Extending LLMs' Context Window with 100 Samples, 2024]]
    - [[@2024WorldModelMillionLengthLiua|LWM]] (Large World Model): $b'\in[\mathrm{1M},\mathrm{50M}]=[100b,5000b]$
        - base model: Llama2
        - PT 4k, FT 32k\~1M, 34B tokens
    - [[@2024DataEngineeringScalingFu|Data Engineering for Scaling Language Models to 128K Context, 2024]]
    - Llama3: $b=\mathrm{500k}$
- [[@2024LongRoPEExtendingLLMDing|LongRoPE]]
    - base model: Llama2/Mistral
    - FT 256k, search 2M, test 2M
    - FT A100x8



| Name            | BaseModel | Method              | PreTrain |     FineTune     |    Test    | \#Tokens  |
|:--------------- |:--------- | ------------------- |:--------:|:----------------:|:----------:|:---------:|
| Llama2          |           | $b=\mathrm{10k}$    |    4k    |                  |            |           |
| Llama3          |           | $b=\mathrm{500k}$   |    8k    |                  |            |           |
| PI              | Llama1    | PI                  |    2k    |    32k (x16)     |            |    4B     |
| LongLoRA        | Llama2    | PI+PEFT             |    4k    | 32k (x8) \~ 100k |            |    2B     |
| YaRN            | Llama2    | $b'=f(s,\lambda_i)$ |    4k    |    64k (x16)     | 128k (x32) |   2.5B    |
| Llama2Long(ABF) | Llama2    | $b'=\mathrm{500k}$  |    4k    |     32k (x8)     |            |   400B    |
| CodeLlama       | Llama2    | $b'=\mathrm{1M}$    |    4k    |     16k (x4)     |   100k+    |    20B    |
| LWM             | Llama2    | $b'=\mathrm{5M}$    |    4k    |  32k\~1M (x250)  |            |    34B    |
| Yi              | Yi        | $b'=\mathrm{50M}$   |    4k    |    200k (x50)    |            | 5B(1\~2B) |
