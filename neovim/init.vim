" vim: ts=4:sw=4:et
" Plugins
call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'vivien/vim-linux-coding-style'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'eagletmt/neco-ghc'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
call plug#end()
call deoplete#enable()

" Colour schemes
colorscheme base16-oceanicnext
set termguicolors

" Airline
    " Theme
    let g:airline_theme='base16_oceanicnext'
    
    " Symbols
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = '☰'
    let g:airline_symbols.maxlinenr = ''
    let g:airline_powerline_fonts = 1
    let g:airline_detect_spelllang=1
    let g:airline_mode_map = {
        \ '__' : '-',
        \ 'n'  : 'N',
        \ 'i'  : 'I',
        \ 'R'  : 'R',
        \ 'c'  : 'C',
        \ 'v'  : 'V',
        \ 'V'  : 'V',
        \ '' : 'V',
        \ 's'  : 'S',
        \ 'S'  : 'S',
        \ '' : 'S',
        \ }

    " Extensions
        " Tabline
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#alt_sep = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline#extensions#tabline#show_close_button = 1 
        let g:airline#extensions#tabline#close_symbol = 'X'

        " Vimtex
        let g:airline#extensions#vimtex#enabled = 1
        let g:airline#extensions#vimtex#left = "{"
        let g:airline#extensions#vimtex#right = "}"

        " ALE
        let g:airline#extensions#ale#enabled = 1
        let airline#extensions#ale#error_symbol = 'E:'
        let airline#extensions#ale#warning_symbol = 'W:'
        let airline#extensions#ale#open_lnum_symbol = '(L'
        let airline#extensions#ale#close_lnum_symbol = ')'

" Deoplete
let g:deoplete#enable_at_startup = 1

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
