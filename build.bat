@echo off

set DEBUG=%1
set OUTDIR=bin-release

IF /i "%DEBUG%"=="-debug" (SET OUTDIR=bin-debug)

compc %DEBUG% -source-path=src -output "%OUTDIR%\SelectDevice.swc" "SelectDevice"

mxmlc %DEBUG% -output "%OUTDIR%\Producer.swf" "src\Producer.as" --library-path+="%OUTDIR%\SelectDevice.swc" 
mxmlc %DEBUG% -output "%OUTDIR%\Consumer.swf" "src\Consumer.as"

mkdir C:\AppServ\www\videochat

copy /y %OUTDIR%\Producer.swf C:\AppServ\www\videochat\
copy /y %OUTDIR%\Consumer.swf C:\AppServ\www\videochat\
copy /y samples\* C:\AppServ\www\videochat\

@echo ���������˳�...
@pause