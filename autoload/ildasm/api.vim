
function! ildasm#api#getClassList(path)
  let cmd = join( [ 
    \ g:ildasm_command, 
    \ shellescape(a:path), 
    \ '/TEXT', 
    \ '/PUBONLY', 
    \ '|findstr \.class ',
    \ '|findstr /V Enumerator',
    \ ],  ' ')
  return map(map(split(s:system(cmd), '\n'), 'substitute(v:val, "\d*<.*>", "", "")'), 'substitute(v:val, ".* ", "", "")')
endfunction

function! ildasm#api#getClassInfo(path, class)
  let cmd = join( [
    \ g:ildasm_command,
    \ shellescape(a:path),
    \ '/ITEM:' . a:class ,
    \ '/TEXT',
    \ '/NOCA',
    \ '|findstr /V {',
    \ '|findstr /V }',
    \ '|findstr /V \/\/',
    \ '|findstr /V .maxstack',
    \ ],  ' ')

  " negrect
  let nlist = []
  let list = split(s:system(cmd), '\n')
  let on = 0
  for item in list
    if item =~ 'IL_\x\x\x\x:.*$'
      let on = 1
    endif
    if on == 0
      call add(nlist, item)
    endif
    if item == ""
      let on = 0
    endif
  endfor
  return nlist
endfunction

function! s:system(string)
" if exists('g:loaded_vimproc')
"   return vimproc#system(a:string)
" else
    return system(a:string)
" endif
endfunction
