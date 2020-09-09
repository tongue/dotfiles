filetype plugin indent on

let g:mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'arzg/vim-colors-xcode'
Plug 'junegunn/vim-peekaboo'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'mbbill/undotree'
Plug 'dyng/ctrlsf.vim'
Plug 'sgur/vim-editorconfig'
Plug 'mattn/emmet-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kshenoy/vim-signature'
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'chrisbra/Colorizer' 
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'dense-analysis/ale'
Plug 'mcchrish/nnn.vim'
call plug#end()

" SETTINGS =========================================================
syntax on

set number
set relativenumber
set noswapfile
set hidden
set nolazyredraw
set mouse=
set visualbell
set autoread

set scrolloff=8
set undolevels=5000

set foldmethod=manual
set diffopt=filler,vertical

set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×

set showcmd
set noshowcmd noruler

set nowrap
set textwidth=0

" Indentation
set noexpandtab
set tabstop=2
set softtabstop=0
set shiftwidth=2
set shiftround

" Search
set ignorecase
set smartcase
set gdefault

set background=dark
set termguicolors
set cursorline
let g:gruvbox_contrast_dark = "soft"
colorscheme gruvbox

" LSP ==============================================================
lua << EOF
local nvim_lsp = require'nvim_lsp'
nvim_lsp.tsserver.setup{}
nvim_lsp.html.setup{}
nvim_lsp.cssls.setup{}
nvim_lsp.jsonls.setup{}
EOF

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_enable_auto_popup = 1
let g:diagnostic_enable_virtual_text = 1

" map <c-p> to manually trigger completion
inoremap <silent><expr> <c-p> completion#trigger_completion()

" ALE
let g:ale_fixers = {'javascript': ['prettier', 'eslint'], 'typescript': ['prettier', 'tslint'], 'css': ['prettier'], 'json': ['prettier'], 'html': ['prettier']}
let g:ale_fix_on_save = 1

let g:ctrlsf_ackprg = 'ag'

" AUTOCMD ==========================================================

" Trigger autoread when changing buffers or coming back to vim.
au FocusGained,BufEnter * :silent! !

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
autocmd BufEnter * lua require'diagnostic'.on_attach()

" FZF ================================================================
let g:fzf_layout = { 'up': '100%' }

function! s:fzf_ag_raw(cmd)
  call fzf#vim#ag_raw(a:cmd)
endfunction

" DELIMITMATE ========================================================
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1 " {|} => { | }

" UNDOTREE ===========================================================
set undofile
" Auto create undodir if not exists
let undodir = expand($HOME . '/.config/nvim/cache/undodir')
if !isdirectory(undodir)
	call mkdir(undodir, 'p')
endif
let &undodir = undodir

" CTRLSF ===========================================================
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_populate_qflist = 1

" JSX ==============================================================
let g:jsx_ext_required = 0

" MATCHUP ==========================================================
let g:matchup_matchparen_enabled = 0

" NNN ==============================================================
" Floating window (neovim latest and vim with patch 8.2.191)
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
let g:nnn#action = {
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }
let g:nnn#replace_netrw = 1

" MAPPINGS =========================================================
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>

nnoremap <leader>w :w<CR>

nnoremap <Leader>v `[v`]

nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <leader>p :w<CR>:Prettier<CR>:w<CR><Esc>

nnoremap <BS><BS> :only<CR>

nnoremap <leader>o :GFiles<CR>
nnoremap <leader>e :Buffers<CR>
nnoremap <leader>i :Files<CR>
nnoremap <leader>u :Ag<CR>

nnoremap <silent> <Leader>1 :NnnPicker<CR>
nnoremap <silent> <Leader>2 :NnnPicker '%:p:h'<CR>

nmap <silent> <Up> <Plug>(ale_previous_wrap)
nmap <silent> <Down> <Plug>(ale_next_wrap)

nnoremap <Leader>0 :UndotreeToggle<CR>

nmap <Leader>ff <Plug>CtrlSFPrompt
vmap <Leader>ff <Plug>CtrlSFPromptExec
nnoremap <Leader>ft :CtrlSFToggle<CR>
inoremap <Leader>ft <Esc>:CtrlSFToggle<CR>

" STATUSLINE ======================================================
function! Current_git_branch()
	let l:branch = split(fugitive#statusline(),'[()]')
	if len(l:branch) > 1
		return remove(l:branch, 1)
	endif
	return ""
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ 
set statusline+=%{Current_git_branch()}
set statusline+=\ 
set statusline+=%#LineNr#
set statusline+=\ %<%f\ %h%m%r
set statusline+=%=
set statusline+=\ 
set statusline+=\ \[%{&fileencoding?&fileencoding:&encoding}\]
set statusline+=\[%{&fileformat}\]
set statusline+=%y
