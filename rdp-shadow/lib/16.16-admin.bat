@ECHO OFF&PUSHD %~DP0 &TITLE ShadowTs

::����ip���˻������룺
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set sha-ip=10.1.16.16
set sha-user=administrator
set sha-passwd="admin123"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::����˺����뺬��������ţ�����˫�����������������%���ţ���Ҫ��%%�����
::Ӱ��ģʽ�����ԱȨ��
::���psexec.exeԶ�̲����ã��븴�� lib\source\enableADMIN$2usePsExec.reg ��Զ�̻���ִ��һ��
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::��ͨģʽ���ڷֱ��ʣ�
set sha-w=1000
set sha-h=600
::��ͨģʽ�������Ͻ�λ�ã�
set sha-x=344
set sha-y=89
::��ͨģʽ�������½�λ�ã�
set sha-ww=1920
set sha-wh=1080



::����ƾ�ݣ�
cmdkey /delete:TERMSRV/%sha-ip%
cmdkey /delete:%sha-ip%
cmdkey /add:%sha-ip% /user:%sha-user% /pass:%sha-passwd%

::�����չ����
echo extname{%~x0}
if %~x0 EQU .cmd (
	call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% keep
	exit
) else lib\PsExec \\%sha-ip% taskkill /F /T /IM RdpSaProxy.exe

::�ȴ��ڼ䡢Զ���޸ĶԶ�ע���������RPC��shadow��δ��������ĳ���
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t REG_DWORD /d 1 /f
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v Shadow /t REG_DWORD /d 2 /f
lib\PsExec  \\%sha-ip% REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowUnlistedRemotePrograms /t REG_DWORD /d 1 /f


::console�Ự�Ƿ����ߣ�
setlocal enabledelayedexpansion

set console-SIDr="empt"
for /f "tokens=1-5 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "console" ^|findstr /i "Active ������"') do set console-SIDr=%%C
echo console-SIDr{!console-SIDr!}
if !console-SIDr! EQU "empt" (
	for /f "tokens=3" %%A in ('lib\PsExec \\%sha-ip% reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fSingleSessionPerUser  ^|find /i "fSingleSessionPerUser"') do set singleUser-KEYr=%%A
	echo singleUser-KEYr{!singleUser-KEYr!}
	if !singleUser-KEYr! EQU "0x0" (call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% kill) else (
		set sha-user-SIDr="empt"
		for /f "tokens=3 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "%sha-user%" ^|findstr /i "Active ������"') do set sha-user-SIDr=%%A
		echo sha-user-SIDr{!sha-user-SIDr!}
		if !sha-user-SIDr! EQU "empt" (call lib\openassion.bat %sha-ip% %sha-user% %sha-w% %sha-h% %sha-x%,%sha-y% %sha-ww% %sha-wh% kill) else (lib\PsExec \\%sha-ip% tscon !sha-user-SIDr! /dest:console)
	)
)

::���ҶԶ�console�ỰID��shadow֮��
for /f "tokens=1-5 delims= " %%A in ('qwinsta /server:%sha-ip% ^|find /i "console" ^|findstr /i "Active ������"') do set console-SIDr=%%C
echo console-SIDr{!console-SIDr!}
start mstsc /v:%sha-ip% /shadow:%console-SIDr% /control /noconsentprompt

::by Edge 16:41 2020/3/20
