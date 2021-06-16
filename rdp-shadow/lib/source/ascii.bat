@echo off
:: helloacm.com
:: ord function implementation
:: convert character to ASCII
:: does not work for ! < > |
setlocal EnableDelayedExpansion
 
set code=0
if [%1] EQU [] goto END
 
set input=%1
:: get first character of the input
set target=%input:~0,1%
 
    for /L %%i in (32, 1, 126) do (
        cmd /c exit /b %%i
        set Chr=^!=ExitCodeAscii!
        if [^!Chr!] EQU [^!target!] set code=%%i & goto END
    )
goto :EOF
 
:END
    echo !code!
 
:: set return code
endlocal & set errorlevel=%code%
