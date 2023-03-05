echo off
echo Hang up remote line
CTTY CON
echo Local has control
echo Preparing to pass control to remote
echo To abort, press Control-C. To continue,
pause
REMOTE
if errorlevel==2 goto noopen
if errorlevel==1 goto badparm
MODE COM1:300,e,7,1
CTTY COM1
goto end
:noopen
echo Cannot open communications channel
goto end
:badparm
echo Incorrect communications parameters
:end

