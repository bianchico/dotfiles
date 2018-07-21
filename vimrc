" vim:set et sw=2:

scriptencoding utf-8

packadd! matchit

set nocompatible
set autoindent
set autoread
set autowrite
set backspace=indent,eol,start
set backupdir^=~/.vim/_backup//
set backupskip&
set backupskip+=/private/tmp/*
set cmdheight=2
set complete-=i
set completeopt=menuone,longest,preview
set cursorline
set dictionary+=/usr/share/dict/words
set directory^=~/.vim/_swap//
set display=lastline
set formatoptions+=1rj
set history=1000
set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set listchars=tab:▸\ ,trail:·,extends:…,precedes:…,nbsp:␠
set nojoinspaces
set nrformats-=octal
set number
set numberwidth=3
set report=0
set scrolloff=3
set sessionoptions-=options
set shiftround
set shortmess=aIoOtT
set showcmd
set smarttab
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/en-local.utf-8.add
set spelllang=en_us
set splitbelow
set splitright
setglobal tags+=./tags;
set thesaurus+=~/.vim/spell/mthesaur.txt
set timeoutlen=1200
set title
set ttimeout
set ttimeoutlen=50
set undodir^=~/.vim/_undo
set undofile
set viminfo+=n~/.vim/viminfo
set viminfo^=!
set virtualedit+=block
set visualbell t_vb=
set wildignore+=*.[aos],*.aux,*.class,*.dSYM,*.dylib,*.out,*.py[co],*.so,.DS_Store
set wildignore+=*~,Session.vim,[._]*.s[a-v][a-z],[._]*.sw[a-p],[._]s[a-v][a-z],[._]sw[a-p],tags
set wildmenu
set wildmode=longest:full,full

set statusline=[%n]                 " buffer number
set statusline+=%(\ %.120f\ %)      " relative path to file
set statusline+=%h%w%m%r%y          " help|preview|modified|readonly|filetype
set statusline+=%{FugitiveStatusLineWrapper()}
set statusline+=%=                  " l-r separator
set statusline+=%(%#ErrorMsg#%{ALEStatusLineWrapper()}%*\ %)
set statusline+=%-10.(0x%B%)        " hex value of character under cursor
set statusline+=%-14.(%l,%c%V%)\ %P " line#,col#-vcol# %

if $COLORTERM ==# 'truecolor'
  if has('termguicolors')
    set termguicolors
  endif

  set background=dark
  silent! colorscheme deep-space
endif

if executable('rg')
  set grepprg=rg\ -H\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
elseif executable('ggrep')
  set grepprg=ggrep\ -rnHI\ --exclude-dir=.git\ --exclude=tags
else
  set grepprg=grep\ -rnHI\ --exclude-dir=.git\ --exclude=tags
endif

filetype plugin indent on
syntax on
" plugin settings
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'never'
let g:markdown_fenced_languages = ['css', 'html', 'javascript', 'ruby']
let g:vim_indent_cont = 2
let g:vim_json_syntax_conceal = 0

" mappings
let g:mapleader = ','

map  <Left>  <Nop>
map  <Right> <Nop>
map  <Up>    <Nop>
map  <Down>  <Nop>
imap <Left>  <Nop>
imap <Right> <Nop>
imap <Up>    <Nop>
imap <Down>  <Nop>

" never switch to ex mode
nmap Q <Nop>
nmap gQ <Nop>

" In insert mode, break the current undo sequence in sensible places. If <CR>
" is already mapped to include <C-G>u, then don't remap it. This preserves the
" endwise.vim <CR> mapping when re-sourcing this file.
if maparg('<CR>', 'i') !~# '<C-G>u<CR>'
  inoremap <CR> <C-G>u<CR>
endif
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" make & include flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" switch to previous file
nnoremap <Leader><Leader> <C-^>

" make Ctrl-C check abbreviations and trigger InsertLeave
inoremap <C-C> <Esc>

nnoremap <Leader>l :set list!<CR>

" add word under cursor to unversioned spellfile
nnoremap zG 2zg

" continuous indentation
vnoremap > >gv
vnoremap < <gv

" clear search highlighting
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" format cucumber tables
noremap <silent> g\| :Tabularize/\|/l1<CR>

noremap gs :sort<CR>
noremap gy "*y

function! FugitiveStatusLineWrapper()
  if !exists('*fugitive#head')
    return ''
  endif

  let head = fugitive#head(7)
  return head ==# '' ? '' : '[' . head . ']'
endfunction

function! ALEStatusLineWrapper()
  if !exists('*ale#statusline#Count')
    return ''
  endif

  let l:count = ale#statusline#Count(bufnr('')).total

  if l:count == 0
    return ''
  endif

  let suffix = l:count == 1 ? '' : 's'

  return ' ' . l:count . ' problem' . suffix . ' '
endfunction

function! s:restore_last_cursor_position()
  " If the last cursor position is on the first line or past the end of the
  " file, don't do anything.
  if line("'\"") == 0 || line("'\"") > line("$")
    return
  endif

  " Jump to the last cursor position. If it is not in the bottom half of the
  " last window, then re-center the window on the line.
  if line("$") - line("'\"") > (line("w$") - line("w0")) / 2
    execute "normal! g`\"zz"
  else
    execute "normal! g`\""
  endif
endfunction

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.log{,.[0-9]*} setlocal readonly nowrap
  autocmd BufNewFile,BufReadPost */node_modules/* setlocal readonly | silent! ALEDisable
  autocmd BufNewFile,BufReadPost .npmignore setlocal ft=conf
  autocmd BufNewFile,BufReadPost .npmrc setlocal ft=dosini
augroup END

augroup vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC
augroup END

augroup lastposjump
  autocmd!
  autocmd BufReadPost *.log{,.[0-9]*} delmarks \"
  autocmd BufReadPost quickfix delmarks \"
  autocmd BufReadPost * call s:restore_last_cursor_position()
augroup END

augroup undo
  autocmd!
  autocmd CursorHoldI * silent! call feedkeys("\<C-G>u", "nt")
  autocmd BufWritePre /tmp/*,$TMPDIR/*,/{private,var,private/var}/tmp/* setlocal noundofile
augroup END

augroup focus
  autocmd!
  autocmd FocusLost * silent! wall
augroup END

augroup swapmod
  autocmd!
  autocmd CursorHold,CursorHoldI,BufWritePost,BufReadPost,BufLeave *
    \ if !empty(filter(split(&directory, ","), "isdirectory(expand(v:val))")) |
    \   let &swapfile = &modified |
    \ endif
augroup END

augroup windows
  " Initially, &wmh == 1 and &wh == 1. Setting &wmh > &wh is disallowed,
  " as is setting 'wmh' after setting 'wh' sufficiently large to prevent
  " opening another window.
  autocmd!
  autocmd VimEnter * set wh=10 wmh=10 wh=999 hh=999 cwh=999
  autocmd VimEnter * set wiw=80
  autocmd VimResized * wincmd =
  autocmd VimEnter * if &lazyredraw | redrawstatus! | endif
augroup END

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost l* nested lwindow
augroup END

augroup diff
  autocmd!
  autocmd FilterWritePre * if &diff | set nonumber | endif
augroup END

augroup cursorline
  autocmd!
  autocmd WinLeave,InsertEnter * set nocursorline
  autocmd WinEnter,InsertLeave * set cursorline
augroup END

silent! source ~/.vimrc.local
