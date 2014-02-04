set nocp

filetype on
filetype indent on
filetype plugin on

autocmd Filetype make setlocal noexpandtab
autocmd Filetype make setlocal softtabstop=0

autocmd BufNewFile,BufRead *.sum set filetype=sum

syntax on
set showmatch

colorscheme default

set hlsearch
set incsearch
set history=50

set backspace=2
set tabstop=4
set shiftwidth=4
set smartindent
set et

set showmode
set showcmd
set number 
set ruler
set nowrap

" initialise pathogen?
"call pathogen#infect()


" Highlight stuff outside the 80col border
highlight rightMargin ctermbg=grey guibg=grey ctermfg=black guifg=black
match rightMargin /.\%>72v/


" In case I use the netrw file browser
let g:netrw_liststyle=3

