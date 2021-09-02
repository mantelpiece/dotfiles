" Close vim if nerdtree is the only thing open.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


" Fix up some file types
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.sum set filetype=sum
autocmd BufNewFile,BufRead *.gradle set filetype=groovy
autocmd BufReadPost Dockerfile* set ft=Dockerfile


" Causes <> in substitutions to misbehave?
autocmd FileType python,javascript,json autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd FileType yaml setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4
