" 定义快捷键的前缀，即<Leader>
let mapleader = ' '
let maplocalleader = ' '
let g:mapleader = ' '
let g:maplocalleader = ' '

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

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'skywind3000/asyncrun.vim'

Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'itchyny/lightline.vim'
Plug 'mbbill/undotree'
Plug 'sbdchd/neoformat'
Plug 'aperezdc/vim-template'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'leafgarland/typescript-vim'
Plug 'luochen1990/rainbow'
Plug 'jiangmiao/auto-pairs'

Plug 'justinmk/vim-sneak'
Plug 'airblade/vim-gitgutter'

Plug 'kshenoy/vim-signature'

Plug 'godlygeek/tabular',{'for':'markdown'}
Plug 'plasticboy/vim-markdown'
Plug 'ludovicchabant/vim-gutentags'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
call plug#end()

" 基础设置 {{{
" theme主题
set background=dark
set t_Co=256
colorscheme gruvbox
" 终端透明
hi Normal  ctermfg=252 ctermbg=none
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
set foldmethod=syntax
:autocmd FileType vim set foldmethod=marker
:autocmd FileType python set foldmethod=indent
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
set completeopt=longest,menu
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
imap kj <C-o>
" Quickly close the current window
nnoremap <leader>q :q<CR>

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
nmap <leader>tn :tabnext<cr>
nmap <leader>te :tabnew<cr>
nmap <leader>tp :tabprevious<cr>

nmap <Tab> <C-w>w

"}}}
" coc {{{
autocmd FileType json syntax match Comment +\/\/.\+$+
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

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

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



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
" }}}
"nerdtree {{{
nmap <leader>ft :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"
"打开文件夹 or 空目录自动打开nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0])&& !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd VimEnter * if !argc() | NERDTree | endif
" }}}
"fzf {{{
" Mapping selecting mappings
nmap <leader>fh :History<CR>
nmap <leader>ff :Files<CR>
nmap <leader>f/ :Ag<CR>
nmap <leader>fm :Marks<CR>
" }}}
" tagbar {{{
nmap <leader>tb :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_width = 30
" }}}
" neomake {{{
"call neomake#configure#automake('w')
"let g:neomake_typescript_enabled_makers = ["tslint"]
"let g:neomake_logfile = '/tmp/neomake.log'
" }}}
" ale {{{
"let g:ale_linters = {'typescript': ['tslint']}
"let g:ale_fixers = {
      "\  '*': ['remove_trailing_lines', 'trim_whitespace'],
      "\ 'typescript': ['tslint']
      "\}
"let g:ale_fix_on_save = 1
" }}}
" quickrun {{{
let g:quickrun_config = {
      \   "_" : {
      \       "outputter" : "message",
      \   },
      \}
"}}}
" neoformat {{{

noremap <leader>bf :Neoformat<CR>
"}}}
" lightline {{{
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified'] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ }
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
" vim-gutentags{{{
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" 所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
  silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" }}}
" vim-template{{{
let g:templates_directory = '/home/zekin/.vim/templates'
" }}}
let g:mkdp_auto_start = 1
" other{{{
" NormalMapForEnter: Normal 模式下回车键，对于特定文件类型，则在行尾加分号
nnoremap <expr> <CR> NormalMapForEnter() . "\<Esc>"
function! NormalMapForEnter()
  if &filetype ==# 'quickfix'
    return "\<CR>"
  elseif index([
        \ 'c',
        \ 'cpp',
        \ 'cs',
        \ 'css',
        \ 'java',
        \ 'rust',
        \ 'scss',
        \ 'typescript',
        \ 'typescript.tsx'
        \ ],&filetype) >= 0
    let l:line = getline('.')
    if l:line != '' && l:line !~ '^\s\+$' && index([';', '{', '(', '\'], l:line[-1:]) < 0
      return "A;"
    else
      return ""
    endif
  else
    return ""
  endif
endfunction

" MapForSemicolonEnter: Insert 模式 ;<CR> 插入 “;” 并换行
" [[[
inoremap <expr> ;<CR> MapForSemicolonEnter()
function! MapForSemicolonEnter()
    if (getline('.')[-1:] != ';') &&
        \(index([
            \ 'c',
            \ 'cpp',
            \ 'cs',
            \ 'css',
            \ 'java',
            \ 'rust',
            \ 'scss',
            \ 'typescript',
            \ 'typescript.tsx'
        \ ],&filetype) >= 0)
        return "\<End>;\<CR>"
    else
        return "\<Esc>o"
    endif
endfunction
" ]]]
" " InsertMapForEnter: Insert 模式下回车键映射
" [[[
inoremap <expr> <CR> InsertMapForEnter()
function! InsertMapForEnter()
    " 补全菜单
    if pumvisible()
        return "\<C-y>"
    " 自动缩进大括号 {}
    elseif strcharpart(getline('.'),getpos('.')[2]-1,1) == '}'
        return "\<CR>\<Esc>O"
    elseif strcharpart(getline('.'),getpos('.')[2]-1,2) == '</'
        return "\<CR>\<Esc>O"
    else
        return "\<CR>"
    endif
endfunction
" ]]]

" }}}
"
let g:asyncrun_open = 8
