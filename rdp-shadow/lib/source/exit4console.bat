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


setlocal enabledelayedexpansion
for /f "tokens=1-3 delims=," %%i in ('qwinsta ^| findstr "ÔËÐÐÖÐ"') do (set BL1=%%i)
set sessid=!BL1:~-40!
set sessid=!sessid: =!
set sessid=!sessid:~0,1!
echo !sessid!
tscon !sessid! /dest:console

pause