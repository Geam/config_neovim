" neovim base configuration {{{
" basic display
set showmatch
set showcmd
set showmode
set ruler
set number

" default indentation setting
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.

" more natural way of spliting
set splitbelow
set splitright

if !&scrolloff
  set scrolloff=5       " Show next 3 lines while scrolling.
endif

set autoread                     " watch if the file is modified outside of vim

set wildmenu
set wildmode=longest:list,full
set wildignore=*.o,*.out,*.obj,*.pyc,.git,.hgignore,.svn,.cvsignore

set ignorecase
set smartcase

" search
set hlsearch            " Highlight search results.
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set incsearch           " Incremental search.

set colorcolumn=80      " color column at 80 columns

" Put all backup and swap in one place
set backupdir=~/.config/nvim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.config/nvim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"}}}

" whitespace highlight {{{
" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Highlighting spaces and tabulations
" (\zs & \ze == start and end of match, \s == any space)
match ErrorMsg '\s\+$'           " Match trailing whitespace
match ErrorMsg '\ \+\t'          " & spaces before a tab
match ErrorMsg '[^\t]\zs\t\+'    " & tabs not at the begining of a line
match ErrorMsg '\[^\s\]\zs\ \{2,\}' " & 2+ spaces not at the begining of a line
"}}}

" Vimscript file settings {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" plugin to install {{{
call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'tomasr/molokai'

" completion
Plug 'Shougo/deoplete.nvim'
Plug 'Rip-Rip/clang_complete'
Plug 'geam/neosnippet-snippets' | Plug 'Shougo/neosnippet.vim'

" ide like
Plug 'ctrlpvim/ctrlp.vim'
Plug 'benekastah/neomake'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'fatih/vim-go'
Plug 'Numkil/ag.nvim'

" fast editing
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

call plug#end()
" }}}

" set leader
let mapleader="\<SPACE>"
nnoremap <silent> <Leader>r :set relativenumber!<CR>

colorscheme molokai "colorscheme

" un-highlight
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" convenient shortcuts
nnoremap Q @q
nnoremap K :Man <cword><CR>
let g:airline_powerline_fonts = 1

" search word under cursor
nnoremap <Leader>s bvey/<C-R>"<CR><Esc>

" no mouse
set mouse=

" terminal mode {{{
tnoremap <Esc> <C-\><C-n>
nnoremap <Leader>t :vsp term://zsh<CR>i
" }}}

" ctrlp {{{
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPMRUFiles<CR>

" set the ignore file for ctrlp plugin
set wildignore+=*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
"}}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1

let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0
let g:clang_use_library = 1

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns._ = ['buffer']
let g:deoplete#omni#input_patterns.c = ['buffer', 'file', 'omni']

let g:deoplete#omni_input_patterns = {}
let g:deoplete#omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:deoplete#omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
" }}}

" snippets {{{
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<TAB>" : "\<Plug>(neosnippet_expand_or_jump)"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"}}}

" neomake {{{1
autocmd! BufWritePost,BufEnter * Neomake " activate syntax checker on save

" go maker {{{2
let g:neomake_go_gobuild_maker = {
    \ 'exe': 'sh',
    \ 'args': ['-c', 'go build -o ' . neomake#utils#DevNull() . ' ./\$0', '%:h'],
    \ 'errorformat':
        \ '%W%f:%l: warning: %m,' .
        \ '%E%f:%l:%c:%m,' .
        \ '%E%f:%l:%m,' .
        \ '%C%\s%\+%m,' .
        \ '%-G#%.%#'
    \ }
" }}}2
"}}}1

" vim-cpp-enhanced-highlight {{{
let g:cpp_class_scope_highlight = 1
"}}}

" vim-go {{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" }}}

" ag.nvim {{{
let g:ag_working_path_mode="r"
" }}}

" filetype {{{
augroup vimrcEx " {
    au!

    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80

    " Jump to the last known cursor position when editing a file
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif

    " FileType {{{
    " http://tedlogan.com/techblog3.html
    autocmd FileType sh setlocal ts=4 sts=4 sw=4 et ai " sh
    autocmd FileType c setlocal ts=4 sts=4 sw=4 noet ai " c
    autocmd FileType cpp setlocal ts=4 sts=4 sw=4 et ai " cpp
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noet ai " Makefile
    autocmd FileType vim setlocal ts=4 sts=4 sw=4 et ai " Vim
    autocmd FileType text setlocal ts=2 sts=2 sw=2 et ai " Text
    autocmd FileType markdown setlocal ts=4 sts=4 sw=4 et ai " Markdown
    autocmd FileType html setlocal ts=2 sts=2 sw=2 et ai " (x)HTML
    autocmd FileType php,java setlocal ts=2 sts=2 sw=2 et ai nocindent " PHP & Java
    autocmd FileType javascript setlocal ts=2 sts=2 sw=2 et ai nocindent " JavaScript
    autocmd FileType python setlocal ts=4 sts=4 sw=4 et ai " Python
    autocmd FileType ocaml setlocal ts=2 sts=2 sw=2 et ai " Ocaml
    autocmd FileType lisp setlocal ts=2 sts=2 sw=2 et ai " Lisp
    autocmd FileType go setlocal ts=2 sts=2 sw=2 noet ai " go
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 et ai "yaml
    autocmd BufNewFile,BufRead *.h set ft=c
    autocmd BufNewFile,BufRead *.json set ft=javascript
    autocmd BufNewFile,BufRead *.webapp set ft=javascript
    autocmd BufNewFile,BufRead *.tpp set ft=cpp
    " }}}

augroup END " }
" }}}
