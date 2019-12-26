call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'reedes/vim-lexical'
Plug 'w0rp/ale'
Plug 'psliwka/vim-smoothie'
call plug#end()

:imap ii <Esc>

let g:coc_global_extensions=[
\   'coc-python',
\   'coc-rls',
\   'coc-json'
\]
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
" Line number
set number
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
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

        " ALE
        let g:airline#extensions#ale#enabled = 1
        let airline#extensions#ale#error_symbol = 'E:'
        let airline#extensions#ale#warning_symbol = 'W:'
        let airline#extensions#ale#open_lnum_symbol = '(L'
        let airline#extensions#ale#close_lnum_symbol = ')'

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

" shell
if &shell =~# 'fish$'
  set shell=/usr/bin/zsh
endif

" Source local vimrc if there's any
if filereadable(".vimrc_local")
    source .vimrc_local
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+
