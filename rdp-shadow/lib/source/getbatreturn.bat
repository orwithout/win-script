@echo off
for /f "tokens=2-4 delims=-." %%A in ('call OpenAssion.bat 10.10.0.20 administrator 800 600 1 2 2100 1100  ^|find "return"') do echo asdf:%%A-%%B-%%C
pause