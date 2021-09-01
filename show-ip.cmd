@echo off
echo.
ipconfig | find "10." | find "IPv4"
ping 127.0.0.1 -n 10 >nul
pause