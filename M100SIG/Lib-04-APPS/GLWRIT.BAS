0 ' CHECKS.BA  (Check writing program)
1 '   Copyright 1985 Tony B. Anderson         All Rights Reserved
2 ' Modified by Robert Smith, 72116,1734 for use with Jon Kaplan's GLCHEK.BA
3 ' A modification of Tony Anderson's CHECKS.BA, GLWRIT.BA works in conjunction
4 ' with GLCHEK.BA and the other programs of the GL100 general ledger system in DL4.
5 ' File CJ.DO should be in RAM. This program will print a check and then write the information to CJ.DO as an append.
6' Follow the instructions below to custokmize the program for your printer and checks.
7' The program can be modified to operate with PowrDOS and (possibly) TS-DOS by changing the Open "CJ" statement in line 138
8' to read LFILESV:OPEN"0:CJ"AS...
50 ' Initialize the Program:  (Change to accomodate YOUR Checks and Printer)
51 MAXFILES=1  ' Pgm will use 1 file
52 T=0    ' Initialize Total counter
53 T1=42  ' Tab to Date Position
54 T2=11   ' Tab to Payee Position
55 T3=53  ' Tab to Amount Position
56 T4=5   ' Tab to Written Amnt. Pos.
57 L1=9   ' FOR-NEXT loop for top of next check
58 L2=52  ' # of Char. on Written Amnt. line  (line length x pitch = L2)
59 Z$="-" ' Character used to fill line
60 '
70 ' Important variables: (go on check)
71 '     D$ = Month and Date String
72 '     Y$ = Year String
73 '     P$ = Payee's name
74 '     N$ = Check Amount (Numbers)
75 '     V$ = Check Amount (Written)
76 '     C$ = Check Number
77 '      T$ = Category
80 ' Prompts:
81 ' At first prompt for Date, program is expecting month and date in any
82 ' form you normally use.  Default is the first 5 characters from computers
83 ' DATE$ string, in the form "05/16", if you hit ENTER. This is followed by
84 ' a prompt for the year; use any form you wish, default is the last two
85 ' characters from the DATE$ string, in the form "85", if you hit ENTER.
86 ' The "Payee" prompt is for the name of the person to whom you are sending
87 ' the check, and may include any keyboard characters.
88 ' The "Amount" prompt may include commas if you wish, and commas will
89 ' be printed ONLY if you include them here.
90 '
91 ' General:
92 ' Checks should be aligned in the printer so the Date Line is the top line.
93 ' The tab positions (T1-T4), and the FOR-NEXT loop (L1) may have to be
94 ' adjusted for your particular check size and printer.  Also, the number of
95 ' characters on the written amount line (L2). 60 = 5 inches at 12 char. per
96 ' inch (Elite).  The line filling character can be changed in line 59.
97 ' Printing format on the check is controlled in lines 200-225 on a
98 ' line-for-line basis, and may require some adjustment for your check.
99 ' The FOR-NEXT loop advances to the top line on the next check.             
100 J$=CHR$(27)+"J":K$=CHR$(27)+"K"
102 CLS:PRINT@49,"Check Writing Program":PRINT@316,"(c)";
104 PRINT@123,"This program fills in the data on       continuous or single-fed checks."
106 PRINT@243,"Press ENTER when Ready: ";:Q$=INPUT$(1)
108 IF(INP(187)AND6)<>2THENGOSUB300
109 LPRINTCHR$(27);CHR$(31);CHR$(12);
114 PRINT@120,J$:PRINT@120,"";
116 D$=LEFT$(DATE$,5):INPUT" Date:    ";D$:PRINT@132,D$K$
117 Y$=RIGHT$(DATE$,2):INPUT" Year:    ";Y$:PRINT@172,Y$K$
118 LINEINPUT" Check Number:    ? ";C$:IFC$=""THENBEEP:GOTO118
119 LINEINPUT" Category:   ? ";T$:IFT$=""THENBEEP:GOTO119
120 LINEINPUT" Payee:   ? ";P$:IFP$=""THENBEEP:GOTO120
122 LINEINPUT" Amount:  ? $";N$:IFN$=""THENBEEP:GOTO122
124 P=INSTR(N$,","):IFPTHENN$=LEFT$(N$,P-1)+MID$(N$,P+1):GOTO124
126 P=INSTR(N$,"."):IFP=0THENN$=N$+".00":GOTO132
128 IFP=LEN(N$)THENN$=N$+"00"
130 IFP+1=LEN(N$)THENN$=N$+"0"
132 N=VAL(N$):D1$=D$+"/"+Y$:T=T+N 
134 P=INSTR(N$,"."):IFP<5THEN138ELSEN$=LEFT$(N$,P-4)+","+MID$(N$,P-3)
136 P=INSTR(N$,","):IFP<5THEN138ELSEN$=LEFT$(N$,P-4)+","+MID$(N$,P-3):GOTO136
138 OPEN"cj.do"FORAPPENDAS1:PRINT#1,D1$CHR$(44)P$CHR$(44)T$CHR$(44)C$CHR$(44)CHR$(44)CHR$(32)N$CHR$(32)CHR$(44)CHR$(32)CHR$(48)CHR$(
32):CLOSE
142 IFN<1THENV$="----- ONLY "+MID$(N$,2)+" CENTS":GOTO178
150 N1=N:V$="":IFN<1000000000THEN154ELSE N2=INT(N1/1000000000)
152 N1=N1-N2*1000000000:IFN2=0THEN154 ELSEV$=V$+STR$(N2)+" BILLION"
154 IFN1<1000000THEN158ELSEN2=INT(N1/1000000)
156 N1=N1-N2*1000000:IFN2=0THEN158 ELSEV$=V$+STR$(N2)+" MILLION"
158 IFN1<1000THEN162ELSEN2=INT(N1/1000)
160 N1=N1-N2*1000:IFN2=0THEN162 ELSEV$=V$+STR$(N2)+" THOUSAND"
162 IFN>999THENN2=INT(N1):IFN2=0THEN164ELSEV$=V$+STR$(N2):N1=N1-N2:GOTO174
164 IFN1<100THEN170ELSEN2=INT(N1/100)
166 N1=N1-N2*100
168 V$=V$+STR$(N2)+" HUNDRED"
170 IFN1<1THEN174ELSEN2=INT(N1)
172 N1=N1-N2:V$=V$+STR$(N2)
174 V$=V$+" DOLLARS":IFN1=0THEN176ELSE N2=INT(N1*100):V$=V$+" and"+STR$(N2)+" CENTS":GOTO178
176 V$=V$+" and NO CENTS"
178 V$=V$+" "+STRING$(L2-1-LEN(V$),Z$)
190 '  Start Check Printing Routine
195 IF(INP(187)AND6)<>2THENGOSUB300
200 LPRINTTAB(T1)D$;TAB(T1+10)Y$
205 LPRINT:LPRINT
210 LPRINTTAB(T2)P$;TAB(T3)N$
215 LPRINT
220 LPRINTTAB(T4)V$
225 FORA=1TOL1:LPRINT:NEXT  ' Should take you to date line on next check. Adjust value of L1 in line 57 if not.
229 '  End Check Printing Routine
230 PRINT@120,J$:PRINT@120," Another? (Y/N): ";:Q$=INPUT$(1)
232 IFINSTR("Yy",Q$)THEN114ELSEN$=STR$(T):N$=MID$(N$,2)
234 P=INSTR(N$,"."):IFP<5THEN240ELSEN$=LEFT$(N$,P-4)+","+MID$(N$,P-3)
236 P=INSTR(N$,","):IFP<5THEN240ELSEN$=LEFT$(N$,P-4)+","+MID$(N$,P-3):GOTO236
240 P=INSTR(N$,"."):IFP=0THENN$=N$+".00":GOTO246
242 IFP=LEN(N$)THENN$=N$+"00"
244 IFP+1=LEN(N$)THENN$=N$+"0"
246 PRINT@120,J$:PRINT@120,"Total Written: $ "N$:PRINT
260 END
300 BEEP:PRINT@122,"Printer is not ready -- Setup Printer"J$
302 PRINT@162,"";:INPUT"and Press ENTER to Continue: ";Q$
304 IF(INP(187)AND6)<>2THEN300ELSERETURN

