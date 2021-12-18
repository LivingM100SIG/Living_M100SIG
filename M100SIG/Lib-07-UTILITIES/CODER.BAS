0 ' CODER.BAS Encryption program. Rev.
1 ' 7/17/87. Features: All in Basic 
2 ' without calls. Therefore easily 
3 ' translated to other machines. 
4 ' Suitable for Electronic Mail.
5 ' Uses only ASCII 33 to 126 and 
6 ' spaces, AND ignores CR's & LF'S,
7 ' including extras added in
8 ' transmission. Marks File start with
10 ' "XX  X" for  correct Start point
11 ' of Decoding. User has the option
12 ' whether to print Spaces & Extras.
13 ' Also, now runs faster.
15 DEFINT F,N,R,Y,Z:DEFSTR A,B,X
20 CLS:LOCATE 8, 1:INPUT "        Source File";F1$:INPUT "        Target File";F2$
30 PRINT "        1] Code";:INPUT "   2] Decode";F:IF F<>1 AND F<>2 GOTO 30
34 IF F=2 THEN R=1:GOTO 40
35 INPUT "        1] Spaces 2] No Spaces";R:IF R<>1 AND R<>2 GOTO 35
40 INPUT "        Enter a 4 digit Number";NU:NU$=STR$(NU):NU$=RIGHT$(NU$,LEN(NU$)-1)
50 N1$=LEFT$(NU$,1)+RIGHT$(NU$,1)
55 IF VAL(N1$)>20 THEN N1=VAL(LEFT$(N1$,1))+VAL(RIGHT$(N1$,1)) ELSE N1=VAL(N1$)
60 N2$=MID$(NU$,2,2)
65 IF VAL(N2$)>20 THEN N2=VAL(LEFT$(N2$,1))+VAL(RIGHT$(N2$,1)) ELSE N2=VAL(N2$)
70 OPEN F1$ FOR INPUT AS 1:OPEN F2$ FOR OUTPUT AS 2
72 IF F=1 THEN PRINT #2,"XX  X";
74 IF F=2 THEN GOSUB 200
80 IF EOF(1) GOTO 150
90 X=INPUT$(1,1):IF ASC(X)>32 GOTO 100
95 IF R=1 GOTO 130 ELSE GOTO 80
100 Y=Y+1:Z=ASC(X)
110 IF F=1 THEN Z=Z+Y MOD N1+N2 ELSE Z=Z-Y MOD N1-N2
115 IF Z<33 THEN Z=Z+94
116 IF Z>126 THEN Z=Z-94
120 X=CHR$(Z)
130 PRINT #2,X;
140 GOTO 80
150 CLOSE:SYSTEM
200 IF EOF(1) GOTO 250
205 A=INPUT$(1,1)
210 IF A<>"X" GOTO 200
220 B=B+A:IF LEN(B)<5 THEN A=INPUT$(1,1):GOTO 220
240 IF B="XX  X" THEN RETURN
250 LOCATE 18, 8:BEEP:PRINT "INVALID FILE":FOR N=1 TO 1000:NEXT:CLOSE:SYSTEM
