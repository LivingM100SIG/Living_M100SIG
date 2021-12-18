      MP2TXT.CO (c) 1990
      Copyright by Paul Globman
      -------------------------

MP2TXT is a "MSPLAN to TEXT" utility that directs the printer output to a
routine that writes to a TEXT file.  MSPLAN does not offer an option to save
a spreadsheet to a TEXT file for further editing/merging with other documents.

Operating parameters
--------------------
1) This utility is written for XOS-C users.  XBASIC.CO must be in bank #3.

2) Your MSPLAN spreadsheet cannot be in bank #2.

3) The output file will be in bank #2 and is called LPT.DO.

4) You may run MP2TXT.CO cross bank via F3, or cursor select it.


MP2TXT.CO will prompt you for the MSPLAN file name, and you will then be in
MSPLAN.  When you press PRINT or SHIFT PRINT, the data is diverted from the
printer port and appended to the LPT.DO file in bank #2.  Succesive print
operations will collect in one file, and will be separated by a ^L (printer
form feed) at the end of each spreadsheet.

When you exit MSPLAN and return to the menu, printed material is once again directed to the printer port.


Errors
------
If XBASIC is not in bank #3, then MP2TXT will not operate and you are returned
to the menu.  If you run out of RAM in bank #2, your spreadsheet will not be
fully printed, but you will not corrupt other files or crash the Tandy 200.

If entering MSPLAN via MP2TXT causes the "Bad file format" message, you may
ignore the message and enter the name of your spreadsheet.

XOS-C does NOT cross load the actual MSPLAN files.  You may cross load
MP2TXT.CO by storing it in bank #3 and calling it from bank #1, where the
spreadsheet file is located.


WARNING
-------
Do not use without XOS-C installed.


1 '************************
2 '*  MP2TXT.CO           *
3 '*    by Paul Globman   *
4 '*  Copyright (c) 1990  *
5 '************************
10 FOR I = 65362 TO 65535 
20 READ X:POKE I,X:SM=SM+X
30 NEXT
40 IF SM = 22381 THEN 60
50 PRINT"error in data":STOP
60 SAVEM"MP2TXT.CO",65362,65535,65362
1000 DATA 33,198,255,34,61,245,33
1010 DATA 132,255,34,19,245,205,219
1020 DATA 160,33,242,255,62,8,205
1030 DATA 112,248,58,119,239,167,194
1040 DATA 198,255,33,168,156,34,87
1050 DATA 249,34,201,248,33,234,255
1060 DATA 62,2,205,112,248,195,153
1070 DATA 108,229,213,197,245,33,213
1080 DATA 255,119,35,34,137,255,58
1090 DATA 210,255,60,50,210,255,241
1100 DATA 254,10,202,175,255,254,13
1110 DATA 194,167,255,62,10,195,135
1120 DATA 255,58,210,255,254,19,218
1130 DATA 193,255,33,210,255,62,4
1140 DATA 205,112,248,175,50,210,255
1150 DATA 33,213,255,34,137,255,193
1160 DATA 209,225,241,201,33,168,156
1170 DATA 34,61,245,34,19,245,195
1180 DATA 164,103,0,213,255,0,0
1190 DATA 0,0,0,0,0,0,0
1200 DATA 0,0,0,0,0,0,0
1210 DATA 0,0,0,0,0,5,237
1220 DATA 255,50,58,76,80,84,11
1230 DATA 245,255,51,58,88,66,65
1240 DATA 83,73,67,46,67,79
1250 REM       END OF DATA
