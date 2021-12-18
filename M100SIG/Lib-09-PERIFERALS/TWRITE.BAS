1 'TWRITE.BAS: A GWBASIC program by Don Sakers to write files to
2 ' a Tandy Portable Disk Drive 1 connected to the COM1 port of an
3 ' MS-DOS computer. Based on information supplied by J.K. Heilman
4 ' in "Exploring the Tandy Portable Disk Drive" (PICO Magazine
5 ' November 1986, pp. 28-29,38.)
6 '  Use RS232 serial connection, no null-modem. Set DIP switches on
7 ' TDD to:1=on, 2=off, 3=off, 4=off.
8 '  Companion files: TDIR.BAS, TWRITE.BAS, TERASE.BAS.
9 '  Licensed for the use of CompuServe M100 SIG members and readers of
10 ' Portable 100 magazine, September 1990 by Don Sakers. Improvements welcome.
11 ON ERROR GOTO 2000
12 CLS
13 PRINT:PRINT:PRINT "CAUTION: This program reads a file from the current"
14 PRINT "         MS-DOS directory and writes it to the TDD UNDER THE SAME"
15 PRINT "         NAME. It will destroy existing TDD files of that name."
16 PRINT:PRINT:PRINT:PRINT "    Set TDD DIP switches: 1 = on | 2,3,4 = off"
17 PRINT
20 OPEN "com1:9600,N,8,1" AS 1
30 PRINT#1,"ZZ"CHR$(7)CHR$(0)CHR$(248)CHR$(13);
39 GOSUB 1000
40 LINE INPUT "enter file name to write (ALL CAPS) ";N$
41 GOSUB 500
44 CS$=N$+SPACE$(24-LEN(N$))+"F"+CHR$(0)
45 CS$=CHR$(LEN(CS$))+CS$
46 FOR I=1 TO LEN(CS$):SM=SM+ASC(MID$(CS$,I,1)):NEXT I
47 CK=(SM MOD 256) XOR 255
50 PRINT #1,"ZZ"CHR$(0)CS$CHR$(CK);
60 R$=INPUT$(31,1):R1$=RIGHT$(R$,4):H=ASC(R1$):R1$=RIGHT$(R$,3)
61 L=ASC(R1$)
70 IF H+L<>0 THEN GOSUB 3000
80 PRINT#1,"ZZ"CHR$(1)CHR$(1)CHR$(1)CHR$(252);
85 GOSUB 1000
90 OPEN N$ FOR INPUT AS #2
91 PRINT:PRINT "Writing ";N$;" to TDD";
94 R$="":FOR X=1 TO 128:R$=R$+INPUT$(1,2):IF EOF(2) THEN 200 ELSE NEXT X
96 SM=0
110 FOR I=1 TO 128:SM=SM+ASC(MID$(R$,I,1)):NEXT I
115 SM=SM+4+128
120 CK=(SM MOD 256) XOR 255
125 PRINT".";
130 PRINT#1,"ZZ"CHR$(4)CHR$(128)R$CHR$(CK);
160 GOTO 94
200 K=LEN(R$)
210 CS$=CHR$(4)+CHR$(K)+R$:SM=0
220 FOR I = 1 TO K+2:SM=SM+ASC(MID$(CS$,I,1)):NEXT I
230 CK=(SM MOD 256) XOR 255
240 PRINT#1,"ZZ"CS$CHR$(CK);
270 PRINT#1,"ZZ"CHR$(2)CHR$(0)CHR$(253);
280 PRINT:PRINT "Have written ";N$;" to TDD"
290 CLOSE:END
500 L=LEN(N$)
510 IF L>9 THEN PRINT "Filename is too long. Please rename the file and try again.":GOTO 290
520 FOR I=1 TO L:A$=MID$(N$,I,1):IF A$="." THEN 540
521 NEXT I
530 PRINT "Filename isn't in the form XXXXXX.YY. Please rename and try again.":GOTO 290
540 B$=LEFT$(N$,I-1):C$=MID$(N$,I+1,2)
550 IF LEN(B$)<6 THEN B$=B$+SPACE$(6-LEN(B$))
560 M$=B$+"."+C$
570 PRINT N$;" will be named ";M$;" on the TDD. Is this okay?"
580 PRINT "Y to continue, any other key to quit."
590 Z$=INKEY$:IF Z$="" THEN 590
600 IF Z$="Y" OR Z$="y" THEN N$=M$ ELSE 290
610 RETURN
1000 R$=INPUT$(4,1):IF ASC(R$)<>18 THEN ERROR 17 ELSE RETURN
2000 IF ERR=54 THEN 2003 ELSE IF ERR=52 THEN 2004 ELSE IF ERR=24 THEN RESUME
2001 PRINT "error #"ERR "in line" ERL:CLOSE:END
2003 CLOSE 1:OPEN "com1:9600,N,8,1" AS 1:RESUME
2004 PRINT "File not found.":CLOSE:END
3000 PRINT#1,"ZZ"CHR$(5)CHR$(0)CHR$(250);
3010 R$=INPUT$(4,1):RETURN
