" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" map o to explicit <Enter> key press to trigger some markdown auto fill
" but it seems not working in obsidian
" nmap o A<CR>

" Yank to system clipboard
" set clipboard=unnamed

" unmap to make ctrl+c work as system copy (Windows)
unmap <C-c>
iunmap <C-c>

" Surround text with [[ ]] to make a wikilink
" NOTE: must use 'map' and not 'nmap'
exmap wiki surround [[ ]]
exmap hwiki surround [[# ]]
map [[ :wiki
map [# :hwiki
