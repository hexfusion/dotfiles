" convert tabs to spaces, use 4 spaces (in tab jump and shift)
set nocompatible
set ts=4
set expandtab
set sw=4
set paste
set number

set backspace=indent,eol,start

" turn on spelling
" set spell spelllang=en_us

" save location
set viminfo=%,'50,\"100,:100,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

set mouse=r

set nolist
" pretty colors
syntax on
set background=light

" HTML TIDY
" highlight html in visual mode then use = to htmltidy
:vmap ,tidy :!tidy -q -i --show-errors 0<CR>

filetype indent on
set filetype=html
set smartindent

:nmap <leader>t :set expandtab<CR>
:nmap <leader>T :set noexpandtab<CR>

" PERL TIDY
"define :Tidy command to run perltidy on visual selection || entire buffer"
command -range=% -nargs=* Tidy <line1>,<line2>!perltidy

"run :Tidy on entire buffer and return cursor to (approximate) original position"
fun DoTidy()
    let l = line(".")
    let c = col(".")
    :Tidy
    call cursor(l, c)
endfun

"shortcut for normal mode to run on entire buffer then return to current line"
au Filetype perl nmap <F2> :call DoTidy()<CR>

"shortcut for visual mode to run on the the current visual selection"
au Filetype perl vmap <F2> :Tidy<CR>
