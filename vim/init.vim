" plugin {{{
call plug#begin('~/.vim/plugged')
" 系统工具
Plug 'itchyny/lightline.vim'
Plug 'sbdchd/neoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

"界面美化
Plug 'norcalli/nvim-colorizer.lua'
Plug 'luochen1990/rainbow'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'

" textobj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'Julian/vim-textobj-brace'
Plug 'kana/vim-textobj-function'

"补全相关
Plug 'ycm-core/YouCompleteMe', {'on': []}
Plug 'ycm-core/lsp-examples', {'do': 'python ./install.py --enable-docker --enable-viml --enable-vue --enable-json --enable-yaml'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()
" }}}
" 基础设置 {{{
" 定义快捷键的前缀，即<Leader>
let mapleader = ' '
let maplocalleader = ' '
let g:mapleader = ' '
let g:maplocalleader = ' '

set termguicolors
" 开启语法高亮
syntax on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on
" 自适应不同语言的智能缩进
filetype indent on
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=2
" 设置格式化时制表符占用空格数
set shiftwidth=2
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=2
" 关闭兼容模式
set nocompatible
" vim 自身命令行模式智能补全
set wildmenu

set hidden

set nrformats=

" theme主题
set background=dark
set t_Co=256
colorscheme gruvbox
" 终端透明
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
" 总是显示状态栏
set laststatus=2
" 开启行号显示
set number
" 高亮显示当前行/列
set cursorline
set cursorcolumn
" 高亮显示搜索结果
set hlsearch
" 禁止折行
set nowrap
" 根据不同的文件类型选择缩进方式
set foldmethod=marker
" 启动 vim 时关闭折叠代码
set nofoldenable
" 设置历史容量
set history=2000
"create undo file
if has('persistent_undo')
  " How many undos
  set undolevels=1000
  " number of lines to save for undo
  set undoreload=10000
  " So is persistent undo ...
  set undofile
  set undodir=~/.vim/vimundo/
endif
" 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉
" 好处：误删什么的，如果以前屏幕打开，可以找回
set t_ti= t_te=
" 鼠标暂不启用, 键盘党....
set mouse=a
" 打开增量搜索模式,随着键入即时搜索
set incsearch
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
" 插入模式下用绝对行号, 普通模式下用相对
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>
set completeopt=longest,menuone
" 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" 关闭方向键, 强迫自己用 hjkl
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
" kj 替换 Esc
inoremap jk <Esc>
" Quickly close the current window
nnoremap <leader>q :wqa<CR>

"     Quickly save the current file
nnoremap <leader>w :w<CR>
" remap U to <C-r> for easier redo
nnoremap U <C-r>
" 设置可以高亮的关键字
if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
  endif
endif

nmap <leader>bl :ls<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>
nmap <leader>bc :bufdo bwipeout<cr>

nmap <Tab> <C-w>w


"}}}
" ycm {{{
let g:ycm_language_server = [
	\		{
  \     'name': 'yaml',
  \     'cmdline': [ 'node', expand( '$HOME/.vim/plugged/lsp-examples/yaml/node_modules/.bin/yaml-language-server' ), '--stdio' ],
  \     'filetypes': [ 'yaml' ],
  \   },
  \   {
  \     'name': 'json',
  \     'cmdline': [ 'node', expand( '$HOME/.vim/plugged/lsp-examples/json/node_modules/.bin/vscode-json-languageserver' ), '--stdio' ],
  \     'filetypes': [ 'json' ],
  \   },
  \   { 'name': 'vue',
  \     'filetypes': [ 'vue' ], 
  \     'cmdline': [ expand( '$HOME/.vim/plugged/lsp-examples/vue/node_modules/.bin/vls' ) ]
  \   },
  \   { 'name': 'docker',
  \     'filetypes': [ 'dockerfile' ], 
  \     'cmdline': [ expand( '$HOME/.vim/plugged/lsp-examples/lsp/docker/node_modules/.bin/docker-langserver' ), '--stdio' ]
  \   },
  \   { 'name': 'vim',
  \     'filetypes': [ 'vim' ],
  \     'cmdline': [ expand( '$HOME/.vim/plugged/lsp-examples/viml/node_modules/.bin/vim-language-server' ), '--stdio' ]
  \   },
  \   { 'name': 'haskell',
  \     'filetypes': [ 'haskell', 'hs', 'lhs' ],
  \     'cmdline': [ 'hie-wrapper', '--lsp' ],
  \     'project_root_files': [ '.stack.yaml', 'cabal.config', 'package.yaml' ]
  \   }
  \ ]
let g:ycm_semantic_triggers = {
  \ 'haskell': ['re!\w{2}']
  \ }

" }}}
" neoformat {{{
noremap =G :Neoformat<CR>
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_typescriptreact = ['prettier']
"autocmd BufWritePre * Neoformat
"}}}
" rainbow {{{
let g:rainbow_active = 1
"}}}
" markdown preview {{{
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_open_to_the_world = 1
let g:mkdp_echo_preview_url = 1
" }}}
" asyncrun {{{
let g:asyncrun_open = 6
" }}}
" AutoRUN {{{

command! Config :e ~/.config/nvim/init.vim
command! YcmStart call plug#load('YouCompleteMe')
nmap <leader>s :YcmStart<CR>
noremap <silent><leader>r :AsyncTask project-run<cr>
" }}}
" fzf {{{
nmap <leader>f :Files<CR>
nmap <leader>g :Rg<CR>
nmap <leader>bt :BTags<CR>
nmap <leader>t :Tags<CR>
" }}}
" for wsl 
let g:clipboard = {
      \   'name': 'myClipboard',
      \   'copy': {
      \      '+': 'win32yank.exe -i',
      \      '*': 'win32yank.exe -i',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o --lf',
      \      '*': 'win32yank.exe -o --lf',
      \   },
      \   'cache_enabled': 1,
      \ }
