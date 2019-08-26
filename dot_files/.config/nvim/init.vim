" .vimrc for plane vim or customized nvim
"
" {{{ install neovim
" macOS: $ brew install neovim/neovim
" RHEL7: # yum -y install epel-release
"        # curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo
"        # yum install -y --enablerepo=epel jemalloc neovim
" }}}

" {{{ set Leader
let g:mapleader = ' '               " <Leader> = <Space>
" }}}

" source plugins {{{
if (isdirectory(expand('~/.config/nvim/repos/github.com/Shougo/dein.vim')) && has('nvim'))
    source ~/.config/nvim/plugins.vim
endif
" }}}

" settings {{{
filetype plugin indent on
syntax enable
set nocompatible                " disable vi compatible
set background=light            " terminal back ground color is light
set hidden                      " if buffer unsaved, can show other buffer
set showmatch                   " show match brackets
set showcmd                     " show typing commands
set nonumber                    " disable show line number
set splitbelow                  " open new window in bottom when  split
set splitright                  " open new window in right  when vsplit
set noincsearch                 " disable incremental search
set hlsearch                    " enable word highlighting in search
set ignorecase                  " if search word is small char only, ignore capital/small
set smartcase                   " if search word include capital char, not ignore capital/small
set wildmenu                    " enable command line completion
set wildmode=list:longest       " show longest match with list in command line completion
set visualbell t_vb=            " disable bell
set backspace=indent,eol,start  " set deletable character by <BS>
set ambiwidth=double            " set Ambiguous character width, for Zenkaku character
set pumheight=7                 " pop up items number is 7
let loaded_matchparen = 1       " disable show match brackets on cursor
set nrformats-=octal            " ignore octal in increment/decrement(^a^x)
set completeopt-=preview        " disable preview in completion
set list                        " show symbols include tab
set listchars=tab:>-            " set list visible style
set autoindent
set spelllang=en,cjk            " treat Japanese in spell check

" specific feature settings {{{

" save undo history
if has('persistent_undo')
    let &undodir = has('nvim') ? expand('~/.config/nvim/undo_history') : expand('~/.vim/undo_history')
    set undofile
    set undolevels=25000
endif

if has('folding')
    set foldmethod=marker       " fold use marker. {{{ }}}
endif

" }}}

" tab settings {{{
set expandtab               " use space
let s:tab_width  = 4        " common tab width
let &tabstop     = s:tab_width
let &shiftwidth  = s:tab_width
let &softtabstop = s:tab_width
unlet s:tab_width

" use \t in only Makefile
augroup Makefile
    autocmd!
    autocmd FileType make setl noexpandtab
augroup END
" }}}

" wild settings {{{
set wildmenu                        " enable wild
" wild ignore settings
let s:wildignore_files =
            \ '.*.sw[a-z],' . '*.un~,' . 'Session.vim,' . '.netrwhist,' .
            \ '.DS_Store,' . '.AppleDouble,' . '.LSOverride,' . 'Icon,' .
            \ '._*,' . '.Spotlight-V100,' . '.Trashes,' . 'CMakeFiles,' .
            \ '.git,' . '.hg,' .
            \ 'a.out,' . '*.o,' . '*.class,' .
            \ '*.jpg,' . '*.png,' . '*.bb,' . '*.gif,' . '*.eps,' .
            \ '*.aux,' . '*.dvi,' . '*.toc,' . '*.pdf,' .
            \ '*.zip,'
let &wildignore = s:wildignore_files
unlet s:wildignore_files
" }}}

" }}}

" Encoding settings : utf-8 {{{
if has('vim_starting')
    set termencoding=utf-8
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ascii,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
    set fileformat=unix
    set fileformats=unix,dos,mac
endif
" }}}

" statusline and ruler settings {{{
set laststatus=0                    " usually hide status line
set statusline=%F%m%r%h%w%=\ %{'[E:'.(&fenc!=''?&fenc:&enc).'][F:'.&ff.']'}[L:%04l\/%04L][P:%04l,%04v]

" simple ruler (only modified flag)
set ruler                           " show ruler, but usually hidden by statusline
set rulerformat=%m
" }}}

" functions {{{

function! s:detect_trailing_spaces()
    " detect trailing spaces for :write hook

    " search trailing spaces. wrap search and do not move cursor
    if search('\s\+$', 'wn')
       echomsg("warn: detect trailing space in " . expand("%"))
    endif
endfunction

function! s:show_trailing_spaces()
    highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
    match TrailingSpaces /\s\+$/
endfunction

function! s:delete_trailing_spaces()
    " delete all trailing spaces
    let s:cursor = getpos(".")
    %substitute/\s\+$//ge
    call setpos(".", s:cursor)
endfunction

function! s:toggle_last_status()
    " toggle laststatus helper
    let s:enable_last_status_value  = 2
    let s:disable_last_status_value = 0

    if(&laststatus == s:enable_last_status_value)
        let &laststatus = s:disable_last_status_value
    else
        let &laststatus = s:enable_last_status_value
    end
endfunction

function! s:toggle_wild_ignore()
    " toggle wildignore settings helper
    let s:enable_last_status_value  = 2
    if (&wildignore != '')
        let s:wildignore_backup = &wildignore
        let &wildignore = ''
        echo "disable wildignore"
    else
        if(exists('s:wildignore_backup'))
            let &wildignore = s:wildignore_backup
            echo "enable wildignore"
        endif
    endif
endfunction

function! s:insert_time_stamps_from_undo_history()
    if !has('persistent_undo')
        echomsg 'Undo Tree Unavailale.'
        finish
    endif

    let s:times_from_history = sort(map(undotree()['entries'], 'v:val["time"]'))
    let s:oldest_unix_time   = s:times_from_history[1]
    let s:latest_unix_time   = s:times_from_history[-1]

    call append(line('$'), strftime('%Y/%m/%d %H:%M:%S', s:oldest_unix_time))
    call append(line('$'), strftime('%Y/%m/%d %H:%M:%S', s:latest_unix_time))
endfunction

" }}}

" commands {{{

" short cut commands
command! ReloadVimrc source $MYVIMRC
command! EditVimrc edit $MYVIMRC
command! EditVimrcPlugins edit $HOME/.config/nvim/plugins.vim
command! SudoWriteCurrentBuffer write !sudo tee %
command! SetFileEncodingUTF8 setl fileencoding=utf8

" commands for fuctions
command! ShowTrailingSpaces              call s:show_trailing_spaces()
command! DeleteTrailingSpaces            call s:delete_trailing_spaces()
command! ToggleLastStatus                call s:toggle_last_status()
command! ToggleWildIgnore                call s:toggle_wild_ignore()
command! InsertTimeStampsFromUndoHistory call s:insert_time_stamps_from_undo_history()

" }}}

" keymaps {{{
" yank to end of line (D like Y)
nnoremap Y y$
" emacs like cursor move
inoremap <C-f> <Right>
inoremap <C-b> <Left>
" disable hlsearch in redraw
nnoremap <C-l> :nohlsearch<CR><C-l>
" help shortcut
nnoremap <C-h> :h<Space>
" search words shortcut in visual block
vnoremap * y/<C-r>"<CR>


" zsh like cursor move in command line mode
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>
cnoremap <C-f> <RIGHT>
cnoremap <C-b> <LEFT>
cnoremap <C-d> <DEL>


" add undo point map
inoremap <CR>  <C-g>u<CR>
inoremap <C-@> <C-g>u<C-@>

" shortcuts
nnoremap <Leader>l :ToggleLastStatus<CR>
nnoremap <Leader>w :ToggleWildIgnore<CR>
nnoremap <Leader>e :SetFileEncodingUTF8<CR>
nnoremap <Leader>s :setl spell!<CR>
nnoremap <Leader>d :DeleteTrailingSpaces<CR>
" }}}

" autocmds {{{

augroup All
    autocmd!
    autocmd BufWritePost * call s:detect_trailing_spaces()
    autocmd InsertLeave  * set nopaste
augroup END

" for Ruby
augroup Ruby
    autocmd!
    autocmd FileType ruby  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType eruby setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType haml  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType slim  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" for Python
augroup Python
    autocmd!
    autocmd FileType python setl tabstop=4 softtabstop=4 shiftwidth=4  expandtab
    autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
augroup END

" for Haskell
augroup Haskell
    autocmd!
    autocmd FileType haskell setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" for TeX
augroup TeX
    autocmd!
    autocmd BufNewFile *.tex setl filetype=tex
    autocmd BufRead    *.tex setl filetype=tex
    autocmd FileType tex nnoremap <buffer><C-K> :make<CR>
augroup END

" for HTML
augroup HTML
    autocmd!
    autocmd FileType html setl tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" for coffee
augroup Coffee
    autocmd!
    autocmd FileType coffee setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" for YAML
augroup Yaml
    autocmd FileType yaml  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" Omni Completion dictionary {{{
augroup OmniCompletionDictionary
    autocmd!
    autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType c          setlocal omnifunc=ccomplete#Complete
    autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete

    " default setting : syntax completaion
    autocmd Filetype *
                \   if &l:omnifunc == ''
                \ |   setlocal omnifunc=syntaxcomplete#Complete
                \ | endif
augroup END
" }}}

" files template {{{

augroup FileTemplate
    autocmd!
    autocmd BufNewFile *.php 0r ~/.config/nvim/templates/php.php
    autocmd BufNewFile *.py  0r ~/.config/nvim/templates/python.py
    autocmd BufNewFile *.rb  0r ~/.config/nvim/templates/ruby.rb
    autocmd BufNewFile *.sh  0r ~/.config/nvim/templates/shell.sh
    autocmd BufNewFile *.tex 0r ~/.config/nvim/templates/tex.tex
    autocmd BufNewFile *.vim 0r ~/.config/nvim/templates/vim.vim
augroup END

" }}}

" }}}

" color settings {{{

highlight Pmenu     ctermbg = grey
highlight PmenuSel  ctermbg = darkcyan
highlight PMenuSbar ctermbg = grey

" }}}
