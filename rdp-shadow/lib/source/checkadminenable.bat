::����Ƿ����Ա����ͨȨ��ֱ��shadow������ԱȨ����������ϣ�
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL || echo notadmin
Rd "%WinDir%\System32\test_permissions" 2>NUL

pause