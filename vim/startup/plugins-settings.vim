" ALE
let g:ale_fix_on_save = 1

let g:ale_fixers = {}
let g:ale_fixers.python = ['black']

let g:ale_linters = {}
let g:ale_linters.python = ['pylint']

let g:ale_pattern_options = {
    \ '\.cfn\.yml$': { 'ale_linters': ['cfn-lint'], 'ale_fixers': [] }
    \ }




" Fugitive
" Review staged hunks
command! Greview :Git! diff --staged

" lightline
let g:lightline = {
    \ 'colorscheme': 'wombat'
    \ }


" indentLine
let g:indentLine_char = '⦙'


" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'


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
au VimEnter * call NERDTreeHighlightFile('py', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('js', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('jsx', 'yellow', 'none', 'yellow', '#151515')

au VimEnter * call NERDTreeHighlightFile('cpp', 'yellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('h', 'darkyellow', 'none', 'cyan', '#151515')

" Specs
au VimEnter * call NERDTreeHighlightFile('.spec.js', 'darkyellow', 'none', 'yellow', '#151515')
au VimEnter * call NERDTreeHighlightFile('test*.py', 'darkyellow', 'none', 'yellow', '#151515')

" Generated
au VimEnter * call NERDTreeHighlightFile('o', 'grey', 'none', 'grey', '#151515')

let NERDTreeIgnore = [ '\.swp', '__pycache__', 'node_modules' ]


" Vimwiki
" Markdown syntax
let g:vimwiki_list = [{'path': '~/vimwiki/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" Diary template
au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template.sh '%'
