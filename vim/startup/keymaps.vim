""""""""""""""""""""""""""""KEY MAPS"""""""""""""""""""""""""""""""

let mapleader=","

" Vim
noremap <silent> <Leader>c :b#\|bd#<CR>
noremap <silent> <Leader>q :xall<CR>
noremap <Leader>v :e ~/.vimrc<CR>
noremap <Leader>vr :source ~/.vimrc<CR>:PlugInstall<CR>:exe ":echo 'vimrc reloaded'"<CR>"


" Files and file navigation
noremap <silent> <Leader>f :NERDTreeToggle <CR>
noremap <silent> <Leader>fc :NERDTreeFind<CR>
noremap <silent> <Leader>ff :CtrlP<CR>
noremap <silent> <Leader>ft :TagbarToggle<CR>


" Errors
noremap <silent> <Leader>en :cnext<CR>
noremap <silent> <Leader>ep :cprev<CR>


" Git
nnoremap <leader>gr :Greview<cr>


" Spelling
noremap <leader>ss :setlocal spell! spelllang=en_au<cr>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=
