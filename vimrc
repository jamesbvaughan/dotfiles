" James Vaughan's vimrc =========================================
if !has('nvim')
  set nocompatible              " be iMproved, required
  filetype off                  " required
endif

" Plugins =======================================================
call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'        " Vim Airline
Plug 'vim-airline/vim-airline-themes' " Vim Airline
Plug 'scrooloose/syntastic'           " Syntastic
Plug 'myint/syntastic-extras'         " Syntastic Extras
Plug 'rdnetto/YCM-Generator'          " YCM Generator
Plug 'tpope/vim-commentary'           " Commentary
Plug 'tpope/vim-fugitive'             " Fugitive
Plug 'junegunn/fzf'                   " fzf
Plug 'junegunn/fzf.vim'               " fzf
Plug 'Valloric/YouCompleteMe'         " YouCompleteMe
Plug 'dracula/vim'                    " dracula
Plug 'groenewege/vim-less'            " Less
Plug 'hail2u/vim-css3-syntax'         " CSS3
Plug 'mxw/vim-jsx'                    " JSX
Plug 'othree/html5.vim'               " HTML5
Plug 'derekwyatt/vim-scala'           " Scala
" Plugin 'pangloss/vim-javascript'	" Javascript
call plug#end()

" My Settings ===================================================
set scrolloff=5					" start scrolling before bottom of pane
set hidden							" allow background buffers
set nu									" show line numbers
set rnu									" show relative line numbers
color dracula					" set colorscheme
set expandtab
set tabstop=2						" change tab length
set shiftwidth=2

set colorcolumn=80

set ignorecase
set smartcase

set nobackup						" no backup files
set noswapfile

set foldmethod=syntax		" folding stuff
set foldnestmax=1
set foldlevelstart=1

if !has('nvim')					" regular vim only settings
  set hlsearch					" highlight search terms as I search
  set foldenable
endif

if has('nvim')					" neovim only settings
endif


" My Keybindings ================================================

let mapleader=" "			" set leader to space
map <leader>q :q<cr>		" close pane with leader+q
map <leader>a za				" close pane with leader+q
set pastetoggle=<F2>		" set F2 to paste toggle

" use ; for commands
map ; :

" fzf
map <C-p> :FZF<cr>

" set Shift-h and Shift-l to move between open buffers
map <S-h> :bp<cr>
map <S-l> :bn<cr>

" set better pane navigation shortcuts
map <C-h> :wincmd h<cr>
map <C-j> :wincmd j<cr>
map <C-k> :wincmd k<cr>
map <C-l> :wincmd l<cr>

" better navigation with wrapped lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" clear search highlights
map <leader>o :noh<cr>

" toggle word wrap
map <leader>w :set wrap !<cr>

" toggle spelling mistake highlighting
map <F5> :setlocal spell! spelllang=en_us<cr>


" Plugin Settings ===============================================

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = '-std=c++0x'
let g:syntastic_javascript_checkers = ['eslint']

" YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
set splitbelow " open preview window on bottom

" Airline
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


" Other =========================================================

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Turn on filetype detection
  filetype on
  filetype indent on
  filetype plugin on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Only rln in normal mode
  autocmd InsertEnter * :set rnu!
  autocmd InsertLeave * :set rnu

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
endif " has("autocmd")

" auto reload .vimrc on save
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
