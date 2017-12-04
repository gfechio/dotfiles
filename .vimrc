syntax on                       " Syntax highlighting
set background=dark             " Terminal with a dark background
set t_Co=256
set expandtab                   " Make a tab to spaces, num of spaces set in tabstop
set fileformat=unix
set shiftwidth=4                " Number of spaces to use for autoindenting
set softtabstop=4                   " A tab is four spaces
set tabstop=8 
set smarttab                    " insert tabs at the start of a line according to
set list                        " show invisible characters
set listchars=tab:>·,trail:·    " but only show tabs and trailing whitespace
set number                      " Enable line numbers
set numberwidth=3               " Line number width
set textwidth=79
" Set f2 to toggle line numbers
nmap <f2> :set number! number?<cr>
" Set f3 to toggle showing invisible characters
nmap <f3> :set list! list?<cr>
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight NonText ctermfg=8 guifg=gray

set list
set listchars=tab:>·,trail:·
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
syntax on
set paste

"Plugin
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'cburroughs/pep8.py'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'fatih/vim-go'
call plug#end()

"Theme
let g:airline_theme='simple'
