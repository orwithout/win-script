::检测是否管理员，普通权限直接shadow，管理员权限则启动诊断：
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL || echo notadmin
Rd "%WinDir%\System32\test_permissions" 2>NUL

pause