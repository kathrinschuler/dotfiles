"+=============================================================
" Features
" be iMproved, required
set nocompatible

" Enable syntax highlighting
syntax on

" Attempt to determine the type of a file based on its name
" and possibly its contents. Use this to allow intelligent
" auto-indenting for each filetype and for plugins that are
" filetype specific.
filetype plugin indent on

"+=============================================================
" Usability options


" Allows you to reuse the window and switch from an unsaved buffer
" without saving it first. Also allows you to keep an undo history
" for multiple files when re-using the same window in this way.
" Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually
" designed for keeping undo history after closing Vim entirely.
" Vim will complain if you try to quit without saving, and swap files
" will keep you safe if your computer crashes.
"set hidden

" Better command-line completion
set wildmenu
set wildignore+=*.o,*.d,*.gcno,*.a,*.tsk

" Show partial commands in the last line of the screen
set showcmd

"set highlighting in searching. To temporarily turn it off use <C-L>.
" see mapping of <C-L>
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Enable use of the mouse for all modes
set mouse=a

"Show line numbers
set number

" Allow backspacing over autoindent, line breaks and
" start of insert action
set backspace=indent,eol,start

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

"Always show statusline
set laststatus=2

" Use 256 colors
set t_Co=256

" character encoding
set encoding=utf-8

" ttyfast makes super awesome things
set ttyfast

" Stop certain movements from always going to the first character
" of a line. While this behaviour deviates from that of Vi,
" it does what most users coming from other editors would expect.
set nostartofline

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" show the line at 100 chars:
if exists('+colorcolumn')
    set colorcolumn=100
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
endif

" Spell checking
set spelllang=en_gb

"" Powerline/Lightline, make it show buffer tabs
set showtabline=2



"+=============================================================
" Indentation options
"
"Information on the following setting can be found with
":help set
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4  "this is the level of autoindent, adjust to taste
set ruler

" smartindent is bad for python, it moves #comments to the start of the line
au! FileType python setl nosmartindent

"only indent 2 for xml files
autocmd BufRead,BufNewFile *.xml,*.xsl,*.xsd set shiftwidth=2 tabstop=2

"indent 4 for cpp/py files
autocmd BufRead,BufNewFile *.h,*.cpp,*.hpp,*.py set shiftwidth=4 tabstop=4

" Use tabs in makefiles!
autocmd FileType make setlocal noexpandtab

"+=============================================================
" Mapppings

"copy automatically to the systems clipboard and remap copy command
set clipboard=unnamed
vnoremap <C-c> "*y

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

"or clear highlight with F12
map <F12> :noh<CR>

"Switch tab with F7 and F8
map <F7> gT
map <F8> gt

"Map jj to Escape
imap jj <Esc>

" disable arrow keys, otherwise I will never stop using them
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

"+=============================================================
" Plugins

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'                             " Powerful statusline
Plug 'vim-airline/vim-airline-themes'                      " Themes for statusline
Plug 'tpope/vim-surround'                                  " Surround parentheses, brackets, quotes etc.
Plug 'scrooloose/nerdcommenter'                            " Commenter
Plug 'rhysd/vim-clang-format'
Plug 'Raimondi/delimitMate'                                 " Parentheses autocomplete
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-fugitive'


" Initialize plugin system
call plug#end()


"+=============================================================
" Plugin Settings
"
" use solarized
" -----------------------------------
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

" airline theme
" -----------------------------------
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1

"" CLang Format
"" -----------------------------------
let g:clang_format#command = "/usr/bin/clang-format"
let g:clang_format#detect_style_file=1

nnoremap <Leader>a :ClangFormat<CR>

"delimitMate
"" -----------------------------------
let g:delimitMate_expand_cr=1
let g:delimitMate_excluded_regions = "Comment,String"

" Nerdtree
" -----------------------------------
" let g:NERDTreeDirArrows=0
nmap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if ( winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() ) | q | endif

let NERDTreeIgnore=['\.o$', '\.a$', '^00', '^tags$', '\.d$']

" Better Whitespace
" -----------------------------------
"Strip Whitespace
map <F10> :StripWhitespace<CR>

