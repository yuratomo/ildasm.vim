ildasm.vim
==========

Description
-----------
Windows SDK�ɕt������ildasm.exe�p��vim�v���O�C���ł��B
ildasm�Ƃ��̂�Visual Studio�́u�I�u�W�F�N�g�u���E�U�v�̒P�̔Ńc�[���ł��B
.Net Framework�̃A�Z���u���t�@�C������N���X�̒�`�𒲂ׂ邱�Ƃ��\�ł��B

Requirements
------------
�K�v�Ȃ̂��͎̂��̂Ƃ���B

* ildasm.exe (Windows SDK)

Setting
-------
# �A�Z���u���̐ݒ�
���̂悤�ɕK�v�ȃA�Z���u����.vimrc�ɒ�`����

    let g:ildasm_assemblies = [
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\mscorlib.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\WindowsBase.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\PresentationCore.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\PresentationFramework.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\System.Core.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\System.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\System.Drawing.dll',
      \ 'C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\Profile\Client\System.Net.dll',
      \ ]

# ildasm�̃p�X�w��
ildasm.exe�Ƀp�X��ʂ�

Usage
-----
* �N��

���̃R�}���h�ŋN������ƃN���X�ꗗ���\�������

(����N����͒x���ł����A�L���b�V������̂Ŏ���ȍ~�͑����͂�)

    :Ildasm

* �N���X�ꗗ

�N���X���̏��Return�L�[�������ƃN���X��`���\������܂��B

* �N���X��`

�N���X���̏��Return�L�[�������ƃN���X��`���ǉ��\������܂��B
Backspace�ŃN���X�ꗗ�ɖ߂�܂��B

* �L���b�V���̃N���A

��x���[�h�����N���X�ꗗ��~/.vim_ildasm �ɃL���b�V�����܂��B
������N���A����ꍇ�́A���̃R�}���h�����s���Ă��������B

    :IldasmClearCache

ScreenShots
-----------

* Visual Studio�̃I�u�W�F�N�g�u���E�U

    ![Visual Studio Object Browser](http://yuratomo.up.seesaa.net/image/object_browser.PNG "object browser")

* Ildasm �N���X�ꗗ

    ![Ildasm Class List](http://yuratomo.up.seesaa.net/image/ildasm_classes.PNG "Class List")


* Ildasm �N���X��`

    ![Ildasm Class Define](http://yuratomo.up.seesaa.net/image/ildasm_classdefine.PNG "Class Define")


HISTORY
-------
*v1.0 2012.07.27 yuratomo

Initial version


