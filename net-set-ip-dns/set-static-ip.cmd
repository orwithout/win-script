::修改ip需要以管理员身份运行，这段代码会弹出UAC，是本脚本运行提权

@echo off
cd /d "%~dp0"
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto Admin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit
:Admin



::修改WLAN为你的网卡的名称
netsh interface ip set address "WLAN" static 192.168.1.101 255.255.255.0 192.168.1.1 1

::设置dns地址：
netsh interface ip set dns "WLAN" static 192.168.1.1
