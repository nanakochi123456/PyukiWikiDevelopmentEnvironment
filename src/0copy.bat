set githubdev=e:\cloud\github\PyukiWikiDevelopmentEnvironment\src
set githubcurrent=e:\cloud\github\PyukiWiki-Current\src
set builddir=s:\pyuki\htdocs
set releasedir=s:\pyuki\htdocs\release

rmdir /s /q %githubdev%
rmdir /s /q %githubcurrent%

mkdir %githubdev%
mkdir %githubcurrent%

xcopy /s %builddir%\*.* %githubdev% >nul
rmdir /s /q %githubdev%\archive
rmdir /s /q %githubdev%\release
rmdir /s /q %githubdev%\temp

xcopy /s %releasedir%\*.* %githubcurrent% >nul
