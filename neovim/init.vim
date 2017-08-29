" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'zchee/deoplete-jedi'
call plug#end()
call deoplete#enable()

" Show line numbers
set number

" Clipboard
set clipboard=unnamedplus

" Ftplugins
filetype plugin indent on
