1 'TREAD.BAS: A GWBASIC program by Don Sakers to read files from
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
13 PRINT:PRINT:PRINT "CAUTION: This program reads a file from the TDD and"
14 PRINT "         writes it to the current MS-DOS directory UNDER THE SAME"
15 PRINT "         NAME. It will overwrite existing MS-DOS files of that name."
16 PRINT:PRINT:PRINT:PRINT "    Set TDD DIP switches: 1 = on | 2,3,4 = off"
17 PRINT
20 OPEN "com1:9600,N,8,1" AS 1
30 PRINT#1,"ZZ"CHR$(7)CHR$(0)CHR$(248)CHR$(13);
39 GOSUB 1000
40 PRINT "enter file name to read (ALL CAPS) XXXXXX.XX"
41 LINE INPUT "                             ----->";N$
42 IF LEN(N$)<9 THEN PRINT "Include trailing spaces and/or extension":GOTO 40
44 CS$=N$+SPACE$(24-LEN(N$))+"F"+CHR$(0)
45 CS$=CHR$(LEN(CS$))+CS$
46 FOR I=1 TO LEN(CS$):SM=SM+ASC(MID$(CS$,I,1)):NEXT I
47 CK=(SM MOD 256) XOR 255
50 PRINT #1,"ZZ"CHR$(0)CS$CHR$(CK);
60 R$=INPUT$(31,1):R1$=RIGHT$(R$,4):H=ASC(R1$):R1$=RIGHT$(R$,3)
61 L=ASC(R1$)
70 IF H+L=0 THEN ERROR 52
72 K=256*H+L
80 PRINT#1,"ZZ"CHR$(1)CHR$(1)CHR$(3)CHR$(250);
85 GOSUB 1000
90 OPEN N$ FOR OUTPUT AS #2
95 PRINT:PRINT "Reading ";N$;
100 FOR I=1 TO INT(K/128)
110 PRINT#1,"ZZ"CHR$(3)CHR$(0)CHR$(252);
120 R$=INPUT$(131,1)
122 D$=MID$(R$,3,128)
123 PRINT".";
124 PRINT#2,D$;
130 NEXT I
132 Z=K-(128*INT(K/128))
135 PRINT#1,"ZZ"CHR$(3)CHR$(0)CHR$(252);
140 R$=INPUT$(Z+3,1):LP=ASC(MID$(R$,2,1)):D$=MID$(R$,3,LP)
150 PRINT #2,D$;
160 CLOSE 2
165 PRINT#1,"ZZ"CHR$(2)CHR$(0)CHR$(253);
170 PRINT:PRINT:PRINT "Finished reading ";N$:PRINT
175 PRINT "Finished writing ";N$;" to current MS-DOS directory."
176 CLOSE:END
1000 R$=INPUT$(4,1):IF ASC(R$)<>18 THEN ERROR 17 ELSE RETURN
2000 IF ERR=54 THEN 2003 ELSE IF ERR=52 THEN 2004 ELSE IF ERR=24 THEN RESUME
2001 PRINT "error #"ERR "in line" ERL:CLOSE:END
2003 CLOSE 1:OPEN "com1:9600,N,8,1" AS 1:RESUME
2004 PRINT "File not found.":CLOSE:END
