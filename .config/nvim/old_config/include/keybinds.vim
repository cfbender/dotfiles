""""""""""""""""""""""""""""""
" => Plugin keybinds
""""""""""""""""""""""""""""""
if !exists('g:vscode')
 " Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif 

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
  nnoremap <Leader>rg <cmd>Telescope live_grep<cr>
  nnoremap ff <cmd>Telescope git_files<cr>
  nnoremap <Leader>ff <cmd>Telescope find_files<cr>
  
  " Fugitive
  nmap <leader>gs :G<CR>
  nmap <leader>gaa :G add .<CR>
  nmap <leader>gac :G ac
  nmap <leader>gacp :G acp
  nmap <leader>gh :diffget //3<CR>
  nmap <leader>gu :diffget //2<CR>
  nmap <leader>gdo :Gvdiff origin<CR>
  nmap <leader>gdm :Gvdiff origin/master<CR>
  
  " Ranger settings
  nmap <leader>o :RnvimrToggle<CR>

  " treehopper
  " m in visual mode will display nodes to select around
  omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
  xnoremap <silent> m :lua require('tsht').nodes()<CR>

  " hop.nvim
  nmap <leader><leader>w :HopWord<CR>
  nmap <leader><leader>p :HopPattern<CR>

else
  nnoremap <leader>ff <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
  nnoremap <Leader>rg <Cmd>call VSCodeNotify('find-it-faster.findWithinFiles')<CR>
  nmap <leader>o <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
  nmap <leader>gn <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
  nmap <leader>ac <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
endif 

" Folding
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
"autocmd BufReadPost,FileReadPost * normal zR

nmap <leader>FF :set foldmethod=manual<CR>zR

" Barbar
" Move to previous/next
nnoremap <silent>    <C-h> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <C-l> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <S-H> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <S-L> <Cmd>BufferMoveNext<CR>
" Pin/unpin buffer
nnoremap <silent>    <leader>tp <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent>    <leader>tc <Cmd>BufferClose<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <leader>bb <Cmd>BufferOrderByBufferNumber<CR>
nnoremap <silent> <leader>bd <Cmd>BufferOrderByDirectory<CR>
nnoremap <silent> <leader>bl <Cmd>BufferOrderByLanguage<CR>
nnoremap <silent> <leader>bw <Cmd>BufferOrderByWindowNumber<CR>
"""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable search highlight when <esc><esc> is pressed
nnoremap <ESC><ESC> :nohlsearch<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Quickly exit file
map Q <Nop>
map <leader>Q :q<cr>
