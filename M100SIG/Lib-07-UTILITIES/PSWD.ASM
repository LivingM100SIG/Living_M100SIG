1 ' "PSSWRD.RVG" uploaded 03/17/85
2 ' Idea copied from another source, modified to enhance capabilities
3 ' by Ralph V. Getsla  **  74405,1177
4 ' see remarks starting at line 10000 for more info. All remarks may be
5 ' deleted without interfering operation. The ONLY way out of this
6 ' program is to hit "CTRL-C" before it actually does the poke in line 10.
7 ' BE WARNED!!! The poke in line 10 DISABLES CTRL-C, and BREAK.
8 '
10 POKE63056,128:POWEROFF,RESUME:CLS:PRINT:PRINT@045,"Enter Password:";:X=0:Z=600
30 B$="........":A=0
40 A$="":Z=Z-1:IFZ<1THEN10ELSEPRINT@125,"   ";:PRINT@125,Z,X;;:A$=INKEY$:IFA$=""THEN40
50 A=A+1:MID$(B$,A)=A$:IFA<8THEN40
60 IFB$="Model100"THENPOKE63056,0:MENU
70 X=X+1:IFX<3THENPRINT@205,"Try again:";:BEEP:GOTO30
80 BEEP:PRINT@205,"Access denied:":FORP=1TO500:NEXTP:BEEP:CLS:GOTO10
10000 '
10001 ' line 10 sets break disable, then powers off
10002 ' password is stored as B$ one character at a time and compared
10003 ' to a stored string in line 60.
10004 ' This version times out and powers off after about 1 minute, and
10005 ' keeps track of how many times it was accessed unsucessfully as well.
10006 ' To modify for your password, change the string in line 60 in the
10007 ' quotes to be the password you want. Set B$ in line 30 to periods
10008 ' equal to the length of your password string. Set the "A<8" to the
10009 ' length of the password string. Right now set at "8". If your string
10010 ' is only 6 chars long, set "A<8" to "A<6".
10011 ' Questions? Query me at 74405,1177 via EPX or on the message board.
10012 ' END of file here

