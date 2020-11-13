" James' vim config
set nocompatible

" Load extra config
if filereadable(expand('~/.vimrc.extra'))
  source ~/.vimrc.extra
endif

" Download vim-plug if missing
if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif
endif

" vim-polyglot
let g:polyglot_disabled = ['pascal']

" ALE
let g:ale_disable_lsp = 1

call plug#begin('~/.vim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'AndrewRadev/switch.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'easymotion/vim-easymotion'
  Plug 'jamessan/vim-gnupg'
  Plug 'neoclide/coc.nvim',     { 'branch': 'release' }
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'scrooloose/nerdtree',   { 'on': 'NERDTreeToggle' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'

  " These just make things pretty
  Plug 'dracula/vim', {'as':'dracula'}
  Plug 'sheerun/vim-polyglot'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

" My Settings ==================================================================
colorscheme dracula       " set colorscheme
set autoindent
set autoread              " auto read files changed outside vim
set breakindent           " indent line wraps
set clipboard=unnamedplus " use the system clipboard
" set colorcolumn=80        " highlight max length column
set encoding=utf-8        " set encoding
set expandtab             " tabs to spaces
set fillchars+=vert:┃
set formatoptions+=j
set hidden                " allow background buffers
set hlsearch              " highlight the search query
set ignorecase            " case insensitive searching
set laststatus=2          " always show airline
set lazyredraw            " don't redraw during macro execution
set linebreak             " break on word boundaries
set mouse=a               " enable the mouse
set nobackup              " no backup files
set noshowmode            " doesn't show the current mode in the command bar
set noswapfile            " no swap files
set number                " show line numbers
set scrolljump=1          " scroll 1 line at a time
set scrolloff=5           " start scrolling 5 lines before bottom of pane
set shiftwidth=2          " shift lines by 2 characters
set smartcase             " only use case sensitive search when uppercase
set tabstop=2             " change default tab length
set updatetime=300        " lower the updatetime for shorter delays
let mapleader=" "         " change the map leader

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '┃'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_section_z = '%p%% %v:%l/%L'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1
" let g:airline_theme = 'dracula'

" coc.nvim
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-python',
  \ 'coc-solargraph',
  \ 'coc-tsserver',
  \ 'coc-yaml'
  \ ]
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" FZF
set runtimepath+=/usr/local/opt/fzf
nmap <C-p> :FZF<cr>
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_colors = {
  \ 'bg+':     ['bg', 'Normal'],
  \ 'info':    ['bg', 'Normal'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \ }

" hide the statusbar for fzf
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Ale
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '➜'
nmap <silent> <C-S-n> <Plug>(ale_next_wrap)

" EasyMotion
nmap <Leader>f <Plug>(easymotion-overwin-f)

" NERDTree
nnoremap <leader>l :NERDTreeToggle<cr>
let NERDTreeMinimalUI=1

" fugitive
noremap gh :Gbrowse<cr>

" help mode settings ===========================================================
autocmd FileType help noremap <buffer> q :q<cr>

" vim/neovim specific configuration ============================================
if has('nvim')
  set inccommand=nosplit
else
  set noesckeys " removes some delays in insert mode
endif


" My Keybindings ===============================================================
nnoremap Q @@
nnoremap <C-m>     :make<cr>
nnoremap <C-h>     :wincmd h<cr>|                            " window left
nnoremap <C-j>     :wincmd j<cr>|                            " window below
nnoremap <C-k>     :wincmd k<cr>|                            " window above
nnoremap <C-l>     :wincmd l<cr>|                            " window right
nnoremap <C-w>     :bprevious\|bdelete #<CR>|                " close the current buffer
nnoremap <S-h>     :bprevious<cr>|                           " previous buffer
nnoremap <S-l>     :bnext<cr>|                               " next buffer
nnoremap <leader>d :bnext\|bdelete #<CR>|                    " close the current buffer
nnoremap <leader>o :nohlsearch<cr>|                          " clear search highlights
nnoremap <leader>p :set paste!<cr>|                          " toggle paste mode
nnoremap <leader>r :source ~/.vimrc<cr>|                     " reload vimrc
nnoremap <leader>s :setlocal spell! spelllang=en_us<cr>|     " toggle spell checking
nnoremap <leader>w :set wrap!<cr>|                           " toggle word wrap
" nnoremap <leader>n :set number!<cr>:set relativenumber!<cr>| " toggle line numbers
nnoremap <leader>n :set number!<cr>|                         " toggle line numbers
nnoremap <leader>v :e ~/.vimrc<cr>|                          " open vimrc
vnoremap <leader>a :sort<cr>|                                " sort lines

" my colors
hi VertSplit ctermbg=darkgray ctermfg=8
" hi ColorColumn ctermbg=0 ctermfg=NONE
" hi LineNr ctermbg=8 ctermfg=7
" hi CursorLineNr ctermbg=8 ctermfg=2
" hi SignColumn ctermbg=8 ctermfg=0
" hi ALEErrorSign ctermbg=8 ctermfg=red
" hi ALEWarningSign ctermbg=8 ctermfg=yellow
hi Normal ctermbg=NONE
