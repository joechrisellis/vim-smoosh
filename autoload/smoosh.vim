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


function! s:CombineLines(lineno1, lineno2, ignored_chars)
    let l:line1 = getline(a:lineno1)
    let l:line2 = getline(a:lineno2)

    let l:line1_length = strchars(l:line1)
    let l:line2_length = strchars(l:line2)

    if l:line1_length <= l:line2_length
        let l:large_line = l:line2
        let l:small_line_length = l:line1_length
        let l:large_line_length = l:line2_length
    else
        let l:large_line = l:line1
        let l:small_line_length = l:line2_length
        let l:large_line_length = l:line1_length
    endif

     " Build up the new line...

    let l:new_line = ""
    let l:i = 0

    while l:i < l:small_line_length
        if index(a:ignored_chars, l:line2[i]) >= 0
            let l:new_line .= l:line1[i]
        else
            let l:new_line .= l:line2[i]
        endif
        let l:i += 1
    endwhile

    while l:i < l:large_line_length
        let l:new_line .= l:large_line[i]
        let l:i += 1
    endwhile

    " Set the contents of the first line to be what we just built.
    call setline(a:lineno1, l:new_line)

    " Save the current position before deleting the second line. Restore the
    " position afterwards so that the cursor stays in the same place
    let l:pos = getpos(".")
    silent exe a:lineno2 . 'd'
    call setpos(".", l:pos)
endfunction

function! smoosh#Smoosh(range_start, range_end, ignored_chars)
    let l:range_start = a:range_start
    let l:range_end = a:range_end

    if a:ignored_chars ==# ""
        let l:ignored_chars = [" "]
    else
        let l:ignored_chars = split(a:ignored_chars, "\zs")
    endif

    " Force the range to include at least two lines.
    if l:range_start >= l:range_end
        let l:range_end = l:range_start + 1
    endif

    " Refuse to try and smoosh beyond the end of the buffer. This can happen
    " if the user tries to :Smoosh on the last line of the buffer.
    if l:range_end > line("$")
        echohl ErrorMsg | echo "Can't smoosh beyond the end of the file!" | echohl None
        return
    end

    " Smoosh lines in pairs, starting from the end of the range and working
    " upwards until we've smooshed everything into a single line.
    while l:range_end - l:range_start >= 1
        call s:CombineLines(l:range_end - 1, l:range_end, l:ignored_chars)
        let l:range_end -= 1
    endwhile
endfunction
