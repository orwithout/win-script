@ECHO OFF

::��ʱ��Ŀ¼����rdp�ļ�����������1~8��Ϊip��user�����ڿ��ߣ���������xy����������xy��
copy /y /a lib\template.rdp %temp%\"%1".rdp
(
echo desktopwidth:i:%3
echo desktopheight:i:%4
echo winposstr:s:0,1,%5,%6,%7,%8
echo full address:s:%1
echo username:s:%1\%2
) >>%temp%\"%1".rdp 
