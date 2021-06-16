@echo off


:aaaa
set num=0
for /f "delims=" %%a in ('qwinsta ^| find /i /v "console" ^| find /i "ÔËÐÐÖÐ" ^| find /i "administrator"') do (
    if /i not "%%a" == "" (
        set /a num+=1
        echo %%a
    )
)
echo %num%
ping 127.0.0.1 -n 2 >nul
if %num% equ 0 (
    goto aaaa
 )
pause

