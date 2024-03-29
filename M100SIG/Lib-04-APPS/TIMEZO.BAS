50 'SCREEN 0,0,0,  WIDTH 80,40,8:'for px-8
100 'WORLD TIME. Ver. G1.0 Tandy Model 100 (also Px-8, see docum.)
105 GOSUB 16000:CLS
110 '(C) COPYRIGHT 1985 ROBERT HOARE (CIS 74116,537) (Source BCX713)
112 'This program may be freely copied, but must NOT be sold!!
210 E1$="Unknown - enter another in same zone"
211 E2$="       <0>  for previous screen"
212 E3$="       <9>  to EXIT program"
220 CLS:PRINT"               WORLD TIME":PRINT
235 PRINT:PRINT"Enter: <12> for 12 hour clock"
236 PRINT"       <24> for 24 hour clock":PRINT E3$:PRINT
270 GOSUB 6000:IF A$="12" THEN CL=12 ELSE CL=24
300 CLS:PRINT"You have chosen the ";CL;" hour clock"
310 PRINT:PRINT E2$:PRINT E3$:PRINT
330 PRINT"Which city is the computer clock set to?":PRINT:GOSUB 6000
340 IF A$="0" THEN 220
350 IF A$="" THEN A$="NEW YORK"
360 GOSUB 8000
370 IF Y$="yes" THEN N$=F$:DN$=D$:D0=D:GOTO 400
380 PRINT E1$:GOTO 310
400 CLS:PRINT"Computer clock is set to ";N$
410 PRINT:PRINT E2$:PRINT E3$:PRINT"       <CR> ";N$:PRINT
430 PRINT"Which city are you in now?":GOSUB 6000
440 IF A$="0" THEN 300
450 IF A$="" THEN A$=N$:Y$="yes":GOTO 470
460 GOSUB 8000
470 IF Y$="yes"THEN T$=F$:DT$=D$:D1=D:GOTO 500
480 PRINT E1$:GOTO 410
500 CLS:PRINT"You are in ";T$
510 PRINT:PRINT E2$:PRINT E3$:PRINT
530 PRINT"Which city's time do you want?":PRINT:GOSUB 6000
540 IF A$="0" THEN 400
550 IF A$="" THEN A$="LONDON"
560 GOSUB 8000
570 IF Y$="yes" THEN DF$=D$:D3=D:GOTO 1200
580 PRINT E1$:GOTO 510
1200 'get time hh:mm:ss date mm/dd/yy and day (0-6).
1260 A$=DATE$:C0=VAL(LEFT$(A$,2)+MID$(A$,4,2))
1270 A$=TIME$:T0=(VAL(LEFT$(A$,2))+(VAL(MID$(A$,4,2))/60))
1280 'Y0=DAY:'for px-8
1300 y0=(instr("  SunMonTueWedThuFriSat",day$)\3)-1:'for M100
1400 Y8=Y0:D8=0-D0:T8=T0:Y$=DN$
1410 GOSUB 7500:NI$=Y$:IF Y$="*" THEN D8=D8-1
1430 GOSUB 7000:Y2=Y9:T2=T9
1500 Y8=Y2:D8=D1:T8=T2:Y$=DT$
1510 GOSUB 7500:TI$=Y$:IF Y$="*" THEN D8=D8+1
1530 GOSUB 7000:Y1=Y9:T1=T9
1600 Y8=Y2:D8=D3:T8=T2:Y$=DF$
1610 GOSUB 7500:FI$=Y$:IF Y$="*" THEN D8=D8+1
1630 GOSUB 7000:Y3=Y9:T3=T9
1750 Y8=Y0:GOSUB 8200:ND$=ED$
1760 Y8=Y1:GOSUB 8200:TD$=ED$
1761 Y8=Y3:GOSUB 8200:FD$=ED$
2000 CLS:'Display results
2500 T8=T0:GOSUB 5000:PRINT NI$;Q$;ND$;" in ";N$;:PRINT
2510 T8=T1:GOSUB 5000:PRINT TI$;Q$;TD$;" in ";T$;:PRINT
2520 T8=T3:GOSUB 5000:PRINT FI$;Q$;FD$;" in ";F$;:PRINT
2550 PRINT STRING$(40,"-")
2619 IF NI$="*" OR TI$="*" OR FI$="*" THEN PRINT "*  DST in effect    ";
2629 IF NI$="?" OR TI$="?" OR FI$="?" THEN PRINT "?  DST dates unknown";
2630 PRINT:PRINT"<0>  new city   <9> to EXIT program"
2640 PRINT"<CR> new time   <CHANGE> computer clock"
2660 GOSUB 6000:IF A$="0" THEN 500
2670 IF A$="CHANGE" THEN 3000 ELSE 1200
3000 CLS:'alter time and date
3010 PRINT:PRINT"In next release of program":PRINT
3030 PRINT:PRINT"<CR> to continue":PRINT:PRINT:GOSUB 6000
3040 GOTO 1200
5000 'format hours
5010 IF CL=24 THEN Z$="0":GOTO 5050
5020 Z$=" ":IF NOT T8 < 12 THEN PM$="pm" ELSE PM$="am"
5030 IF NOT T8 < 13 THEN T8=T8-12
5040 IF T8 < 1 THEN T8=T8+12
5050 M$=STR$(INT(60*(T8-INT(T8)))):H$=STR$(INT(T8))
5060 M$=RIGHT$(M$,LEN(M$)-1):H$=RIGHT$(H$,LEN(H$)-1)
5070 Q$="  "+STRING$(2-LEN(H$),Z$)+H$+":"+STRING$(2-LEN(M$),"0")+M$+PM$+"  ":RETURN
6000 'accept input
6010 LINE INPUT "===> ";A$:IF A$="9" THEN 9000 ELSE RETURN
7000 'time calc
7100 Y9=Y8:T9=T8+D8
7120 IF T9>23.99 THEN Y9=Y9+1:T9=T9-24:GOTO 7210
7130 IF T9<0 THEN Y9=Y9-1:T9=T9+24
7200 IF Y9<0 THEN Y9=Y9+7:RETURN
7210 IF Y9>6 THEN Y9=Y9-7
7499 RETURN
7500 'check DST
7510 IF Y$=" " OR Y$="?" THEN RETURN
7530 C8=VAL(LEFT$(Y$,4)):C9=VAL(MID$(Y$,6,4)):Y$=" "
7540 IF C8>C9 THEN 7600
7550 IF C0>C8 AND C0<C9 THEN Y$="*":RETURN
7570 RETURN
7600 IF C0<C9 OR C0>C8 THEN Y$="*"
7700 RETURN
8000 'City in table?
8050 CLS:RESTORE:J=1
8055 IF J=N GOTO 8190
8060 READ F$,D,D$:I=1
8070 Z$=MID$(A$,I,1)
8071 Z=ASC(Z$):IF Z>96 AND Z<123 THEN Z=Z-32:Z$=CHR$(Z)
8080 IF NOT Z$=MID$(F$,I,1) THEN J=J+1:GOTO 8055
8090 IF NOT I=LEN(A$) THEN I=I+1:GOTO 8070
8100 LET Y$="yes":RETURN
8190 LET Y$="":RETURN
8200 'day to char
8210 ON Y8+1 GOTO 8220,8221,8222,8223,8224,8225,8226
8220 ED$="Sun":RETURN
8221 ED$="Mon":RETURN
8222 ED$="Tue":RETURN
8223 ED$="Wed":RETURN
8224 ED$="Thu":RETURN
8225 ED$="Fri":RETURN
8226 ED$="Sat":RETURN
9000 END:'city data follows
10000 DATA"AUCKLAND",+12,"1027-0428"
10200 DATA"CAIRO",+2,"?"
10400 DATA"CARACAS",-4,"?"
10600 DATA"DALLAS",-6,"0428-1027"
10800 DATA"DENVER",-7,"0428-1027"
11000 DATA"LONDON",0,"0331-1027"
11200 DATA"LOS ANGELES",-8,"0428-1028"
11400 DATA"NEW YORK",-5,"0428-1028"
11600 DATA"PARIS",+1,"0428-1028"
11800 DATA"RIO DE JANEIRO",-3,"?"
12000 DATA"ST. JOHN'S NFLD",-3.5,"0428-1028"
12200 DATA"NUKUALOFA, TONGA",+13," "
12400 DATA"HONOLULU",-10," "
12600 DATA"ANCHORAGE",-9,"0428-1028"
12800 DATA"PHOENIX",-7," "
13000 DATA"HONG KONG",+8,"?"
13200 DATA"SINGAPORE",+7.5," "
13400 DATA"TOKYO",+9,"?"
13600 DATA"PEKING",+8,"?"
13800 DATA"MOSCOW",+3,"0428-1028"
14000 DATA"SYDNEY",+10,"1027-0428"
14200 DATA"BAHRAIN",+3," "
14400 DATA"DELHI",+5.5," "
14600 DATA"ATHENS",+2,"0428-1028"
16000 LET N=24:'count of cities
16010 RETURN
