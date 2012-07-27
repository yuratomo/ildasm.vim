ildasm.vim
==========

Description
-----------
Windows SDKに付属するildasm.exe用のvimプラグインです。
ildasmといのはVisual Studioの「オブジェクトブラウザ」の単体版ツールです。
.Net Frameworkのアセンブリファイルからクラスの定義を調べることが可能です。

Requirements
------------
必要なのものは次のとおり。

* ildasm.exe (Windows SDK)

Setting
-------
# アセンブリの設定
次のように必要なアセンブリを.vimrcに定義する

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

# ildasmのパス指定
ildasm.exeにパスを通す

Usage
-----
* 起動

次のコマンドで起動するとクラス一覧が表示される

(初回起動後は遅いですが、キャッシュするので次回以降は早いはず)

    :Ildasm

* クラス一覧

クラス名の上でReturnキーを押すとクラス定義が表示されます。

* クラス定義

クラス名の上でReturnキーを押すとクラス定義が追加表示されます。
Backspaceでクラス一覧に戻ります。

* キャッシュのクリア

一度ロードしたクラス一覧は~/.vim_ildasm にキャッシュします。
これをクリアする場合は、次のコマンドを実行してください。

    :IldasmClearCache

ScreenShots
-----------

* Visual Studioのオブジェクトブラウザ

    ![Visual Studio Object Browser](http://yuratomo.up.seesaa.net/image/object_browser.PNG "object browser")

* Ildasm クラス一覧

    ![Ildasm Class List](http://yuratomo.up.seesaa.net/image/ildasm_classes.PNG "Class List")


* Ildasm クラス定義

    ![Ildasm Class Define](http://yuratomo.up.seesaa.net/image/ildasm_classdefine.PNG "Class Define")


HISTORY
-------
*v1.0 2012.07.27 yuratomo

Initial version


