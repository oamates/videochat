@echo off

set base=D:\Software\Media\red5-server-1.0

@echo ���ǲ����õĲ��𹤾ߣ�Ĭ�ϲ���·��Ϊ %base%
@echo ������ò���ȷ�������ã��ڽ��в��𣡣���
@echo ���������ȷ���������������

call %base%\red5-shutdown.bat
rm -rf %base%\webapps\videochat
cp -rf web %base%\webapps\videochat
call %base%\red5.bat

