" I hate spaces in end of lines or tabs anywhere
" match Error /\t\|\s\+$/

" convert tabs to spaces, use 4 spaces (in tab jump and shift)
set ts=4
set expandtab
set sw=4

set paste
set nonumber

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

set list
" pretty colors
syntax on
set background=light

:vmap ,tidy :!tidy -q -i --show-errors 0<CR>

filetype indent on
set filetype=html
set smartindent
