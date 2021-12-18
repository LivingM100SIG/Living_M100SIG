5 REM 
6 KEY OFF
80 PRINT CHR$(12)
100 PRINT"Mutuels Calculator"
102 PRINT : PRINT"     Need instructions? (Y/N)";
103 A$=INKEY$ : IF A$="" THEN 103
104 IF A$="y" OR A$="Y" THEN 5000
105 PRINT CHR$(12)
110 PRINT:PRINT"Enter pool totals:"
120 INPUT"          Win Pool:$";WP
130 INPUT"        Place Pool:$";PP
140 INPUT"         Show Pool:$";SP
141 CLS
150 PRINT:PRINT"Pool Totals:              Takeout:        Net Pool:"
160 PRINT"     Win Pool: $";WP,(WP*.17),(WP-(WP*.17))
170 PRINT"   Place Pool: $";PP,(PP*.17),(PP-(PP*.17))
180 PRINT"    Show Pool: $";SP,(SP*.17),(SP-(SP*.17))
190 TK=(WP*.17)+(PP*.17)+(SP*.17)
195 PRINT"Total Takeout(17%)          $";TK
196 PRINT"Track's Share        (7.75%)$";(WP+PP+SP)*.0775
197 PRINT"Availiable for Purses(7.0%) $";(WP+PP+SP)*.07
198 PRINT"Parimutuel Tax       (2.0%) $";(WP+PP+SP)*.02
199 PRINT"Breeders' Fund       (0.25%)$";(WP+PP+SP)*.0025
200 PRINT:PRINT"     <<< Hit Any Key >>>";
202 A$ = INKEY$
204 IF A$="" THEN 202
205 CLS
290 PRINT
300 PRINT"Calculate Payoffs:"
305 PRINT"Enter amount in each pool for top three horses:"
310 PRINT:INPUT"For WINNER:     WIN POOL: $";W1
315 INPUT"              PLACE POOL: $";P1
320 INPUT"               SHOW POOL: $";S1
325 PRINT
330 INPUT"For 2nd:      PLACE POOL: $";P2
335 INPUT"               SHOW POOL: $";S2
337 PRINT
340 INPUT"For 3rd:       SHOW POOL: $";S3
350 M1=(((WP-(WP*.17))-W1)/W1) : M1=(INT(M1*100))/100
355 M2=((PP-(PP*.17))-(P1+P2))/2
360 M3=M2/P1 : M3=(INT(M3*100))/100
365 M4=M2/P2 : M4=(INT(M4*100))/100
370 M5=((SP-(SP*.17))-(S1+S2+S3))/3
375 M6=M5/S1 : M6=(INT(M6*100))/100
380 M7=M5/S2 : M7=(INT(M7*100))/100
385 M8=M5/S3 : M8=(INT(M8*100))/100
386 PRINT CHR$(12)
390 PRINT:PRINT"True Prices:"
391 SP$="               "
392 M1$=LEFT$(STR$((M1*2)+2) + SP$,10)
393 M2$=LEFT$(STR$((M2*2)+2) + SP$,10)
394 M3$=LEFT$(STR$((M3*2)+2) + SP$,10)
395 M4$=LEFT$(STR$((M4*2)+2) + SP$,10)
396 M5$=LEFT$(STR$((M5*2)+2) + SP$,10)
397 M6$=LEFT$(STR$((M6*2)+2) + SP$,10)
398 M7$=LEFT$(STR$((M7*2)+2) + SP$,10)
399 M8$=LEFT$(STR$((M8*2)+2) + SP$,10)
510 PRINT
520 PRINT"WINNER:   ";M1$;M3$;M6$
522 PRINT"PLACE:              ";M4$;M7$
524 PRINT"SHOW:                         ";M8$
530 PRINT:PRINT"ACTUAL PRICES:"
531 PRINT
532 A1=(INT((VAL(M1$)*5))/5): B1$=LEFT$(STR$((VAL(M1$)-A1)) + SP$,10)
533 IF A1<2.1 THEN A1=2.1
536 A3=(INT((VAL(M3$)*5))/5): B3$=LEFT$(STR$((VAL(M3$)-A3)) + SP$,10)
537 IF A3<2.1 THEN A3=2.1
538 A4=(INT((VAL(M4$)*5))/5): B4$=LEFT$(STR$((VAL(M4$)-A4)) + SP$,10)
539 IF A4<2.1 THEN A4=2.1
542 A6=(INT((VAL(M6$)*5))/5): B6$=LEFT$(STR$((VAL(M6$)-A6)) + SP$,10)
543 IF A6<2.1 THEN A6=2.1
544 A7=(INT((VAL(M7$)*5))/5): B7$=LEFT$(STR$((VAL(M7$)-A7)) + SP$,10)
545 IF A7<2.1 THEN A7=2.1
546 A8=(INT((VAL(M8$)*5))/5): B8$=LEFT$(STR$((VAL(M8$)-A8)) + SP$,10)
547 IF A8<2.1 THEN A8=2.1
548 BR=VAL(B1$)+VAL(B3$)+VAL(B4$)+VAL(B6$)+VAL(B7$)+VAL(B8$)
550 A1$=LEFT$(STR$(A1) + SP$,10)                          
552 A3$=LEFT$(STR$(A3)+SP$,10)
553 A4$=LEFT$(STR$(A4) +SP$,10)
554 A6$=LEFT$(STR$(A6) +SP$,10)
556 A7$=LEFT$(STR$(A7) +SP$,10)
557 A8$=LEFT$(STR$(A8) +SP$,10)
600 PRINT"WINNER:   ";A1$;A3$;A6$
605 PRINT"PLACE:              ";A4$;A7$
610 PRINT"SHOW:                         ";A8$
615 PRINT
650 BK=(VAL(M1$)-VAL(A1$))*(W1/2)
655 BK=BK+(VAL(M3$)-VAL(A3$))*(P1/2)
660 BK=BK+(VAL(M6$)-VAL(A6$))*(S1/2)
665 BK=BK+(VAL(M4$)-VAL(A4$))*(P2/2)
670 BK=BK+(VAL(M7$)-VAL(A7$))*(S2/2)
675 BK=BK+(VAL(M8$)-VAL(A8$))*(S3/2)
690 PRINT"Braakage:  $";BK,(INT((BK/(WP+PP+SP))*1000)/1000)"%";
700 A$=INKEY$ : IF A$="" THEN 700
710 GOTO 5
5000 PRINT CHR$(12)"--< Mutuels Calculator >--"
5005 PRINT"--< By David L. Smith  >--"
5010 PRINT
5015 PRINT"   This program computes the win-place-show payoffs in a"
5020 PRINT"parimutuel wagering system such as that at most American"
5025 PRINT"race tracks.  You will need to enter the totals from the"
5030 PRINT"infield 'tote board' at the track and the program will show"
5035 PRINT"you how much the track deducts for its profit, how much goes"
5040 PRINT"to the government, etc.  Then the program will give"
5045 PRINT"the actual payoffs corresponding to the data entered and "
5050 PRINT"total 'breakage', the money the racetrack makes by rounding"
5055 PRINT"off the nickels, dimes and pennies."
5056 PRINT : PRINT"<< Hit Any Key >>";
5057 A$=INKEY$ : IF A$="" THEN 5057
5060 PRINT CHR$(12) : PRINT"For test runs use this data:"
5065 PRINT
5070 PRINT"Win Pool-10000 Place Pool-5000 Show Pool 7500"
5075 PRINT
5080 PRINT"For Winner- to Win- 4000"
5085 PRINT"          to Place- 1500"
5090 PRINT"           to Show- 2500"
5095 PRINT"For 2nd-  to Place- 250"
5100 PRINT"           to Show- 450"
5105 PRINT"For 3rd-   to Show- 1400"
5110 PRINT:PRINT"<< Hit Any Key >>";
5115 A$=INKEY$ : IF A$="" THEN 5115
5120 CLS
5121 PRINT"You should get these results (Actual Prices):"
5122 PRINT
5123 PRINT"    Winner -   $ 4.00  $ 3.60  $ 2.40"
5124 PRINT"    Place  -           $11.60  $ 4.60"
5125 PRINT"    Show   -                   $ 2.80"
5126 PRINT
5127 PRINT"If you have any questions leave E-mail to 72767,3346"
5128 PRINT:PRINT"Tandy and other Portable users will find they can find great prices in the":PRINT"place and show pools by using this program at the track!"
5130 PRINT:PRINT"<< Hit Any Key >>";
5132 A$=INKEY$: IF A$="" THEN 5132
5180 CLEAR: GOTO 5
5190 REM
                                                                     