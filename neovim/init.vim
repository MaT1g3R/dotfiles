" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'vivien/vim-linux-coding-style'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
call plug#end()
call deoplete#enable()

" Show line numbers
set number

" Modeline
set modeline

" Clipboard
set clipboard=unnamedplus

" Ftplugins
filetype plugin indent on

" Line length
set colorcolumn=80

" Clang completion
source ~/.clang_complete.vim

if filereadable("vimrc_local")
    source vimrc_local
endif

" Supertab
source ~/.config/nvim/supertab.vim

" Leader key
let mapleader = ","

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
