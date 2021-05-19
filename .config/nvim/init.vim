" Providers
let g:python3_host_prog = "/usr/bin/python3"
let g:loaded_python_provider = 0
let g:custom_path = '~/.config/nvim/'

func LoadConfig(name)
    exec 'source' g:custom_path . a:name . '.vim'
endfunc

exec 'luafile' expand(g:custom_path . 'lua/plugins.lua')

call LoadConfig('base')
call LoadConfig('keybinds')

set nocompatible

"colorscheme arcolors
set termguicolors

set shell=bash

" Rnvimr
let g:rnvimr_ranger_cmd = 'ranger --cmd="set column_ratios 1,1"'
" Make Ranger replace Netrw and be the file explorer
let g:rnvimr_enable_ex = 1

" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1

" Disable a border for floating window
let g:rnvimr_draw_border = 1

" Hide the files included in gitignore
let g:rnvimr_hide_gitignore = 0


" EasyMotion 
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" Set target color to more sensible red
hi link EasyMotionTarget SpellBad

let g:endwise_no_mappings = 1

" rainbow parens
let g:rainbow#max_level = 16
autocmd vimenter * :RainbowParentheses

" airline settings
let g:airline#extensions#tabline#enabled = 1

" multiple cursors settings
let g:multi_cursor_exit_from_visual_mode = 1
let g:multi_cursor_exit_from_insert_mode = 1
