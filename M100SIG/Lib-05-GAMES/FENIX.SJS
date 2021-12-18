0 REM FENIX.BA - SJ Sims [72245,1254]	3/13/84
1 DEFINTA-Z:GOTO18
2 PRINT@X+R,CL$:R=0:X=RND(1)*35+1:IFSC>BVTHENT=T+INT(BV/600)*50:BV=BV+600:FORI=1TO5:SOUND555,1:SOUND444,1:NEXT:F=F-1
3 T=T-1:PRINT@X+R,B$:PRINT@M+239,P$;:PRINT@280,T"	Hi Score:"HS"	Score:"SC;:I$=INKEY$:IFI$=""THENW=W+1ELSEW=0
4 IFW>3THEN16ELSEIFI$="."THENM=M+1ELSEIFI$=","THENM=M-1ELSEIFI$=" "THEN9
5 IFT<1THEN13ELSEIFM<0THENM=39:PRINT@240,CL$;
6 IFM>39THENM=0:PRINT@279,CL$;
7 X=X+RND(1)*3-1:IFX<0THENX=0ELSEIFX>36THENX=36ELSEIFT<50THENSOUND4000,1
8 GOTO3
9 FORY=200+MTOMSTEP-40:PRINT@Y,CHR$(152);:SOUNDY*68,1:I$=INKEY$:PRINT@Y," ";:NEXT
10 IFM=X+1ORM=X+3THENSC=SC+50:BEEP:FORI=0TO10:PRINT@X+R,"BLORK!":PRINT@X+R,CL$:SOUND16000,1:NEXT:GOTO2
11 IFM=X+2THENSC=SC+100:SOUND440,10:FORI=0TO10:PRINT@X+R,"WAAGH!":PRINT@X+R,CL$:SOUND1760,1:NEXT:GOTO2
12 IFX+R>40*FTHEN16ELSEPRINT@X+R,CL$:R=R+40:SC=SC-5:GOTO5
13 PRINT@175,"Game Over":LINE(0,0)-(239,63),1,BF:FORI=1TO20:I$=INKEY$:NEXT:CLS:IFSC<=HSTHEN18
14 HS=SC:LINEINPUT"NEW HIGH SCORE!!!	Enter your name	(20 characters max) ";HN$:FORI=1TO30
15 POKEHB!+I-1,ASC(MID$(STR$(HS)+" "+HN$+SPACE$(32),I,1)):NEXT:GOTO18
16 LINE(X*6+15,R/40*8+4)-(M*6+3,51):LINE(X*6+15,R/40*8+4)-(M*6+3,51),0:FORW=10000TO15000STEP250:PRINT@239+M,"* *";
17 SOUNDW,1:I$=INKEY$:PRINT@239+M," * ";:NEXT:SC=SC-100:W=0:GOTO2
18 HS$="                                ":P1=VARPTR(HS$):HB!=PEEK(P1+1)+PEEK(P1+2)*256:CL$=SPACE$(6):HS=VAL(HS$)
19 CLS:PRINTTAB(9)"F E N I X":LINE(0,9)-(239,9):PRINT:PRINT"High Score:"HS$:PRINT"Last Score:"SC
20 PRINT@243,"<I>nstructions, <P>lay or <M>enu?";
21 B$=" ^"+CHR$(145)+"^ ":P$=" "+CHR$(133)+" ":ONINSTR("PpMmIi",INPUT$(1))GOTO22,22,23,23,25,25:GOTO21
22 CLS:M=20:T=350:F=2:SC=0:BV=600:GOTO2
23 MENU
25 D$=CHR$(10)+CHR$(27)+"p"+SPACE$(15)+"DEATH RAY!"+SPACE$(15)+CHR$(27)+"q"
26 CLS:PRINT:PRINT" Aliens are trying to take over EARTH!!":PRINT
27 PRINT"They weave back & forth across the sky, but remain cautious; not descending     until fired upon!":GOSUB38
28 PRINT"If you fire and miss, the Alien will de-scend slightly and you will lose FIVE"
29 PRINT"points.  If you miss too many times the Alien will zap you with his":PRINTD$:GOSUB38
30 PRINT"If the Alien detects any indecision on  your part (a failure to move or shoot)"
31 PRINT"he will again unleash the fury of the":PRINTD$:PRINT"and you will lose 100 points!":GOSUB38
32 PRINT"Alien:"B$TAB(20)"You:"P$:PRINT:PRINT"Guide your ship left or right by tappingthe "CHR$(34)"<"CHR$(34)" and ";
33 PRINTCHR$(34)">"CHR$(34)" keys.":PRINT:PRINT"Press the SPACEBAR to fire at the alien.":GOSUB38
34 PRINT"You will receive 50 points for "CHR$(34)"winging"CHR$(34)"the alien, and 100 points for a direct  hit."
35 PRINT"Additional time is awarded at 600 point intervals, but difficulty increases at  the same time!":GOSUB38
36 PRINT:PRINT"Warriors with "CHR$(27)"pThe Right Stuff"CHR$(27)"q will scorein the 2000+ point range.":PRINT
37 PRINT"Good Luck - ":PRINT"	You'll need it!":GOSUB38:GOTO19
38 PRINT@286,"<Press any key to continue>";INPUT$(1);:CLS:RETURN
99 REM If memory is a problem, delete lines 25-39 and don't use the "INSTRUCTION" option.

