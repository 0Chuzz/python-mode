let g:pymode_version = "0.6.3"

com! PymodeVersion echomsg "Current python-mode version: " . g:pymode_version

" OPTION: g:pymode -- bool. Run pymode.
if pymode#Default('g:pymode', 1) || !g:pymode
    " DESC: Disable script loading
    finish
endif

" DESC: Check python support
if !has('python')
    echoerr expand("<sfile>:t") . " required vim compiled with +python."
    let g:pymode_lint       = 0
    let g:pymode_rope       = 0
    let g:pymode_path       = 0
    let g:pymode_doc        = 0
    let g:pymode_run        = 0
    let g:pymode_virtualenv = 0
endif


" Virtualenv {{{

if !pymode#Default("g:pymode_virtualenv", 1) || g:pymode_virtualenv

    call pymode#Default("g:pymode_virtualenv_enabled", [])

    " Add virtualenv paths
    call pymode#virtualenv#Activate()

endif

" }}}


" DESC: Fix python path
if !pymode#Default('g:pymode_path', 1) || g:pymode_path
python << EOF
import sys, vim, os

curpath = vim.eval("getcwd()")
libpath = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(
    vim.eval("expand('<sfile>:p')")))), 'pylibs')

sys.path = [libpath, curpath] + sys.path
EOF
endif


" Lint {{{

if !pymode#Default("g:pymode_lint", 1) || g:pymode_lint

    let g:qf_list = []

    " OPTION: g:pymode_lint_write -- bool. Check code every save.
    call pymode#Default("g:pymode_lint_write", 1)

    " OPTION: g:pymode_lint_onfly -- bool. Check code every save.
    call pymode#Default("g:pymode_lint_onfly", 0)

    " OPTION: g:pymode_lint_message -- bool. Show current line error message
    call pymode#Default("g:pymode_lint_message", 1)

    " OPTION: g:pymode_lint_checker -- str. Choices are: pylint, pyflakes, pep8, mccabe
    call pymode#Default("g:pymode_lint_checker", "pyflakes,pep8,mccabe")

    " OPTION: g:pymode_lint_config -- str. Path to pylint config file
    call pymode#Default("g:pymode_lint_config", $HOME . "/.pylintrc")

    " OPTION: g:pymode_lint_cwindow -- bool. Auto open cwindow if errors find
    call pymode#Default("g:pymode_lint_cwindow", 1)

    " OPTION: g:pymode_lint_jump -- int. Jump on first error.
    call pymode#Default("g:pymode_lint_jump", 0)

    " OPTION: g:pymode_lint_hold -- int. Hold cursor on current window when
    " quickfix open
    call pymode#Default("g:pymode_lint_hold", 0)

    " OPTION: g:pymode_lint_minheight -- int. Minimal height of pymode lint window
    call pymode#Default("g:pymode_lint_minheight", 3)

    " OPTION: g:pymode_lint_maxheight -- int. Maximal height of pymode lint window
    call pymode#Default("g:pymode_lint_maxheight", 6)

    " OPTION: g:pymode_lint_ignore -- string. Skip errors and warnings (e.g. E4,W)
    call pymode#Default("g:pymode_lint_ignore", "E501")

    " OPTION: g:pymode_lint_select -- string. Select errors and warnings (e.g. E4,W)
    call pymode#Default("g:pymode_lint_select", "")

    " OPTION: g:pymode_lint_mccabe_complexity -- int. Maximum allowed complexity
    call pymode#Default("g:pymode_lint_mccabe_complexity", 8)

    " OPTION: g:pymode_lint_signs -- bool. Place error signs
    if !pymode#Default("g:pymode_lint_signs", 1) || g:pymode_lint_signs

        " DESC: Signs definition
        sign define W text=WW texthl=Todo
        sign define C text=CC texthl=Comment
        sign define R text=RR texthl=Visual
        sign define E text=EE texthl=Error
        sign define I text=II texthl=Info

    endif

    " DESC: Set default pylint configuration
    if !filereadable(g:pymode_lint_config)
        let g:pymode_lint_config = expand("<sfile>:p:h:h") . "/pylint.ini"
    endif

    py from pymode import check_file

endif

" }}}


" Documentation {{{

if !pymode#Default("g:pymode_doc", 1) || g:pymode_doc

    " OPTION: g:pymode_doc_key -- string. Key for show python documantation.
    call pymode#Default("g:pymode_doc_key", "K")

endif

" }}}


" Breakpoints {{{

if !pymode#Default("g:pymode_breakpoint", 1) || g:pymode_breakpoint

    if !pymode#Default("g:pymode_breakpoint_cmd", "import ipdb; ipdb.set_trace() ### XXX BREAKPOINT")  && has("python")
python << EOF
from imp import find_module
try:
    find_module('ipdb')
except ImportError:
    vim.command('let g:pymode_breakpoint_cmd = "import pdb; pdb.set_trace() ### XXX BREAKPOINT"')
EOF
    endif

    " OPTION: g:pymode_breakpoint_key -- string. Key for set/unset breakpoint.
    call pymode#Default("g:pymode_breakpoint_key", "<leader>b")

endif

" }}}


" Execution {{{

if !pymode#Default("g:pymode_run", 1) || g:pymode_run

    " OPTION: g:pymode_doc_key -- string. Key for show python documentation.
    call pymode#Default("g:pymode_run_key", "<leader>r")

endif

" }}}


" Rope {{{

if !pymode#Default("g:pymode_rope", 1) || g:pymode_rope

    " OPTION: g:pymode_rope_auto_project -- bool. Auto open ropeproject
    call pymode#Default("g:pymode_rope_auto_project", 1)

    " OPTION: g:pymode_rope_enable_autoimport -- bool. Enable autoimport
    call pymode#Default("g:pymode_rope_enable_autoimport", 1)

    " OPTION: g:pymode_rope_autoimport_generate -- bool.
    call pymode#Default("g:pymode_rope_autoimport_generate", 1)

    " OPTION: g:pymode_rope_autoimport_underlines -- bool.
    call pymode#Default("g:pymode_rope_autoimport_underlineds", 0)

    " OPTION: g:pymode_rope_codeassist_maxfiles -- bool.
    call pymode#Default("g:pymode_rope_codeassist_maxfixes", 10)

    " OPTION: g:pymode_rope_sorted_completions -- bool.
    call pymode#Default("g:pymode_rope_sorted_completions", 1)

    " OPTION: g:pymode_rope_extended_complete -- bool.
    call pymode#Default("g:pymode_rope_extended_complete", 1)

    " OPTION: g:pymode_rope_autoimport_modules -- array.
    call pymode#Default("g:pymode_rope_autoimport_modules", ["os","shutil","datetime"])

    " OPTION: g:pymode_rope_confirm_saving -- bool.
    call pymode#Default("g:pymode_rope_confirm_saving", 1)

    " OPTION: g:pymode_rope_global_prefix -- string.
    call pymode#Default("g:pymode_rope_global_prefix", "<C-x>p")

    " OPTION: g:pymode_rope_local_prefix -- string.
    call pymode#Default("g:pymode_rope_local_prefix", "<C-c>r")

    " OPTION: g:pymode_rope_short_prefix -- string.
    call pymode#Default("g:pymode_rope_short_prefix", "<C-c>")

    " OPTION: g:pymode_rope_vim_completion -- bool.
    call pymode#Default("g:pymode_rope_vim_completion", 1)

    " OPTION: g:pymode_rope_guess_project -- bool.
    call pymode#Default("g:pymode_rope_guess_project", 1)

    " OPTION: g:pymode_rope_goto_def_newwin -- str ('new', 'vnew', '').
    call pymode#Default("g:pymode_rope_goto_def_newwin", "")

    " OPTION: g:pymode_rope_always_show_complete_menu -- bool.
    call pymode#Default("g:pymode_rope_always_show_complete_menu", 0)

    " DESC: Init Rope
    py import ropevim

    fun! RopeCodeAssistInsertMode() "{{{
        call RopeCodeAssist()
        return ""
    endfunction "}}}

    fun! RopeLuckyAssistInsertMode() "{{{
        call RopeLuckyAssist()
        return ""
    endfunction "}}}

    fun! RopeOmni(findstart, base) "{{{
        if a:findstart
            py ropevim._interface._find_start()
            return g:pymode_offset
        else
            call RopeOmniComplete()
            return g:pythoncomplete_completions
        endif
    endfunction "}}}

    " Rope menu
    menu <silent> Rope.Autoimport :RopeAutoImport<CR>
    menu <silent> Rope.ChangeSignature :RopeChangeSignature<CR>
    menu <silent> Rope.CloseProject :RopeCloseProject<CR>
    menu <silent> Rope.GenerateAutoImportCache :RopeGenerateAutoimportCache<CR>
    menu <silent> Rope.ExtractVariable :RopeExtractVariable<CR>
    menu <silent> Rope.ExtractMethod :RopeExtractMethod<CR>
    menu <silent> Rope.Inline :RopeInline<CR>
    menu <silent> Rope.IntroduceFactory :RopeIntroduceFactory<CR>
    menu <silent> Rope.FindFile :RopeFindFile<CR>
    menu <silent> Rope.OpenProject :RopeOpenProject<CR>
    menu <silent> Rope.Move :RopeMove<CR>
    menu <silent> Rope.MoveCurrentModule :RopeMoveCurrentModule<CR>
    menu <silent> Rope.ModuleToPackage :RopeModuleToPackage<CR>
    menu <silent> Rope.Redo :RopeRedo<CR>
    menu <silent> Rope.Rename :RopeRename<CR>
    menu <silent> Rope.RenameCurrentModule :RopeRenameCurrentModule<CR>
    menu <silent> Rope.Restructure :RopeRestructure<CR>
    menu <silent> Rope.Undo :RopeUndo<CR>
    menu <silent> Rope.UseFunction :RopeUseFunction<CR>

endif

" }}}


" OPTION: g:pymode_folding -- bool. Enable python-mode folding for pyfiles.
call pymode#Default("g:pymode_folding", 1)

" OPTION: g:pymode_utils_whitespaces -- bool. Remove unused whitespaces on save
call pymode#Default("g:pymode_utils_whitespaces", 1)

if pymode#Default('b:pymode', 1)
    finish
endif

" Syntax highlight
if !pymode#Default('g:pymode_syntax', 1) || g:pymode_syntax
    let python_highlight_all=1
endif


" Options {{{

" Python indent options
if !pymode#Default('g:pymode_options_indent', 1) || g:pymode_options_indent
    setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
    setlocal cindent
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal shiftround
    setlocal smartindent
    setlocal smarttab
    setlocal expandtab
    setlocal autoindent
endif

" Python other options
if !pymode#Default('g:pymode_options_other', 1) || g:pymode_options_other
    setlocal complete+=t
    setlocal formatoptions-=t
    setlocal number
    setlocal nowrap
    setlocal textwidth=79
endif

" }}}


" Documentation {{{

if g:pymode_doc

    " DESC: Set commands
    command! -buffer -nargs=1 Pydoc call pymode#doc#Show("<args>")

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_doc_key ":call pymode#doc#Show(expand('<cword>'))<CR>"
    exe "vnoremap <silent> <buffer> " g:pymode_doc_key ":<C-U>call pymode#doc#Show(@*)<CR>"

endif

" }}}


" Lint {{{

if g:pymode_lint

    let b:qf_list = []

    " DESC: Set commands
    command! -buffer -nargs=0 PyLintToggle :call pymode#lint#Toggle()
    command! -buffer -nargs=0 PyLintWindowToggle :call pymode#lint#ToggleWindow()
    command! -buffer -nargs=0 PyLintCheckerToggle :call pymode#lint#ToggleChecker()
    command! -buffer -nargs=0 PyLint :call pymode#lint#Check()

    " DESC: Set autocommands
    if g:pymode_lint_write
        au BufWritePost <buffer> PyLint
    endif

    if g:pymode_lint_onfly
        au InsertLeave <buffer> PyLint
    endif

    if g:pymode_lint_message

        " DESC: Show message flag
        let b:show_message = 0

        " DESC: Errors dict
        let b:errors = {}

        au CursorHold <buffer> call pymode#lint#show_errormessage()
        au CursorMoved <buffer> call pymode#lint#show_errormessage()

    endif

endif

" }}}


" Rope {{{

if g:pymode_rope

    " DESC: Set keys
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "g :RopeGotoDefinition<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "d :RopeShowDoc<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "f :RopeFindOccurrences<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "m :emenu Rope . <TAB>"
    inoremap <silent> <buffer> <S-TAB> <C-R>=RopeLuckyAssistInsertMode()<CR>

    let s:prascm = g:pymode_rope_always_show_complete_menu ? "<C-P>" : ""
    exe "inoremap <silent> <buffer> <Nul> <C-R>=RopeCodeAssistInsertMode()<CR>" . s:prascm
    exe "inoremap <silent> <buffer> <C-space> <C-R>=RopeCodeAssistInsertMode()<CR>" . s:prascm

endif

" }}}


" Execution {{{

if g:pymode_run

    " DESC: Set commands
    command! -buffer -nargs=0 -range=% Pyrun call pymode#run#Run(<f-line1>, <f-line2>)

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_run_key ":Pyrun<CR>"
    exe "vnoremap <silent> <buffer> " g:pymode_run_key ":Pyrun<CR>"

endif

" }}}


" Breakpoints {{{

if g:pymode_breakpoint

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_breakpoint_key ":call pymode#breakpoint#Set(line('.'))<CR>"

endif

" }}}


" Utils {{{

if g:pymode_utils_whitespaces
    au BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
endif

" }}}


" Folding {{{

if g:pymode_folding

    setlocal foldmethod=expr
    setlocal foldexpr=pymode#folding#expr(v:lnum)
    setlocal foldtext=pymode#folding#text()

endif

" }}}


" vim: fdm=marker:fdl=0
