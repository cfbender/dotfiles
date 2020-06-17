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

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
     \ pumvisible() ? "\<C-n>" :
     \ <SID>check_back_space() ? "\<Tab>" :
     \ coc#refresh()
     
inoremap <silent><expr> <S-TAB>
  \ pumvisible() ? "\<C-p>" :
  \ <SID>check_back_space() ? "\<S-TAB>" :
  \ coc#refresh()

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm."
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" GoTo code navigation.
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev-error)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next-error)
nnoremap <leader>cr :CocRestart

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocActionAsync('doHover')
    endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)"

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')
map <F4> :Format<CR>

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Trees
map <C-t> :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeShow<CR>

" FZF settings
nnoremap <Leader>ps :Rg<SPACE>
nnoremap <C-p> :GFiles<CR>
nnoremap <Leader>pf :Files<CR>

" Fugitive
nmap <leader>gs :G<CR>
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gdo :Gvdiff origin<CR>
nmap <leader>gdm :Gvdiff origin/master<CR>
