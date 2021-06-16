@ECHO OFF&PUSHD %~DP0 &TITLE Fix：0.53
echo 启动：%date% %time%
setlocal enabledelayedexpansion

::【psping -n 2 10.55.16.3:7443 2>nul |find "loss"】 返回：
::Sent = 4, Received = 0, Lost = 4 (100% loss),
::或（无丢失）：
::Sent = 4, Received = 4, Lost = 0 (0% loss),

::for语句使用截断【delims==(%% ,】得到：
::Sent   4  Received   4  Lost   0  0 loss)
::A      B   C         D   E     F  G  H


set targetROS="10.55.0.2"
set targetGW="10.55.0.53"
set targetGWsComment="gw10-55-0-53"
set Distance4Dn=102
set Distance4Up=2


set PingTarget="10.55.0.53:7443"
set waitS=1
set waitS4ok=2
set pingN=2
set /a rebootGWlimitS=2040

set t4now=%time%
set /a nowH=!t4now:~0,2!
set /a nowM=1!t4now:~3,2!-100
set /a nowS=1!t4now:~6,2!-100
set /a nowSS=!nowH!*3600+!nowM!*60+!nowS!
set /a SS4target=!nowSS!+!rebootGWlimitS!
set /a H4mark=!nowH!
set /a H0=100-100


:Next
timeout  /t %waitS% >nul
set t4now=%time%
set /a nowH=!t4now:~0,2!
set /a nowM=1!t4now:~3,2!-100
set /a nowS=1!t4now:~6,2!-100
set /a nowSS=!nowH!*3600+!nowM!*60+!nowS!


if !nowH! NEQ !H4mark! (
	echo.
	set/p=[!nowH!]<nul
	set /a H4mark=!nowH!
	
	if !nowH! EQU !H0! (
	set /a SS4target=!nowSS!+!rebootGWlimitS!
	)
	
)

set pingRcvd="empt"
for /f "tokens=1-8 delims==(%%, " %%A in ('psping -w 0 -n %pingN% %PingTarget% 2^>nul ^|find "loss"') do  set pingRcvd=%%D

if !pingRcvd! EQU "empt" (set/p=E<nul&goto Next)
if !pingRcvd! EQU 0 (
	set/p=x<nul
	ssh admin@%targetROS% ":foreach sssrched in=[/ip route find comment=%targetGWsComment%] do={/ip route set $sssrched distance=%Distance4Dn%}"
	if !nowSS! GTR !SS4target! (
		set/p=R<nul
		ssh root@%targetGW% "reboot"
		set /a SS4target=!nowSS!+!rebootGWlimitS!
		)
	goto Next
	)

if !pingRcvd! EQU 1 (set/p=i<nul&goto Next)
if !pingRcvd! EQU %pingN% (
	set/p=.<nul
	ssh admin@%targetROS% ":foreach sssrched in=[/ip route find comment=%targetGWsComment%] do={/ip route set $sssrched distance=%Distance4Up%}"
	timeout  /t %waitS4ok% >nul
	goto Next
	)








