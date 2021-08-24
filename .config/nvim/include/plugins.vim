"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Remaps and Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline', Cond(!exists('g:vscode'))                                     " status line
Plug 'jiangmiao/auto-pairs', Cond(!exists('g:vscode'))                                        " pairing for parens and brackets
Plug 'neoclide/coc.nvim', Cond(!exists('g:vscode'), {'branch': 'release'})                    " code completion
Plug 'gorodinskiy/vim-coloresque', Cond(!exists('g:vscode'))                                  " highlight colors
Plug 'flazz/vim-colorschemes', Cond(!exists('g:vscode'))                                      " so many colorschemes
Plug 'ap/vim-css-color', Cond(!exists('g:vscode'))                                            " highlight colors
Plug 'dracula/vim', Cond(!exists('g:vscode'), { 'as': 'dracula' })                            " dracula theme
" use normal easymotion when in vim mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
Plug 'tpope/vim-fugitive', Cond(!exists('g:vscode'))                                          " git integration
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))                                            " fuzzy finder
Plug 'junegunn/fzf', Cond(!exists('g:vscode'), { 'do': { -> fzf#install() } })                " fuzzy finder for vim
Plug 'quramy/vim-js-pretty-template', Cond(!exists('g:vscode'))                               " pretty template strings
Plug 'terryma/vim-multiple-cursors', Cond(!exists('g:vscode'))             								    " multiple cursors
Plug 'scrooloose/nerdcommenter', Cond(!exists('g:vscode'))                                    " comment things
Plug 'arcticicestudio/nord-vim', Cond(!exists('g:vscode'))                                    " nord color scheme
Plug 'vim-scripts/paredit.vim', Cond(!exists('g:vscode'))                                     " balance parens
Plug 'sheerun/vim-polyglot', Cond(!exists('g:vscode'))                                        " language packs
Plug 'prettier/vim-prettier', Cond(!exists('g:vscode'), {                                   
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] })
Plug 'junegunn/rainbow_parentheses.vim', Cond(!exists('g:vscode'))                       	    " rainbow parentheses
Plug 'kevinhwang91/rnvimr', Cond(!exists('g:vscode'), {'do': 'make sync'})                    " ranger integration
Plug 'vim-scripts/syntaxcomplete', Cond(!exists('g:vscode'))                                  " syntax completion
Plug 'mbbill/undotree', Cond(!exists('g:vscode'))                                             " visual undo tree
Plug 'chaoren/vim-wordmotion'                                                                 " better word jumping, camelCase, snake_case, etc.
Plug 'tpope/vim-endwise'                                                                      " add end after do

call plug#end()

" rainbow parens
let g:rainbow#max_level = 16
if !exists('g:vscode')
  autocmd vimenter * :RainbowParentheses
endif

" airline settings
let g:airline#extensions#tabline#enabled = 1

" multiple cursors settings
let g:multi_cursor_exit_from_visual_mode = 1
let g:multi_cursor_exit_from_insert_mode = 1

" coc settings
let g:coc_global_extensions = [
  \ 'coc-actions',
  \ 'coc-css',
  \ 'coc-elixir',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-marketplace',
  \ 'coc-omnisharp',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-tsserver',
  \ 'coc-rust-analyzer'
  \ ]

set hidden
set updatetime=300
set shortmess+=c

" Highlight symbol under cursor on CursorHold
if !exists('g:vscode')
  autocmd CursorHold * silent call CocActionAsync('highlight')
end

" Rnvimr
let g:rnvimr_ranger_cmd = 'ranger --cmd="set column_ratios 1,1"'
let g:rnvimr_bw_enable = 1
let g:rnvimr_ex_enable = 1
let g:rnvimr_draw_border = 1
let g:rnvimr_pick_enable = 1

" EasyMotion 
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" Set target color to more sensible red
hi link EasyMotionTarget SpellBad

let g:endwise_no_mappings = 1
