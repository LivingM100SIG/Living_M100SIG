v_{s}~v{[_1 CLS:PRINT:PRINT"THIS PROGRAM IS A COLLECTION OF VARIOUS":PRINT"SIMPLE STATISTICAL CALCULATIONS, PLUS A"
2 PRINT"PROGRAM TO HELP YOU SELECT THE CORRECT":PRINT"STATISTICAL METHOD, GIVEN THE TYPE OF"
3PRINT" DATA AND STUDY YOU ARE DOING.":FORT=1TO1800:NEXTT
4CLS:PRINT@80,"  ## THIS PROGRAM FOR THE EXPRESS USE":PRINT"  OF MEMBERS OF THE MODEL 100 SIG."
5PRINT"  ALL RIGHTS RESERVED.":PRINT"     BY RICK DAVIDSON  ##":PRINT"     71646,1276";
6 FORY=1TO1800:NEXTY
7 CLEAR:CLS
8 PRINT"PLEASE SELECT ONE:"
10 PRINT"<A> CHOICE OF STATISTICAL METHODS"
15 PRINT"<B> CHI SQUARE,2X2 TABLE(WITH P VALUES)"
20 PRINT"<C> CHI SQUARE, LARGER TABLE"
25 PRINT"<D> STANDARD DEVIATION"
30 PRINT"<E> ONE-SAMPLE T-TEST"
40 PRINT"<F> MULTIPLE REGRESSION"
45 PRINT"<G> MENU";
50 LETA$=INKEY$
55 IFA$=""THEN50
60 IFA$="A"ORA$="a"THEN1000
65 IFA$="B"ORA$="b"THEN500
70 IFA$="C"ORA$="c"THEN4000
75 IFA$="D"ORA$="d"THEN2000
80 IFA$="E"ORA$="e"THEN5000
82 IFA$="F"ORA$="f"THEN3000
85 IFA$="G"ORA$="g"THENMENU
90 GOTO6
500 CLS:PRINT:PRINT"      CHI SQUARE PROGRAM FOR"
505 PRINT "        TWO-BY-TWO TABLE"
506 PRINT:PRINT" THIS PROGRAM WILL GIVE YOU REGULAR":PRINT"AND YATE'S CORRECTED CHI SQUARE VALUES,"
507 PRINT"          PLUS P VALUES.":PRINT"       HIT ANY KEY TO BEGIN";
508 C$=INKEY$:IFC$=""THEN508
510 CLS:PRINT:INPUT"INPUT ROW 1 COL 1 ";A
515 INPUT"INPUT ROW 1 COL 2 ";B
520 INPUT"INPUT ROW 2 COL 1 ";C
525 INPUT"INPUT ROW 2 COL 2 ";D
530 LETX=((A*D)-(B*C))^2
535 LETY=A+B+C+D
540 LETZ=(A+B)*(C+D)*(B+D)*(A+C)
545 CHI=(X*Y)/Z
550 CHI=CHI+.0005
555 CHI=INT(CHI*1000)/1000
560 CLS:PRINT:PRINT
565 PRINT,"CHI SQUARE=";CHI
570 L=((A*D)-(B*C))^2
575 V=SQR(L)
580 W=(V-(A+B+C+D)/2)^2
585 Q=W*Y/Z
590 Q=Q+.0005:Q=INT(Q*1000)/1000
595 PRINT"(WITH YATE'S CORRECTION=";Q;")"
600 IFCHI<3.841THENPRINT"P>.O5"
605 IFCHI>3.841ANDCHI<5.024THENPRINT"P IS BETWEEN .05 AND .025"
610 IFCHI>5.024ANDCHI<6.635THENPRINT"P IS BETWEEN .025 AND .01"
615 IFCHI>6.635ANDCHI<7.879THENPRINT"P IS BETWEEN .01 AND .005"
620 IFCHI>7.879ANDCHI<10.82THENPRINT"P IS BETWEEN .005 AND .001"
625 IFCHI>10.828THENPRINT"P IS LESS THAN 0.001"
630 PRINT"HIT <ENTER> TO CONTINUE":PRINT"HIT ANY OTHER KEY FOR MENU";:A$=INPUT$(1):IFA$<>CHR$(13)THEN7
635 CLS:GOTO500
1000 CLS:PRINT""
1005 PRINT"       CHOICE OF STATISTICAL METHODS"
1010 PRINT"       IN HYPOTHESIS TESTING"
1015 PRINT""
1020 PRINT"               BY       ":PRINT"        RICK DAVIDSON,M.D.,MPH   "
1025 FORA=1TO2000:NEXTA:CLS
1030 PRINT"YOUR MEASUREMENTS ARE (SELECT ONE):"
1035 PRINT"<I>NTERVAL(AND NORMALLY DISTRIBUTED)*"
1040 PRINT"<N>OMINAL       <M>MENU"
1045 PRINT"<O>RDINAL":PRINT"* IF THE POPULATION IS NOT NORMALLY"
1047 PRINT"  DISTRIBUTED, RANK THE OBSERVATIONS"
1048 PRINT"  AND USE ORDINAL-SCALE DATA"
1049 A$=INKEY$:IFA$=""THEN1049
1050 IFA$<>"I"ANDA$<>"i"ANDA$<>"N"ANDA$<>"n"ANDA$<>"O"ANDA$<>"o"ANDA$<>"M"ANDA$<>"m"THEN1030
1052 IFA$="M"ORA$="m"THEN7
1055 CLS:PRINT:PRINT:PRINT"    SELECT ONE OF THE FOLLOWING TYPES":PRINT"              OF EXPERIMENTS":FORX=1TO700:NEXTX
1060 CLS:PRINT"<A> 2 TREATMENT GROUPS,DIFFERENT":PRINT"    INDIVIDUALS"
1065 PRINT"<B> >2 TREATMENT GROUPS,DIFFERENT":PRINT"    INDIVIDUALS"
1070 PRINT"<C> BEFORE-AND-AFTER SINGLE TREATMENT,":PRINT"    SAME INDIVIDUAL"
1075 PRINT"<D> MULTIPLE TREATMENTS,SAME INDIVIDUAL"
1080 PRINT"<E> ASSOCIATION BETWEEN TWO VARIABLES";
1082 B$=INKEY$:IFB$=""THEN1082
1085 CLS:IFB$<>"A"ANDB$<>"a"THEN1105
1090 PRINT:PRINT
1091 IFA$<>"I"ANDA$<>"i"THEN1095
1092 PRINT"  YOU SHOULD USE AN UNPAIRED T-TEST IN": PRINT"            YOUR ANALYSIS":FORZ=1TO800:NEXTZ:CLS:GOTO1030
1095 IFA$<>"N"ANDA$<>"n"THEN1100
1096 PRINT"     YOU SHOULD USE A CHI-SQUARE":PRINT"     ANALYSIS OF A CONTINGENCY TABLE":FORI=1TO800:NEXTI:GOTO1030
1100 IFA$<>"O"ANDA$<>"o"THEN1105
1101 PRINT"   YOU SHOULD USE A MANN-WHITNEY":PRINT"    RANK-SUM TEST IN YOUR ANALYSIS"
1102 FORX=1TO800:NEXTX:CLS:GOTO1030
1105 IFB$<>"B"ANDB$<>"b"THEN1125
1110 CLS:PRINT:PRINT:IFA$<>"I"ANDA$<>"i"THEN1115
1111 PRINT"YOU SHOULD USE AN ANALYSIS OF VARIANCE":PRINT"          IN YOUR ANALYSIS"
1112 FORW=1TO600:NEXTW:CLS:GOTO1030
1115 IFA$="N"ORA$="n"THEN1095
1120 IFA$="O"ORA$="o"THENPRINT"   YOU SHOULD USE THE KRUSKAL-WALLIS":PRINT"      STATISTIC IN YOUR ANALYSIS"
1121 FORV=1TO800:NEXTV:CLS:GOTO1030
1125 IFB$<>"C"ANDB$<>"c"THEN1145
1130 PRINT:PRINT:IFA$<>"I"ANDA$<>"i"THEN1135
1131 PRINT"    YOU SHOULD USE A PAIRED T-TEST":PRINT"         IN YOUR ANALYSIS":FORU=1TO800:NEXTU:CLS:GOTO1030
1135 IFA$<>"N"ANDA$<>"n"THEN1140
1136 PRINT"    YOU SHOULD USE McNEMAR'S TEST":PRINT"       IN YOUR ANALYSIS":FORT=1TO800:NEXTT:GOTO1030
1140 IFA$="O"ORA$="o"THENPRINT"YOU SHOULD USE THE WILCOXON SIGNED-RANK       TEST IN YOUR ANALYSIS"
1141 FORS=1TO800:NEXTS:CLS:GOTO1030
1145 IFB$<>"D"ANDB$<>"d"THEN1165
1150 PRINT:PRINT:IFA$<>"I"ANDA$<>"i"THEN1155
1151 PRINT"   YOU SHOULD USE REPEATED-MEASURE":PRINT"        ANALYSIS OF VARIANCE":FORR=1TO800:NEXTR:CLS:GOTO1030
1155 IFA$<>"N"ANDA$<>"n"THEN1160
1156 PRINT"    YOU SHOULD USE THE COCHRANE Q TEST":PRINT"          IN YOUR ANALYSIS":FORQ=1TO800:NEXTQ:CLS:GOTO1030
1160 IFA$<>"O"ANDA$<>"o"THEN1165
1161 PRINT"   YOU SHOULD USE A FRIEDMAN STATISTIC":PRINT"        IN YOUR ANALYSIS":FORP=1TO800:NEXTP:CLS:GOTO1030
1165 IFB$<>"E"ANDB$<>"e"THEN1030
1170 CLS:PRINT:IFA$<>"I"ANDA$<>"i"THEN1175
1171 PRINT"  YOU SHOULD USE LINEAR REGRESSION AND":PRINT"   THE PEARSON PRODUCT MOMENT"
1172 PRINT"    CORRELATION COEFFICIENT":FORO=1TO800:NEXTO:CLS:GOTO1030
1175 IFA$<>"N"ANDA$<>"n"THEN1180
1176 PRINT"YOU SHOULD USE A CONTINGENCY COEFFICIENT      IN YOUR ANALYSIS"
1177 FORN=1TO800:NEXTN:CLS:GOTO1030
1180 IFA$<>"O"ANDA$<>"o"THEN1196
1181 PRINT:PRINT"  YOU SHOULD USE THE SPEARMAN RANK":PRINT"   CORRELATION IN YOUR ANALYSIS":FORM=1TO800:NEXTM:CLS:GOTO1030
1196 PRINT"YOU SHOULD USE A CHI-SQUARE ANALYSIS OF           A CONTINGENCY TABLE":FORY=1TO800:NEXTY:CLS:GOTO1030
2000 CLS:N=0
2005 PRINT:PRINT"THIS PROGRAM CALCULATES STANDARD":PRINT" DEVIATION AND MEAN FOR A SAMPLE."
2010 PRINT"ENTER OBSERVATIONS 1 BY 1.":PRINT"PRESS ENTER AFTER EACH.
2015 PRINT"INPUT 99999 TO END":PRINT
2025 PRINT"OBSERVATION ";N+1;:INPUTA
2030 IFA=99999!THENGOTO2050
2035 N=N+1
2040 S=S+A:S2=S2+A*A
2045 GOTO2025
2050 MEAN=S/N
2055 SDEV=SQR((N*S2-S*S)/(N*(N-1)))
2060 PRINT"MEAN= ";MEAN:PRINT"STANDARD DEVIATION= ";SDEV
2065 PRINT
2070 PRINT"PRESS ANY KEY FOR MENU";:A$=INPUT$(1):GOTO7
3000 CLS
3005 PRINT" MULTIPLE LINEAR REGRESSION PROGRAM ":PRINT
3015 PRINT"THIS PROGRAM USES THE METHOD":PRINT" OF LEAST SQUARES TO FIT A SET OF
3020 PRINT"VALUES TO AN EQUATION OF THE FORM :"
3030 PRINT"Y = A(0) + A(1)*X(1) + A(2)*X(2) + . . . + A(K)*X(K)
3035 FORQ=1TO1800:NEXTQ
3040 CLS:PRINT"Y IS THE INDEPENDENT VARIABLE.":PRINT" THE X(I)'S ARE DEPENDENT."
3045 PRINT"EACH OBSERVATION CONSISTS OF A Y VALUE":PRINT"     AND K X( ) VALUES.
3050 PRINT"THE OUTPUT INCLUDES THE K+1 A( ) VALUES.
3055 PRINT:INPUT"TO BEGIN PRESS ENTER";Z9
3060 PRINT
3065 INPUT"INPUT NUMBER OF INDEPENDENT VARIABLES";NI
3070 PRINT"INPUT THE VALUES OF THE INDEPENDENT":PRINT"  VARIABLES AS DIRECTED ON CRT.
3075 PRINT"THEN INPUT THE VALUE OF THE DEPENDENT":PRINT" VARIABLE FOR THAT OBSERVATION.
3085 PRINT:INPUT"PRESS ENTER TO BEGIN";Z9$
3090 PRINT:I=0
3100PRINT
3105 PRINT"INPUT 99999 FOR Y TO END DATA INPUT."
3110 PRINT,"OBSERVATION ";I+1
3115 INPUT"DEPENDENT VARIABLE Y =";V(NI+2)
3120 IFV(NI+2)=99999!THENGOTO3180
3125 I=I+1
3130 V(1)=1
3135 FORJ=2TONI+1
3140 PRINT"INDEPENDENT VARIABLE ";J-1;" X(";J-1;") =";:INPUTV(J)
3145 NEXTJ
3150 FORJ1=1TONI+1:FORJ2=1TONI+2
3155 A(J1,J2)=A(J1,J2)+V(J1)*V(J2)
3160 NEXTJ2:NEXTJ1
3165 S(NI+2)=S(NI+2)+V(NI+2)*V(NI+2):
3170 S1(NI+2)=S1(NI+2)+V(NI+2)
3175 GOTO3100
3180 FORJ=1TONI+1
3185 FORK=JTONI+1
3190 IFA(K,J)<>0THENGOTO3205
3195 NEXTK
3200 PRINT:PRINT,"NO UNIQUE SOLUTION":GOTO3375
3205 FORL=1TONI+2
3210 A1=A(J,L):A(J,L)=A(K,L):A(K,L)=A1
3215 NEXTL
3220 AV=1/A(J,J)
3225 FORK=1TONI+2:A(J,K)=AV*A(J,K):NEXTK
3230 FORI=1TONI+1
3235 IFI=JTHENGOTO3260
3240 A3=A(I,J)
3245 FORK=1TONI+2
3250 A(I,K)=A(I,K)-A(J,K)*A3
3255 NEXTK
3260 NEXTI
3265 NEXTJ
3270 PRINT
3275 PRINT"REGRESSION COEFFICIENTS FOLLOW "
3280 PRINT
3285 FORK=1TONI+1
3290 PRINT"A(";K-1;") = ";A(K,NI+2)
3295 NEXTK
3300 PRINT:GOTO3310
3305 PRINT
3310 PRINT"DO YOU WANT TO PREDICT Y AT A CERTAIN POINT(Y/N)";
3315 INPUTZ9$
3320 IFZ9$="Y"ORZ9$="N"THENGOTO3335
3325 PRINT"INPUT ERROR. TRY AGAIN. "
3330 FORL=1TO300:NEXTL:GOTO3305
3335 IFZ9$="N"THEN7
3340 FORI=1TONI
3345 PRINT"   VALUE OF X(";I;") ";:INPUTX(I)
3350 NEXTI
3355 X(0)=1
3360 PR=0
3365 FORI=0TONI:PR=PR+X(I)*A(I+1,NI+2):NEXTI
3370 PRINT:PRINT"PREDICTION = ";PR
3375 PRINT"TO CONTINUE, PRESS RETURN; ANY OTHER KEY FOR MENU";:A$=INPUT$(1):IFA$<>CHR$(13)THEN7
3380 PRINT:GOTO3310
4000 CLS:PRINT:PRINT"CONTINGENCY TABLE ANALYSIS PROGRAM":PRINT"FOR TABLES LARGER THAN TWO BY TWO."
4015 INPUT"PRESS ENTER TO BEGIN";Z9
4020 CLS:PRINT:PRINT
4025 INPUT"INPUT NUMBER OF ROWS  ";R
4030 INPUT"INPUT NUMBER OF COLUMNS";C
4035 Z1=R+1:Z2=C+1
4040 DIMA(Z1,Z2),AE(Z1,Z2)
4045 CLS:PRINT
4050 FORI=1TOR
4055 PRINT"ROW ";I
4060 FORJ=1TOC
4065 PRINT"     COLUMN ";J;:INPUTA(I,J)
4070 NEXTJ
4075 NEXTI
4080 FORI=1TOR
4085 FORJ=1TOC
4090 A(I,C+1)=A(I,C+1)+A(I,J)
4095 NEXTJ:NEXTI
4100 FORJ=1TOC
4105 FORI=1TOR
4110 A(R+1,J)=A(R+1,J)+A(I,J)
4115 NEXTI:NEXTJ
4120 FORI=1TOC:T=T+A(R+1,I):NEXTI
4125 FORI=1TOR:FORJ=1TOC
4130 AE(I,J)=A(I,C+1)*A(R+1,J)/T
4135 NEXTJ:NEXTI
4140 FORI=1TOR:FORJ=1TOC
4145 CHI=CHI+(A(I,J)-AE(I,J))^2/AE(I,J)
4150 NEXTJ:NEXTI
4155 PRINT
4160 CHI=CHI+.0005:CHI=INT(CHI*1000)/1000
4165 PRINT,"CHI SQUARE = ";CHI
4170 PRINT"DEGREES OF FREEDOM = ";(C-1)*(R-1)
4175 PRINT"Press <RETURN> key to continue;any other key to menu";
4180 A$=INPUT$(1):IFA$<>CHR$(13)THEN7
4185 CLEAR:CLS:GOTO4020
5000 CLS:PRINT:PRINT"THIS PROGRAM WILL COMPUTE THE T VALUE":PRINT" AND NUMBER OF DEGREES OF FREEDOM"
5005 PRINT" FROM A SAMPLE OF OBSERVATIONS.":PRINT" IT IS A SINGLE SAMPLE T-TEST 
5010 PRINT"AND REQUIRES A HYPOTHESIS OF THE FORM":PRINT"        U= U0":PRINT"WHERE U0 IS A HYPOTHESIZED MEAN.";
5015 FORQ=1TO1800:NEXTQ:CLS
5016 PRINT:PRINT
5020 PRINT"THE T-VALUE MAY BE COMPUTED EITHER FROM A SAMPLE OR FROM THE SAMPLE MEAN,"
5021PRINT" SAMPLE S.D. AND NUMBER OF OBSERVATIONS.":FORR=1TO1800:NEXTR:CLS
5030 PRINT:PRINT"ESSENTIALLY, IF THE T STATISTIC IS REASONABLY CLOSE TO 0 (E.G.  BETWEEN 2 "
5035 PRINT"AND -2 FOR LARGER SAMPLES) THEN THE HYPOTHESIS IS CONFIRMED."
5045 INPUT"PRESS ENTER TO BEGIN";Z9
5050 PRINT
5055 INPUT"MEAN FOR NULL HYPOTHESIS =";M0
5060 PRINT
5065 PRINT"PRESS 1 IF SAMPLE STATISTICS AVAILABLE,":PRINT" THEN PRESS ENTER;
5070 PRINT"OTHERWISE JUST PRESS ENTER.":INPUTZ8
5075 IFZ8=1THENGOTO5145
5080 N=0
5085 PRINT
5090 PRINT"ENTER OBSERVATIONS 1 BY 1.":PRINT"PRESS ENTER AFTER EACH.
5095 PRINT"INPUT 99999 TO END"
5100 PRINT
5105 PRINT"OBSERVATION ";N+1;:INPUTA
5110 IFA=99999!THENGOTO5130
5115 N=N+1
5120 S=S+A:S2=S2+A*A
5125 GOTO5105
5130 MEAN=S/N
5135 SDEV=SQR((N*S2-S*S)/(N*(N-1)))
5140 GOTO5170
5145 PRINT
5150 INPUT"SAMPLE MEAN =";MEAN
5155 INPUT"SAMPLE STANDARD DEVIATION =";SDEV
5160 INPUT"NUMBER OF OBSERVATIONS =";N
5165 GOTO5170
5170 T=(MEAN-M0)/(SDEV/SQR(N))
5175 PRINT:PRINT
5185 PRINT"T - VALUE = ";T
5190 PRINT"DEGREES OF FREEDOM =";N-1
5195 PRINT"PRESS ANY KEY FOR MENU";:A$=INPUT$(1):GOTO7

