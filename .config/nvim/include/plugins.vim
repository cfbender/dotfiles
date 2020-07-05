"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Remaps and Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'                                    " status line
Plug 'jiangmiao/auto-pairs'                                       " pairing for parens and brackets
Plug 'alvan/vim-closetag'                                         " auto close html/jsx tags
Plug 'neoclide/coc.nvim', {'branch': 'release'}                   " code completion
Plug 'gorodinskiy/vim-coloresque'                                 " highlight colors
Plug 'flazz/vim-colorschemes'																			" so many colorschemes
Plug 'dracula/vim', { 'as': 'dracula' }                           " dracula theme
Plug 'easymotion/vim-easymotion'                                  " better intrafile movement
Plug 'mattn/emmet-vim'                                            " emmet support
Plug 'tpope/vim-fugitive'                                         " git integration
Plug 'junegunn/fzf.vim'                                           " fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }               " fuzzy finder for vim
Plug 'quramy/vim-js-pretty-template'                              " pretty template strings
Plug 'terryma/vim-multiple-cursors'             								  " multiple cursors
Plug 'scrooloose/nerdcommenter'                                   " comment things
Plug 'arcticicestudio/nord-vim'                                   " nord color scheme
Plug 'vim-scripts/paredit.vim'                                    " balance parens
Plug 'sheerun/vim-polyglot'                                       " language packs
Plug 'prettier/vim-prettier', {                                   
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'junegunn/rainbow_parentheses.vim'                       	  " rainbow parentheses
Plug 'vim-scripts/syntaxcomplete'                                 " syntax completion
Plug 'mbbill/undotree'                                            " visual undo tree
Plug 'chaoren/vim-wordmotion'                                     " better word jumping, camelCase, snake_case, etc.

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
  \ 'coc-explorer',
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

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

let g:loaded_netrwPlugin = 1

function! AuCocExplorerAutoOpen()
    let l:use_floating = 0
    " Auto-open explorer when there's no file to show.
    if @% == '' || @% == '.' 
        if l:use_floating
            exe ':CocCommand explorer --position floating '
        else
            autocmd User CocExplorerOpenPost ++once exe ':only'
            exe ':CocCommand explorer '
        endif
    endif
endfunction
autocmd User CocNvimInit call AuCocExplorerAutoOpen()

" EasyMotion 
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" Set target color to more sensible red
hi link EasyMotionTarget SpellBad

" vim-closetag file extensions
let g:closetag_filenames = "*.html,*.jsx,*.tsx"
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }
