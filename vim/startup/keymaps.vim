""""""""""""""""""""""""""""KEY MAPS"""""""""""""""""""""""""""""""

let mapleader=","


" Vim

" C-c is _not_ the same as Esc to exit insert mode. <C-[> is but there's no
" way I'm fixing that habit now. Double <Esc> to avoid delay waiting for
" another char if there is a mapping with <Esc>
inoremap <C-c> <Esc><Esc>

noremap <silent> <Leader>c :bd<CR>
noremap <silent> <Leader>q :xall<CR>
noremap <Leader>ve :e ~/.vimrc<CR>
noremap <Leader>vr :source ~/.vimrc<CR>:PlugInstall<CR>:bd<CR>:exe ":echo 'vimrc reloaded'"<CR>"


" Files and file navigation
noremap <silent> <Leader>ff :NERDTreeToggle <CR>
noremap <silent> <Leader>fc :NERDTreeFind<CR>
"noremap <silent> <Leader>fz :FZF<CR>
noremap <silent> <Leader>fz :Files<CR>
" noremap <silent> <Leader>ft :TagbarToggle<CR>

" Buffers
noremap <Leader>b :buffers<CR>:buffer<Space>


" Clipboard
noremap <silent> <Leader>xc "+y
noremap <silent> <Leader>xp "+p
noremap <silent> <Leader>xP "+P


" Errors
noremap <silent> <Leader>en :cnext<CR>
noremap <silent> <Leader>ep :cprev<CR>

noremap <silent> <leader>ln :ALENext<cr>
noremap <silent> <leader>lp :ALEPrevious<cr>


" Syntax viewing
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" Git
nnoremap <leader>gr :Greview<cr>


" Spelling
noremap <leader>ss :setlocal spell! spelllang=en_au<cr>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=


" Vimwiki
noremap <silent> C-<cr> :VimwikiVSplitLink 1 1<cr>
noremap <silent> S-<cr> :VimwikiSplitLink 1 1<cr>
