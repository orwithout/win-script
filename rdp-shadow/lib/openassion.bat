@ECHO OFF
setlocal enabledelayedexpansion

::��¼���ؽ��̡�Զ�˻Ự��1-2����ip��user��3-8�������ԣ�
for /f "tokens=1-5 delims= " %%A in ('netstat -ano ^| find "%1:3389"') do echo !all-PID! | find "%%E" >nul ||set all-PID=!all-PID!-%%E
echo all-PID{!all-PID!}
for /f "tokens=1-4 delims=# " %%A in ('qwinsta /server:%1 ^|find /v "console" ^|find /i "%2" ^|findstr /i "Active ������"') do echo !all-SIDr! | find "%%B.%%D" >nul || set all-SIDr=!all-SIDr!-%%B.%%D
echo all-SIDr{!all-SIDr!}


::��ssion��
call lib\makerdpfile.bat %1 %2 %3 %4 %5 %6 %7 %8
start mstsc %temp%\"%1".rdp"
if %9 EQU keep exit else ping 127.0.0.1 -n 2 >nul


::��ѯ�����½��̡��Զ��»Ự��
set new-PID="empt"
:Wt4newPID
ping 127.0.0.1 -n 1 >nul
set/p=.<nul
for /f "tokens=1-5 delims= " %%A in ('netstat -ano ^| find "%1:3389"') do echo !all-PID! | find "%%E" >nul || set new-PID=%%E
if %new-PID% EQU "empt" (goto Wt4newPID)
echo new-PID{%new-PID%}

set new-SIDr="empt"
:Wt4newSID
ping 127.0.0.1 -n 1 >nul
set/p=.<nul
for /f "tokens=1-4 delims=# " %%A in ('qwinsta /server:%1 ^|find /v "console" ^|find /i "%2" ^|findstr /i "Active ������"') do echo !all-SIDr! | find "%%B.%%D" >nul || set new-SIDr=%%D
if !new-SIDr! EQU "empt" (goto Wt4newSID)
echo new-SIDr{%new-SIDr%}

::�ж��Ƿ���Ҫkeep�Ự
echo keepORkill{%9}
if %9 EQU keep (echo return{%new-PID%-%new-SIDr%}) else (
	ping 127.0.0.1 -n 2 >nul
	lib\PsExec \\%1 tscon %new-SIDr% /dest:console
	ping 127.0.0.1 -n 1 >nul
	taskkill /F /T /PID %new-PID%
	ping 127.0.0.1 -n 2 >nul
)

