echo off
if !%1==! goto nofil
echo .
echo ^Z to end
rfilter >>%1
goto owari
:nofil
echo Format: UPL <filespec>
:owari
