@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor vendor-apr

goto getSizeDefined
:getSize
set FILE_SIZE=%~z1
goto:eof
:getSizeDefined

if not exist archive\ mkdir archive

rem Self
if exist archive\%PROJECT%-%VERSION%.7z goto:eof
curl --insecure --location https://github.com/g-stefan/vendor-%PROJECT%/releases/download/v%VERSION%/%PROJECT%-%VERSION%.7z --output archive\%PROJECT%-%VERSION%.7z
call :getSize "archive\%PROJECT%-%VERSION%.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q archive\%PROJECT%-%VERSION%.7z goto:eof

rem Source
pushd archive
set VENDOR=%PROJECT%-%VERSION%
set WEB_LINK=http://mirror.evowise.com/apache/apr/apr-1.7.0.tar.gz
if not exist %VENDOR%.tar.gz curl --insecure --location %WEB_LINK% --output %VENDOR%.tar.gz
7z x %VENDOR%.tar.gz -so | 7z x -aoa -si -ttar -o.
del /F /Q %VENDOR%.tar.gz
7zr a -mx9 -mmt4 -r- -sse -w. -y -t7z %VENDOR%.7z %VENDOR%
rmdir /Q /S %VENDOR%
popd
