0 'LINES, (c)COPYRIGHT 1991, by Henry Glover 72256,2564
1 CLS:ONERRORGOTO15:OPEN"LINES.DO"FORINPUTAS1:PRINT@124,"kill existing LINES.DO file? Y/N"
2 I$=INKEY$:IFI$="Y"ORI$="y"THENKILL"LINES.DO":GOTO7ELSEIFI$="N"ORI$="n"THEN3ELSE2
3 CLS:PRINT@80,"number of lines in existing file:"
4 IFEOF(1)THENX=2:GOSUB5:N$=LEFT$(D$,X):CLOSE:PRINT"last line in existing file is #"N$:PRINT"add to existing file? Y/N":PRINT@120,"":GOTO6ELSED$="":LINEINPUT#1,D$:S=S+1:PRINT@113,S:GOTO4
5 IFMID$(D$,X,1)=" "THENX=X-1:RETURNELSEX=X+1:GOTO5
6 I$=INKEY$:IFI$="Y"ORI$="y"THEN8ELSEIFI$="N"ORI$="n"THENMENUELSE6
7 CLS:PRINT:PRINT:LINEINPUT"starting number: ";N$:N=VAL(N$)
8 LINEINPUT"number of lines to feed to file: ";B$:B=VAL(B$)
9 LINEINPUT"increment by: ";A$:A=VAL(A$):IFX>0THENN=VAL(N$)+A
10 PRINT"Basic or Text mode? B/T"
11 I$=INKEY$:IFI$="T"ORI$="t"THEN12ELSEIFI$="B"ORI$="b"THEN12ELSE11
12 CLS:PRINT@85,"wait...":OPEN"LINES.DO"FORAPPENDAS1
13 IFE=BTHENMENUELSEN$=STR$(N):X=LEN(N$)-1:GOSUB14:N=N+A:E=E+1:GOTO13
14 IFI$="T"ORI$="t"THENPRINT#1,RIGHT$(N$,X)+"  ":RETURNELSEPRINT#1,RIGHT$(N$,X)+" '":RETURN
15 IFERR<>52THENCLS:PRINT@130,"error"ERR"in line"ERL:ENDELSERESUME7
16 '
17 'Once you have downloaded the LINES.DO file from the forum library to basic and saved it as LINES.BA, be sure to kill LINES.DO so as not to confuse it with the LINES.DO file created by LINES.BA itself.
18 'LINES.BA can be a useful tool for setting up new programs.  It generates sequentially-numbered program lines into a newly created text file, LINES.DO.
19 'When loading the LINES.DO file (the .DO file created by LINES.BA) into basic (ie, Load "LINES.DO") - if you selected Text mode, the program you developed in the LINES.DO file will be loaded with any residual blank lines deleted, whereas -
20 'if you selected Basic mode, all lines in LINES.DO will be transferred to basic, whether or not you developed a program in LINES.DO, so that you can then continue in the edit mode with numbered blank lines intact.
21 'LINES.BA will also add new lines to an existing LINES.DO file or to any basic program saved as LINES.DO (ie, Save "LINES.DO" or Save "LINES",A).
22 'To begin a new program line in the LINES.DO file locate the cursor anywhere to the right of the CR of the next numbered line by pressing the down-arrow key, and then hit <DEL/BKSP>.
