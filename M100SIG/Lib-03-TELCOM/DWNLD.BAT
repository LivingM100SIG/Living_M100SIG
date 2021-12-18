
echo off
cls
echo DWNLD.BAT Copyright 1987 by R.G. Olson, releasd to public domain.
echo A "user-friendly" BATch file for PC or M/S DOS to R/S M100 series
echo file transfers. Connect RS-232 ports via R/S Cat. No.s
echo    RS-232 male-male DB25 cable.          26-1408
echo    Female-female DB25 adapter.           26-1495
echo    Null Modem Adapter.                   26-1496
echo .
echo  Put M100 in TEXT mode and supply file_name.
echo  Tap M100 function key [F2] =} "Load from:"
echo  Type:"COM:57N1E" & HIT THE [ENTER] KEY.
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
echo on
MODE COM%2:1200,N,7,1
echo off
pause
echo on
COPY /b %1 COM%2:
echo off
goto end
:msg
echo .
echo PROPER Command syntax:
echo DWNLD DR-Ltr:\Subdir\FILENAME.EXT  Port#
echo        Port#x= 1, 2, 3, or 4 for the PC Serial Port COMx:
:end
echo .
echo If M100 is hung with "Load from:....." after COPY has finished,
echo    hit [SHIFT-BREAK].
echo on
