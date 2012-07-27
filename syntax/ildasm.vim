if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

source $VIMRUNTIME/syntax/cs.vim
syn keyword ildasmIgnore   module assembly forwarder extern imagebase file stackreserve specialname rtspecialname cil managed auto ansi newslot runtime valuetype beforefieldinit literal native initonly sequential serializable
syn keyword ildasmKeyword  class field method event property set get permissionset addon removeon
syn keyword ildasmModifier virtual instance final implements
syn keyword ildasmExtends  extends
syn keyword ildasmSpecial  DependencyProperty
syn keyword ildasmHide     hidebysig
syn match   ildasmSet      "^ *.set \_.\{-})"
syn match   ildasmGet      "^ *.get \_.\{-})"
syn match   ildasmAddon    "^ *.addon \_.\{-})"
syn match   ildasmRemoveon "^ *.removeon \_.\{-})"
syn match   ildasmIL       "IL_\x\x\x\x:.*$"
syn match   ildasmKakko    "\[\a*\]"
syn match   ildasmClass    "^[A-Z][a-zA-Z0-9.]*"

hi default link ildasmIgnore   Ignore
hi default link ildasmKeyword  Type
hi default link ildasmModifier Number
hi default link ildasmSpecial  Special
hi default link ildasmHide     Ignore
hi default link ildasmIL       Ignore
hi default link ildasmSet      Ignore
hi default link ildasmGet      Ignore
hi default link ildasmAddon    Ignore
hi default link ildasmRemoveon Ignore
hi default link ildasmKakko    Comment
hi default link ildasmClass    Function
hi default link ildasmCurrent  Function
hi default link ildasmHeader   Underlined
hi default link ildasmExtends  WildMenu

let b:current_syntax = 'ildasm'
