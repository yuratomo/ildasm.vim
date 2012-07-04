" File: plugin/ildasm.vim
" Last Modified: 2012.07.04
" Author: yuratomo (twitter @yusetomo)
" Usage:
"
"   1.append _vimrc
"     let g:ildasm_assemblies = [
"       \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\WindowsBase.dll'
"       \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\PresentationCore.dll'
"       \ ]
"
"   2.:Ildasm<ENTER>
"

if exists('g:loaded_ildasm') && g:loaded_ildasm == 1
  finish
endif

if !exists('g:ildasm_command')
  let g:ildasm_command = shellescape('ildasm.exe')
endif

command! -nargs=* Ildasm      :call ildasm#start(0)
command! -nargs=* IldasmSplit :call ildasm#start(1)

let g:loaded_ildasm = 1

