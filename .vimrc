" James Vaughan's vimrc ========================================================
set nocompatible
filetype plugin on

" Download vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Plugins ======================================================================
call plug#begin('~/.vim/plugged')
  Plug 'altercation/vim-colors-solarized'
  Plug 'airblade/vim-gitgutter'
  Plug 'easymotion/vim-easymotion'
  Plug 'digitaltoad/vim-pug'
  Plug 'dylanaraps/wal.vim'
  Plug 'elixir-lang/vim-elixir'
  Plug 'jamessan/vim-gnupg'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'mxw/vim-jsx'
  Plug 'ryanoasis/vim-devicons'
  Plug 'rust-lang/rust.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'slashmili/alchemist.vim'
  Plug 'ternjs/tern_for_vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vimwiki/vimwiki'
  Plug 'w0rp/ale'
  Plug 'Valloric/YouCompleteMe'
call plug#end()

" My Settings ==================================================================
colorscheme wal                 " set colorscheme
set autoread              " auto read files changed outside vim
set clipboard=unnamedplus " use the system clipboard
set colorcolumn=80        " highlight max length column
set encoding=utf-8        " set encoding
set expandtab             " tabs to spaces
set formatoptions+=j
set hidden                " allow background buffers
set hlsearch              " highlight the search query
set ignorecase            " case insensitive searching
set laststatus=2          " always show airline
set lazyredraw            " don't redraw during macro execution
set list
set listchars=tab:>-,trail:·
set mouse=a               " enable the mouse
set nobackup              " no backup files
set noesckeys             " removes some delays in insert mode
set noshowmode            " doesn't show the current mode in the command bar
set noswapfile            " no swap files
set number                " show line numbers
set relativenumber        " show relative line numbers
set scrolljump=1          " scroll 1 line at a time
set scrolloff=5           " start scrolling 5 lines before bottom of pane
set shiftwidth=2          " shift lines by 2 characters
set smartcase             " only use case sensitive search when uppercase
set tabstop=2             " change default tab length

" Airline
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:airline_section_z = '%p%% %v:%l/%L'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1
let g:airline_theme = 'solarized'

" YCM
let g:ycm_autoclose_preview_window_after_completion = 1

" FZF
map <C-p> :Files<cr>

" Ale
let g:ale_lint_on_text_changed = 'never'

" EasyMotion
map <leader>f <Plug>(easymotion-prefix)s

" GitGutter
set updatetime=250
let g:gitgutter_sign_added = '•'
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_removed = '•'
map <leader>g :GitGutterSignsToggle<cr>

" Rust
let g:rustfmt_autosave = 1

" Vimwiki
let g:vimwiki_list = [{'path': '~/Documents/vimwiki',
                     \ 'syntax': 'markdown',
                     \ 'ext': '.md'}]

" My Keybindings ===============================================================
let mapleader=" "
nnoremap - za
nnoremap Q @@
nnoremap <C-h>     :wincmd h<cr>|                        " window left
nnoremap <C-j>     :wincmd j<cr>|                        " window below
nnoremap <C-k>     :wincmd k<cr>|                        " window above
nnoremap <C-l>     :wincmd l<cr>|                        " window right
nnoremap <C-w>     :bprevious\|bdelete #<CR>|            " close the current buffer
nnoremap <S-h>     :bprevious<cr>|                       " previous buffer
nnoremap <S-l>     :bnext<cr>|                           " next buffer
nnoremap <leader>d :bprevious\|bdelete #<CR>|            " close the current buffer
nnoremap <leader>o :nohlsearch<cr>|                      " clear search highlights
nnoremap <leader>p :set paste!<cr>|                      " toggle paste mode
nnoremap <leader>r :source ~/.vimrc<cr>|                 " reload vimrc
nnoremap <leader>s :setlocal spell! spelllang=en_us<cr>| " toggle spell checking
nnoremap <leader>w :set wrap!<cr>|                       " toggle word wrap
vnoremap <leader>a :sort<cr>|                            " sort lines
