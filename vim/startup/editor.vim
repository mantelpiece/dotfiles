""""""""""""""""""""""""""""EDITOR SETTINGS""""""""""""""""""""""""""""
scriptencoding utf8

syntax enable

set autowrite

set encoding=utf8

set tabstop=4
set shiftwidth=0 " Use the value of tabstop for shiftwidth
set softtabstop=0

" Display whitespace
set list
set listchars=tab:•·,trail:·

set autoindent
set expandtab
set smartindent

set number
" set cursorline

" Maybe use base16 doodads?
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif
" colorscheme Tomorrow-Night-Eighties
" Override highlight for matching parenthesis. 208 is an orange colour
hi MatchParen ctermbg=bg ctermfg=208

" Highlight characters outside the 80col border
"highlight rightMargin ctermbg=grey guibg=grey ctermfg=black guifg=black
"match rightMargin /.\%>104v/
