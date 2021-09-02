""""""""""""""""""""""""""""EDITOR SETTINGS""""""""""""""""""""""""""""
set encoding=utf8

syntax enable

set autowrite


let s:uname = system("uname -a")
if (empty($TMUX))
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
elseif s:uname =~ "Darwin"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
elseif s:uname =~ "microsoft"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[2 q"
end

set tabstop=4
set shiftwidth=0 " Use the value of tabstop for shiftwidth
set softtabstop=0
set autoindent
set expandtab
set smartindent


" Display whitespace
set list
set listchars=tab:•·,trail:·

" Gutter
set number
set cursorline
set signcolumn=yes

" Maybe use base16 doodads?
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif

" Override highlight for matching parenthesis. 208 is an orange colour
hi MatchParen ctermbg=bg ctermfg=208

" Highlight characters outside the 80col border
"highlight rightMargin ctermbg=grey guibg=grey ctermfg=black guifg=black
"match rightMargin /.\%>104v/
