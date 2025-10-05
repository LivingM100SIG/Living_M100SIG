(c) 1986 Polar Engineering and Consulting

Version 1.04

Description:
The RAM Disk ROM works with either the Node DATAPAC Model 102/200, the PG design 64K RAM bank, or the PCSG 96K RAM bank.  The ROM is installed by typing CALL 63012.  The Model 102's main menu file RAMDSK is used after that to access the RAM Disk menu.

Text enhancements:
CTRL-O: switch between insert and overwrite modes
CTRL-J: count chars, words and lines
CTRL-L: locate and replace

ROM entry points:
All entry points are accessed by CALLing 63013.  The A reg value determines the operation of the entry point.  The HL register pair specifies the argument (if any).  Memory location (-1) returns the file type of the file used in the operation.  If the operation fails then memory location (-1) will be zero.  The string variable S$ in the following explanations can be replaced with any valid string variable.   All files refer to RAM Disk files unless otherwise noted.

RAM Disk menu from BASIC        CALL 63013,1
Runs the RAM Disk menu.  Use instead of MENU in BASIC programs that are copied to main RAM.  Use {MENU in BASIC programs that are run by CALL 63013,22.

Is the RAM Disk formatted?      CALL 63013,8
This call MUST be done at the beginning of any program that is going to do RAM Disk operations!
Error #200: no RAMDisk attached
Error #201: RAMDisk is not formatted

Format the RAM Disk             CALL 63013,9
All files stored on the RAM Disk are deleted.
Error #200: no RAMDisk attached

Find the next visible file      CALL 63013,10,VARPTR(S$)
Only the next visible file of type PEEK(-1) is found (see CALL 63013,12).  If the returned value of PEEK(-1)=0 then there aren't any more files of the requested type.  Otherwise, the file name is assigned to S$.

Reset the directory             CALL 63013,12
Do this call after a CALL 63013,12 series to reset the directory search.  All sort bits set to zero.  See CALL 63013,10 and CALL 63013,18.

Set filnam block                CALL 63013,13,VARPTR(S$)
Assigns the file name S$ to the filnam block (FC93..FC9B).  This operation is needed for specifing the second file name for operations requiring two file names.

Amount of RAM Disk space free   CALL 63013,14
Returns the number of 256 byte blocks free in memory locations 64728 and 64729.  The number of bytes free is: (PEEK(64728)+PEEK(64729)*256)*256.

Find the next file              CALL 63013,18,VARPTR(S$)
The next visible or invisible file of type PEEK(-1) is found (see CALL 63013,12).  If the returned value of PEEK(-1)=0 then there aren't any more files of the requested type.  Otherwise, the file name is assigned to S$.

Edit a file                     CALL 63013,20,VARPTR(S$)
Invoke TEXT on file S$ and continues execution when user pressed F8.  If the file doesn't exist then it is created before invoking TEXT.  If there isn't enough room to load the file into the main memory then PEEK(-1) will be zero.  If there isn't enough room the to save the file in the RAM Disk then the bell will ring and the user will be put back into the TEXT program.
IMPORTANT NOTE! This operation clears all BASIC variables and resets the GOSUB/FOR stack to zero.

Copy a file                     CALL 63013,21,VARPTR(S$)
Copy file from S$ to the name specified by the filnam block (see CALL 63013,13).  There must be enough free main memory to hold the complete file during the copy.  If the copy fails then PEEK(-1) will be zero.  The destination file will be overwritten if it exists.

Run a file                      CALL 63013,22,VARPTR(S$)
Run file from S$.  If the file is not found PEEK(-1) will be zero.  Otherwise, the file will be run.  The thee different types of files are handled differently:
 .BA: program is loaded into the RAMBNK hook file and run there.  A open curly bracket '{' followed by MENU will return RAMBNK to just the hook size and return to the RAM Disk menu.  Like a RUN command.
 .CO: program is loaded into the HIMEM to MAXRAM memory.  If the EXE<>0 then the machine code is executed.  Like a RUNM command.
 .DO: see CALL 63013,20

Load a file                     CALL 63013,23,VARPTR(S$)
Load file from S$ into main memory using the name specified by the filnam block (see CALL 63013,13).  If the load fails then PEEK(-1) will be zero.

Save a file                     CALL 63013,24,VARPTR(S$)
Save file to S$ from main memory using the name specified by the filnam block (see CALL 63013,13).  If the save fails then PEEK(-1) will be zero.

Rename a file                   CALL 63013,25,VARPTR(S$)
Rename file S$ to the name specified by the filnam block (see CALL 63013,13).  If the rename fails then PEEK(-1) will be zero.

Delete a file                   CALL 63013,26,VARPTR(S$)
Delete file S$.  If the file does not exist then PEEK(-1) will be zero.

File existance                  CALL 63013,27,VARPTR(S$)
If the file S$ does not exist then PEEK(-1) will be zero.  Otherwise, PEEK(-1) will be the file type and PEEK(64728)+PEEK(64729)*256 will be the length.

Main memory file existance      CALL 63013,28,VARPTR(S$)
If the main memory file S$ does not exist then PEEK(-1) will be zero.  Otherwise, PEEK(-1) will be the file type and PEEK(64728)+PEEK(64729)*256 will be the length.

Make a file visible             CALL 63013,29,VARPTR(S$)
Make the file S$ visible.  PEEK(-1) will be zero if the file is not found.

Make a file invisible           CALL 63013,37,VARPTR(S$)
Make the file S$ invisible.  PEEK(-1) will be zero if the file is not found.


Below is a sample program that can be used to demonstrate all of the RAMDisk functions.  Use the cut and paste functions to merge this program into a .BA file.
 - Put cursor on line zero
 - Press function key 7
 - Press CTRL-DownArrow
 - Press function key 5
 - EXIT and go into BASIC
 - Press PASTE
 - Save program

1 '(c) 1986 Polar Engineering and Consulting
5 SCREEN0
10 CALL63013,8 'must check for RAM Disk first thing!
15 S$="" 'define string so varptr won't cause an ?FC error
100 REM Command input loop
105 C$="":INPUT"[M]enu, [F]iles or command #";C$
110 IF C$="" THEN MENU
115 F=VAL(C$):C$=LEFT$(C$,1)
120 IF C$="M" OR C$="m" THEN MENU
125 IF C$="F" OR C$="f" THEN GOSUB10000:GOTO100
130 IF F<8 OR F>37 THEN BEEP:GOTO100
135 ONF-7GOSUB800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100,3200,3300,3400,3500,3600,3700
140 GOTO100
800 REM Is the RAM Disk formatted?
805 PRINT"RAM Disk formatted?"
810 PRINT"Error #200:no RAM bank"
815 PRINT"      #201:not formatted"
820 CALL63013,8
825 RETURN
900 REM Format the RAM Disk
905 PRINT"Format RAM Disk"
910 CALL63013,9
915 PRINT"RAM Disk is now formatted"
920 RETURN
1000 REM Find next visible RAM Disk directory entry
1005 PRINT"Find next visible file"
1010 FT=192:INPUT"File type (128=BA, 160=CO, 192=DO)";FT
1015 POKE-1,FT
1020 CALL63013,10,VARPTR(S$)
1025 IF PEEK(-1)=0 THEN PRINT"No more files":RETURN
1030 PRINT"Next visible file: "S$
1035 RETURN
1100 REM --
1105 PRINT"Undefined"
1110 RETURN
1200 REM Reset directory search
1205 PRINT"Reset directory search"
1210 CALL63013,12
1215 RETURN
1300 REM Set filnam block with filename in string
1305 PRINT"Set filnam block"
1310 AF$="":INPUT"File name";AF$:IF AF$=""THEN RETURN
1315 CALL63013,13,VARPTR(AF$)
1320 RETURN
1400 REM Amount of RAM Disk space free
1405 PRINT"Amount of RAM Disk space free"
1410 CALL63013,14
1415 FS!=(PEEK(64728)+PEEK(64729)*256)*256
1420 PRINTFS!"bytes free"
1425 RETURN
1500 REM --
1505 PRINT"Undefined"
1510 RETURN
1600 REM --
1605 PRINT"Undefined"
1610 RETURN
1700 REM --
1705 PRINT"Undefined"
1710 RETURN
1800 REM Find the next directory entry
1805 PRINT"Find next file"
1810 FT=192:INPUT"File type (128=BA, 160=CO, 192=DO)";FT
1815 POKE-1,FT
1820 CALL63013,18,VARPTR(S$)
1825 IF PEEK(-1)=0 THEN PRINT"No more files":RETURN
1830 PRINT"Next file: "S$
1835 RETURN
1900 REM --
1905 PRINT"Undefined"
1910 RETURN
2000 REM Edit a RAM Disk file
2005 PRINT"Edit a file"
2010 RF$="":INPUT"File name";RF$:IF RF$="" THEN RETURN
2015 LETA=A:CALL63013,20,VARPTR(RF$)
2020 IF PEEK(-1)=0 THEN PRINT"File not found":RETURN
2025 GOTO100 (EDIT CLEARS THE GOSUB/FORLOOP STACK!)
2100 REM Copy a RAM Disk file
2105 PRINT"Copy a file"
2110 RF$="":INPUT"From file name";RF$:IF RF$="" THEN RETURN
2115 AF$=RF$:INPUT"To file name";AF$
2120 CALL63013,13,VARPTR(AF$)
2125 CALL63013,21,VARPTR(RF$)
2130 IF PEEK(-1)=0 THEN PRINT"Copy failed"
2135 RETURN
2200 REM Run a RAM Disk file (will not return to this BASIC program)
2205 PRINT"Run a file"
2210 RF$="":INPUT"From file name";RF$:IF RF$="" THEN RETURN
2215 AF$=RF$:INPUT"As file name";AF$
2220 CALL63013,13,VARPTR(AF$)
2225 CALL63013,22,VARPTR(RF$)
2230 IF PEEK(-1)=0 THEN PRINT"Run failed"
2235 RETURN
2300 REM Load a RAM Disk file
2305 PRINT"Load a file"
2310 RF$="":INPUT"From file name";RF$:IF RF$="" THEN RETURN
2315 AF$=RF$:INPUT"To file name";AF$
2320 CALL63013,13,VARPTR(AF$)
2325 CALL63013,23,VARPTR(RF$)
2330 IF PEEK(-1)=0 THEN PRINT"Load failed"
2335 RETURN
2400 REM Save a RAM Disk file
2405 PRINT"Save a file"
2410 AF$="":INPUT"From file name";AF$:IF AF$="" THEN RETURN
2415 RF$=AF$:INPUT"To file name";RF$
2420 CALL63013,13,VARPTR(AF$)
2425 CALL63013,24,VARPTR(RF$)
2430 IF PEEK(-1)=0 THEN PRINT"Save failed"
2435 RETURN
2500 REM name a RAM Disk file
2505 PRINT"Rename a file"
2510 RF$="":INPUT"Old file name";RF$:IF RF$="" THEN RETURN
2515 AF$=RF$:INPUT"New file name";AF$
2520 CALL63013,13,VARPTR(AF$)
2525 CALL63013,25,VARPTR(RF$)
2530 IF PEEK(-1)=0 THEN PRINT"Name failed"
2535 RETURN
2600 REM delete a RAM Disk file
2605 PRINT"Delete a file"
2610 RF$="":INPUT"File name";RF$:IF RF$="" THEN RETURN
2615 CALL63013,26,VARPTR(RF$)
2620 IF PEEK(-1)=0 THEN PRINT"File not found"
2625 RETURN
2700 REM exist? a RAM Disk file
2705 PRINT"File exist?"
2710 RF$="":INPUT"File name";RF$:IF RF$="" THEN RETURN
2715 CALL63013,27,VARPTR(RF$)
2720 IF PEEK(-1)=0 THEN PRINT"File not found":RETURN
2725 PRINT"File type:"PEEK(-1)
2730 L=PEEK(64728)+PEEK(64729)*256
2735 PRINT"Length:"L
2740 RETURN
2800 REM exist? a main RAM file
2805 PRINT"Main RAM file exist?"
2810 AF$="":INPUT"File name";AF$:IF AF$="" THEN RETURN
2815 CALL63013,28,VARPTR(AF$)
2820 IF PEEK(-1)=0 THEN PRINT"Main RAM file not found":RETURN
2825 PRINT"File type:"PEEK(-1)
2830 L=PEEK(64728)+PEEK(64729)*256
2835 PRINT"Length:"L
2840 RETURN
2900 REM Make a file visible
2905 PRINT"Make a file visible"
2910 RF$="":INPUT"File name";RF$:IF RF$="" THEN RETURN
2915 CALL63013,29,VARPTR(RF$)
2920 IF PEEK(-1)=0 THEN PRINT"File not found"
2925 PRINT"File is visible now"
2930 RETURN
3000 REM --
3005 PRINT"Undefined"
3010 RETURN
3100 REM --
3105 PRINT"Undefined"
3110 RETURN
3200 REM --
3205 PRINT"Undefined"
3210 RETURN
3300 REM --
3305 PRINT"Undefined"
3310 RETURN
3400 REM --
3405 PRINT"Undefined"
3410 RETURN
3500 REM --
3505 PRINT"Undefined"
3510 RETURN
3600 REM --
3605 PRINT"Undefined"
3610 RETURN
3700 REM Make a file invisible
3705 PRINT"Make a file invisible"
3710 RF$="":INPUT"File name";RF$:IF RF$="" THEN RETURN
3715 CALL63013,37,VARPTR(RF$)
3720 IF PEEK(-1)=0 THEN PRINT"File not found":RETURN
3725 PRINT"File is invisible now"
3730 RETURN
10000 REM Ram Disk directory
10005 PRINT"RAM Disk files:"
10010 POKE-1,128:GOSUB11000
10015 POKE-1,160:GOSUB11000
10020 POKE-1,192:GOSUB11000
10023 CALL63013,12
10025 IF POS(0)>1 THEN PRINT
10030 GOTO 1400 'print free space message
11000 REM Ram Disk next file
11005 CALL63013,10,VARPTR(S$)
11010 IF PEEK(-1)=0 THEN RETURN
11030 PRINTS$"  ";
11035 GOTO11000
