
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
  let classname = substitute(a:class,'.*\.','','')
  let list = split(
    \ substitute(
      \ substitute(s:system(cmd), '.ctor', classname, ''),
      \ '.cctor', 'static ' . classname, ''),
    \ '\n')
  let on = 0
  let getset = 0
  for item in list
    if item =~ 'IL_\x\x\x\x:.*$'
      let on = 1
    elseif item =~ '^ \+.get ' || item =~ '^ \+.set ' || item =~ '^ \+.addon ' || item =~ '^ \+.removeon '
      let on = 1
      let getset = 1
    endif
    if on == 0
      call add(nlist, s:negrect(item))
    endif
    if getset == 1
      let on = 0
      let getset = 0
      if nlist[-1] != ''
        call add(nlist, '')
      endif
    endif
    if item == ""
      let on = 0
    endif
  endfor

  " insert class
  let nlist[0] = '.class ' . nlist[0][1:]

  return nlist
endfunction

let s:negrect_words = join(map([
  \ 'module',
  \ 'assembly',
  \ 'forwarder',
  \ 'extern',
  \ 'imagebase',
  \ 'file',
  \ 'stackreserve',
  \ 'specialname',
  \ 'rtspecialname',
  \ 'cil',
  \ 'managed',
  \ 'auto',
  \ 'ansi',
  \ 'newslot',
  \ 'runtime',
  \ 'valuetype',
  \ 'beforefieldinit',
  \ 'literal',
  \ 'native',
  \ 'initonly',
  \ 'sequential',
  \ 'serializable',
  \ 'virtual',
  \ 'instance',
  \ 'final',
  \ 'implements',
  \ 'hidebysig',
  \ '.permissionset',
  \ 'inheritcheck',
  \ 'demand',
  \ 'class',
  \ 'managed',
  \], "' ' . v:val . '\\>'"),
  \ '\|')
function! s:negrect(text)
  return substitute(a:text, '\(' . s:negrect_words . '\)', '', 'g')
endfunction

function! s:system(string)
" if exists('g:loaded_vimproc')
"   return vimproc#system(a:string)
" else
    return system(a:string)
" endif
endfunction
