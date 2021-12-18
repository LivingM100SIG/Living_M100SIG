100 ' mmap.do for the NEC 8201
110 '
120 ' Author: Alex Lane [75175,1370]
130 ' 
140 ' The program displays the contents
150 ' of a specified memory range in
160 ' in both hex and ASCII.  A copy 
170 ' of the output is saved in a RAM
180 ' file.
190 ' 
200 ' The format for the output was 
210 ' inspired by the CP/M utility
220 ' DDT.COM.
230 '
240 ' To make the program send
250 ' its output only to the screen,
260 '    ii) delete the line OPENing 
270 '        the RAM file;
280 '   iii) delete the PRINT#1
290 '        statements.
300 '
310 ' If you don't mind a messy screen,
320 ' change K1 to 15 and the RAM file
330 ' will be suitable for output to a
340 ' printer.
350 '
360 CLS:SCREEN ,0
370 K1=7:
380 OPEN "memap" FOR OUTPUT AS #1
390 PRINT "(add 'h' suffix for hex)
400 INPUT"Starting Location";I$:GOSUB 680:AL=I
410 INPUT"  Ending Location";I$:GOSUB 680:OM=I:IF OM<AL THEN BEEP:PRINT"Bad input":GOTO 400
420 CLS
430 FOR BM=AL TO OM STEP K1+1
440 X=BM:P=3:GOSUB 590
450 PRINT#1,X$" ";:' To RAM
460 PRINT X$" ";:' To screen
470 FOR K=0 TO K1
480 IF BM+K>OM THEN L$=L$+STRING$(3*(K1-K)+3," "):GOTO 540
490 X=PEEK(BM+K)
500 IF X>49 AND X<128 THEN M$=M$+CHR$(X) ELSE M$=M$+"."
510 P=1:GOSUB 590
520 L$=L$+X$+" "
530 NEXT K
540 PRINT#1,L$;"  ";M$:' To RAM
550 PRINT L$;"  ";M$:' To screen
560 L$="":M$="":X$=""
570 NEXT BM
580 END
590 ' dtoh conversion [x in; x$ out]
600 X$=""
610 FOR Q=P TO 0 STEP -1
620 J=INT(X/(16^Q)):X=X-J*16^Q
630 J$=MID$("0123456789ABCDEF",J+1,1)
640 X$=X$+J$
650 NEXTQ
660 RETURN
670 '
680 ' htod conversion [i$ in; i out]
690 IF RIGHT$(I$,1)<>"h" AND RIGHT$(I$,1)<>"H" THEN I=VAL(I$):RETURN
700 I=0
710 FOR Z=1 TO LEN(I$)-1
720 Z1=INSTR("123456789ABCDEF",MID$(I$,Z,1))
730 IF Z1=0 AND MID$(I$,Z,1)<>"0" THEN Z1=INSTR("123456789abcdef",MID$(I$,Z,1))
740 IF Z1=0 AND MID$(I$,Z,1)<>"0" THEN PRINT "Bad input. Start again.":END
750 I=I+Z1*16^(LEN(I$)-1-Z)
760 NEXT Z
770 RETURN
