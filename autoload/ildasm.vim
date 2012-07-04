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
  let ret = s:load()
  if ret == -1
    call s:usage()
    return
  endif
  call s:openWindow(a:mode)
  call s:list()
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
    let cline = getline('.')
    let s = strridx(cline, ' ', pos)
    let e = stridx(cline, ' ', pos)
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
      for assembly in g:assembly_list
        let path = assembly.path
        for class in assembly.classes
          if class == word
            let b:ildasm_line = idx
            call s:show([ class , path ])
            break
          endif
          let idx += 1
        endfor
      endfor
    endif
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
endfunction

function! s:list()
  let s:ildasm_mode = s:MODE_LIST
  setl modifiable
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

function! s:show(...)
  let s:ildasm_mode = s:MODE_BODY
  if len(a:000) > 0
    let part = a:1
  else
    let part = split(getline('.'), s:ildasm_separator)
  endif
  if len(part) >= 2
    setl modifiable
    % delete _
    call setline(1, split(ildasm#api#getClassInfo(part[1],part[0]), '\n'))
    setl nomodifiable
    call cursor(1,0)
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
  for path in g:ildasm_assemblies
    let classes = ildasm#api#getClassList(path)
    redraw
    echo 'ildasm: loading ' . path . ' ... '
    call add(g:assembly_list, { 'path' : path, 'classes' : classes })
  endfor
  return 1
endfunction

