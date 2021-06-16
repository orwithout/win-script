@echo off
setlocal enabledelayedexpansion

for /f "tokens=3" %%A in ('lib\psexec.exe \\10.1.9.11 reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fSingleSessionPerUser  ^|find /i "fSingleSessionPerUser"') do (
set singleUser-KEYr=%%A
)
echo singleUser-KEYr{!singleUser-KEYr!}
pause

