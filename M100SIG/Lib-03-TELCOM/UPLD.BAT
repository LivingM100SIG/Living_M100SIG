
echo off
cls
echo UPLD.BAT Copyright 1987 by R.G. Olson
echo A "user-friendly" BATch file for R/S M100 series to PC or M/S DOS
echo file transfers. Connect RS-232 ports via R/S Cat. No.s
echo    RS-232 male-male DB25 cable.          26-1408
echo    Female-female DB25 adapter.           26-1495
echo    Null Modem Adapter.                   26-1496
echo  Put M100 in TEXT or EDIT mode with Source file Displayed.
echo  Tap M100 function key [F3] =} "Save to:"
echo  Type:"COM:87N1E" BUT DON'T YET HIT THE [ENTER] KEY!
echo ON the PC: Invoke This Batch File.
echo .
IF @%1@==@@ goto msg
IF @%2@==@@ goto msg
IF @%2@==@1@ goto go
IF @%2@==@2@ goto go
IF @%2@==@3@ goto go
IF @%2@==@4@ goto go
goto msg
:go
IF EXIST %1 goto warn
echo on
MODE COM%2:9600,N,7,1,P
echo off
echo Strike a PC key then after "COPY COM....", hit the M100's [Enter]
pause
echo on
COPY COM%2: /a %1
COPY %1 CON:
echo off
echo .
echo  Prepare Printer for Listing
pause
echo on
echo %1 LISTING >PRN
copy %1 prn
echo off
goto end
:warn
echo .
echo FILENAME.EXT= %1 ALREADY EXISTS ! ! !
echo DELete %1 or USE A DIFFERENT FILENAME.EXT
:msg
echo .
echo PROPER Command syntax: UPLD DR-Ltr:\Subdir\FILENAME.EXT  Port#
:end
echo on
