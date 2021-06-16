@ECHO OFF

::临时文目录生成rdp文件备调，参数1~8，为ip，user，窗口宽、高，窗体左上xy、右下坐标xy：
copy /y /a lib\template.rdp %temp%\"%1".rdp
(
echo desktopwidth:i:%3
echo desktopheight:i:%4
echo winposstr:s:0,1,%5,%6,%7,%8
echo full address:s:%1
echo username:s:%1\%2
) >>%temp%\"%1".rdp 
