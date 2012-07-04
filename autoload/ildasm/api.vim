
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
    \ '/PUBONLY',
    \ '/NOCA',
    \ '|findstr /V {',
    \ '|findstr /V }',
    \ '|findstr /V \/\/',
    \ '|findstr /V .maxstack',
    \ ],  ' ')
  return s:system(cmd)
endfunction

function! s:system(string)
" if exists('g:loaded_vimproc')
"   return vimproc#system(a:string)
" else
    return system(a:string)
" endif
endfunction
