set releasedevelutf8=s:\pyuki\htdocs\release\utf8-lf\pyukiwiki-0.2.1-customoer-preview-devel-utf8
set test1=s:\www\test1.local\htdocs
set githubdev=e:\cloud\github\PyukiWikiDevelopmentEnvironment\src
set githubcurrent=e:\cloud\github\PyukiWiki-Current\src
set builddir=s:\pyuki\htdocs
set releasedir=s:\pyuki\htdocs\release

xcopy /s %releasedevelutf8%\*.* %test1%
rmdir /s /q %githubdev%
rmdir /s /q %githubcurrent%

mkdir %githubdev%
mkdir %githubcurrent%

xcopy /s %builddir%\*.* %githubdev% >nul
rmdir /s /q %githubdev%\archive
rmdir /s /q %githubdev%\release
rmdir /s /q %githubdev%\temp

xcopy /s %releasedir%\*.* %githubcurrent% >nul
