" Emmet - HTML/JSX 'autocompletion'
" %h2#tagline.hero-text => <h2 id=tagline class=hero-text></h2>
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript EmmetInstall

let g:user_emmet_settings={
    \ 'javascript.js': { 'extends': 'jsx' },
    \ 'javascript.jsx': { 'extends': 'jsx' }
\ }


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

au VimEnter * call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
au VimEnter * call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('html', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
au VimEnter * call NERDTreeHighlightFile('coffee', 'red', 'none', 'red', '#151515')
au VimEnter * call NERDTreeHighlightFile('js', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('o', 'grey', 'none', 'grey', '#151515')
au VimEnter * call NERDTreeHighlightFile('cpp', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('h', 'cyan', 'none', 'cyan', '#151515')

let NERDTreeIgnore = [ '\.swp' ]


" Syntasic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_aggregate_errors=1 " Something I had?

let g:syntastic_javascript_checkers = [ 'eslint' ]
let g:syntastic_python_checkers = [ 'pylint' ]
let g:syntastic_sh_checkers = [ 'shellcheck' ]
let g:syntastic_typescript_checkers = [ 'eslint' ]

let g:syntastic_sh_shellcheck_args = "-x"

" Point syntastic checker at locally installed `eslint` if it exists.
fun! s:SetSyntasticEslintExec()
  let b:syntastic_javascript_eslint_exec = findfile('node_modules/.bin/eslint', '.;')
endfunction
autocmd FileType javascript exec s:SetSyntasticEslintExec()
