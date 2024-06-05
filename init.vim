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
    call dein#add('Shougo/neomru.vim')
    " call dein#add('Shougo/neoyank.vim')

    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/deoplete-lsp')
    call dein#add('neovim/nvim-lspconfig')
    " call dein#add('nvim-lua/diagnostic-nvim')
    " call dein#add('nvim-lua/lsp_extensions.nvim')

    call dein#add('ryanoasis/vim-devicons')
    call dein#add('preservim/nerdtree')
    call dein#add('majutsushi/tagbar')

    call dein#add('CRAG666/code_runner.nvim')
    call dein#add('Yggdroot/indentLine')
    call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
                        \ 'build': 'sh -c "cd app && npx --yes yarn install"' })
    call dein#add('jiangmiao/auto-pairs')
    call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})
    call dein#add('tomasr/molokai')
    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-fugitive')
    call dein#add('airblade/vim-gitgutter')

    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    call dein#add('rcarriga/nvim-notify')
    call dein#add('voldikss/vim-floaterm')

    call dein#add('github/copilot.vim')

    call dein#add('puremourning/vimspector')

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
" set virtualedit=onemore
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
set fileencodings=ucs-bom,utf-8,utf-16,default,iso-2022-jp,euc-jp,sjis

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
let g:indentLine_conceallevel = 0

" For terminal mode
tnoremap <Esc> <C-\><C-n>
command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
autocmd TermOpen * startinsert



" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Sets the background to NONE, making it transparent.
hi Normal guibg=NONE ctermbg=NONE
hi Visual guibg=LightGrey ctermbg=LightGrey


" Automatically strip trailing space on save
function s:stripTrailingSpaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

autocmd BufWritePre * call s:stripTrailingSpaces()




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
    augroup ftplugin-my-denite
        autocmd! * <buffer>
        autocmd InsertEnter <buffer> imap <silent><buffer> <CR> <ESC><CR>
        autocmd InsertEnter <buffer> inoremap <silent><buffer> <Esc> <Esc><C-w><C-q>:<C-u>call denite#move_to_parent()<CR>
    augroup END

    call deoplete#custom#buffer_option('auto_complete', v:false)
    imap <silent><buffer> <Esc> <Esc>:call denite#move_to_parent()<CR>
    inoremap <silent><buffer> <Down> <Esc>
        \:call denite#move_to_parent()<CR>
        \:call cursor(line('.')+1,0)<CR>
        \:call denite#move_to_filter()<CR>A
    inoremap <silent><buffer> <Up> <Esc>
        \:call denite#move_to_parent()<CR>
        \:call cursor(line('.')-1,0)<CR>
        \:call denite#move_to_filter()<CR>A
endfunction

let s:denite_default_options = {}
" highlight filtering word
call extend(s:denite_default_options, {'highlight_matched_char': 'None', 'highlight_matched_range': 'Search', 'match_highlight': v:true, })
" split denite window to the top
call extend(s:denite_default_options, {'direction': 'top', 'filter_split_direction': 'top', })
" set the filter's prompt
call extend(s:denite_default_options, {'prompt': '>', })
call extend(s:denite_default_options, {'smartcase': v:true, })
" start with filter window by default
call extend(s:denite_default_options, {'start_filter': v:true, })
call denite#custom#option('default', s:denite_default_options)

" call denite#custom#var('file/rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
" call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
if executable("rg")
    call denite#custom#var('file/rec', 'command',
   \ ['rg', '--files', '--glob', '!.git', '--color', 'never', '--hidden'])
    call denite#custom#var('grep', {
   \ 'command': ['rg'],
   \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
   \ 'recursive_opts': [],
   \ 'pattern_opt': ['--regexp'],
   \ 'separator': ['--'],
   \ 'final_opts': [],
   \ })
endif

call denite#custom#source('file/rec', 'max_candidates', 100)
call denite#custom#source('grep', 'max_candidates', 300)

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

" Enable Deoplete for specific filetypes
" autocmd FileType c,cpp call deoplete#custom#buffer_option('auto_complete', v:true)
" autocmd FileType python call deoplete#custom#buffer_option('auto_complete', v:true)
" autocmd FileType vim call deoplete#custom#buffer_option('auto_complete', v:true)
autocmd FileType javascript,html setlocal tabstop=2 shiftwidth=2 softtabstop=2 | call deoplete#custom#buffer_option('auto_complete', v:true)

" Close the preview window after completion is done
autocmd CompleteDone * if pumvisible() == 0 | silent! pclose | endif
" Tab completion
" inoremap <expr><TAB> pumvisible()? "\<C-n>": "\<TAB>"



" LSP configuration
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    cmd = { 'clangd', '--offset-encoding=utf-16' }, 
}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.bashls.setup{}
EOF

let g:copilot_filetypes = {
    \ '*':      v:false,
    \ 'python': v:true,
    \ 'c':      v:true,
    \ 'cpp':    v:true,
    \ 'vim':    v:true,
    \ 'html':   v:true,
    \ 'javascript': v:true,
    \ 'sh':     v:true,
    \ 'markdown': v:true
\}

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

" Automatically close the quickfix window when leving it.
autocmd WinLeave <buffer> if &buftype == 'quickfix' |cclose| endif



" vimspector settings
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ] 
" To install the gadgets, run :VimspectorInstall

" Start or continue debugging
nmap <Leader>dl :call vimspector#Launch()<CR>
" Stop debugging
nmap <Leader>de :call vimspector#Reset()<CR>
" Restart debugging with the same configuration
nmap <Leader>dr :call vimspector#Restart()<CR>
" Step over
nmap <Leader>dn :call vimspector#StepOver()<CR>
" Step into
nmap <Leader>di :call vimspector#StepInto()<CR>
" Step out
nmap <Leader>do :call vimspector#StepOut()<CR>
" Continue execution (to next breakpoint or end)
nmap <Leader>dc :call vimspector#Continue()<CR>
" Add a breakpoint at the current line
nmap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
" Evaluate expression under cursor or visual selection
nmap <Leader>dv :call vimspector#Evaluate()<CR>






" tagbar settings
nnoremap <F8> :TagbarToggle<CR>



" MarkdownPreview Settings
let g:mkdp_auto_start = 0
let g:mkdp_browser = 'chrome'
let g:mkdp_echo_preview_url = 1
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop



" " Code runner settings
" " Modify the executable name for c/cpp for different project.
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
nnoremap <Leader>q :RunClose<CR>




" Treesitter settings
lua << EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
}
EOF




" Floaterm settings
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_width = 0.95



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-notify settings
lua << EOF
require'ukagaka'
EOF

" local notify = require('notify')
" vim.notify = notify
" notify.setup({ background_colour = "#000000", })
" print = function(...)
"     local print_safe_args = {}
"     local _ = { ... }
"     for i = 1, #_ do
"         table.insert(print_safe_args, tostring(_[i]))
"     end
"     notify(table.concat(print_safe_args, ' '), "info")
" end

" let g:clipboard = {
"     \   'name': 'custom_clipboard',
"     \   'copy': {
"     \       '+': 'sh /home/shinku/Documents/wsl_clipboard.sh set',
"     \       '*': 'sh /home/shinku/Documents/wsl_clipboard.sh set',
"     \    },
"     \   'paste': {
"     \       '+': 'sh /home/shinku/Documents/wsl_clipboard.sh get',
"     \       '*': 'sh /home/shinku/Documents/wsl_clipboard.sh get',
"     \    },
"     \   'cache_enabled': 1,
"     \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom start screen
" fun! Start()
"     echomsg "Starting Neovim custom start screen"

"     if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
"         echomsg "Skipping custom start screen due to conditions"
"         return
"     endif

"     enew

"     setlocal
"         \ bufhidden=wipe
"         \ buftype=nofile
"         \ nobuflisted
"         \ nocursorcolumn
"         \ nocursorline
"         \ nolist
"         \ nonumber
"         \ noswapfile
"         \ norelativenumber

"     let art_path = expand('~/.config/nvim/aa.txt')
"     if filereadable(art_path)
"         let art_lines = readfile(art_path)
"         call append('$', art_lines)
"         echomsg "Art file loaded"
"     else
"         echomsg "Art file not found or not readable: " . art_path
"     endif

"     setlocal nomodifiable nomodified

"     nnoremap <buffer><silent> e :enew<CR>
"     nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
"     nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
" endfun

" autocmd VimEnter * call Start()



