"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Remaps and Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'nvim-lualine/lualine.nvim', Cond(!exists('g:vscode'))                                   " status line
Plug 'jiangmiao/auto-pairs', Cond(!exists('g:vscode'))                                        " pairing for parens and brackets
Plug 'neoclide/coc.nvim', Cond(!exists('g:vscode'), {'branch': 'release'})                    " code completion
Plug 'gorodinskiy/vim-coloresque', Cond(!exists('g:vscode'))                                  " highlight colors
Plug 'flazz/vim-colorschemes', Cond(!exists('g:vscode'))                                      " so many colorschemes
Plug 'ap/vim-css-color', Cond(!exists('g:vscode'))                                            " highlight colors
Plug 'dracula/vim', Cond(!exists('g:vscode'), { 'as': 'dracula' })                            " dracula theme
" use hop when in vim mode
Plug 'phaazon/hop.nvim', Cond(!exists('g:vscode'))
" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
Plug 'tpope/vim-fugitive', Cond(!exists('g:vscode'))                                          " git integration
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))                                            " fuzzy finder
Plug 'junegunn/fzf', Cond(!exists('g:vscode'), { 'do': { -> fzf#install() } })                " fuzzy finder for vim
Plug 'nvim-lua/plenary.nvim'                                                                  " dependency for telescope
Plug 'nvim-telescope/telescope.nvim'                                                          " extendable fuzzy finder
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
Plug 'tpope/vim-endwise', Cond(!exists('g:vscode'))                                           " add end after do
Plug 'APZelos/blamer.nvim', Cond(!exists('g:vscode'))                                         " add git blame like GitLens
Plug 'folke/tokyonight.nvim', Cond(!exists('g:vscode'), { 'branch': 'main' })                 " tokyo night theme
Plug 'kyazdani42/nvim-web-devicons', Cond(!exists('g:vscode'))
Plug 'romgrk/barbar.nvim', Cond(!exists('g:vscode'))
Plug 'nvim-treesitter/nvim-treesitter', Cond(!exists('g:vscode'), {'do': ':TSUpdate'})
Plug 'mfussenegger/nvim-treehopper', Cond(!exists('g:vscode'))                                " node selection in visual mode
call plug#end()

" rainbow parens
let g:rainbow#max_level = 16
if !exists('g:vscode')
  autocmd vimenter * :RainbowParentheses
endif


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
let g:rnvimr_ranger_cmd = ['ranger', '--cmd=set column_ratios 1,1']
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

let g:blamer_enabled = 1
let g:blamer_date_format = '%m/%d/%y %I:%M %p'

" NOTE: If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})
" Enable/disable close button
let bufferline.closable = v:true

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = v:true


lua << EOF
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent= true
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_italic_variables = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
if vim.g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {mirror = false},
            vertical = {mirror = false}
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

require'nvim-treesitter.configs'.setup {
  auto_install = true,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = {
    "typescript",
    "javascript",
    "jsdoc",
    "elixir",
    "rust",
    "tsx",
    "toml",
    "fish",
    "json",
    "yaml",
    "css",
    "html",
    "lua"
  },
}

-- requires monkeypatch to https://github.com/mfussenegger/nvim-treehopper/pull/18
-- TODO: remove after merge
require("tsht").config.ft_to_parser.typescriptreact = "tsx"

require'hop'.setup()
end
EOF
