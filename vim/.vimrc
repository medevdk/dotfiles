" Basic fallback vimrc - for when nvim is unavailable
set nocompatible
filetype plugin indent on

" Display
set number
set relativenumber
set cursorline
set scrolloff=8
set wrap
set showcmd
set showmode
set laststatus=2

" Encoding
set encoding=utf-8

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Behaviour
set noswapfile
set backspace=indent,eol,start
set clipboard=unnamed
set mouse=a
set splitbelow
set splitright
set noerrorbells

" Splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Remap escape
inoremap jk <Esc>

" Netrw file explorer
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 2

" Syntax
syntax on
