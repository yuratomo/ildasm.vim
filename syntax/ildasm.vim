if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

source $VIMRUNTIME/syntax/cs.vim
syn keyword ildasmIgnore   module assembly forwarder extern imagebase file stackreserve hidebysig specialname rtspecialname cil managed auto ansi newslot runtime valuetype beforefieldinit literal native initonly 
syn keyword ildasmKeyword  class field method event property set get permissionset addon removeon
syn keyword ildasmModifier virtual instance final extends implements
syn keyword ildasmSpecial  DependencyProperty
syn match   ildasmSet      "^ *.set .*$"
syn match   ildasmGet      "^ *.get .*$"
syn match   ildasmKakko    "\[\a*\]"

hi default link ildasmIgnore   Ignore
hi default link ildasmKeyword  Type
hi default link ildasmModifier Number
hi default link ildasmSpecial  Special
hi default link ildasmSet      Ignore
hi default link ildasmGet      Ignore
hi default link ildasmKakko    Comment

let b:current_syntax = 'ildasm'
