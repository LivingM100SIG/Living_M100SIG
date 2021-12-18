1 'TDIR.BAS: A GWBASIC program by Don Sakers to display directory of
2 ' a Tandy Portable Disk Drive 1 connected to the COM1 port of an
3 ' MS-DOS computer. Based on information supplied by J.K. Heilman
4 ' in "Exploring the Tandy Portable Disk Drive" (PICO Magazine
5 ' November 1986, pp. 28-29,38.)
6 '  Use RS232 serial connection, no null-modem. Set DIP switches on
7 ' TDD to:1=on, 2=off, 3=off, 4=off.
8 '  Companion files: TREAD.BAS, TWRITE.BAS, TERASE.BAS.
9 '  Licensed for the use of CompuServe M100 SIG members and readers of
10 ' Portable 100 magazine, September 1990 by Don Sakers. Improvements
11 ' welcome.
13 ON ERROR GOTO 200
14 CLS
15 PRINT:PRINT:PRINT:PRINT "    Set TDD DIP switches: 1 = on | 2,3,4 = off"
16 PRINT:PRINT "If you get DEVICE TIMEOUT or an error message, try again."
17 PRINT:PRINT:PRINT "Directory of PDD:":PRINT
20 OPEN "com1:9600,N,8,1,DS5000" AS 1
30 PRINT#1,"ZZ"CHR$(7)CHR$(0)CHR$(248)CHR$(13);
40 GOSUB 100
41 PRINT#1,"ZZ"CHR$(0)CHR$(26)SPACE$(24)"F"CHR$(1)CHR$(158)CHR$(13);
42 GOTO 400
50 PRINT#1,"ZZ"CHR$(0)CHR$(26)SPACE$(24)"F"CHR$(2)CHR$(157)CHR$(13);
60 GOTO 400
70 CLOSE:END
100 R$=INPUT$(4,1):IF ASC(R$)<>18 THEN ERROR 17 ELSE RETURN
200 IF ERR=54 THEN 203 ELSE IF ERR=52 THEN 204 ELSE IF ERR=24 THEN 41
201 PRINT "error #"ERR "in line" ERL:CLOSE:END
203 CLOSE 1:OPEN "com1:9600,N,8,1" AS 1:RESUME
204 PRINT "File not found":CLOSE:END
400 R$=INPUT$(31,1):H=ASC(LEFT$(R$,1)):IF H=18 THEN 500
410 F$=MID$(R$,3,9):L=(ASC(MID$(R$,28,1))*256)+ASC(MID$(R$,29,1))
411 F=ASC(MID$(R$,30,1))
415 IF L=0 THEN 500
420 PRINT F$;L,
425 GOTO 50
500 PRINT:PRINT:PRINT F;" free sectors on disk":PRINT
501 CLOSE:END
