echo off
if !%1==! goto nofil
echo .
pause
type %1
goto owari
:nofil
echo Format: DOW (filespec)
:owari
