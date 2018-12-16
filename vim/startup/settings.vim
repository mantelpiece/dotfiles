" Backspace
set backspace=indent,eol,start

" Buffers
" set hidden " I'm not sure what this does? 'Hide buffers when they are
" abandoned'?
"
" Colours
set t_ut=
set t_Co=256

" Command line
set wildmenu
set wildmode=longest:full,full

" Timeouts - 3s on mappings, 0.5s on keycodes
set timeout timeoutlen=3000 ttimeoutlen=100
set laststatus=2
let g:airline_powerline_fonts=1

" Search
set grepprg=ack " use ack for grep
set incsearch
set magic " use magic with regexs
set noshowmatch " do not show matching braces

" Window
" Lines to the cursor when scrolling via j/k
set so=7

" Disable error bells.
set noerrorbells
set novisualbell
set t_vb=


" Wrapping
set wrap
set linebreak
set breakindent
set showbreak=..
