:: Configuration File

@echo off

set i=0

:: How many times to ping
set failwait=10000 
:: Who to ping
set remote_host=example.com
:: The rsync user
set sftp_user=exampleuser
:: The working directory
set _this_path=%~dp0 


:: Source folder
set remote_folder=/home/%sftp_user%/
:: Destination folder
set local_folder=/Documents and Settings/Administrator/Desktop/


:: Setup Variables
schedule=00:00 /every:m,t,w,th,f,s,su


