set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'myint/syntastic-extras'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-commentary'
Plugin 'bling/vim-airline'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'mxw/vim-jsx'

call vundle#end()            " required
filetype plugin indent on    " required

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

" auto reload .vimrc on save
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" show line numbers
set number

" Syntastic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = '-std=c++0x'
let g:syntastic_javascript_checkers = ['jshint']

" hide annoying warning when using YCM with C family
let g:ycm_confirm_extra_conf = 0

" change default Explore viewing style
let g:netrw_liststyle=3

" allow background buffers
set hidden

" change tab length
set tabstop=4
set shiftwidth=4

" highlight search terms as I search
set hlsearch
set incsearch

" no backups
set nobackup
set noswapfile

" set bash as default vim shell
set shell=bash\ --norc

" theme stuff
set background=dark
colorscheme ron

" airline
set laststatus=2
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


" MY BINDINGS

" set F2 to paste toggle
set pastetoggle=<F2>

" toggle line numbers
nnoremap <F3> :set nonumber !<CR>

" set Shift-h and Shift-l to move between open buffers
map <S-h> :bp <CR>
map <S-l> :bn <CR>

" set C-v and C-b to open new panes
map <C-v> :sp <CR>
map <C-b> :vsp <CR>

" set better pane navigation shortcuts
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>

" open NERDTree
map <C-t> :NERDTreeToggle <CR>

" open up Explore with space-k
:let mapleader=" "
map <leader>k :Explore<cr>

" no more shift-; for controls
map ; :

" toggle spelling mistake highlighting
map <F5> :setlocal spell! spelllang=en_us <CR>
