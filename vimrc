" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Setup Bundle Support {
" The next three lines ensure that the ~/.vim/bundle/ system works
filetype on
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Appearance
set background=dark
colorscheme jellybeans
if has("gui_gtk2")
  set guifont=Cousine\ for\ Powerline\ 11
else
  set guifont=Cousine\ for\ Powerline:h13
endif
if has("gui_running")
  set transparency=10
endif
set guioptions-=T " turns off toolbar
set vb " turns off visual bell
set noerrorbells " don't make noise

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Editor behavior
set smartindent
set backupdir=~/.vimswaps,/tmp
let mapleader=","
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=1000 " keep 1000 lines of command line history
set ruler      " show the cursor position all the time
set showcmd    " display incomplete commands
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
set hidden     " Allow buffer switching without saving
if has('persistent_undo')
  set undofile         " Persistent undo is nice ...
  set undolevels=1000  " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif
set showmode   " Display the current mode
set cursorline " Highlight current line
set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
set mouse=a    " Automatically enable mouse usage
set mousehide  " Hide the mouse cursor while typing

" Formatting
set nowrap " Do not wrap long lines
set softtabstop=2
set shiftwidth=2
set tabstop=2
set autoindent
set expandtab " Use spaces instead of tabs
set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)

if has('cmdline_info')
  set ruler                   " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd                 " Show partial commands in status line and
    " Selected characters/lines in visual mode
endif

" Search
set incsearch  " do incremental searching
set ignorecase " Case insensitive search
set smartcase  " Case sensitive when uc present

" Status bar
if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%-3.3n\                  " buffer number
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=                       " Right aligned
  set statusline+=0x%-8B                   " character value
  set statusline+=%-14.(%l,%c%V%)\ %p%%    " file nav info
endif

" Files to be ignored
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Highlight spaces in ruby
let ruby_space_errors=1

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Do not replace tabs with spaces for languages that care
autocmd FileType make     set noexpandtab
autocmd FileType python   set noexpandtab
autocmd FileType javascript set dictionary+=$HOME/.vim/dict/node.dict

" Remove trailing spaces
autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" Custom extensions
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.jst set filetype=html

" Settings for raw text editing
autocmd BufRead *\.txt setlocal formatoptions=l
autocmd BufRead *\.txt setlocal lbr
autocmd BufRead *\.txt map j gj
autocmd BufRead *\.txt map k gk
autocmd BufRead *\.txt setlocal smartindent
autocmd BufRead *\.txt setlocal spell spelllang=en_us

" Automatically update copyright notice with current year
autocmd BufWritePre *
            \ if &modified |
            \   exe "g#\\cCopyright \(c\) \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
            \ endif

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>

" Bundle filetype
autocmd BufNewFile,BufReadPost *.bundle set filetype=vim


" Key (re)Mappings
map Q gq " Don't use Ex mode, use Q for formatting
map <leader>t :CtrlP<CR>
map <leader>b :CtrlPBuffer<CR>
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>f :execute 'NERDTreeFind'<CR>
map <leader>l :TagbarToggle<CR>
nmap <silent> <leader>/ :nohlsearch<cr>

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Move across tabs
map <S-H> gT
map <S-L> gt

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Fix home and end keybindings for screen, particularly on mac
" - for some reason this fixes the arrow keys too. huh.
map [F $
imap [F $
map [H g0
imap [H g0

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Force saving when needing to sudo first"
cnoreabbrev <expr> w!!
                \((getcmdtype() == ':' && getcmdline() == 'w!!')
                \?('!sudo tee % >/dev/null'):('w!!'))

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" Strip whitespace
function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
