" Backspace
set backspace=indent,eol,start

" Buffers
set hidden " I think this lets you change without saving

" Colours
set t_ut=
set t_Co=256

" Command line
set wildmenu
set wildmode=longest:full,full

" Timeouts - 3s on mappings, 0.5s on keycodes
set timeout timeoutlen=3000 ttimeoutlen=100
set laststatus=2

" Mouse
set ttymouse=xterm2
set mouse=a


" Search
set grepprg=ack " use ack for grep
set incsearch
set magic " use magic with regexs
set noshowmatch " do not show matching braces

" Window
set scrolloff=7

" Disable error bells.
set noerrorbells
set novisualbell
set t_vb=


" Wrapping
set wrap
set linebreak
set breakindent
set showbreak=..
