1 'TERASE.BAS: A GWBASIC program by Don Sakers to erase files from
2 ' a Tandy Portable Disk Drive 1 connected to the COM1 port of an
3 ' MS-DOS computer. Based on information supplied by J.K. Heilman
4 ' in "Exploring the Tandy Portable Disk Drive" (PICO Magazine
5 ' November 1986, pp. 28-29,38.)
6 '  Use RS232 serial connection, no null-modem. Set DIP switches on
7 ' TDD to: 1=on, 2=off, 3=off, 4=off.
8 '  Companion files: TREAD.BAS, TWRITE.BAS, TDIR.BAS.
9 '  Licensed for the use of CompuServe M100 SIG members and readers of
10 ' Portable 100 magazine, September 1990 by Don Sakers. Improvements
11 ' welcome.
14 ON ERROR GOTO 200
15 CLS
16 PRINT:PRINT:PRINT:PRINT "    Set TDD DIP switches: 1 = on | 2,3,4 = off"
20 OPEN "com1:9600,N,8,1" AS 1
30 PRINT#1,"ZZ"CHR$(7)CHR$(0)CHR$(248)CHR$(13);
39 GOSUB 100
40 PRINT "enter file name to obliterate (ALL CAPS) XXXXXX.XX"
41 LINE INPUT "                                   ----->";N$
42 IF LEN(N$)<9 THEN PRINT "Include trailing spaces":GOTO 41
44 CS$=N$+SPACE$(24-LEN(N$))+"F"+CHR$(0)
45 CS$=CHR$(LEN(CS$))+CS$
46 FOR I=1 TO LEN(CS$):SM=SM+ASC(MID$(CS$,I,1)):NEXT I
47 CK=(SM MOD 256) XOR 255
50 PRINT #1,"ZZ"CHR$(0)CS$CHR$(CK);
60 R$=INPUT$(31,1):R1$=RIGHT$(R$,4):H=ASC(R1$):R1$=RIGHT$(R$,3)
61 L=ASC(R1$)
70 IF H+L=0 THEN ERROR 52
80 PRINT#1,"ZZ"CHR$(5)CHR$(0)CHR$(250);
90 R$=INPUT$(4,1):CLOSE:END
100 R$=INPUT$(4,1):IF ASC(R$)<>18 THEN ERROR 17 ELSE RETURN
200 IF ERR=54 THEN 203 ELSE IF ERR=52 THEN 204
201 PRINT "error #"ERR "in line" ERL:CLOSE:END
203 CLOSE 1:OPEN "com1:9600,N,8,1" AS 1:RESUME
204 PRINT "File not found":CLOSE:END
