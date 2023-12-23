" dein settings {{{
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " Plugins
    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/denite.nvim')
    call dein#add('Shougo/deoplete-lsp')
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/neomru.vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('CRAG666/code_runner.nvim')
    call dein#add('Yggdroot/indentLine')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('b0o/schemastore.nvim')
    call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
                        \ 'build': 'sh -c "cd app && npx --yes yarn install"' })
    call dein#add('jiangmiao/auto-pairs')
    call dein#add('majutsushi/tagbar')
    call dein#add('neovim/nvim-lspconfig')
    call dein#add('nvim-lua/diagnostic-nvim')
    call dein#add('nvim-lua/lsp_extensions.nvim')
    call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})
    call dein#add('preservim/nerdtree')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('tomasr/molokai')
    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-fugitive')
    call dein#add('tpope/vim-surround')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    call dein#end()
    call dein#save_state()
endif
" プラグインの追加・削除やtomlファイルの設定を変更した後は
" 適宜 call dein#update や call dein#clear_state を呼んでください。
" そもそもキャッシュしなくて良いならload_state/save_stateを呼ばないようにしてください。


" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif
" }}}


" General settings
colorscheme molokai
set autoread
set number
set cursorline
set virtualedit=onemore
set termguicolors
set mouse=
set ignorecase
set smartcase
set wrapscan
set hlsearch
set expandtab
set shiftwidth=4
set tabstop=4
set showmatch
set wildmode=list:longest
set clipboard+=unnamedplus

" Remove comment continuation set by $VIMRUNTIME/ftplugin/vim.vim
autocmd FileType * setlocal formatoptions-=cro


nnoremap <End> <End><Right>
nnoremap <Home> ^
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>

inoremap <S-Tab> <C-d>
inoremap <Home> <Esc>^i
inoremap <PageUp> <C-o><C-u>
inoremap <PageDown> <C-o><C-d>


let g:python3_host_prog = '/usr/bin/python3'




" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Sets the background to NONE, making it transparent.
hi Normal guibg=NONE ctermbg=NONE
hi Visual guibg=LightGrey ctermbg=LightGrey



" airline settings
let g:airline_theme = 'wombat'
let g:airline#extensions#tabline#enabled = 1 " タブラインを表示
let g:airline_powerline_fonts = 1            " Powerline Fontsを利用 "実際nerd fontが必要だそうです...
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
let g:airline_mode_map = {
	\ 'n'  : 'Normal',
	\ 'i'  : 'Insert',
	\ 'R'  : 'Replace',
	\ 'c'  : 'Command',
	\ 'v'  : 'Visual',
	\ 'V'  : 'V-Line',
	\ '⌃V' : 'V-Block',
	\ }


" denite settings {
augroup my_denite
    autocmd!
    autocmd FileType denite call s:denite_my_settings()
    autocmd FileType denite-filter call s:denite_filter_my_settings()
augroup END

" Define mappings
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
endfunction

function! s:denite_filter_my_settings() abort
    " imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
    augroup ftplugin-my-denite
        autocmd! * <buffer>
        autocmd InsertEnter <buffer> imap <silent><buffer> <CR> <ESC><CR><CR>
        autocmd InsertEnter <buffer> inoremap <silent><buffer> <Esc> <Esc><C-w><C-q>:<C-u>call denite#move_to_parent()<CR>
    augroup END
    
    call deoplete#custom#buffer_option('auto_complete', v:false)

    inoremap <silent><buffer> <Down> <Esc>
       \:call denite#move_to_parent()<CR>
       \:call cursor(line('.')+1,0)<CR>
       \:call denite#move_to_filter()<CR>A
    inoremap <silent><buffer> <Up> <Esc>
       \:call denite#move_to_parent()<CR>
       \:call cursor(line('.')-1,0)<CR>
       \:call denite#move_to_filter()<CR>A
endfunction

call denite#custom#var('file/rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
call denite#custom#var('grep', 'default_opts', [])
call denite#custom#var('grep', 'recursive_opts', [])

call denite#custom#source('max_candidates', '5000')
" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

nmap <silent> <C-u><C-p> :<C-u>Denite file/rec<CR>
nmap <silent> <C-u><C-j> :<C-u>Denite line<CR>
nmap <silent> <C-u><C-g> :<C-u>Denite grep<CR>
nmap <silent> <C-u><C-g><C-g> :<C-u>DeniteCursorWord grep<CR>
nmap <silent> <C-u><C-u> :<C-u>Denite file_mru<CR>
nmap <silent> <C-u><C-y> :<C-u>Denite neoyank<CR>
nmap <silent> <C-u><C-r> :<C-u>Denite -resume<CR>
nmap <silent> <C-u>; :<C-u>Denite -resume -immediately -select=+1<CR>
nmap <silent> <C-u>- :<C-u>Denite -resume -immediately -select=-1<CR>
nnoremap <Leader>m :Denite mark<CR>

" }




" NERDTree settings
nnoremap <C-t> :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif



" Deoplete setting
let g:deoplete#enable_at_startup = 1

" LSP configuration
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.vimls.setup{}
EOF

" LSP Keybindings
" Go to definition
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
" Find references
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
" Show hover documentation
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
" Go to implementation
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
" Signature help
nnoremap <silent> <C-k> :lua vim.lsp.buf.signature_help()<CR>
" Rename symbol
nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
" Code action
nnoremap <silent> <Leader>ca :lua vim.lsp.buf.code_action()<CR>
" Show diagnostics popup
nnoremap <silent> <Leader>d :lua vim.diagnostic.open_float()<CR>
" Navigate to the previous diagnostic
nnoremap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
" Navigate to the next diagnostic
nnoremap <silent> ]d :lua vim.diagnostic.goto_next()<CR>
" Format code
nnoremap <silent> <Leader>f :lua vim.lsp.buf.format()<CR>



" tagbar settings
nnoremap <F8> :TagbarToggle<CR>



" MarkdownPreview Settings
let g:mkdp_auto_start = 1
let g:mkdp_browser = 'chrome'
let g:mkdp_echo_preview_url = 1
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop



" Code runner settings
" Modify the executable name for c/cpp for different project.
lua << EOF
require'code_runner'.setup{
    filetype = {
        c = "make && ./executable_name",
        cpp = "make && ./executable_name",
        python = "python3 -u",
    },
}
EOF
nnoremap <Leader>r :RunCode<CR>



" Treesitter settings
lua << EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
}
EOF
