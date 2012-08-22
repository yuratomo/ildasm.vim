" File: autoload/w3m/search_engines/local_msdn.vim
" Author: yuratomo (twitter @yusetomo)

if !exists('g:w3m_local_msdn_type')
  let g:w3m_local_msdn_type = 1
endif
if !exists('g:w3m_local_msdn_version')
  let g:w3m_local_msdn_version = 100
endif

let s:engine = w3m#search_engine#Init('msdnl', 'http://msdn.microsoft.com/ja-jp/library/%s(d=printer,v=vs.' . g:w3m_local_msdn_version . ').aspx')

function s:get_help_pid()
  if executable('tasklist')
    let tlist = split(system('tasklist | findstr HelpLibAgent.exe'))
    if len(tlist) > 0
      return tlist[1]
    endif
  endif
  return 0
endfunction

function! s:engine.preproc()
  let pid = s:get_help_pid()
  if pid != 0
    let self.url = 'http://127.0.0.1:47873/help/' . g:w3m_local_msdn_type . '-' . pid . '/ms.help?method=page&id=allmembers.t:%s&PageSize=10&PageNumber=1&locale=JA-JP&ProductVersion=' . g:w3m_local_msdn_version . '&Product=VS'
  endif
endfunction

function! s:engine.postproc()
endfunction

function! s:engine.filter(outputs)
    return a:outputs
endfunction

call w3m#search_engine#Add(s:engine)
