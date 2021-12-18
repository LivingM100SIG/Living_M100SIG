0 'HANG10, (c)COPYRIGHT 1991, by Henry Glover 72256,2564
1 N=10:CLS:S=10:I=10:ONERRORGOTO10:OPEN"LINES.DO"FORINPUTAS1:PRINT@124,"kill existing LINES.DO file? Y/N"
2 I$=INKEY$:IFI$="Y"ORI$="y"THENGOSUB9:CLOSE:KILL"LINES.DO":GOTO5ELSEIFI$="N"ORI$="n"THENGOSUB9:GOTO3ELSE2
3 IFEOF(1)THENCLOSE:X=2ELSES$="":LINEINPUT#1,S$:Y=Y+1:GOTO3
4 IFMID$(S$,X,1)=" "THENS=VAL(LEFT$(S$,X-2)+"0")+IELSEX=X+1:GOTO4
5 OPEN"LINES.DO"FORAPPENDAS1
6 IFM=NTHEN7ELSEPRINT#1,RIGHT$(STR$(S),LEN(STR$(S))-1)+" '":S=S+I:M=M+1:GOTO6
7 CLS:Y=Y+N:Z=Z+N:PRINT"lines fed:"Z:PRINT"total lines:"Y:PRINT@134,"repeat? Y/N
8 I$=INKEY$:IFI$="Y"ORI$="y"THENM=0:GOTO6ELSEIFI$="N"ORI$="n"THENCLOSE:A$="LINES"+CHR$(0):A=VARPTR(A$):CALL24079,0,PEEK(A+1)+256*PEEK(A+2)ELSE8
9 CLS:PRINT@84,"wait...":RETURN
10 IFERR<>52THENCLS:PRINT@130,"error"ERR"in line"ERL:ENDELSEGOSUB9:RESUME5
11 '
12 'HANG10.BA is a simplified version of the LINES.BAS program previously uploaded to Lib 8.  It is faster, shorter, and more convenient to use, as there are no prompts for the various parameters.
13 'HANG10 generates a block of 10 numbered program lines into a newly created text file, LINES.DO.  You may feed as many additional blocks of 10 lines to the LINES.DO file as you choose.
14 'The program then automatically jumps to the LINES.DO text file so that you may then use this file as a shell to write in your BASIC programs, or if you prefer you can use the numbered lines in the edit mode in BASIC,
15 'in each instance using the Load "LINES.DO" command in BASIC to convert the text file to a basic file.
16 'By deleting the REM sign (') of the next numbered line following the BASIC program you have written in the LINES.DO file, all residual numbered blank lines will be automatically removed when loading the text file to basic;
17 'otherwise all numbered lines will remain intact when downloaded to basic.
18 'HANG10.BA will also add new lines to an existing LINES.DO file or to any basic program saved as LINES.DO (ie, Save "LINES.DO" or Save "LINES",A).
19 'While HANG10.BA is designed to feed blocks of 10 numbered lines, by editing the value of N in line 1 of the program you can change the number of lines to 20 or 30 or whatever,
20 'in which case you may wish to change the program name to HANG20 or HANG30.
21 'To begin a new program line in the LINES.DO file locate the cursor anywhere to the right of the CR of the next numbered line by pressing the down-arrow key, and then hit <DEL/BKSP>.
22 'Caveat: for the M200 change CALL 24079 in line 8 to CALL 29118
23 'Thanks to Neil Wick for the text jump routine in line 8 (TXTJMP.THD, Lib. 8)
