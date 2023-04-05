" disable builtin filetype feature (turned back on later)
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" This is Vundle, which can be found in Github at gmarik/vundle.git
" specify GitHub repos with 'user/repository' format
Plugin 'VundleVim/Vundle.vim'

" nerdtree allows filesystem navigation while in vim
" :help NERD_tree.txt
Plugin 'scrooloose/nerdtree.git'
Plugin 'scrooloose/nerdcommenter'

" ctrl-p file search
Plugin 'kien/ctrlp.vim'

" To get plugins from vim scripts, reference the plugin by name as it appears
" on the site
Plugin 'jeetsukumaran/vim-buffergator'

" git integration
Plugin 'tpope/vim-fugitive'
" cs command for changing 'surroundings' ie quotes, brackets and tags
" counterpart to builtin ci command
Plugin 'tpope/vim-surround'
" repeat integration for other tpope extensions
Plugin 'tpope/vim-repeat'

" git autocomplete
"Plugin 'Valloric/YouCompleteMe'
" python autocomplete
Plugin 'davidhalter/jedi-vim'

" python folding
"Plugin 'tmhedberg/SimpylFold'

" ack search tool
Plugin 'mileszs/ack.vim'
" ag plugin for ack.vim, for speedup
Plugin 'ggreer/the_silver_searcher'

" superawesome color schemes
Plugin 'flazz/vim-colorschemes'

" python syntax
Plugin 'hdima/python-syntax'
" javascript syntax
Plugin 'jelera/vim-javascript-syntax'
Plugin 'scrooloose/syntastic'

" code tag listing: see methods and members of an object
"Plugin 'vim-scripts/taglist-plus'
Plugin 'majutsushi/tagbar'

" status
Plugin 'bling/vim-airline'

" most recently used files
Plugin 'vim-scripts/mru.vim'

" aka zencoding:
Plugin 'mattn/emmet-vim'

" Spell check
Plugin 'kamykn/spelunker.vim'

call vundle#end()



" all plugins must be declared before this point
" turn filetype functionality back on.
filetype plugin indent on

" custom options
" line numbering
set number
" tab size
set tabstop=4
set shiftwidth=4
" convert tabs to spaces
set expandtab

" instant search: jump to results on keydown
set incsearch
" highlight search results
set hlsearch
" case insensitive IFF search string is all lower case
set smartcase

" number of lines to keep below/above cursor, ie scroll when cursor gets
" within 10 spaces top/bottom of screen
set scrolloff=6

" indentation
set autoindent
set smartindent

set t_Co=256
" color apprentice
" color BadWolf
color atom
" color automation
" color codeschool

" YouCompleteMe plugin keymaps
" GoTo tries GoToDefinition then GoToDeclaration
"nnoremap gd :YcmCompleter GoTo<CR>
"nnoremap gD :YcmCompleter GoToDeclaration<CR>

" vim-jedi equivalents of YCM (see above)
map gd :call jedi#goto()<CR>
map gD :call jedi#goto_assignments()<CR>

" SimplyIFold plugin keymaps
" fold docstrings
let g:SimpylFold_docstring_preview = 0

autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

autocmd BufRead *.py normal zR

" ctrlp plugin options
" working path always stays in start directory
let g:ctrlp_working_path_mode = 0
" index everything (rather than only marked directories)
let g:ctrlp_root_markers = ['']
" infinite max files
let g:ctrlp_max_files = 0
" near-infinite max depth. Whee!
"
let g:ctrlp_max_depth = 99
" sane custom ignore
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|tmp$',
    \ 'file': '\.exe$\|\.so$\|\.dat$\|\.jar$\|\.pyc$\|\.pdf$\|\.ipynb$\|\.ico$\|\.png$\|\.jpg$\|\.gif$\|\.bmp$\|\.svg$\|\.xcf$\|\.swf$\|\.pst$\|\.swc$\|\.zip$\|\.gz$\|\.tar$'
    \ }


" default indexing root is workspace
map <C-p> :CtrlP /home/dev/workspace<CR>

"autocmd ColorScheme * highlight ExtraWhitespace ctermbg=black guibg=black
"highlight ExtraWhitespace ctermbg=black guibg=black

" ack and ag
" set silver_searcher as default codesearching tool
" -S: case sensitive only if query includes capital letters
" --max-count: sanity check, stop searching after 100 hits
" --nogroup: don't search file names (use CtrlP for searching filenames)
" --column: print column numbers in results
let g:ackprg = 'ag --nogroup --column -S --max-count 100'


" buffergator: no more cts!
" switch windows using g<movement> rather than <C-W><movement>
map gwh <C-W>h
map gwl <C-W>l
map gwj <C-W>j
map gwk <C-W>k
" move windows using g<S-movement> rather than <C-W><S-movement>
map gwH <C-W>H
map gwL <C-W>L
map gwJ <C-W>J
map gwK <C-W>K
" open windows using <Leader>t<movement>
map <Leader>wh <Leader><LEFT>
map <Leader>wl <Leader><RIGHT>
map <Leader>wj <Leader><DOWN>
map <Leader>wk <Leader><UP>

" NERD tree
map <Leader>nn :NERDTreeFind<cr>
map <Leader>nf :NERDTreeToggle<cr>
map <Leader>nb :NERDTreeFromBookmark<cr>

" taglist-plus
map <leader>tl :TagbarToggle<cr>

" syntastic options: defaults
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" tabs: no more cts
" switch tabs with gt<motion>
map gtl :tabn<cr>
map gth :tabp<cr>
map gt0 :tabfirst<cr>
" move tabs with gt<S-motion>
map gtL :execute 'silent! tabmove ' . tabpagenr()<cr>
map gtH :execute 'silent! tabmove ' . (tabpagenr()-2)<cr>
" new tab with gtn ('go tab new'). TODO definitely needs to be changed 
map gtn :tabedit<cr>
" close tab with ZT
map ZT :tabclose<cr>


" NERDCommenter
" add 1 space between comment character and commented text
let NERDSpaceDelims=1


" Ack: TODO NEEDS WORK
" searches for visually highlighted text, using register 'a'
" \av: searches visually highlighted text
" copies visual into 'a' register, yanks, calls :Ack, escapes and
" enters contents of 'a'
map <Leader>av "ay:Ack <C-r>=fnameescape(@a)<CR><CR>
" \aw: searches for word under cursor
" yanks in word into 'a' register, calls :Ack, escapes and enters contents of
" 'a'
map <Leader>aw "ayiw:Ack <C-r>=fnameescape(@a)<CR><CR>
" \aW: searches for whitespace-delimited text under cursor
map <Leader>aW "ayiW:Ack <C-r>=fnameescape(@a)<CR><CR>
" \aa: open Ack
map <Leader>aa :Ack<space>
" \a%: search for current file name by accessing the % (filename) register and
" removing the path
map <Leader>a% :Ack <C-r>=expand('%:t')<CR><CR>

" get rid of marks
let g:showmarks_enable = 0
