N$:AL=PP+58:WT$=FN$:LL=PP+98:TF=-1:AF=0
65 POWER CONT
100 'program initialization
105 GOSUB 29000 'disp init scrn
110 CLS:GOSUB 9000 'disp stat scrn
150 'init fn keys
155 SCREEN 0,0
160 CALL 23161 'clr fn keys
165 KEY OFF
170 DATA "Set ","Hour","Strt","Clr ","Exit"
175 FOR II=4TO8:READ KY$(II):KX=II:GOSUB 9100:GOSUB 9300:NEXT II
200 '-------branch to control loop-----
205 GOTO 32000
210 '---application routines 210-999---
220 IF CT$<>TIME$THENGOSUB260:PRINT@CL,CT$:RETURN:ELSERETURN
225 IF CT$<>TIME$THENGOSUB260:GOSUB280:PRINT@CL,CT$:PRINT@CL+80,WT$:RETURN:ELSERETURN
230 ON ERROR GOTO 235:GOSUB10100:HV#=EV#:HH#=INT(HV#):HM#=INT((HV#-HH#)*100):HS#=INT(((HV#-HH#)*100-HM#)*100):HN#=HS#+(HH#*60+HM#)*60:GOSUB275:WN#=0:WT$=FN$:RETURN
235 BEEP:RESUME230
250 ONERROR GOTO255:GOSUB10100:WV#=EV#:WH#=INT(WV#):WM#=INT((WV#-WH#)*100):WS#=INT(((WV#-WH#)*100-WM#)*100):WN#=WS#+(WH#*60+WM#)*60:GOSUB285:HN#=0:HT$=FN$:RETURN
255 BEEP:RESUME250
260 CT$=TIME$:CH#=INT(VAL(LEFT$(CT$,2))):CM#=INT(VAL(MID$(CT$,4,2))):CS#=INT(VAL(RIGHT$(CT$,2))):CN#=CS#+(CH#*60+CM#)*60:RETURN
270 HN#=CN#+WN#:HH#=INT(HN#/3600):HM#=INT((HN#-HH#*3600)/60):HS#=HN#-HH#*3600-HM#*60:GOSUB275:RETURN
275 HT$=RIGHT$(STR$(HH#),2)+":"+RIGHT$(STR$(HM#),2)+":"+RIGHT$(STR$(HS#),2):RETURN
280 WN#=HN#-CN#:WH#=INT(WN#/3600):WM#=INT((WN#-WH#*3600)/60):WS#=WN#-WH#*3600-WM#*60:GOSUB285:RETURN
285 WT$=RIGHT$(STR$(WH#),2)+":"+RIGHT$(STR$(WM#),2)+":"+RIGHT$(STR$(WS#),2):RETURN
300 AF=0:IFHN#=0THENRETURN
310 GOSUB 220:BEEP:FORII=1TO500:NEXTII:SS$=INKEY$:IFSS$=""GOTO300ELSERETURN
350 AF=0:HN#=0:WN#=0:WT$=FN$:HT$=FN$:RETURN
999 '-------main fn key routines-------
1000 EX=-1:RETURN
2000 EX=-1:RETURN
3000 EX=-1:RETURN
4000 KX=4:GOSUB 9500:GOSUB 9800
4100 IFTFTHENGOSUB230ELSEGOSUB250
4900 GOSUB 9000
4920 KX=4:GOSUB 9500:GOSUB 9700
4990 EX=-1:RETURN
5000 KX=5:GOSUB 9500:GOSUB 9800
5100 TF=NOTTF:IFTFTHENKY$(5)="Hour"ELSEKY$(5)="Wait"
5110 GOSUB 350
5900 GOSUB 9000
5920 KX=5:GOSUB 9500:GOSUB 9700
5990 EX=-1:RETURN
6000 KX=6:GOSUB 9500:GOSUB 9800
6020 KV=0:GOSUB 9600 ' all keys n/a
6030 KX=7:GOSUB 9100:GOSUB 9300 'key on
6100 AF=-1:IFTFTHENGOSUB280ELSEGOSUB270
6105 IFHN#=0THEN6210
6110 GOSUB 9000
6120 IF NOT AF THEN GOTO 6210
6130 GOSUB 225
6140 IF CN# >= HN# THEN GOSUB 300
6150 GOTO 6120
6210 GOSUB 350
6900 GOSUB 9000
6910 KV=-1:GOSUB 9600 'all keys av
6920 KX=6:GOSUB 9500:GOSUB 9700
6990 EX=-1:RETURN
7000 KX=7:GOSUB 9500:GOSUB 9800
7100 GOSUB 350
7900 GOSUB 9000
7920 KX=7:GOSUB 9500:GOSUB 9700
7990 EX=-1:RETURN
7999 '--normal exit: unset loop flag---
8000 EX=0:RETURN
8998 '--------utility subroutines------
8999 'status display
9000 PRINT@0,BK$;BK$;BK$;BK$;BK$;BK$;BK$;
9010 PRINT@PP,   "Current time ===> ";:PRINT@CL,CT$;
9020 PRINT@PP+40,"  Alarm time ===> ";:PRINT@AL,HT$;
9030 PRINT@PP+80,"   Time left ===> ";:PRINT@LL,WT$;
9040 PRINT@PP+160,"   Enter times as HH.MMSS";
9050 PRINT@PP+200," Press any key to stop alarm";
9090 EX=-1:RETURN
9099 'set fn key avail
9100 KN(KX)=-1:RETURN
9199 'set fn key not available
9200 KN(KX)=0:KS(KX)=0:KA(KX)=0:KEY (KX) OFF:KP=280+(KX-1)*5:PRINT@KP,"    ";:RETURN
9299 'set available key on
9300 IF KN(KX) AND (NOT KA(KX)) THEN KS(KX)=-1:KA(KX)=0:KP=280+(KX-1)*5: PRINT@KP, KY$(KX);:KEY KX,"":KEY (KX) ON
9310 RETURN
9399 'set available key off
9400 IF KN(KX) AND KS(KX) AND (NOT KA(KX)) THEN KS(KX)=0:KP=280+(KX-1)*5: PRINT@KP, "####";:KEY (KX) OFF
9410 RETURN
9499 'toggle key active
9500 IF NOT KN(KX) THEN RETURN
9520 KP=280+(KX-1)*5
9530 IF NOT KA(KX) THEN KA(KX)=-1:PRINT@KP, RV$+KY$(KX)+NR$;:KEY (KX) OFF:RETURN ELSE KA(KX)=0:PRINT@KP,KY$(KX);:KEY (KX) ON:RETURN
9599 'set all keys availability
9600 FOR KX=4TO8
9620 IF KV THEN GOSUB 9100 ELSE IF NOT KA(KX) THEN GOSUB 9200
9630 NEXT KX:RETURN
9699 'set all keys on
9700 FOR KX=4TO8
9710 GOSUB 9300:NEXT KX:RETURN
9799 'set all keys off
9800 FOR KX=4TO8
9810 GOSUB 9400:NEXT KX:RETURN
10099 'get numeric input
10100 SS$=INKEY$:IFSS$<>""THEN 10100
10105 PRINT@40,BK$;BK$;BK$;BK$;BK$;:PRINT@PL,"Value ====> ";:EV$="":ED=0
10110 SS$=INKEY$:IF SS$="" THEN 10110
10120 IF SS$=CHR$(8) AND LEN(EV$)>0 THEN PRINT CHR$(127);:EV$=LEFT$(EV$,LEN(EV$)-1):GOTO 10110
10130 IF SS$=CHR$(13) THEN 10180
10140 IF (SS$>="0" AND SS$<="9") THEN EV$=EV$+SS$:PRINT SS$;:GOTO 10110
10150 IF LEN(EV$)=0 AND (SS$="-" OR SS$="+") THEN :EV$=EV$+SS$:PRINT SS$;:GOTO 10110
10160 IF SS$="." AND NOT ED THEN ED=-1:EV$=EV$+SS$:PRINT SS$;:GOTO 10110
10170 BEEP:GOTO 10110
10180 EV#=VAL(EV$):RETURN
28999 'initial program screen
29000 CLS:SCREEN 0,0
29010 PRINT@122,"* * TIMER - A Simple Alarm Clock * *"
29020 PRINT@205," Copyright 1987 M. Aiello"
29030 FORII=1TO800:NEXT II:RETURN
31997 '
31998 '---------main menu loop---------
31999 '
32000 EX = -1
32100 ON KEY GOSUB 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000
32200 GOSUB 220:IF EX THEN GOTO 32200 'wait for fn key
32250 '
32251 'normal exit
32252 '
32255 CLS
32260 CALL 23164,0,23366 'reset fn keys
32265 CALL 27795 're-init BASIC fn keys
32270 KEY OFF
32275 CLOSE:MAXFILES=1
32280 POWER 10
32300 MENU
