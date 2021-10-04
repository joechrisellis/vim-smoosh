" vim-smoosh - smoosh multiple lines into one.
"
" Maintainer: Joe Ellis <joechrisellis@gmail.com>
" Version:    0.1.0
" License:    Same terms as Vim itself (see |license|)
" Location:   plugin/smoosh.vim
" Website:    https://github.com/joechrisellis/vim-smoosh
"
" Use this command to get help on vim-smoosh:
"
"     :help smoosh

if exists("g:loaded_vim_smoosh")
  finish
endif
let g:loaded_vim_smoosh = 1

command! -range -nargs=? Smoosh :call smoosh#Smoosh(<line1>, <line2>, "<args>")

function SmooshOp(type = '') abort
  if a:type ==# ''
    set opfunc=SmooshOp
    return 'g@'
  endif
  exe "'[,']Smoosh"
endfunction

nnoremap <silent> <expr> <Plug>(smoosh) SmooshOp()
