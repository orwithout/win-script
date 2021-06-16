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
::修改ip获取方式为dhcp
netsh interface ip set address name="WLAN" source=dhcp
ping 127.0.0.1 >nul

::修改dns获取方式
netsh interface ip set dnsservers name="WLAN" source=dhcp

::等待
ping 127.0.0.1 >nul