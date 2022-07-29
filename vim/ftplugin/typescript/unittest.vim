vim9script

if exists("g:loaded_js_unittest_runner")
    # finish
    var a = 1
endif
g:loaded_js_unittest_runner = 1


var testRunner = "npx jest"
var defaultArgs = "--no-colors --detectOpenHandles"
var outputPaneHeight = 10
var srcDir = "src"
var testsDir = "test"


def TestRunnerAvailable(): number
    :silent systemlist($"{testRunner} --version")

    if v:shell_error == 0
        return 1
    else
        return 0
    endif
enddef

def CommandUnittestRun(scope: string)
    if TestRunnerAvailable() == 0
        echo $"unable to find {testRunner}..."
        return
    endif

    if scope == 'contextual'
        TestContextual()
    endif

    if scope == 'file'
        TestFile()
    endif

    if scope == 'linked-test-module'
        TestLinkedTestModule()
    endif
enddef

def TestContextual()
    if stridx(expand('%'), $"{testsDir}/") == 0
        TestFile()
    else
        TestLinkedTestModule()
    endif
enddef

def TestFile()
    var results = ExecuteTestRunner(expand('%'))
    ShowOutput(results)
enddef

def TestLinkedTestModule()
    var sourceFileName = expand('%:r')
    var sourceFileExt = expand('%:e')

    var testFileName = substitute(sourceFileName, srcDir, testsDir, "")
    var testFile = $"{testFileName}.test.{sourceFileExt}"
    if !filereadable(testFile)
        echo $"Test file {testFile} does not exist"
        return
    endif

    echo $"Attempting to excute pytest {testFile}"

    var results = ExecuteTestRunner(testFile)
    ShowOutput(results)
enddef


def ExecuteTestRunner(args: string): list<string>
    var output = systemlist($"{testRunner} {defaultArgs} {args}")
    var clean = output->map((_, x) => substitute(x, '\v[\d+m', "", "g"))
    return clean[0 : -1]
enddef


def ShowOutput(output: list<string>)
    # Store current buffer so when can switch back to it
    g:pytestRunCurWinnr = bufwinnr("%")
    augroup PytestRun
        autocmd!
        autocmd BufEnter *.test call InitKeymaps()
        autocmd BufLeave *.test execute $":{g:pytestRunCurWinnr} wincmd w"
    augroup END

    var winnr = bufwinnr("Output.test")
    silent! execute winnr < 0 ? "bot :10new Output.test" : $":{winnr} wincmd w"
    # execute "bot :10new Output.test"
    setlocal buftype=nowrite bufhidden=delete nobuflisted noswapfile nowrap nonumber #filtype=pytest

    # var cleanLines = output->map((_, val) => trim(val))
    execute "normal ggdG"
    append(0, output)
    execute "normal dd"
    UnittestSyntax()
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


def UnittestSyntax()
    hi def link ExecHeader      Comment
    hi def link ExecFooter      Comment
    hi def link FailureHeader   Function
    hi def link FileName        Function
    hi def link CodeSnippet     Comment
    hi def link FailureFooter   Comment

    hi def Success              ctermfg=green
    hi def Failure              ctermfg=red
    hi def SlowTest             ctermfg=red

    hi def link TestSuccess     Success
    hi def link TestFailure     Failure

    syn clear
    syntax include @Typescript syntax/typescript.vim
    syn sync fromstart

    syn match ExecHeader        '\v^(PASS|FAIL) .*'
    syn match FileName          '\v(\f+\.(js|ts))' containedin=ExecHeader
    syn match Success           '\v^PASS' contained containedin=ExecHeader
    syn match Failure           '\v^FAIL' contained containedin=ExecHeader

    syn match TestResult        '\v^\s+([✓✕] .*)'
    syn match TestSuccess       '\v(✓)' contained containedin=TestResult
    syn match TestFailure       '\v(✕)' contained containedin=TestResult
    syn match SlowTest          '\v(\([1-9]\d{1,} ms\))' contained containedin=TestResult


    syn match FailureHeader     '\v^\s+(● .*)'
    syn match CodeSnippet       '\v^\s+(\>\s+)?((\d+)?\s+\|).*'
    syn region RTypescript      matchgroup=CodeSnippet start=+| + keepend end="$" contained containedin=CodeSnippet contains=@Typescript
    # syn match Typescript        '\v.*' contained containedin=CodeSnippet contains=@Typescript
    syn match Failure           '\v\s(\>)\s' contained containedin=CodeSnippet
    syn match Failure           '\v(\^)' contained containedin=RTypescript
    syn match FailureFooter     '\v^\s+(at .*)$' contains=FileName

    syn match Success           '\v(\d{1,} passed)'
    syn match Failure           '\v(\d{1,} failed)'
    syn match ExecFooter        '\v^Ran all test suites matching .*'
enddef


:command RefreshUnittestRun :source /Users/brendan.studds/.dotfiles/vim/ftplugin/typescript/unittest.vim
:noremap <Leader>dd :RefreshUnittestRun<CR>
:command -nargs=0 UnittestReSyntax :call UnittestSyntax(<f-args>)

def InitKeymaps()
    :nnoremap <nowait> <silent> <buffer> <leader>c :bd<CR>
    :nnoremap <nowait> <buffer> <leader>ds :RefreshUnittestRun<CR>:UnittestReSyntax<CR>
enddef

:command -nargs=1 TestRun :call CommandUnittestRun(<f-args>)
:nnoremap <silent> <Leader>tf :TestRun file<CR>
:nnoremap <silent> <Leader>tt :TestRun contextual<CR>

:defcompile
