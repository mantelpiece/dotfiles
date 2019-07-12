" Fugitive
" Review staged hunks
command! Greview :Git! diff --staged

" lightline
let g:lightline = {
    \ 'colorscheme': 'wombat'
    \ }


" NERD tree configuration
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

" Docs
au VimEnter * call NERDTreeHighlightFile('md', 'magenta', 'none', '#3366FF', '#151515')
au VimEnter * call NERDTreeHighlightFile('json', 'magenta', 'none', 'yellow', '#151515')

" Web
au VimEnter * call NERDTreeHighlightFile('html', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')

" Source
au VimEnter * call NERDTreeHighlightFile('js', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('jsx', 'yellow', 'none', 'yellow', '#151515')

au VimEnter * call NERDTreeHighlightFile('cpp', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('h', 'darkyellow', 'none', 'cyan', '#151515')

" Specs
au VimEnter * call NERDTreeHighlightFile('.spec.js', 'darkyellow', 'none', 'yellow', '#151515')

" Generated
au VimEnter * call NERDTreeHighlightFile('o', 'grey', 'none', 'grey', '#151515')

let NERDTreeIgnore = [ '\.swp' ]



" Vimwiki diary template
au BufNewFile ~/vimwiki/diary/*.wiki :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'
