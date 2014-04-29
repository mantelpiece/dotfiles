set nocompatible

" Initialise Vundle

filetype off " Required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

" Configure plugins
Plugin 'gmarik/Vundle.vim'

Plugin 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'

call vundle#end()
filetype plugin indent on

syntax on
set showmatch

" Configure CtrlP plugin
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" Configure nerdtree
map <Tab> :NERDTreeToggle<CR>
" Close vim if nerdtree is the only thing open.
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

filetype on
filetype indent on
filetype plugin on

" Make sure make files use tab characters
autocmd Filetype make setlocal noexpandtab
autocmd Filetype make setlocal softtabstop=0

" Fix up some file types
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.sum set filetype=sum

colorscheme default

set hlsearch
set incsearch
set history=50

set backspace=2
set tabstop=2
set shiftwidth=2
set smartindent
set et

set showmode
set showcmd
set number 
set ruler
set nowrap

" Highlight stuff outside the 80col border
highlight rightMargin ctermbg=grey guibg=grey ctermfg=black guifg=black
match rightMargin /.\%>72v/


" In case I use the netrw file browser
let g:netrw_liststyle=3

