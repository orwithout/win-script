
@echo off


for /f "skip=1 delims=" %%i in (%~0) do (
echo %%i
)
pause



for /f "delims=" %%i in (filename1.txt) do (
set var=%%i
set var=!var:\=/!
echo !var!>>filename2.txt
)