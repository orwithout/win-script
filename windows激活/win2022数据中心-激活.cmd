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



slmgr.vbs -upk && slmgr /ipk WX4NM-KYWYW-QJJR4-XV3QB-6VM33 && slmgr /skms skms.netnr.eu.org && slmgr /ato && slmgr /xpr


::备用kms服务器：
::slmgr /skms zh.us.to
::slmgr.vbs -skms kms.03k.org
::slmgr.vbs -skms kms.cangshui.net
::slmgr /skms kms.xspace.in

