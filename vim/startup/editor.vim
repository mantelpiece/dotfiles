""""""""""""""""""""""""""""EDITOR SETTINGS""""""""""""""""""""""""""""

syntax enable

set encoding=utf8

set tabstop=4
set shiftwidth=0 " Use the value of tabstop for shiftwidth
set expandtab
set smartindent
set autoindent

set number
" set cursorline

" Maybe use base16 doodads?
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif
" colorscheme Tomorrow-Night-Eighties

" Highlight characters outside the 80col border
"highlight rightMargin ctermbg=grey guibg=grey ctermfg=black guifg=black
"match rightMargin /.\%>104v/
