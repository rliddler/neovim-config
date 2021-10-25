" Possibly not needed any more but helped unbreak the odd thing
set nocompatible

" ----------------------------------------------
" Plugin setup
" ----------------------------------------------
filetype off
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim' 		      " Light touch status line
Plug 'jlanzarotta/bufexplorer'        " Show a sortable list of open buffers
Plug 'scrooloose/nerdtree'            " Visualise the project directory
Plug 'tpope/vim-commentary'           " Alternative commenting to try out
Plug 'mhinz/vim-startify'             " A start screen!
Plug 'kyazdani42/nvim-web-devicons'   " Fancy icons using patched font
Plug 'ntpeters/vim-better-whitespace' " Strip away whitespace from modified lines
Plug 'tpope/vim-endwise'              " Adds ends to ruby for you because you're lazy
Plug 'tpope/vim-fugitive'             " Git wrapper to help with lightline status
Plug 'tpope/vim-projectionist'        " Navigate to test files

Plug 'mileszs/ack.vim'              " fallback to old searching

" Language specific things
Plug 'google/vim-jsonnet'               " jsonnet

" Telescope search related
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Treesitter for syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Some colour schemes
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'

" Language server via COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()
filetype plugin indent on
syntax on


" ----------------------------------------------
" Colours and appearance
" ----------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

if has('termguicolors')
  set termguicolors
endif

"let g:sonokai_style = 'atlantis'
"let g:sonokai_enable_italic = 1

 let g:everforest_background = 'hard'

colorscheme everforest


" ----------------------------------------------
" Lightline setup
" ----------------------------------------------
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'everforest',
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \ },
  \ }

" Overwrite the default filename to be more specific
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" To do with ensuring we sync all our syntax highlighting
" each time from the start = may be slow however
syn sync fromstart


" ----------------------------------------------
" Commands
" ---------------------------------------------
let mapleader = "," 			" setup the leader key

" Telescope searching
nnoremap <leader>ff :lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({layout_config={width=0.8}}))<cr>
nnoremap <leader>fa :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({layout_config={width=0.8}}))<cr>
nnoremap <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({layout_config={width=0.8}}))<cr>
nnoremap <leader>fb <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap <leader>fh <cmd>Telescope help_tags theme=get_dropdown<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>


" Some sensible mappings for copy paste.
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" make W and Q act like w and q
command! W :w
command! Q :q
command! Qa :qa
command! Wq :wq
command! WQ :wq

" <leader>. to view all document buffers
nmap <silent> <unique> <Leader>. :BufExplorer<CR>

" Double leader to switch to the previous buffer
map <silent> <Leader><Leader> :b#<CR>

" <Leader>Q to toggle the rustlang tooltips in normal mode
" nnoremap <silent> <leader>Q :CocCommand rust-analyzer.toggleInlayHints<cr>

" <Leader>h to dismiss search result highlighting until next search or press of 'n'
noremap <silent> <leader>h :noh<CR>

" <Leader>H to show hidden characters
nmap <silent> <leader>H :set nolist!<CR>

" <Leader>i to reindent the current file
map <silent> <leader>i  mzgg=G`z

" <Leader>rt to run ctags on the current directory
map <leader>rt :!ctags -R .<CR><CR>

" <Leader>sp to toggle spelling highlighting
nmap <silent> <Leader>sp :setlocal spell!<CR>

" <Leader>sw to strip whitespace off the ends
nmap <silent> <Leader>sw <cmd>StripWhitespace<cr>


" ----------------------------------------------
" Indentation and formatting
" ----------------------------------------------

" Highlight trailing whitespace
highlight RedundantSpaces guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted

" Highlight Non-breaking spaces
highlight BadSpaces term=standout ctermbg=red guibg=red
match BadSpaces / \+/

set autoindent                          " Automatically indent based on syntax detection
set smarttab                            " tabs depend on the width set
set expandtab                           " Convert tabs to spaces
set shiftround 				                  " Round indentation to nearest multiple on shift
set nowrap                              " Line wrapping off
set scrolloff=3                         " More context around cursor
set tabstop=2                           " Number of spaces a tab is
set softtabstop=2                       " Number of spaces a tab is while editing
set shiftwidth=2 			                  " When shifting indent 2


" ----------------------------------------------
" General Settings
" ----------------------------------------------
set vb t_vb= 				                    " Disable annoying bells
set backupdir=/var/tmp,~/.tmp,.         " Don't clutter project dirs up with swap files
set directory=/var/tmp,~/.tmp,.

set number
set ruler
set mouse=a

set laststatus=2
set fdm=marker
set backspace=start,indent,eol

set textwidth=90                        " Wrap at 90 because paysvc is restrictive
set colorcolumn=90                      " Colour that column so we know if we're close
set fo+=t                               " required to be in format options whilst editing

set mousehide                           " Hide the mouse cursor when typing
set hidden                              " Allow buffer switching without saving
set sidescrolloff=0
set cursorline                          " Hilight the line the cursor is on

set background=dark
set nofoldenable                        " Disable all folding of content
set nojoinspaces                        " Use only 1 space after "." when joining lines instead of 2

set history=1000                        " Remember a decent way back
set spelllang=en_gb


" -----------------------------------
" NerdTree config
" -----------------------------------
" Close the tree when selecting a file
let NERDTreeQuitOnOpen=1
" open the tree
nmap <silent> <Leader>m :NERDTreeToggle<CR>
" open the tree and navite to the current file
map <silent> <Leader>M :NERDTreeFind<CR>


" -----------------------------------
" COC recommended config
" -----------------------------------
set nobackup
set nowritebackup
"set cmdheight=2
set updatetime=300
set shortmess+=c

if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
els
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              "\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


" -----------------------------------
" Search Options
" -----------------------------------
set hlsearch        " highlight search matches...
set incsearch       " ...as you type
set ignorecase      " Generally ignore case
set smartcase       " Care about case when capital letters show up

" Possibly required to force older regex for ruby files - uncomment if slow
" set re=1

" Prevent horrible scrolling around when trying to use a mouse
map <ScrollWheelLeft> <nop>
map <S-ScrollWheelLeft> <nop>
map <C-ScrollWheelLeft> <nop>
map <ScrollWheelRight> <nop>
map <S-ScrollWheelRight> <nop>
map <C-ScrollWheelRight> <nop>


" -----------------------------------
" Search Options
" -----------------------------------
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" ----------------------------------------------
" Git
" ----------------------------------------------
autocmd Filetype gitcommit setlocal spell textwidth=72 " wrap commits


" ----------------------------------------------
" Setup Startify
" ----------------------------------------------
let g:startify_change_to_vcs_root = 1
let g:startify_files_number = 6

let g:startify_list_order = [
      \ ['   Recent files in this directory:'],
      \ 'dir',
      \ ['   Bookmarks:'],
      \ 'bookmarks',
      \ ['   Sessions:'],
      \ 'sessions',
      \ ]

let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ ]

let g:startify_bookmarks = [
      \ { 'v': '~/.config/nvim/init.vim' },
      \ { 't': '/tmp/foo.txt' },
      \ ]

" Stop things splitting with Startify and replace it instead
autocmd User Startified setlocal buftype=


" -----------------------------------
" Setup file wildcard ignored names
" -----------------------------------
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem          " Disable output and VCS files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.jar                " Disable archive files
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " Ignore bundler and sass caches
set wildignore+=*/tmp/cache/*                                                " Ignore rails temporary asset caches
set wildignore+=node_modules/*                                               " Ignore node modules
set wildignore+=*.swp,*.swo,*~,._*                                           " Disable temp and backup files
set wildignore+=_build/*                                                     " Ignore elixirs build folder


" -----------------------------------
" Setup Projectionist switching to test files
" -----------------------------------
let g:projectionist_heuristics ={
      \  "spec/*.rb": {
      \     "app/*.rb":       {"alternate": "spec/{}_spec.rb",         "type": "source"},
      \     "lib/*.rb":       {"alternate": "spec/{}_spec.rb",         "type": "source"},
      \     "spec/*_spec.rb": {"alternate": ["app/{}.rb","lib/{}.rb"], "type": "test"}
      \  }
      \}

" -----------------------------------
" Treesitter enabling of highlights
" -----------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {"ruby"},
  },
}
EOF


" -----------------------------------
" Telescope stuff
" -----------------------------------
:lua require'nvim-web-devicons'.setup {}

lua <<EOF
require('telescope').setup{
  pickers = {
    buffers = {
      mappings = {
        i = {
          ['<C-w>'] = require("telescope.actions").smart_send_to_qflist,
          },
        },
      },
    },
  }
EOF
