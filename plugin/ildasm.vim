" File: plugin/ildasm.vim
" Last Modified: 2012.07.01
" Author: yuratomo (twitter @yusetomo)
" Usage:
"
"   1.append _vimrc
"     call ildasm#addAssembly('C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\WindowsBase.dll')
"
"   2.:Ildasm<ENTER>
"

if exists('g:loaded_ildasm') && g:loaded_ildasm == 1
  finish
endif

if !exists('g:ildasm_command')
  let g:ildasm_command = shellescape('C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\ildasm.exe')
endif

command! -nargs=* 
  \ Ildasm
  \ :call ildasm#start()

let g:loaded_ildasm = 1
