" James' vim config
set nocompatible

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

call plug#begin('~/.vim/plugged')
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'altercation/vim-colors-solarized'
  Plug 'airblade/vim-gitgutter'
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'digitaltoad/vim-pug'
  Plug 'dylanaraps/wal.vim'
  Plug 'easymotion/vim-easymotion'
  Plug 'elixir-lang/vim-elixir'
  Plug 'fatih/vim-go'
  Plug 'jamessan/vim-gnupg'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'ledger/vim-ledger'
  Plug 'mhinz/vim-startify'
  Plug 'mxw/vim-jsx'
  Plug 'rust-lang/rust.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'sheerun/vim-polyglot'
  Plug 'slashmili/alchemist.vim'
  Plug 'ternjs/tern_for_vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vimwiki/vimwiki'
  Plug 'w0rp/ale'
  Plug 'zchee/deoplete-go', { 'do': 'make' }
call plug#end()

" My Settings ==================================================================
colorscheme wal           " set colorscheme
set autoread              " auto read files changed outside vim
set clipboard=unnamedplus " use the system clipboard
set colorcolumn=80        " highlight max length column
set encoding=utf-8        " set encoding
set expandtab             " tabs to spaces
set fillchars+=vert:│
set formatoptions+=j
set hidden                " allow background buffers
set hlsearch              " highlight the search query
set ignorecase            " case insensitive searching
set laststatus=2          " always show airline
set lazyredraw            " don't redraw during macro execution
set mouse=a               " enable the mouse
set nobackup              " no backup files
set noshowmode            " doesn't show the current mode in the command bar
set noswapfile            " no swap files
set number                " show line numbers
set relativenumber        " show relative line numbers
set scrolljump=1          " scroll 1 line at a time
set scrolloff=5           " start scrolling 5 lines before bottom of pane
set shiftwidth=2          " shift lines by 2 characters
set smartcase             " only use case sensitive search when uppercase
set tabstop=2             " change default tab length
let mapleader=" "         " change the map leader

" Deoplete
let g:deoplete#enable_at_startup = 1
set completeopt-=preview " disable the preview window
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

" Airline
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '┃'
let g:airline#extensions#tabline#left_sep = '▌'
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
let g:airline_theme = 'solarized'

" FZF
nmap <C-p> :Files<cr>

" Ale
" let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '➜'
let g:ale_linter_aliases = {'vimwiki': 'markdown'}
" nmap <silent> <C-S-p> <Plug>(ale_previous_wrap)
nmap <silent> <C-S-n> <Plug>(ale_next_wrap)

" EasyMotion
nmap <Leader>f <Plug>(easymotion-overwin-f)

" GitGutter
set updatetime=250
let g:gitgutter_sign_added = '•'
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_removed = '•'
map <leader>g :GitGutterSignsToggle<cr>
hi GitGutterAddDefault ctermbg=NONE ctermfg=2
hi GitGutterChangeDefault ctermbg=NONE ctermfg=3
hi GitGutterDeleteDefault ctermbg=NONE ctermfg=1

" Rust
let g:rustfmt_autosave = 1

" Vimwiki
let g:vimwiki_list = [{'path': '~/Documents/notes',
                     \ 'syntax': 'markdown',
                     \ 'ext': '.md'}]

" Startify
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (system("tput cols") / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction
let g:startify_custom_header = s:filter_header(startify#fortune#boxed())
let g:startify_bookmarks = [ {'v': '~/.vimrc'},
                           \ {'w': '~/Documents/notes/index.md'},
                           \ {'p': '~/.config/polybar/config'},
                           \ {'x': '~/.xmonad/xmonad.hs'},
                           \ {'b': '~/.bashrc'}]
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 0


" My Keybindings ===============================================================
nnoremap - za
nnoremap Q @@
nnoremap <C-h>     :wincmd h<cr>|                            " window left
nnoremap <C-j>     :wincmd j<cr>|                            " window below
nnoremap <C-k>     :wincmd k<cr>|                            " window above
nnoremap <C-l>     :wincmd l<cr>|                            " window right
nnoremap <C-w>     :bprevious\|bdelete #<CR>|                " close the current buffer
nnoremap <S-h>     :bprevious<cr>|                           " previous buffer
nnoremap <S-l>     :bnext<cr>|                               " next buffer
nnoremap <leader>d :bprevious\|bdelete #<CR>|                " close the current buffer
nnoremap <leader>o :nohlsearch<cr>|                          " clear search highlights
nnoremap <leader>p :set paste!<cr>|                          " toggle paste mode
nnoremap <leader>r :source ~/.vimrc<cr>|                     " reload vimrc
nnoremap <leader>s :setlocal spell! spelllang=en_us<cr>|     " toggle spell checking
nnoremap <leader>w :set wrap!<cr>|                           " toggle word wrap
nnoremap <leader>n :set number!<cr>:set relativenumber!<cr>| " toggle line numbers
vnoremap <leader>a :sort<cr>|                                " sort lines

" vim/neovim specific configuration
if has('nvim')
else
  set noesckeys " removes some delays in insert mode
endif

" my colors (expanding from wal)
hi VertSplit ctermbg=8 ctermfg=0
hi ColorColumn ctermbg=0 ctermfg=NONE
hi LineNr ctermbg=0 ctermfg=8
hi CursorLineNr ctermbg=0 ctermfg=8
