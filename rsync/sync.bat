REM  |   Peter Novotnak, Flexion 2012.
@echo off

call "%~dp0config.bat"

echo 'Sync started!' "%time% >> %_this_path%logs\starts.log"
:start
if "%i%"=="10" (
    echo 'SYNC FAILED!..' "%time% >> %_this_path%failure.log"
    exit
)

set /A i+=1
echo %i%' attempt to sync...

cacls "%local_folder:/=\%*" /e /p Administrator:f
cacls "%local_folder:/=\%*" /e /p Admin:f
cacls "%local_folder:/=\%*" /e /p everyone:f
cacls "%local_folder:/=\%*" /e /p %USERNAME%:f

"%_this_path%rsync.exe" -rz --delete --rsh="'%_this_path%ssh.exe' -i '%_this_path%id_rsa' -o \"StrictHostKeyChecking no\" -l '%sftp_user%'" '%remote_host%':'%remote_folder%'* '%local_folder%' 2> "%_this_path%logs\transfer.error.log"

::  |    did the command complete successfully?
if NOT "%ERRORLEVEL%"=="0" (
    echo 'sync FAILED, waiting to retry...'
	:: If not, ping until victory, then try again.
    :ping
	ping -n 1 -w 20000 %remote_host% > nul
    if NOT "%errorlevel%"=="0" (
         ping -n 5 -w 1000 localhost > nul
         goto :ping
    )
    goto :start
)

cacls "%local_folder:/=\%*" /e /p Administrator:f
cacls "%local_folder:/=\%*" /e /p Admin:f
cacls "%local_folder:/=\%*" /e /p everyone:f
cacls "%local_folder:/=\%*" /e /p %USERNAME%:f

echo success! %time% >> %_this_path%logs\success.log

shutdown /r /c "%restart_message%"

exit
