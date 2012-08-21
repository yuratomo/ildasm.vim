" File: autoload/w3m/search_engines/local_msdn.vim
" Author: yuratomo (twitter @yusetomo)

if !exists('g:w3m_local_msdn_type')
  let g:w3m_local_msdn_type = 0
endif

let s:engine = w3m#search_engine#Init('msdnl', 'http://www.google.com/search?ie=EUC-JP&oe=UTF-8&sitesearch=msdn.microsoft.com/ja-jp/library/&q=%s')

function s:get_help_pid()
  if executable('tasklist')
    let tlist = split(system('tasklist | findstr HelpLibAgent.exe')
    if len(tlist) > 0
      let items = split(tlist[0], ' \+')
      if len(items) == 6 && items[5] == 'K'
        " windows xp ?
        return items[1]
      else
        " windows 7 ?
        return items[0]
      endif
    endif
  endif
  return 0
endfunction

function! s:engine.preproc()
  let pid = s:get_help_pid()
  if pid != 0
    let self.url = 'http://127.0.0.1:47873/help/' . g:w3m_local_msdn_type . '-' . pid . '/ms.help?method=search&query=%s&PageSize=10&PageNumber=1&locale=JA-JP&ProductVersion=100&Product=VS'
  endif
endfunction

function! s:engine.postproc()
endfunction

function! s:engine.filter(outputs)
    return a:outputs
endfunction

call w3m#search_engine#Add(s:engine)
