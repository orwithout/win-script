@echo off

echo 完整路径：	%0
echo 无首尾的引号：	%~0
echo 只取文件名：	%~nx0
echo 不含扩展名：	%~n0
echo 只取扩展名：	%~x0
echo 只取路径：	%~dp0
echo 盘符：		%~d0
echo 文件大小：	%~z0
echo 文件修改时间：	%~t0

::对%1，%2，%3……也有效
pause