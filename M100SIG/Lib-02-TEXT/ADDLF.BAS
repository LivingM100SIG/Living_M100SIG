5  ' NOT CONFIGURED TO RUN ON THE
6  ' MODEL 100. USE ON A HOST COMPUTER
7  ' AFTER FILE UPLOAD FROM A MODEL 100
8  '       ...Phil Wheeler [71266,125]
9  '
10 '*** (c) 1983 by F.B. David, Dillon, SC   - 830424 ***
11 '*** NOT FOR RESALE - FOR USE IN PUBLIC DOMAIN ONLY !!!
20 '*** Program - ADDLF.BAS 
30 ' This program adds Line Feeds for those Basic programs written on various
31 ' text editors, etc. which put a Carriage return at the end of each line 
32 ' but no Line Feed thusly making the program unreadable by the TYPE command
33 ' on CP/M and IBM-PC machines.  Use MBASIC on CP/M or BASIC/BASICA on the
34 ' to run this program.  The file to be corrected must be an ASCII file.
40 CLEAR 5000
50 FALSE%=0:TRUE%=NOT FALSE%:FIVE%=5
60 PRINT "SOURCE PROGRAM NAME: ";:LINE INPUT P1$:IF MID$(RIGHT$(P1$,4),1,1)<>"." THEN P1$=P1$+".BAS":IF LEN(P1$)>12 THEN PRINT 
CHR$(7):GOTO 60
65 CT=0
70 PRINT "DESTINATION PROGRAM NAME: ";:LINE INPUT P2$:IF MID$(RIGHT$(P2$,4),1,1)<>"." THEN P2$=P2$+".BAS":IF LEN(P2$)>12 THEN 
P2$=LEFT$(P2$,8)+RIGHT$(P2$,4)
80 OPEN "I",1, P1$
90 OPEN "O",2, P2$
100 WHILE EOF(1)=FALSE%
110 LINE INPUT #1, A$
120 CT=CT+1:IF CT MOD FIVE%=FALSE% THEN PRINT". ";
130 Z$=INKEY$:IF Z$=CHR$(27) THEN END
140 PRINT #2, A$
150 WEND
160 PRINT:PRINT
170 PRINT "DONE *******";CHR$(7)
180 PRINT "ANOTHER (Y/N) ";:LINE INPUT B$
190 CLOSE
200 IF B$ = "Y" THEN 60
210 END

