" a lot of stuff taken from http://stevelosh.com/blog/2010/09/coming-home-to-vim
" https://bitbucket.org/sjl/dotfiles/src/bd5cc7a9e0c81eda3ca9bfbcfc1d94a30173451d/vim/vimrc?at=default

let $BASH_ENV = "~/.bash_profile"
let $ZSH_ENV = "~/.zshenv"
set shell=/bin/zsh

set mouse=

" pathogen
""""""""""
filetype off
call pathogen#incubate()
filetype plugin indent on


" Basic settings
""""""""""""""""

" statusline
" http://learnvimscriptthehardway.stevelosh.com/chapters/17.html
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%{fugitive#statusline()} " current branch
set statusline+=\ \ %l    " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines

set nocompatible
set history=100

" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/10,'10,f0,h,\"100


" file opening
set wildmenu
" have command-line completion <Tab> (for filenames, help topics, option
" names) first list the available options and complete the longest common
" part, then have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full
" files to ignore
set wildignore+=*.o,*.obj,*.png,*.jpg,.git,tmp

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!)
set comments+=b:\"

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Made D behave
nnoremap D d$

" Display and Colors
""""""""""""""""""""

syntax on
" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800
set t_Co=256
"color railscasts+
color vibrantink
set background=dark

" show special chars
set list
" set listchars=tab:▸\ ,eol:¬
set list listchars=tab:▸\ ,extends:»,trail:·
set showbreak=↪

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

" \-r to toggle rainbow parens
nmap <leader>r :RainbowParenthesesToggle<cr>

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" Tabs
""""""

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab


" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>


" Keystrokes -- Toggles
"""""""""""""""""""""""

" have leader-p ("toggle paste") toggle paste on/off and report the change, and
" where possible also have <F2> do this both in normal and insert mode:
nnoremap <leader>p :set invpaste paste?<CR>
nmap <F2> <leader>p
imap <F2> <C-O><leader>p
set pastetoggle=<F2>

" have \tf ("toggle format") toggle the automatic insertion of line breaks
" during typing and report the change:
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
  \ endif <Bar> set fo?<CR>
nmap <F3> \tf
imap <F3> <C-O>\tf

" have \tl ("toggle list") toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>
nmap <F4> \tl



" search / replace
""""""""""""""""""

" fix search regex handling
" nnoremap / /\v
" vnoremap / /\v

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

set incsearch
set showmatch
set hlsearch
" reset search term highlighting
nnoremap <leader><space> :noh<cr>
" ack
nnoremap <leader>a :Ack

" replace in whole line by default
set gdefault

" Keep search matches in the middle of the window and pulse the line when moving
" to them.
nnoremap n nzzzv
nnoremap N Nzzzv

" Don't move on *
nnoremap * *<c-o>


" Movement
""""""""""

" show relative linenumbers
set relativenumber

" matchit with tab
map <tab> %

" disable evil cursor keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" make j and k behave more sane
nnoremap j gj
nnoremap k gk

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape
" Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt',
" `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
noremap <BS> <PageUp>
noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]

" scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>





" Text formatting
"""""""""""""""""

set wrap

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" \-w strip all trailing whitespace in file
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<CR>

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq
nnoremap W gqqj


" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=79

" C-u to uppercase current word
inoremap <C-u> <esc>mzgUiw`za

" Split windows / multi file
""""""""""""""""""""""""""""

" \-w to vsplit
nnoremap <leader>v <C-w>v<C-w>l

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" switch to next split
nnoremap <S-Tab> <C-W>w

" Minimum Split height 0 lines
set wmh=1

" multi-file-editing
set hidden
" if a buffer is already opened in one of
" the windows, Vim will jump to that window, instead of creating a new
" window
set switchbuf=useopen

au BufRead,BufNewFile *.hamlc set ft=haml
au BufRead,BufNewFile *.md    set ft=markdown
au BufRead,BufNewFile haproxy*.cfg  set ft=haproxy

" commandT
let g:CommandTMaxHeight=15


" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}

imap frosli #<SPACE>frozen_string_literal:<SPACE>true

set runtimepath^=~/.vim/bundle/ctrlp.vim
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_clear_cache_on_exit = 0
endif

