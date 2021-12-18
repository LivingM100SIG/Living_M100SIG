0 'DEPARA -- Mike Aiello, 31 March 1987, Version 1.0
1 ' This program removes single occurences of CR-LF pairs from an ASCII file.
2 ' Where 2 or more CR-LF's occur together, all but one are removed. Spaces
3 ' are added as necessary to replace the CR-LF's removed.
4 ' The main application of this program is to allow uploaded text (with each
5 ' line delimited with a CR-LF) to be manipulated by word procesors that
6 ' use CR-LF to indicate a new paragraph. (For example: Microsoft WORD)
7 ' A double CR-LF sequence is used in the original text to indicate a CR-LF
8 ' that does imply a paragraph break.
9 ' This program may be run on the Tandy Model 100, or on an MS-DOS computer
10 ' using a Microsoft-compatable BASIC
100 CLEAR
110 MAXFILES=2
120 DEFINT A-Z
130 '
140 TRUE=-1:FALSE=0
150 LF$=CHR$(10):CR$=CHR$(13)
160 F1=1:F2=2 'file ptrs
170 M1=10 'buffer length
180 M2=50 'CR-LF buffer len
190 '
200 DIM BU$(M1) ' char buffer
210 DIM C(M2)   ' ptrs to buffer pos of nth cr-lf
220 DIM S(M2)   ' flags nth cr-lf is preceeded by a space
230 '
240 CLS
250 ON ERROR GOTO 260:GOTO 270
260 RESUME 250
270 INPUT "Enter name of input file";F1$
280 OPEN F1$ FOR INPUT AS 1
290 ON ERROR GOTO 300:GOTO 310
300 RESUME 290
310 INPUT "Enter name of output file";F2$
320 OPEN F2$ FOR OUTPUT AS 2
330 '
340 ON ERROR GOTO 550
350 PRINT:PRINT"Transfering:":PRINT
360 REM -- branch point
370 IF EOF(1) GOTO 530
380 P1=(P1+1)MOD M1
390 BU$(P1)=INPUT$(1,F1)
400 JJ=JJ+1
410 JK = JJ MOD 100:IF JK=0 THEN PRINT " .";JJ;
420 '
430 IF BU$(P1)=CR$ THEN XC=TRUE:GOTO 460
440 IF BU$(P1)=LF$ THEN XL=TRUE:GOTO 460
450 IF BU$(P1)=" " THEN XS=TRUE ELSE XS=FALSE:XC=FALSE:XL=FALSE
460 REM branch pt
470 '
480 IF CL AND NOT (XC OR XL OR XS)  THEN GOSUB 630  ' reset cr-lf buffer
490 IF (XC AND XL)                  THEN GOSUB 740  ' count cr-lf pair
500 IF NOT (CL OR XC OR XL OR XS)   THEN GOSUB 580  ' o/p buffered chars
510 GOTO 360
520 '
530 PRINT:BEEP:BEEP:PRINT"Transfer done!":CLOSE 1,2:END
540 '
550 PRINT"Error";ERR;"at line";ERL
560 END
570 '
580 REM -- output routine
590 FOR PP = 1 TO P1:PRINT #2,BU$(PP);:NEXT PP
600 P1=0
610 RETURN
620 '
630 REM -- hold output routine
640 IF C1=1 THEN E1=C(C1)+2 ELSE E1=C(C1) ' get address of byte to move
650 E2=C(1)    ' buf adr of 1st cr-lf
660 E3=P1-E1+1 'length of buffer to move
670 IF C1=1 AND (NOT (S(C1) OR XS)) THEN BU$(E2)=" ":E2=E2+1 'ins sp if need
680 IF E3 > 0 THEN FOR EE=1 TO E3:BU$(E2+EE-1)=BU$(E1+EE-1):NEXT EE 'move
690 P1=P1-(E1-E2) 'adjust buffer length
700 C1=0 'reset cr-lf buffer
710 CL=FALSE
720 RETURN
730 '
740 REM cr-lf logging rtn
750 CL=TRUE
760 C1=C1+1
770 C(C1)=P1-1 'ptr to nth cr-lf pair
780 S(C1)=XS
790 XC=FALSE
800 XL=FALSE
810 RETURN
