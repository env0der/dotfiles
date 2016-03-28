let mapleader = ','

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround' "{{{
  let g:surround_no_insert_mappings = 1
"}}}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch' "{{{
  nmap <leader>D :Remove
"}}}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --all' } "{{{
  nnoremap <silent> <c-p> :FZF<CR>
  nnoremap gb :Buffers<cr>
  " nnoremap <leader>l :BLines<cr>
  " nnoremap <leader>t :BTags<cr>
  " nnoremap <leader>T :Tags<cr>
"}}}
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim' "{{{
  let g:unite_data_directory='~/.nvim/.cache/unite'
  let g:unite_source_history_yank_enable=1
  let g:unite_prompt='» '
  let g:unite_source_rec_async_command =['ag', '--follow', '--nocolor', '--nogroup','--hidden', '-g', '', '--ignore', '.git', '--ignore', '*.png']

  let g:unite_source_grep_command='ag'
  let g:unite_source_grep_default_opts='--nocolor --nogroup --hidden -a -S'
  let g:unite_source_grep_recursive_opt=''

  " nnoremap <silent> <c-p> :Unite -auto-resize -start-insert -direction=botright buffer file_rec/async<CR>
  " nnoremap <silent> <leader>bb :Unite -auto-resize -start-insert -direction=botright buffer<CR>

	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>f :UniteWithCursorWord file_rec/async -profile-name=navigate<CR>

  " nnoremap <leader>uq :UniteClose<CR>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings()

  function! s:unite_settings() "{{{
	  " Enable navigation with control-j and control-k in insert mode
	  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
	  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    imap <silent><buffer><expr> <C-s>     unite#do_action('split')
    imap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
    imap <silent><buffer><expr> <C-t>     unite#do_action('tabswitch')
  endfunction "}}}
"}}}
Plug 'Shougo/unite-outline' "{{{
  nnoremap <silent> <leader>o :Unite -auto-resize -start-insert -silent -direction=botright outline<CR>
"}}}

Plug 'mhinz/vim-grepper' "{{{
  nnoremap <leader>g :Grepper -tool ag -cword -grepprg ag --hidden --vimgrep<cr>
  nnoremap <leader>G :Grepper -tool ag -grepprg ag --hidden --vimgrep<cr>
  nmap gs <plug>(GrepperOperator)
  xmap gs <plug>(GrepperOperator)

  let g:grepper = {
        \ 'highlight': 0,
        \ 'quickfix': 0,
        \ }
  nnoremap <leader>qg :lclose<CR>
"}}}

Plug 'dyng/ctrlsf.vim', { 'on': ['CtrlSF', 'CtrlSFToggle'] }
Plug 'vim-airline/vim-airline' "{{{
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tagbar#enabled = 0
  let g:airline_powerline_fonts = 1
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = '|'
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = '|'
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_splits = 0
  let g:airline#extensions#tabline#show_close_button = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#show_tab_type = 0
  let g:airline#extensions#bufferline#enabled = 0
  let g:airline#extensions#taboo#enabled = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
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
"}}}
Plug 'vim-airline/vim-airline-themes' "{{{
  let g:airline_theme = 'simple'
"}}}
Plug 'gcmt/taboo.vim' "{{{
  set sessionoptions+=tabpages,globals
  let g:taboo_tabline = 0
  nmap <leader>tr :TabooRename<space>
"}}}

Plug 'easymotion/vim-easymotion' "{{{
  let g:EasyMotion_do_mapping = 0
  nmap <Space> <Plug>(easymotion-overwin-f)
  let g:EasyMotion_smartcase = 1
"}}}

Plug 'scrooloose/nerdtree' "{{{
  noremap <leader>ft :NERDTreeToggle<CR>
  let g:NERDTreeAutoDeleteBuffer=1
  let g:NERDTreeShowHidden=1
"}}}

Plug 'Shougo/deoplete.nvim' "{{{
  let g:deoplete#enable_at_startup = 1
  set completeopt+=noinsert,noselect

  " Movement within 'ins-completion-menu'
  imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
  imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

  " " <CR>: If popup menu visible, expand snippet or close popup with selection,
  " "       Otherwise, check if within empty pair and use delimitMate.
  " imap <silent><expr><CR> pumvisible() ?
  "       \ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : "\<C-y>")
  "       \ : (delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<CR>")

  " Undo completion
  inoremap <expr><C-g> deoplete#mappings#undo_completion()

  " <Tab> completion:
  " 1. If popup menu is visible, select and insert next item
  " 2. Otherwise, if within a snippet, jump to next input
  " 3. Otherwise, if preceding chars are whitespace, insert tab char
  " 4. Otherwise, start manual autocomplete
  imap <silent><expr><Tab> pumvisible() ? "\<C-n>"
    \ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
    \ : (<SID>is_whitespace() ? "\<Tab>"
    \ : deoplete#mappings#manual_complete()))

  smap <silent><expr><Tab> pumvisible() ? "\<C-n>"
    \ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
    \ : (<SID>is_whitespace() ? "\<Tab>"
    \ : deoplete#mappings#manual_complete()))

  inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:is_whitespace() "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~? '\s'
  endfunction "}}}
"}}}

Plug 't9md/vim-choosewin' "{{{
  nmap <leader>w <Plug>(choosewin)

  let g:choosewin_label = 'FGHJKLZXCVBNM'
  let g:choosewin_overlay_enable     = 1
  let g:choosewin_statusline_replace = 1
  let g:choosewin_tabline_replace    = 1
  let g:choosewin_label_padding      = 3
  let g:choosewin_blink_on_land      = 0

  let g:choosewin_color_label = {
    \ 'cterm': [ 236, 2 ], 'gui': [ '#555555', '#000000' ] }
  let g:choosewin_color_label_current = {
    \ 'cterm': [ 234, 220 ], 'gui': [ '#333333', '#000000' ] }
  let g:choosewin_color_other = {
    \ 'cterm': [ 235, 235 ], 'gui': [ '#333333' ] }
  let g:choosewin_color_overlay = {
    \ 'cterm': [ 2, 10 ], 'gui': [ '#88A2A4' ] }
  let g:choosewin_color_overlay_current = {
    \ 'cterm': [ 72, 64 ], 'gui': [ '#7BB292' ] }
"}}}

Plug 'https://github.com/env0der/delimitMate.git', { 'branch': 'optional-jump-over' } "{{{
 let g:delimitMate_expand_cr = 1
 let g:delimitMate_jump_over_in_insert_mode = 0
"}}}

Plug 'haya14busa/vim-asterisk' "{{{
  map *  <Plug>(asterisk-z*)
  map #  <Plug>(asterisk-z#)
  map g* <Plug>(asterisk-gz*)
  map g# <Plug>(asterisk-gz#)
  let g:asterisk#keeppos = 1
"}}}

Plug 'haya14busa/incsearch.vim' "{{{
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
"}}}
Plug 'osyo-manga/vim-anzu' "{{{
  map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
  map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
"}}}
Plug 'osyo-manga/vim-over' "{{{
  let g:over_enable_auto_nohlsearch = 1
  let g:over#command_line#search#enable_incsearch = 1
  cabbrev %s OverCommandLine<cr>%s
  cabbrev '<,'>s '<,'>OverCommandLine<cr>s
"}}}

Plug 'bkad/CamelCaseMotion' "{{{
	nmap <silent> e <Plug>CamelCaseMotion_e
	nmap <silent> w <Plug>CamelCaseMotion_w
	xmap <silent> w <Plug>CamelCaseMotion_w
	omap <silent> W <Plug>CamelCaseMotion_w
	nmap <silent> b <Plug>CamelCaseMotion_b
	xmap <silent> b <Plug>CamelCaseMotion_b
	omap <silent> B <Plug>CamelCaseMotion_b
"}}}

Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'AndrewRadev/sideways.vim' "{{{
  nnoremap H :SidewaysLeft<cr>
  nnoremap L :SidewaysRight<cr>
"}}}

Plug 'svermeulen/vim-easyclip' "{{{
  let g:EasyClipUseSubstituteDefaults = 1
  let g:EasyClipUseCutDefaults = 0

  nmap x <Plug>MoveMotionPlug
  xmap x <Plug>MoveMotionXPlug
  nmap xx <Plug>MoveMotionLinePlug
"}}}

Plug 'miyakogi/conoline.vim' "{{{
  let g:conoline_color_normal_dark = 'ctermbg=234'
  let g:conoline_color_normal_nr_dark = 'ctermbg=234'
  let g:conoline_color_insert_dark = 'ctermbg=234'
  let g:conoline_color_insert_nr_dark = 'ctermbg=234'
  let g:conoline_auto_enable = 1
"}}}

Plug 'mhinz/vim-sayonara' "{{{
  nnoremap <silent><leader>qq  :Sayonara<cr> " kill current buffer and close the window
  nnoremap <silent><leader>wc  :q<cr> " close current window but keep the buffer
  nnoremap <silent><leader>bk  :Sayonara!<cr> " kill current buffer but keep the window
"}}}

" languages support
Plug 'guns/vim-clojure-highlight' "{{{
  au BufNewFile,BufRead *.edn set filetype=clojure
""}}}
Plug 'guns/vim-clojure-static'
Plug 'luochen1990/rainbow' "{{{
  let g:rainbow_active = 1
  let g:rainbow_conf = {
      \   'ctermfgs': ['white', 'blue', 'yellow', 'magenta'],
      \   'operators': '_,_',
      \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \}
"}}}
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'honza/dockerfile.vim'

Plug 'othree/yajs.vim', { 'for': 'javascript' }
" Automatically treat .es6 extension files as javascript
autocmd BufRead,BufNewFile *.es6 setfiletype javascript
Plug 'othree/html5.vim'
Plug 'martin-svk/vim-yaml'

Plug 'klen/python-mode', { 'for': 'python '}
let g:pymode_rope = 1

" Colors
Plug 'w0ng/vim-hybrid'
call plug#end()

set t_ut= " improve screen clearing by using the background color
set background=dark
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

highlight LineNr ctermbg=none
set rnu
set number
set numberwidth=3
set noshowmode
set clipboard=unnamed
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set splitbelow " Splitting a window will put the new window below the current
set splitright " Splitting a window will put the new window right of the current

" Start scrolling 5 lines before the border
set scrolloff=5

" case insensitive search
set ignorecase
set smartcase

" Switch between buffers without saving
set hidden

" Keep the cursor on the same column
set nostartofline
set regexpengine=1

inoremap jj <ESC>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>sc :nohl<cr>

" Enter adds new line beneath current line in normal mode
nmap <CR> :a<CR><CR>.<CR>
" C-j inserts new line at the current cursor position in normal mode
nmap <C-j> i<CR><ESC>
" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" shortcuts for windows {{{
  nnoremap <leader>w/ <C-w>v<C-w>l
  nnoremap <leader>w- <C-w>s
  nnoremap <m-h> <C-w>h
  nnoremap <m-j> <C-w>j
  nnoremap <m-k> <C-w>k
  nnoremap <m-l> <C-w>l
  tnoremap <m-h> <C-\><C-n><C-w>h
  tnoremap <m-l> <C-\><C-n><C-w>l
  tnoremap <m-j> <C-\><C-n><C-w>j
  tnoremap <m-k> <C-\><C-n><C-w>k
  au WinEnter term://* startinsert
"}}}

" kill current tab
nnoremap <leader>tk :tabclose<CR>
" new tab
nnoremap <leader>tn :tabnew<CR>

" switch to alternate buffer
map <leader><leader> :b#<CR>

" Start substitute on current word under the cursor
nnoremap <leader>ss :%s///gc<Left><Left><Left>

" Zoom
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>

" change vim cursor depending on the mode
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
elseif empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

" Open files where we left off
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" BACKUP / TMP FILES
" taken from
" http://stackoverflow.com/questions/4331776/change-vim-swap-backup-undo-file-name
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" Delete trailing whitespaces on file save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
au BufWrite * silent call DeleteTrailingWS()

if has('nvim')
  nnoremap <leader>T  :vsplit +terminal<cr>
  tnoremap <esc>      <c-\><c-n>
  autocmd BufEnter term://* startinsert
endif

