call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'padawan-php/deoplete-padawan', { 'for': 'php' }
Plug 'StanAngeloff/php.vim', {'for': 'php'}
Plug 'autozimu/LanguageClient-neovim', {
			\ 'branch': 'next',
			\ 'do': 'bash install.sh',
			\ }
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs', 'for': 'php'}
Plug 'neomake/neomake'
Plug 'SirVer/ultisnips' | Plug 'phux/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'nvie/vim-flake8'
call plug#end()

"""""" Deoplete 
let g:deoplete#sources#padawan#add_parentheses = 1
" needed for echodoc to work if add_parentheses is 1
let g:deoplete#skip_chars = ['$']

let g:deoplete#sources = {}
let g:deoplete#sources.php = ['padawan', 'ultisnips', 'tags', 'buffer']

let g:deoplete#enable_at_startup = 1

"""""" CTags
" cycle through menu items with tab/shift+tab
inoremap <expr> <TAB> pumvisible() ? "\<c-n>" : "\<TAB>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<TAB>"
" update tags in background whenever you write a php file
au BufWritePost *.php silent! !eval '[ -f ".git/hooks/ctags" ] && .git/hooks/ctags' &

"""""" Language Server
" Required for operations modifying multiple buffers like rename.
set hidden
let g:LanguageClient_serverCommands = {
			\ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
			\ 'php': ['php', '/home/abeaussier/.tooling/php-language-server/bin/php-language-server.php'],
			\ 'python': ['/usr/local/bin/pyls'] }
" only start lsp when opening php files
au filetype php LanguageClientStart

" use LSP completion on ctrl-x ctrl-o as fallback for padawan in legacy projects
au filetype php set omnifunc=LanguageClient#complete

" no need for diagnostics, we're going to use neomake for that
let g:LanguageClient_diagnosticsEnable  = 0
let g:LanguageClient_signColumnAlwaysOn = 0

""" Key: K                | Action: Hover
""" Key: gd               | Action: go to definition
""" Key: f2               | Action: Rename
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>


""""""" NeoMake
autocmd BufWritePost * Neomake
let g:neomake_error_sign   = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '∆', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

"""""" Ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" PHP7
let g:ultisnips_php_scalar_types = 1

""""""" FZF
nnoremap <silent> œ :call fzf#vim#gitfiles('', fzf#vim#with_preview('right'))<CR>

""""""" Custom 
set number relativenumber
set nonumber norelativenumber " turn hybrid line numbers off
set number! relativenumber!   " toggle hybrid line numbers

" Verbose log
function! ToggleVerbose()
	if !&verbose
		set verbosefile=~/.log/vim/verbose.log
		set verbose=15
	else
		set verbose=0
		set verbosefile=
	endif
endfunction

"""""""" PYTHON
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

set encoding=utf-8

let python_highlight_all=1
syntax on

"""""""" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
