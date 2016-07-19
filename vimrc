" Plugins =======================================================
call plug#begin('~/.config/nvim/plugged')

  " Fuzzy Finder
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Syntastic
  Plug 'scrooloose/syntastic'
  Plug 'myint/syntastic-extras'

  " YouCompleteMe
  Plug 'Valloric/YouCompleteMe'
  Plug 'rdnetto/YCM-Generator'

  " Vim Syntax
  Plug 'mxw/vim-jsx'

  " Dracula Theme
  Plug 'dracula/vim'

  " Commentary
  Plug 'tpope/vim-commentary'

  " CSS3
  Plug 'hail2u/vim-css3-syntax'

call plug#end()


" My Settings ===================================================

set scrolloff=5					" start scrolling before bottom of pane
set hidden              " allow background buffers

set nu									" show line numbers
set rnu									" show relative line numbers

" set background=dark			" set theme
color dracula					" set colorscheme

set expandtab
set tabstop=2						" change tab length
set shiftwidth=2

set colorcolumn=80,120

set ignorecase
set smartcase

set nobackup						" no backup files
set noswapfile

set foldmethod=syntax		" folding stuff
set foldnestmax=1
set foldlevelstart=1

" Airline
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']


" My Keybindings ================================================

" use ; for commands
map ; :

:let mapleader=" "			" set leader to space
map <leader>q :q<cr>		" close pane with leader+q
map <leader>a za				" toggle folding with space+a
map <leader>o :noh<cr>  " clear search highlights
map <leader>w :set wrap !<cr>   " toggle word wrap
nnoremap <leader> @q
" set pastetoggle=<F2>		" set F2 to paste toggle

" built in terminal
map <S-t> :Terminal<cr>

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

" toggle spelling mistake highlighting
map <F5> :setlocal spell! spelllang=en_us<cr>

" fuzzy finder
map <C-p> :FZF<cr>


" Other =========================================================

" auto reload on save
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
