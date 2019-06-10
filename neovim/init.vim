" Plugins
call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-speeddating'
Plug 'reedes/vim-lexical'
Plug 'ervandew/supertab'
Plug 'davidhalter/jedi-vim'
" Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-sayonara', {'on': 'Sayonara'}
Plug 'vim-scripts/SyntaxRange'
Plug 'kana/vim-smartinput'
" For func argument completion
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
"
" " File plugins
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'donRaphaco/neotex', { 'for': 'tex' }
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'zchee/deoplete-clang', {'for': ['c', 'cpp']}
Plug 'vivien/vim-linux-coding-style', {'for': 'c'}
Plug 'vhda/verilog_systemverilog.vim', {'for': 'verilog_systemverilog'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'sebastianmarkow/deoplete-rust', {'for': 'rust'}
Plug 'jceb/vim-orgmode', {'for': 'org'}
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'markdown'] }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': 'javascript'}
Plug 'martinda/Jenkinsfile-vim-syntax'
call plug#end()
call deoplete#enable()

set mouse=a
" Default format: 4 spaces, 79 line length, unix line ending
set sw=4
set ts=4
set et
set autoindent

set encoding=utf8
set ignorecase
set smartcase
set magic

" Shortcuts

    " Leader key
    let mapleader = ","
    let maplocalleader = ","

    " Map C-x to C-w to do window stuff easier
    map <C-x> <C-w>
    " Map C-/ to toggle comments
    " Vim sees / as _ for some reason
    map <C-_> <leader>c<space>
    
    " Esc to exit terminal mode
    tnoremap <Esc> <C-\><C-n>
    
    " Moveing around windows
    if has('macunix')
        tnoremap <C-Left> <C-\><C-N><C-w>h
        tnoremap <C-Down> <C-\><C-N><C-w>j
        tnoremap <C-Up> <C-\><C-N><C-w>k
        tnoremap <C-Right> <C-\><C-N><C-w>l
        inoremap <C-Left> <C-\><C-N><C-w>h
        inoremap <C-Down> <C-\><C-N><C-w>j
        inoremap <C-Up> <C-\><C-N><C-w>k
        inoremap <C-Right> <C-\><C-N><C-w>l
        nnoremap <C-Left> <C-w>h
        nnoremap <C-Down> <C-w>j
        nnoremap <C-Up> <C-w>k
        nnoremap <C-Right> <C-w>l
    else
        tnoremap <A-h> <C-\><C-N><C-w>h
        tnoremap <A-j> <C-\><C-N><C-w>j
        tnoremap <A-k> <C-\><C-N><C-w>k
        tnoremap <A-l> <C-\><C-N><C-w>l
        inoremap <A-h> <C-\><C-N><C-w>h
        inoremap <A-j> <C-\><C-N><C-w>j
        inoremap <A-k> <C-\><C-N><C-w>k
        inoremap <A-l> <C-\><C-N><C-w>l
        nnoremap <A-h> <C-w>h
        nnoremap <A-j> <C-w>j
        nnoremap <A-k> <C-w>k
        nnoremap <A-l> <C-w>l
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
        let g:polyglot_disabled = ['latex']
        
        " NeoTex
        let g:tex_flavor = 'latex'
        let g:neotex_latexdiff = 1
        let g:neotex_delay = 500

        " ALE
        let g:airline#extensions#ale#enabled = 1
        let airline#extensions#ale#error_symbol = 'E:'
        let airline#extensions#ale#warning_symbol = 'W:'
        let airline#extensions#ale#open_lnum_symbol = '(L'
        let airline#extensions#ale#close_lnum_symbol = ')'

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_completed_snippet = 1
let g:python_host_prog = $HOME.'/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME.'/.pyenv/versions/neovim/bin/python'

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
if has('macunix')
    let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
    let g:deoplete#sources#clang#clang_header = '/Library/Developer/CommandLineTools/usr/lib/clang/'
else
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
    let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
endif

" JSON
set conceallevel=0

" Rust
let g:deoplete#sources#rust#racer_binary=$HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$HOME.'/rust/src'
let g:rustfmt_autosave = 1

" Convert between spaces and tabs
source ~/.config/nvim/space_tab.vim

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

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

" jedi-vim
let g:pymode_rope = 0
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#use_splits_not_buffers = "top"
let g:jedi#goto_command = "<leader>b"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<leader><space>"
let g:jedi#rename_command = "<leader>r"

" Supertab
let g:SuperTabDefaultCompletionType = "<C-n>"
let g:SuperTabContextDefaultCompletionType = "<C-n>"

" Prettier
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue PrettierAsync

" neosnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
" if has('conceal')
  " set conceallevel=2 concealcursor=niv
" endif


"startify
let g:startify_session_dir = '~/.cache/nvim/session'
let g:startify_files_number = 5
let g:startify_update_oldfiles = 1
let g:startify_padding_left = 4
nmap <Leader>z :Startify<CR>
highlight StartifyHeader    guifg=#6699CC

let g:startify_custom_header = [
\ '',
\ '    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗', 
\ '    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
\ '    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
\ '    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
\ '    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
\ '    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝'
\ ]

let g:startify_list_order = [
        \ ['   Files:'],
        \ 'bookmarks',
        \ ['   Sessions:'],
        \ 'sessions',
        \ ['   Recent files:'],
        \ 'files',
        \ ['   Commands:'],
        \ 'commands',
        \ ]

if has('macunix')
    let g:startify_bookmarks = [
            \ {'d1': '~/dotfiles/shell/zshrc'},
            \ {'d2': '~/dotfiles/neovim/init.vim'},
            \ ]
else
    let g:startify_bookmarks = [
            \ {'d1': '~/dotfiles/shell/zshrc'},
            \ {'d2': '~/dotfiles/neovim/init.vim'},
            \ {'d3': '~/nfs/docker-compose.yml'},
            \ {'d4': '~/nfs/Caddyfile'},
            \ ]
endif

let g:startify_commands = [
        \ {'p1': ['Update All Plugins', ':PlugUpdate']},
        \ {'p2': ['Install New Plugins', ':PlugInstall']},
        \ {'p3': ['Clean Old Plugins', ':PlugClean']},
        \ {'p4': ['Upgrade vim-plug', ':PlugUpgrade']},
        \ {'p5': ['Plugin Status', ':PlugStatus']},
        \ {'ch': ['Check Health', ':checkhealth']},
        \ {'r': ['Reload init.vim', ':so ~/dotfiles/neovim/init.vim']},
        \ ]

" Source local vimrc if there's any
if filereadable(".vimrc_local")
    source .vimrc_local
endif

" Custom command
:command Automake :autocmd BufWritePost <buffer> make
