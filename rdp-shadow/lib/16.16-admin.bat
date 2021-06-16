@ECHO OFF&PUSHD %~DP0 &TITLE ShadowTs

::主机ip、账户、密码：
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set sha-ip=10.1.16.16
set sha-user=administrator
set sha-passwd="admin123"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::如果账号密码含有特殊符号，请用双引号括起来；如果有%符号，需要用%%来替代
::影子模式须管理员权限
::如果psexec.exe远程不能用，请复制 lib\source\enableADMIN$2usePsExec.reg 到远程机上执行一次
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::普通模式窗口分辨率：
set sha-w=1000
set sha-h=600
::普通模式窗体左上角位置：
set sha-x=344
set sha-y=89
::普通模式窗口右下角位置：
set sha-ww=1920
set sha-wh=1080



::重做凭据：
cmdkey /delete:TERMSRV/%sha-ip%
cmdkey /delete:%sha-ip%
cmdkey /add:%sha-ip% /user:%sha-user% /pass:%sha-passwd%

::检查扩展名：
echo extname{%~x0}
if %~x0 EQU .cmd (
	call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% keep
	exit
) else lib\PsExec \\%sha-ip% taskkill /F /T /IM RdpSaProxy.exe

::等待期间、远程修改对端注册表以允许RPC、shadow、未经过允许的程序：
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t REG_DWORD /d 1 /f
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v Shadow /t REG_DWORD /d 2 /f
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowUnlistedRemotePrograms /t REG_DWORD /d 1 /f


::console会话是否在线：
setlocal enabledelayedexpansion

set console-SIDr="empt"
for /f "tokens=1-5 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "console" ^|findstr /i "Active 运行中"') do set console-SIDr=%%C
echo console-SIDr{!console-SIDr!}
if !console-SIDr! EQU "empt" (
	for /f "tokens=3" %%A in ('lib\PsExec \\%sha-ip% reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fSingleSessionPerUser  ^|find /i "fSingleSessionPerUser"') do set singleUser-KEYr=%%A
	echo singleUser-KEYr{!singleUser-KEYr!}
	if !singleUser-KEYr! EQU "0x0" (call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% kill) else (
		set sha-user-SIDr="empt"
		for /f "tokens=3 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "%sha-user%" ^|findstr /i "Active 运行中"') do set sha-user-SIDr=%%A
		echo sha-user-SIDr{!sha-user-SIDr!}
		if !sha-user-SIDr! EQU "empt" (call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% kill) else (lib\PsExec \\%sha-ip% tscon !sha-user-SIDr! /dest:console)
	)
)

::查找对端console会话ID，shadow之：
for /f "tokens=1-5 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "console" ^|findstr /i "Active 运行中"') do set console-SIDr=%%C
echo console-SIDr{!console-SIDr!}
start mstsc /v:%sha-ip% /shadow:%console-SIDr% /control /noconsentprompt

::by Edge 16:41 2020/3/20
