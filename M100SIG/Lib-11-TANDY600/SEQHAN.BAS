10 'suggestions for enhancements to Tom Schulte 72745,256 PLEASE!
30 ON ERROR GOTO  450
40 CLS:PRINT"":PRINT"          SEQUENTIAL HANDLER     ";:PRINT DATE$;:PRINT"   ";:PRINT TIME$:PRINT"          By Tom Schulte"
50 PRINT"":PRINT"     This program will handle Tandy 600 sequentially accessed files such as txt      files, basic programs saved in ascii format or unspecified (.no extension)      files."
60 PRINT"": PRINT"W= Write a File"
70 PRINT"R= Read a File"
80 PRINT"A= Append a File"
90 PRINT"S= Return to System Manager"
100 PRINT"F= File Management    "
110 PRINT"":PRINT"Chose one "
120 A$ = INPUT$(1)
130 IF A$ = "w" OR A$ = "W" THEN GOSUB 190:GOTO 200
140 IF A$ = "r" OR A$ = "R" THEN GOSUB 190:GOTO 260
150 IF A$ = "a" OR A$ = "A" THEN GOSUB 190:GOTO 380
160 IF A$ = "s" OR A$ = "S" THEN SYSTEM
170 IF A$ = "f" OR A$ = "F" THEN 570                       
180 GOTO 30
190 LINE INPUT "filename and extension (if any) > ";F$:RETURN
200 OPEN F$ FOR OUTPUT AS 1
210 LINE INPUT "enter data or press the space bar and then <enter> to end - ";N$
220 IF N$ = CHR$(32) THEN 250
230 WRITE# 1, N$
240 PRINT: GOTO 210
250 GOTO 40
260 INPUT"WAIT BETWEEN STRINGS";W$
270 IF W$ = "y"OR W$ = "Y"THEN W = 1
280 CLS:CLOSE 1:OPEN F$  FOR INPUT AS 1
290 IF EOF(1), THEN 350
300 INPUT#1, N$
310 PRINT N$
320 IF W <> 1 THEN GOTO 340
330 GOSUB 530
340 GOTO 290
350 CLOSE 1
360 GOSUB 530
370 GOTO 40
380 OPEN F$ FOR APPEND AS 1
390 LINE INPUT "enter data or press the space bar and then <enter> to end - ";N$
400 IF N$ = CHR$(32) THEN 430
410 WRITE# 1,N$
420 GOTO 390
430 CLOSE 1
440 GOTO 40
450 IF ERR = 64 THEN 470
460 IF ERR = 53 THEN 480 ELSE 490
470 PRINT"Bad file name try again":GOTO 500
480 PRINT"file not found try again":GOTO 500
490 BEEP:PRINT "*** ERROR number ";ERR;" in line ";ERL;"   ***":STOP
500 RESUME 510         
510 GOSUB 530
520 GOTO 30
530 PRINT"":PRINT"press any key to continue"
540 Z$ = INKEY$
550 IF Z$ = "" THEN 540
560 RETURN
570 PRINT" SUGGEST YOU MERGE FILEMGR.BAS TO HERE"
                                                                                                                              