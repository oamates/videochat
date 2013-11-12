@echo off

set DEBUG=%1
set OUTDIR=bin-release

IF /i "%DEBUG%"=="-debug" (SET OUTDIR=bin-debug)

mxmlc %DEBUG% -output "%OUTDIR%\Producer.swf" "src\Producer.as"
mxmlc %DEBUG% -output "%OUTDIR%\Consumer.swf" "src\Consumer.as"

mkdir C:\AppServ\www\videochat

copy /y %OUTDIR%\Producer.swf C:\AppServ\www\videochat\
copy /y %OUTDIR%\Consumer.swf C:\AppServ\www\videochat\
copy /y samples\* C:\AppServ\www\videochat\

@echo ���������˳�...
@pause