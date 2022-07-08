vim9script



if exists('g:loaded_pytest_runner')
    # finish
    var a = 1
endif
g:loaded_pytest_runner = 1


# v: predefined by Vim
# g: global
# b: local to buffer
# w: local to window

# $NAME: environment variable
# &name: option value
# @r:    register contents

var pytest = 'pytest'
var outputPaneHeight = 10
var testsDir = "tests"


def PytestAvailable(): number
    :silent systemlist($"hash {pytest}")

    if v:shell_error == 0
        return 1
    else
        return 0
    endif
enddef

def CommandPytestRun(scope: string)
    if PytestAvailable() == 0
        echo "unable to find pytest..."
        return
    endif

    if scope == 'file'
        PytestFile()
    endif

    if scope == 'linked-test-module'
        PytestLinkedTestModule()
    endif
enddef


def PytestFile()
    var results = ExecutePytest(expand('%'))
    ShowOutput(results)
    GreenBar()
enddef

def PytestLinkedTestModule()
    var sourceFilePath = expand('%:h')
    var sourceFileName = expand('%:t')

    var testFile = $"{testsDir}/{sourceFilePath}/test_{sourceFileName}"
    if !filereadable(testFile)
        echo $"Test file {testFile} does not exist"
        return
    endif

    echo $"Attempting to excute pytest {testFile}"

    var results = ExecutePytest(testFile)
    ShowOutput(results)
    GreenBar()
enddef


def ExecutePytest(args: string): list<string>
    var output = systemlist($"pytest {args}")
    return output[0 : -1]
enddef


def ShowOutput(output: list<string>)
    g:pytestRunCurWinnr = bufwinnr("%")
    augroup PytestRun
        autocmd!
        autocmd BufLeave *.pytest execute $":{g:pytestRunCurWinnr} wincmd w"
        autocmd BufEnter *.pytest call InitKeymaps()
    augroup END

    var winnr = bufwinnr("Output.pytest")
    #silent! execute winnr < 0 ? "botright new Output.pytest" : $"{winnr} wincmd w"
    execute "bot :10new Output.pytest"
    setlocal buftype=nowrite bufhidden=delete nobuflisted noswapfile nowrap nonumber #filtype=pytest

    var cleanLines = output->map((_, val) => trim(val))
    append(0, cleanLines)
    execute "normal dd"
    PytestSyntax()
enddef


# Example of stuff
def RedBar()
    redraw
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ", &columns - 1)
    echohl
enddef

# Example of stuff
def GreenBar()
    redraw
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ", &columns - 1)
    echohl
enddef


def PytestSyntax()
    hi def link PytestHeader        String
    hi def link PytestDecorator     Comment
    hi def link PytestPlatform      String
    hi def link PytestFooter        String

    hi def PytestUnitSuccess        ctermfg=green
    hi def PytestUnitFailure        ctermfg=red

    syn clear
    syn sync fromstart
    syn match PytestHeader          '\v^\s+(test session starts)\s+$'
    syn match PytestDecorator       '\v(\={2,})'
    syn match PytestPlatform        '\v^(platform(.*))'
    syn match PytestFooter          '\v\s+((.*) passed in (.*))\s+'
    syn match PytestResultLine      '\v(.*\s+[.]+\s+\[\d{1,3}\%\])'
    syn match PytestUnitSuccess     '\v(\.)' contained containedin=PytestResultLine
    syn match PytestUnitFailure     '\v.*\s+(f|F)' contained containedin=PytestResultLine
enddef


def InitKeymaps()
    nnoremap <nowait> <silent> <buffer> <leader>c :bd<CR>
enddef


:command -nargs=1 PytestRun :call CommandPytestRun(<f-args>)
:noremap <silent> <Leader>tf :PytestRun file<CR>
:noremap <silent> <Leader>tt :PytestRun linked-test-module<CR>


:defcompile
# ShowOutput(["1", "2"])
:command RefreshPytestRun :source /Users/brendan.studds/.dotfiles/vim/ftplugin/python/pytest.vim
:noremap <Leader>dd :RefreshPytestRun<CR>
