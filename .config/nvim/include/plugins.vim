"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Remaps and Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}                   " code completion
Plug 'chaoren/vim-wordmotion'                                     " better word jumping, camelCase, snake_case, etc.
Plug 'scrooloose/nerdcommenter'                                   " comment things
Plug 'vim-scripts/paredit.vim'                                    " balance parens
Plug 'vim-scripts/syntaxcomplete'                                 " syntax completion
Plug 'quramy/vim-js-pretty-template'                              " pretty template strings
Plug 'gorodinskiy/vim-coloresque'                                 " highlight colors
Plug 'tpope/vim-fugitive'                                         " git integration
Plug 'terryma/vim-multiple-cursors'								  " multiple cursors
Plug 'mbbill/undotree'                                            " visual undo tree
Plug 'sheerun/vim-polyglot'                                       " language packs
Plug 'preservim/nerdtree'                                         " visual file tree
Plug 'jiangmiao/auto-pairs'                                       " pairing for parens and brackets
Plug 'junegunn/rainbow_parentheses.vim'                       	  " rainbow parentheses
Plug 'vim-airline/vim-airline'                                    " status line
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier', {                        
  \ 'do': 'yarn install',
  \}
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'

call plug#end()

" rainbow parens
let g:rainbow#max_level = 16
autocmd vimenter * :RainbowParentheses

" airline settings
let g:airline#extensions#tabline#enabled = 1

" multiple cursors settings
let g:multi_cursor_exit_from_visual_mode = 1
let g:multi_cursor_exit_from_insert_mode = 1

" coc settings
let g:coc_global_extensions = [
  \ 'coc-actions',
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-omnisharp',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-tsserver',
  \ 'coc-rust-analyzer'
  \ ]

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Show hidden files
let NERDTreeShowHidden=1
