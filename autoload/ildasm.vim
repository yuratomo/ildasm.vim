let [ s:MODE_LIST, s:MODE_BODY ] = range(2)
let s:ildasm_title_prefix = 'ildasm-'
let s:ildasm_separator = '    - '
let s:ildasm_mode = s:MODE_LIST

function! s:usage()
  new
  let bufname = s:ildasm_title_prefix
  silent edit `=bufname`
  let help= [
    \ "[USAGE]",
    \ "1. Append your _vimrc following settings.",
    \ "",
    \ "let g:ildasm_assemblies = [",
    \ " \\ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\WindowsBase.dll'",
    \ " \\ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\PresentationCore.dll'",
    \ " \\ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\PresentationFramework.dll'",
    \ " \\ ]",
    \ "",
    \ "2. Input command \":Ildasm<ENTER>\"",
    \ "",
    \ "",
    \ ]
  call setline(1,help)
  setl bt=nofile noswf nowrap hidden nolist nomodifiable ft=vim
endfunction

function! ildasm#start(mode)
  if !executable(g:ildasm_command)
    call s:message(g:ildasm_command . ' is not exists.')
    return
  endif
  let ret = s:load()
  if ret == -1
    call s:usage()
    return
  endif

  call s:openWindow(a:mode)
  call s:list()

  if ret == 1
    try
      exe "write" fnameescape(g:ildasm_cache)
    catch /^Vim(write):/
      throw "EXCEPT:IO(" . getcwd() . ", " . a:file . "):WRITEERR"
    endtry
  endif
endfunction

function! ildasm#exit()
  bd
endfunction

function! ildasm#open()
  if s:ildasm_mode == s:MODE_LIST
    let b:ildasm_line = line('.')
    call s:show()
  elseif s:ildasm_mode == s:MODE_BODY
    let pos = col('.')
    let tline = getline(1)
    let cline = getline('.')
    let s = s:matchr(cline, '[^a-zA-Z0-9_.]', pos)
    let e = match(cline, '[^a-zA-Z0-9_.]', pos)
    if s == -1
      let s = 0
    else
      let s += 1
    endif
    if e == -1
      let e = len(cline) - 1
    else
      let e -= 1
    endif

    let word = cline[ s : e ]
    if stridx(word, '.') > 0
      let idx=1
      for mode in [0, 1]
        for assembly in g:assembly_list
          let path = assembly.path
          if mode == 0
            " first same search in assembly
            if path != tline
              continue
            endif
          else
            if path == tline
              continue
            endif
          endif
          for class in assembly.classes
            if class == word
              let b:ildasm_line = idx
              call s:show([ class , path ])
              return
            endif
            let idx += 1
          endfor
        endfor
      endfor
    endif
    call s:message(word . ' not found')
  endif
endfunction

function! ildasm#back()
  if s:ildasm_mode == s:MODE_LIST
    bd!
  elseif s:ildasm_mode == s:MODE_BODY
    call s:list()
    call cursor(b:ildasm_line, 0)
  endif
endfunction

function! ildasm#help()
  if exists('g:loaded_w3m') && g:loaded_w3m == 1
    let pos = col('.')
    let cline = getline('.')
    let s = s:matchr(cline, '[^a-zA-Z0-9_.]', pos)
    let e = match(cline, '[^a-zA-Z0-9_.]', pos)
    if s == -1
      let s = 0
    else
      let s += 1
    endif
    if e == -1
      let e = len(cline) - 1
    else
      let e -= 1
    endif

    let word = cline[ s : e ]

    let id = 1
    while buflisted('w3m-' . id) != 0
      let id += 1
    endwhile
    let winnum = winnr('$')
    for winno in range(1, winnum)
      let bn = bufname(winbufnr(winno))
      if bn =~ 'w3m-*'
         exe winno . "wincmd w"
         exe ':W3m msdnl ' . word
         return
      endif
    endfor

    exe ':W3mSplit msdnl ' . word
  endif
endfunction

function! s:openWindow(mode)
  let id = 1
  while buflisted(s:ildasm_title_prefix . id)
    let id += 1
  endwhile
  let bufname = s:ildasm_title_prefix . id

  if a:mode == 1
    new
  endif
  silent edit `=bufname`
  setl bt=nofile noswf nowrap hidden nolist nomodifiable ft=ildasm
  let b:ildasm_line = 0
  augroup ildasm
    au!
    exe 'au BufDelete <buffer> call ildasm#exit()'
  augroup END
  nnoremap <buffer> <CR> :call ildasm#open()<CR>
  nnoremap <buffer> <BS> :call ildasm#back()<CR>
  nnoremap <buffer> <F1> :call ildasm#help()<CR>
endfunction

function! s:list()
  let s:ildasm_mode = s:MODE_LIST
  setl modifiable
  call clearmatches()
  % delete _
  let idx=1
  for assembly in g:assembly_list
    let path = assembly.path
    for class in assembly.classes
      call setline(idx, class . s:ildasm_separator . path)
      let idx += 1
    endfor
  endfor
  setl nomodifiable
endfunction

function! s:listFromCache()
  let s:ildasm_mode = s:MODE_LIST
  setl modifiable
  call clearmatches()
  % delete _
  exe "read" fnameescape(g:ildasm_cache)
  setl nomodifiable
endfunction

function! s:show(...)
  let idx = 1
  let s:ildasm_mode = s:MODE_BODY
  if len(a:000) > 0
    let part = a:1
    let idx = line('$') + 1
  else
    let part = split(getline('.'), s:ildasm_separator)
  endif
  if len(part) >= 2
    setl modifiable
    if idx == 1
      call clearmatches()
      % delete _
    endif
    call matchadd("ildasmHeader", '\%' . idx . 'l')
    exe 'syn match ildasmCurrent "' . part[0] . '"'
    call setline(idx, part[1])
    call setline(idx+1, ildasm#api#getClassInfo(part[1],part[0]))
    setl nomodifiable
    call cursor(idx+1,0)
  endif
endfunction

function! s:load()
  if !exists('g:ildasm_assemblies')
    return -1
  endif
  if exists('g:assembly_list')
    return 0
  endif

  let g:assembly_list = []
  let path = ''
  let classes = []
  if filereadable(g:ildasm_cache)
    let lines = readfile(g:ildasm_cache)
    for line in lines
      let part = split(line, s:ildasm_separator)
      if path != part[1]
        if path != ''
          call add(g:assembly_list, { 'path' : path, 'classes' : classes })
        endif
        let classes = []
        let path = part[1]
      endif
      call add(classes, part[0])
    endfor
    if path != ''
      call add(g:assembly_list, { 'path' : path, 'classes' : classes })
    endif
    call s:message( 'load from cache ( ' . g:ildasm_cache . ' )')
    return 2
  endif

  for path in g:ildasm_assemblies
    let classes = ildasm#api#getClassList(path)
    redraw
    call s:message( 'loading ' . substitute(path, ".*\\", '', 'g') . ' ... ')
    call add(g:assembly_list, { 'path' : path, 'classes' : classes })
  endfor
  return 1
endfunction

function! ildasm#clearCache()
  if exists('g:assembly_list')
    unlet g:assembly_list
  endif
  call delete(g:ildasm_cache)
  call s:message('Cache cleared!!')
endfunction

function! s:message(msg)
  redraw
  echo 'ildasm: ' . a:msg
endfunction

function! s:matchr(line, pat, pos)
  let idx = a:pos
  if idx >= len(a:line)
    let idx = len(a:line) - 1
  endif
  while idx >= 0
    if a:line[idx] =~ a:pat
      return idx
    endif
    let idx = idx - 1
  endwhile
  return -1
endfunction

" for dotnet-complete

function! s:to_type(str)
  return substitute(a:str, '.*\.', '', '')
endfunction

function! s:to_value(str)
  return substitute(substitute(substitute(a:str, '()', '', ''), '.*\.', '', ''), "'", '', 'g')
endfunction

function! ildasm#xxx()
  call s:openWindow(0)
  setl modifiable
  call clearmatches()
  % delete _

  for item in g:assembly_list
    for class in item.classes
      let lines = ildasm#api#getClassInfo(item.path, class)
      if len(lines) > 0 && lines[1] =~ ".*System.Enum"
        call setline(line('$') + 1, [ "call dotnet#enum('" . substitute(lines[0], '^.*[. ]', '', '') . "', [" ] )
        redraw
        let xxx = map(map(filter(lines, 'v:val =~ "="'), 'substitute(v:val, " = .*$", "\",\"\"),", "")'), 'substitute(v:val, "^.* ", "  \\\\ dotnet#prop(\"", "")')
        call setline(line('$') + 1, xxx)
        redraw
        call setline(line('$') + 1, [ '  \ ])', '' ] )
        redraw
        redraw
      endif
    endfor
  endfor
endfunction

function! s:normalize(str)
  return substitute(substitute(substitute(a:str, ' \+', ' ', 'g'), '^ ', '', ''), ' $', '', '')
endfunction

function! ildasm#x()
  
  for item in g:assembly_list
    for class in item.classes
      let lines = ildasm#api#getClassInfo(item.path, class)
      "let lines = ildasm#api#getClassInfo('C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\mscorlib.dll', 'System.IO.MemoryStream')
      let find_class = 0
      let class_name = ''
      let type_name = ''
      let signature = ''
      let retvalue = ''
      let methods = {}
      let mnow = 0
      let vnow = 0
      let enow = 0
      if len(lines) > 0 && lines[1] =~ ".*System.Enum"
        continue
      endif
      for line in lines

        if line =~ '[<>`]'
          let line = substitute(line, '`.*>', '', '')
          let line = substitute(line, '<.*>', '', '')
        endif

        if mnow == 1
          if value_name == '' && line =~ '('
            let value_name = s:func(line)
            let signature = substitute(line, '^.*(', '', '')
            let retvalue .= substitute(line, '\<\w\+(.*', '', '')
          else
            let signature .= line
          endif

          if line =~ ')' || line == ''
            if value_name != '' && value_name != '(' && !has_key(methods, value_name . signature)
              call setline(line('$') + 1, "  \\ dotnet#method('" . value_name . "', '" . s:normalize(signature) .  "', '" . s:normalize(retvalue) . "'),")
              let methods[value_name] = ''
            endif
            let mnow = 0
          endif

          continue
        endif

        if vnow == 1
          let value_name = s:to_value(substitute(line, '^ *', '', ''))
          call setline(line('$') + 1, "  \\ dotnet#prop('" . value_name . "', '" . s:to_type(type_name) . "'),")
          let vnow = 0
          continue
        endif

        if enow == 1
          let value_name = s:to_value(substitute(line, '^ *', '', ''))
          call setline(line('$') + 1, "  \\ dotnet#event('" . value_name . "', '" . s:to_type(type_name) . "'),")
          let enow = 0
          continue
        endif

        if line =~ '^\.class'
          let class_name = substitute(line, '^.*[. ]', '', '')
          "let namespace  = substitute(substitute(line, '^.* ', '', ''), '\..\{-\}$', '', '')
          let namespace  = substitute(line, '^.* ', '', '')
          let start = strridx(namespace, '.')
          let namespace = namespace[0 : start - 1]
        elseif line =~ '^       extends'
          let super_class = substitute(line, '       extends ', '', '')
          exe 'edit ' . namespace
          call setline(line('$') + 1, "call dotnet#class('" . class_name . "', '" . s:to_type(super_class) . "', [ " )
          let find_class = 1
          let methods = {}
        endif

        if find_class == 0
          continue
        endif

        if line =~ '  \.method'
          if line =~ '('
            let value_name = s:func(line)
            let signature = substitute(line, '^.*(', '', '')
            let retvalue = substitute(substitute(line, '.*public ', '', ''), '\<\w\+(.*', '', '')
            let mnow = 1
          else
            let value_name = ''
            let signature = ''
            let retvalue = substitute(line, '.*public ', '', '')
            let mnow = 1
            continue
          endif
        endif

        if line =~ '  \.property'
          let part = split(line, ' ')
          if len(part) > 2
            call setline(line('$') + 1, "  \\ dotnet#prop('" . s:to_value(part[2]) . "', '" . s:to_type(part[1]) . "'),")
          elseif len(part) > 1
            let vnow = 1
            let type_name = part[1]
            continue
          else
            continue
          endif
        endif

        if line =~ ' \.event'
          let part = split(line, '[. ]')
          if len(part) > 2
            call setline(line('$') + 1, "  \\ dotnet#event('" . s:to_value(part[-1]) . "', '" . s:to_type(part[-2]) . "'),")
          elseif len(part) > 1
            let enow = 1
            let type_name = part[1]
            continue
          else
            continue
          endif
        endif

        if line =~ ' \.field' && line !~ ' static '
          let part = split(line, ' ')
          call setline(line('$') + 1, "  \\ dotnet#field('" . s:to_value(part[-1]) . "', '" . s:to_type(part[-2]) . "'),")
        endif

        redraw
      endfor
      if find_class == 1
        call setline(line('$') + 1, [ '  \ ])', '' ] )
      endif
      exe ':w'
    endfor
  endfor
endfunction

function! s:func(line)
  let ed = stridx(a:line, '(')
  if ed >= 0
    let st1 = strridx(a:line, ' ', ed)
    let st2 = strridx(a:line, '.', ed)
    if st1 > st2
      let st = st1
    else
      let st = st2
    endif
    if st >= 0
      return substitute(a:line[ st + 1 : ed ], "'(", '(', '')
    endif
  endif
  return ''
endfunction

