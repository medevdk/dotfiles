set nocompatible	"better safe then sorry, but not neccesary
filetype plugin indent on

set showcmd		"show what is typed as command
set showmode		"show mode

set encoding=utf-8      "Set default encoding
set wrap        	 "wrap long lines to fit in the window
set cursorline		"highlight current line
set scrolloff=5		"always keep 5 lines above and below cursor

set splitbelow		"open new split panes to the right and bottom
set splitright

set backspace=indent,eol,start	 "make backspace work like in most other programs in Insert mode

set laststatus=2	  "always display status line

set number      	 "Show current line number
set relativenumber       "Show relative line number

set noerrorbells	 "No beeps
set visualbell  	 "Flash screen on error

set clipboard=unnamed   "use the sytem clipboard

"set autoindent
set expandtab		"use spaces instead of tabs
set smarttab		"use smart tabbing
set shiftwidth=2	"instead of 8 character tab
set softtabstop=2	"1 tab == 2 spaces

set incsearch		"search as characters are entered
set hlsearch		"highlight matches

"Change cursor shape between Insert and Normal mode in iTerm2
if $TERM_PROGRAM =~"iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" "Vertical bar in Insert mode
  let &t_SR = "\<ESC>]50;CursorShape=0\x7" "Block in normal mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set mouse=a		"enable mouse support

"set directory^=$HOME/.vim/tmp//   "store swap files in tmp directory
set noswapfile      "disable swap file functionality
inoremap jk <Esc>	"remap escape key to jk

"Insert closing brace
inoremap {<cr> {<cr>}<esc>ko   

nnoremap <C-J> <C-W><C-J>  "easy navigating between splits
nnoremap <C-K> <C-W><C-K>  "instead of ctrl-w then j , now it is only ctrl-j
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>



"netrw file explorer, instead plugin nerdtree
":Sexplore - open in horizontal split
":Vexplore - open in vertical split -> Preferred!
"
let g:netrw_liststyle = 3  "preferred view in netrw
let g:netrw_banner = 0	   "remove banner in netrw
let g:netrw_winsize = 25   "set to 25% width of page
let g:netrw_browse_split = 2  "open file in a new vertical split
let g:netrw_altv = 1 

"launcg netrw when enter vim, using VimEnter autocommand
"augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
"augroup END

"set color scheme dracula (from package)
"packadd! dracula
"packadd! gruvbox
syntax on    		 "enable syntax highlighting
"color dracula
"color gruvbox


