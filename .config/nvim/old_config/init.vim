" Providers
let g:python3_host_prog = "/usr/bin/python3"
let g:loaded_python_provider = 0

set shell=bash
" Plugins first
runtime! include/plugins.vim

" Other settings
runtime! include/general.vim
runtime! include/keybinds.vim

if !exists('g:vscode')
  runtime! include/style.vim
endif

