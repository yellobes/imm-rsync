call "%~dp0config.bat"

:: Add the task to the scheduler
at %schedule% /every:m,t,w,th,f,s,su "%~dp0sync.bat"

:: Allow it through the firewall
netsh firewall set allowedprogram "%~dp0rsync.exe" rsync ENABLE
