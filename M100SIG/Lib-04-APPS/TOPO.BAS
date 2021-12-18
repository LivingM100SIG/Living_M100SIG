
10 CLS:PRINT@48,"Topographic Grid Survey":PRINT@88,"Cut and Fill Calculator":PRINT@136,"Program"
20 PRINT@248,"(c) 1985 by John Lovell":PRINT@290,"All Rights Reserved";:FORX=1TO1000:NEXT
30 CLS
40 GOSUB560:PRINT:LINEINPUT"Number of horiz. lines    =>";HL$:IFHL$="Q"ORHL$="q"THENMENUELSEHL=VAL(HL$)
50 LINEINPUT"Number of vert. lines     =>";VL$:VL=VAL(VL$)
60 LINEINPUT"Grid size in feet (CR=10) =>";GS$:IFGS$=""THENGS$="10"
70 GS=VAL(GS$)
80 LINEINPUT"Proposed/Existing (Y/N)   =>";PE$:IFPE$="Y"ORPE$="y"THENPE=1:GOTO100ELSEPE=0
90 LINEINPUT"Depth correction figure   =>";DC$:DC=VAL(DC$)
100 GOSUB560:PRINT:LINEINPUT"Display cell as it is calculated=>";A$:DI=0:A$=LEFT$(A$,1):IFA$="Y"ORA$="y"THENDI=1
110 IFDI=0THEN140
120 LINEINPUT"Display time in sec.s/0 for KEY =>";DE$
130 IFDE$="0"THENID=1ELSEDE=VAL(DE$)*500
140 DIM A(HL*VL):PN=HL*VL:CLS:PRINT"Coroborate figures:":PRINTTAB(5)"Vertical lines.....:"VL
150 PRINTTAB(5)"Horizontal lines...:"HL:PRINTTAB(5)"Grid size..........:"GS:
160 IFPE THENPRINTTAB(5)"Proposed/Existing..: ON"ELSEPRINTTAB(5)"Depth correction...:"DC
170 IFDI=0THENPRINTTAB(5)"Calculation display: OFF"
180 IFDI THENPRINTTAB(5)"Display figures,";
190 IFID THENPRINT" KEY next cell.
200 IFDE THENPRINT" "DE$" Sec. per cell.
210 PRINT:PRINTTAB(4)" *** Is this correct (Y/N) ***";
220 A$=INKEY$:IFA$=""THEN220
230 IFA$="Y"ORA$="y"THEN240ELSERUN
240 CLS:P=1:L=1:PRINT@40,"Enter horizontal line 1 (l. to r.):":SOUND9394,5:PRINT
250 FORX=1 TO HL*VL:IF P=VL+1 THENCLS:L=L+1:PRINT@40,"Enter horizontal line"L"(l. to r.):":PRINT:P=1:SOUND9394,5
260 IFDC THENPRINT@289,"Height Correction:"DC;
270 PRINT@160,"Line"L"/ Point"P;TAB(18)"=>      ":PRINT@182,"";:SOUND9394,3
280 IFPE THENPRINTSTRING$(4,8);"Exist=>     ";STRING$(4,8);:LINEINPUTA$
290 IFPE THENPRINTTAB(15)"Proposed=>     ";STRING$(4,8);:LINEINPUTB$:A(X)=VAL(A$)-VAL(B$):GOTO310
300 LINEINPUTA$:A(X)=VAL(A$)-DC
310 P=P+1:NEXT
320 FORX=1TO250:NEXT:CLS:PRINTTAB(10)"All points have been":PRINT"  entered and calculations have begun."
330 PRINT:PRINTTAB(12)"Please stand by.
340 IFDI=0THENFORX=1TO(VL*HL):T=T+A(X):NEXT:T=T/(VL*HL):T=T*GS*GS*(VL-1)*(HL-1):GOTO460
350 FORX=1TO(VL*(HL-1))-1:IFX/VL=INT(X/VL)THENNEXT
360 A1=A(X):A2=A(X+1):A3=A(X+VL):A4=A(X+VL+1)
370 A=((A1+A2+A3+A4)/4)*GS*GS:ST=A:T=T+ST
380 CLS
390 IFST<0THENPRINT"   Fill ";ELSEIFST>0THENPRINT"   Cut ";ELSEPRINT"   ";
400 PRINT"Cell"CN+1:PRINT:PRINT"Cu Ft:";:PRINTUSING"#,###.#";ABS(ST):PRINT"CU YD:";:PRINTUSING" ####.# ";ABS(ST/27)
410 PRINT@59,A1+DC;TAB(32)A2+DC:PRINT@105,GS$"x"GS$:PRINT@139,A3+DC;TAB(32)A4+DC
420 IFT<0THENA$="to Fill"ELSEIFT>0THENA$="to Cut"ELSEA$="needed
430 IFDC THENPRINT@210,"Correction factor:"DC;
440 T1=T/27:PRINT@244,"Sub-total:"ABS(INT(T1*10))/10"cu yds "A$:GOSUB520
450 NEXT
460 CLS:IFT<0THENA$="Fill"ELSEIFT>0THENA$="Cut"ELSEA$="None"
470 PRINT@40,"Total Cubic Feet :";:PRINTUSING"#,###,###.#";ABS(T);:PRINT"    "A$
480 PRINT"Total Cubic Yards:";:PRINTUSING" ####,###.#";ABS(T/27);:PRINT"   Needed"
490 PRINT:PRINT"Total Cells Calculated:"(VL-1)*(HL-1):PRINT@287,"Press <ENTER> to continue.";
500 LINEINPUTA$:IFA$=""THENRUN
510 MENU
520 CN=CN+1:IFID=0THEN550
530 PRINT@292,"<Press Spacebar>";
540 A$=INKEY$:IFA$=""THEN540ELSERETURN
550 FORTI=1TODE:NEXT:SOUND4184,3:RETURN
560 CLS:PRINTTAB(11)"Topographic Survey":PRINTTAB(15)"Calculator":RETURN
                                                                                