1 'blackbook 8/24/88.3
2 '(copyright) Jay Holovacs, 1988 (CIS 74756,413)
5 GOSUB 550:PRINT @47,"Address Book Print Utility":PRINT @92,"by Jay Holovacs"
6 PRINT:PRINT "Would you like to Sort your file before":PRINT "proceeding (Y/N)?";:R$=INPUT$(1):IF INSTR(1,"Yy",R$) THEN 800
8 CLEAR 8000:DEFINT A-Z:XP=20:GOSUB 700:DIM PD(XP/2,1),LN$(XP,4,3) 'xp=max # of pages (zero-based)
10 GOSUB 550:PRINT:PRINT "Ready to read file":FI$="ADRS":INPUT "Name of input file [cr=ADRS]";FI$:OPEN FI$ FOR INPUT AS 1
13 PRINT:PRINT "...reading and paginating..."
15 LINE INPUT #1,L$:IF ASC(L$)<>35 THEN 30 'skip this line
20 GOSUB 300:GOSUB 500 'read the address, increment the pointers
30 IF EOF(1) THEN CLOSE:GOTO 35 ELSE 15
35 'ready to print out
37 GOSUB 550:PRINT:PRINT "Ready to print: ";FI$:PRINT "consisting of";PG+1;" pages"
40 NP=PG\2 OR 1:GOSUB 100 'number of panels
42 PRINT:PRINT "Get printer ready, hit any key";:BEEP:R$=INPUT$(1):GOSUB 600
45 LPRINT:FOR PNUM=0 TO NP STEP 2:GOSUB 200:IF (PNUM MOD 4)=2 THEN GOSUB 560:LPRINT FF$
47 NEXT
49 LPRINT FF$
50 GOSUB 550:PRINT "Flip your page over for opposite side":PRINT "Align the top edge carefully":R$=INPUT$(1):LPRINT IP$;CD$;
55 LPRINT:FOR PNUM=1 TO NP STEP 2:GOSUB 200:IF (PNUM MOD 4)=3 THEN GOSUB 560:LPRINT FF$
57 NEXT:GOSUB 550:PRINT "Address book complete.."
99 LPRINT IP$:END 'restore printer to normal
100 'set up panel descriptor array--calculate panels NP=zero-based # of panels (always odd)
101 'inserts zero-based page numbers in slots
105 FOR NN=0 TO NP
110 IF NN AND 1 THEN PD(NN,0)=NN:PD(NN,1)=NN+(NP-NN)*2+1:GOTO 120 'if odd panel
115 PD(NN,1)=NN:PD(NN,0)=NN+(NP-NN)*2+1 'even panel
120 NEXT
199 RETURN
200 'print panel #PNUM; QQ=offset from left edge of page
205 LPRINT TAB(QQ);STRING$(100,"-")
207 LPRINT TAB(QQ);"|   ";PD(PNUM,0)+1;TAB(QQ+92);PD(PNUM,1)+1;TAB(QQ+100);"|":GOSUB 290
210 FOR PS=0 TO 4:FOR ALN=0 TO 3
215 LPRINT TAB(QQ);"|   ";LN$(PD(PNUM,0),PS,ALN);TAB(QQ+50);"|   ";LN$(PD(PNUM,1),PS,ALN);TAB(QQ+100);"|"
220 NEXT ALN:GOSUB 290
222 NEXT PS
225 LPRINT TAB(QQ);STRING$(100,"-"):LPRINT
289 RETURN
290 LPRINT TAB(QQ);"|";TAB(QQ+50);"|";TAB(QQ+100);"|":RETURN
300 'convert L$ into a 4 line address, pg=page,ps=position on page
305 P1=2 'strip off #
307 FOR NN=0 TO 3
310 GOSUB 400:LN$(PG,PS,NN)=F$
315 NEXT:RETURN
400 'read the next field from l$ and trim to 42 char max; P1=starting point
401 'exit p1=start of next field, f$=field value
405 IF P1>=LEN(L$) THEN F$="":RETURN'nothing left to parse
410 P2=INSTR(P1,L$,"\"):IF P2=0 THEN P2=LEN(L$)+1
415 F$=MID$(L$,P1,P2-P1):P1=P2+1
420 IF LEN(F$)>42 THEN F$=LEFT$(F$,42)
499 RETURN
500 'increment the page/position pointers
505 PS=PS+1:IF PS>=5 THEN PS=0:PG=PG+1
510 RETURN
550 CLS:PRINT @ 13,"* * Blackbook * *":BEEP:RETURN
560 IF ST THEN GOSUB 550:PRINT "halt for printer page check...":R$=INPUT$(1)
565 RETURN
570 LPRINT TAB(QQ+50);"|  alignment check":RETURN
600 'set up page alignment
602 LPRINT CD$
605 GOSUB 570:GOSUB 550:PRINT "Check the alignment mark...":PRINT"Is it in the exact CENTER Y/N?";:R$=INPUT$(1):IF INSTR(1,"Nn",R$) THEN 640
610 GOSUB 550:PRINT "Carefully align paper to the top of a":PRINT "fresh piece...hit any key";:R$=INPUT$(1):LPRINT IP$;CD$;
612 PRINT:PRINT "Do you want to pause printer between":PRINT "pages to check alignment? Y/N";:R$=INPUT$(1):IF INSTR(1,"Yy",R$) THEN ST=-1 ELSE ST=0
615 RETURN
640 PRINT "Need to adjust paper guide..":PRINT "Adjust paper side to side and hit key";:R$=INPUT$(1):GOTO 605
700 'initialize printer constants
702 IP$=CHR$(27)+"4":CD$=CHR$(15):FF$=CHR$(12)'Values to reset printer to top of form, select condensed type,formfeed
703 'CLEAR statements at lines 8 & 810 will hold a very large address file, change if memory is tight
704 CL=136:QQ=CL/2-50'characters per line for your printer--check the manual!
705 RETURN
800 'shell sort
810 CLEAR 8000:DEFINT A-Z:N=1:GOSUB 550:PRINT "Sort option...":DIM A$(200),S(10) 'num of names
815 PRINT:FI$="adrs":INPUT "Name of input file [cr=ADRS]";FI$:OPEN FI$ FOR INPUT AS 1:INPUT "Name of destination file";OF$
817 PRINT:PRINT "..sorting.."
820 LINE INPUT #1,A$(N):IF EOF(1) THEN 830
822 IF LEN(A$(N))>=254 THEN BEEP:PRINT "Truncated line: ":PRINT A$(N)
823 N=N+1:GOTO 820
830 CLOSE #1:S(1)=1:FOR I=1 TO 9:S(I+1)=S(I)*3+1:NEXT
850 P=0
860 P=P+1:IF S(P+2)<N THEN 860
880 FOR I=P TO 1 STEP -1
890 S=S(I)
900 FOR J=S+1 TO N
910 L=J-S
920 A$=A$(J)
930 IF A$>=A$(L) THEN 970
940 A$(L+S)=A$(L)
950 L=L-S
960 IF L>0 THEN 930
970 A$(L+S)=A$
980 NEXT J,I
990 :OPEN OF$ FOR OUTPUT AS 1:FOR Q=1 TO N:PRINT #1,A$(Q):NEXT:CLOSE:GOTO 8
