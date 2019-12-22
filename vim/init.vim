" plugin {{{
call plug#begin('~/.vim/plugged')
" 系统工具
Plug 'skywind3000/asyncrun.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'
Plug 'scrooloose/nerdcommenter'
Plug 'itchyny/lightline.vim'
Plug 'sbdchd/neoformat'
Plug 'justinmk/vim-sneak'
Plug 'jiangmiao/auto-pairs'
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ludovicchabant/vim-gutentags'

"界面美化
Plug 'norcalli/nvim-colorizer.lua'
Plug 'luochen1990/rainbow'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'

" 语言相关
Plug 'HerringtonDarkholme/yats.vim', {'for': ['typescript', 'typescriptreact']}
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'iamcco/markdown-preview.nvim', {'for': 'markdown', 'do': { -> mkdp#util#install() } }
Plug 'dart-lang/dart-vim-plugin', {'for': 'dart'}

" textobj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-diff'
Plug 'kana/vim-textobj-entire'
Plug 'Julian/vim-textobj-brace'
Plug 'kana/vim-textobj-function'

"补全相关
Plug 'ycm-core/YouCompleteMe'
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
" deoplete {{{
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:ycm_language_server = 
  \ [ 
  \   {
  \     'name': 'texlab',
  \     'cmdline': [ 'texlab'],
  \     'filetypes': [ 'tex' ]
  \   },
  \ ]
" }}}
"defx {{{
call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'botright',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'columns': 'git:mark:indent:icons:filename:type'
      \ })
nmap <leader>p :Defx<CR>
"打开文件夹 or 空目录自动打开nerdtree
autocmd FileType defx call s:defx_my_settings()
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0])&& !exists("s:std_in") | exe 'Defx' argv()[0] | wincmd p | ene | endif
autocmd VimEnter * if !argc() | Defx | endif
function! s:defx_my_settings() abort
  setl nospell
  setl signcolumn=no
  setl nonumber
  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') :
        \ defx#do_action('drop',)
  nmap <silent><buffer><expr> <2-LeftMouse>
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') :
        \ defx#do_action('drop',)
  nnoremap <silent><buffer><expr> s defx#do_action('drop', 'split')
  nnoremap <silent><buffer><expr> v defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> t defx#do_action('drop', 'tabe')
  nnoremap <silent><buffer><expr> o defx#do_action('open_tree')
  nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> C defx#do_action('copy')
  nnoremap <silent><buffer><expr> P defx#do_action('paste')
  nnoremap <silent><buffer><expr> M defx#do_action('rename')
  nnoremap <silent><buffer><expr> D defx#do_action('remove_trash')
  nnoremap <silent><buffer><expr> A defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> U defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select')
  nnoremap <silent><buffer><expr> R defx#do_action('redraw')
  nnoremap <buffer><silent> [c <Plug>(defx-git-prev)
  nnoremap <buffer><silent> ]c <Plug>(defx-git-next)
endfunction

" Defx git
let g:defx_git#indicators = {
      \ 'Modified'  : '✹',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Deleted'   : '✖',
      \ 'Unknown'   : '?'
      \ }
call defx#custom#column('git', 'column_length', 0)
hi def link Defx_filename_directory NERDTreeDirSlash
hi def link Defx_git_Modified Special
hi def link Defx_git_Staged Function
hi def link Defx_git_Renamed Title
hi def link Defx_git_Unmerged Label
hi def link Defx_git_Untracked Tag
hi def link Defx_git_Ignored Comment

" Defx icons
" Requires nerd-font, install at https://github.com/ryanoasis/nerd-fonts or
" brew cask install font-hack-nerd-font
" Then set non-ascii font to Driod sans mono for powerline in iTerm2
" disbale syntax highlighting to prevent performence issue
let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 1
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
" snaek {{{
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
" }}}
" markdown preview {{{
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_open_to_the_world = 1
let g:mkdp_echo_preview_url = 1
" }}}
" asyncrun {{{
let g:asyncrun_open = 8
" }}}
" haskell{{{
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
" }}}
" AutoRUN {{{
func! AuToRUN()
  exec "w"
  if &filetype == 'c'
    exec "AsyncRun gcc % && ./a.out && rm a.out"
  elseif &filetype == 'python'
    exec "AsyncRun python %"
  elseif &filetype == 'haskell'
    exec "AsyncRun runghc %"
  endif
endfunc

nmap <leader>r :call AuToRUN()<CR>
command! Config :e ~/.config/nvim/init.vim
" }}}
" fzf {{{
nmap <leader>f :Files<CR>
nmap <leader>g :Rg<CR>
nmap <leader>bt :BTags<CR>
nmap <leader>t :Tags<CR>
" }}}
" gutentags {{{
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" 所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_exclude = ['./node_modules/**']
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" }}}
