" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'vivien/vim-linux-coding-style'
call plug#end()
call deoplete#enable()

" Show line numbers
set number

" Clipboard
set clipboard=unnamedplus

" Ftplugins
filetype plugin indent on

" Line length
set colorcolumn=79

" Clang completion
source ~/.clang_complete.vim

if filereadable("vimrc_local")
    source vimrc_local
endif
