call plug#begin('~/.vim/plugged')
" Color scheme
Plug 'tinted-theming/base16-vim'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Navigation
Plug 'christoomey/vim-tmux-navigator'

" Smooth scrolling
Plug 'karb94/neoscroll.nvim'

" Spelling, thesaurus, dictionary
Plug 'preservim/vim-lexical'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

" ANSI escape sequences
Plug 'powerman/vim-plugin-AnsiEsc'

" Language syntax
Plug 'terrastruct/d2-vim'

" Native LSP & Completion
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'saghen/blink.cmp', { 'tag': '*', 'do': 'cargo build --release' }
call plug#end()

" Disable unused remote plugin providers for faster startup and clean checkhealth
let g:loaded_python3_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

set mouse=a
" Default format: 4 spaces, 79 line length, unix line ending
set sw=4
set ts=4
set et
set autoindent

set ignorecase
set smartcase
set magic
" Line number
set number
set signcolumn=yes

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Diagnostic message update interval
set updatetime=300

" Don't give |ins-completion-menu| messages
set shortmess+=c

" Clipboard
set clipboard=unnamedplus

" Ftplugins
filetype plugin indent on

" Line length
set colorcolumn=80

" Shortcuts
    " Leader key
    let mapleader = ","
    let maplocalleader = ","

    " Map C-/ to toggle comments (using Neovim native commenting)
    " Terminal may send <C-_> or <C-/> for Ctrl-/
    nmap <C-_> gcc
    xmap <C-_> gc
    nmap <C-/> gcc
    xmap <C-/> gc

    " Esc to exit terminal mode
    tnoremap <Esc> <C-\><C-n>

    " Moving around windows (seamlessly across Vim splits and Tmux panes)
    let g:tmux_navigator_no_mappings = 1
    if has('macunix')
        tnoremap <silent> <C-Left> <C-\><C-N>:TmuxNavigateLeft<cr>
        tnoremap <silent> <C-Down> <C-\><C-N>:TmuxNavigateDown<cr>
        tnoremap <silent> <C-Up> <C-\><C-N>:TmuxNavigateUp<cr>
        tnoremap <silent> <C-Right> <C-\><C-N>:TmuxNavigateRight<cr>
        inoremap <silent> <C-Left> <C-\><C-N>:TmuxNavigateLeft<cr>
        inoremap <silent> <C-Down> <C-\><C-N>:TmuxNavigateDown<cr>
        inoremap <silent> <C-Up> <C-\><C-N>:TmuxNavigateUp<cr>
        inoremap <silent> <C-Right> <C-\><C-N>:TmuxNavigateRight<cr>
        nnoremap <silent> <C-Left> :TmuxNavigateLeft<cr>
        nnoremap <silent> <C-Down> :TmuxNavigateDown<cr>
        nnoremap <silent> <C-Up> :TmuxNavigateUp<cr>
        nnoremap <silent> <C-Right> :TmuxNavigateRight<cr>
    else
        tnoremap <silent> <A-h> <C-\><C-N>:TmuxNavigateLeft<cr>
        tnoremap <silent> <A-j> <C-\><C-N>:TmuxNavigateDown<cr>
        tnoremap <silent> <A-k> <C-\><C-N>:TmuxNavigateUp<cr>
        tnoremap <silent> <A-l> <C-\><C-N>:TmuxNavigateRight<cr>
        inoremap <silent> <A-h> <C-\><C-N>:TmuxNavigateLeft<cr>
        inoremap <silent> <A-j> <C-\><C-N>:TmuxNavigateDown<cr>
        inoremap <silent> <A-k> <C-\><C-N>:TmuxNavigateUp<cr>
        inoremap <silent> <A-l> <C-\><C-N>:TmuxNavigateRight<cr>
        nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
        nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
        nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
    endif

    map <C-q> <C-w>q
    map <C-t> :vsp<CR>


" Colour schemes
set termguicolors
colorscheme base16-oceanicnext

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
    let g:airline_detect_spelllang = 1
    let g:airline_mode_map = {
        \ '__' : '-',
        \ 'n'  : 'N',
        \ 'i'  : 'I',
        \ 'R'  : 'R',
        \ 'c'  : 'C',
        \ 'v'  : 'V',
        \ 'V'  : 'V',
        \ "\<C-v>" : 'V',
        \ 's'  : 'S',
        \ 'S'  : 'S',
        \ "\<C-s>" : 'S',
        \ }

    " Extensions
        " Tabline
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#alt_sep = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline#extensions#tabline#show_close_button = 1 
        let g:airline#extensions#tabline#close_symbol = 'X'

        " Neovim native LSP diagnostics in Airline
        let g:airline#extensions#nvimlsp#enabled = 1
        let g:airline#extensions#nvimlsp#error_symbol = 'E:'
        let g:airline#extensions#nvimlsp#warning_symbol = 'W:'
        let g:airline#extensions#nvimlsp#open_lnum_symbol = '(L'
        let g:airline#extensions#nvimlsp#close_lnum_symbol = ')'

" vim-lexical
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType tex call lexical#init()
  autocmd FileType text call lexical#init()
  autocmd FileType org call lexical#init()
augroup END
let g:lexical#dictionary = ['~/dotfiles/data/british',]
let g:lexical#thesaurus = ['~/dotfiles/data/moby-thesaurus.txt',]
let g:lexical#spelllang = ['en_ca']
let g:lexical#spell_key = '<leader>s'
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'

" Source local vimrc if there's any
if filereadable(".vimrc_local")
    source .vimrc_local
endif

" Jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" Markdown preview browser
if has('macunix')
    let g:mkdp_browser = 'Firefox Nightly'
else
    if executable('firefox-nightly')
        let g:mkdp_browser = 'firefox-nightly'
    elseif executable('firefox')
        let g:mkdp_browser = 'firefox'
    endif
endif

" Load Lua configurations
lua require('config.lsp')
lua require('config.neoscroll')
