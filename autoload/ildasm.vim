
let [ s:MODE_LIST, s:MODE_BODY ] = range(2)
let s:ildasm_title_prefix = 'ildasm-'
let s:ildasm_separator = '    - '
let s:ildasm_mode = s:MODE_LIST
let g:ildasm_line = 0

function! s:usage()
  echo "[USAGE]"
  echo "   1.append _vimrc following settings"
  echo "     let g:ildasm_assemblies = ["
  echo "       \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\WindowsBase.dll'"
  echo "       \ ]"
  echo ""
  echo "   2.:Ildasm<ENTER>"
  echo ""
endfunction

function! ildasm#start()
  let ret = s:load()
  if ret == -1
    call s:usage()
    return
  endif
  call s:openWindow()
  let s:ildasm_mode = s:MODE_LIST
  call s:show()
endfunction

function! ildasm#exit()
  if !exists('g:assembly_list')
    unlet g:assembly_list
  endif
endfunction

function! ildasm#open()
  if s:ildasm_mode == s:MODE_LIST
    let s:ildasm_mode = s:MODE_BODY
    call s:show()
  endif
endfunction

function! ildasm#back()
  if s:ildasm_mode == s:MODE_LIST
    bd!
  elseif s:ildasm_mode == s:MODE_BODY
    let s:ildasm_mode = s:MODE_LIST
    call s:show()
    call cursor(g:ildasm_line, 0)
  endif
endfunction

function! s:openWindow()
  let winnum = winnr('$')
  for winno in range(1, winnum)
    let bufname = bufname(winbufnr(winno))
    if bufname =~ s:ildasm_title_prefix
       exe winno . "wincmd w"
       return
    endif
  endfor

  let id = 1
  while buflisted(s:ildasm_title_prefix . id)
    let id += 1
  endwhile
  let bufname = s:ildasm_title_prefix . id

  new
  silent edit `=bufname`
  setl bt=nofile noswf nowrap hidden nolist nomodifiable ft=cs
  augroup ildasm
    au!
    exe 'au BufDelete <buffer> call ildasm#exit()'
  augroup END
  nnoremap <buffer> <CR> :call ildasm#open()<CR>
  nnoremap <buffer> <BS> :call ildasm#back()<CR>
endfunction

function! s:show()
  if s:ildasm_mode == s:MODE_LIST
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
  elseif s:ildasm_mode == s:MODE_BODY
    let g:ildasm_line = line('.')
    let part = split(getline('.'), s:ildasm_separator)
    if len(part) >= 2
      setl modifiable
      % delete _
      call setline(1, split(ildasm#api#getClassInfo(part[1],part[0]), '\n'))
      setl nomodifiable
      call cursor(1,0)
    endif
  endif
endfunction

function! s:load()
  if !exists('g:ildasm_assemblies')
    return -1
  endif

  let g:assembly_list = []
  for path in g:ildasm_assemblies
    let classes = ildasm#api#getClassList(path)
    redraw
    echo 'ildasm: loading ' . path . ' ... '
    call add(g:assembly_list, { 'path' : path, 'classes' : classes })
  endfor
  return 0
endfunction

