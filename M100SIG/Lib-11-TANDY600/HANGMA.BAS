1 REM WRITTEN BY WARREN MONTAGUE 8-1-92 VERSION 1.0
2 REM   1723 GRANT AVE.   REDONDO BEACH, CA. 90278
3 REM WORDS CAN BE ADDED IN DATA STATEMENT LINE 6000
5 XOFF = 120: YOFF = 102: CLS : REM XOFF STARTS AT 120 YOFF AT 102
10 KEY OFF: DIM GS(36)
20 READ WR$: IF WR$ <> "EOF" THEN WCNT = WCNT + 1: GOTO 20: REM SIZE OF WORD TABLE
30 WD$ = "": GOSUB 1900: REM GET A WORD
50 GOSUB 4000: GOSUB 5000
60 GOSUB 1000: REM SET UP A WORD
65 GOSUB 9000: GOSUB 9050
70 GOSUB 1100: LOCATE 15, 60: REM GUESS A LETTER
75 IF GLEN = WL THEN PRINT "YOU WIN!!!!!!": INPUT "DO YOU WANT TO PLAY AGAIN"; GS$: IF GS$ = "y" OR GS$ = "Y" THEN RUN ELSE STOP
80 GOTO 65
199 STOP
200 REM CIRLCE ROUTINE S=CIRCUMFIRENCE
210 FOR A = -S TO S
220 B = INT(SQR(S * S - A * A))
230 PSET (XREL + B, A + YREL)
240 PSET (XREL + A, YREL + B)
250 PSET (XREL - B, A + YREL)
260 PSET (XREL + A, YREL - B)
270 NEXT: RETURN
1000 REM SET UP A WORD
1010 WL = LEN(WD$)
1020 LOCATE 15, 30: PRINT "                                              ";
1030 FOR X = 1 TO WL * 2 STEP 2: LOCATE 15, 30 + X: PRINT CHR$(196); : NEXT X
1040 RETURN
1100 REM GUESS A LETTER
1110 FOR X = 1 TO WL
1120 IF GS$ = MID$(WD$, X, 1) AND GS(ASC(GS$) - 96) = 0 THEN LOCATE 15, 29 + X * 2: PRINT GS$; : F = 1: GLEN = GLEN + 1
1140 NEXT X
1145 IF F = 1 THEN GS(ASC(GS$) - 96) = 1
1150 IF F = 1 THEN F = 0: RETURN
1160 GS = ASC(GS$) - 96: IF GS < 1 THEN RETURN
1165 IF GS(GS) = 0 THEN GLIM = GLIM + 1: IF GLIM < 7 THEN GOSUB 5300: XOFF = XOFF + 13: YOFF = YOFF - 7: GOSUB 5000:  ELSE GOSUB 7000
1170 IF GS(GS) = 1 THEN LOCATE 16, 1: PRINT "YOU HAVE ALREADY PICKED THAT LETTER!"; : FOR X = 1 TO 500: NEXT X: LOCATE 16, 1: PRINT SPC(77); : RETURN
1180 GS(GS) = 1: LOCATE 1, 1 + ICNT: PRINT GS$; : ICNT = ICNT + 1: RETURN
1900 REM GET A WORD
1910 LOCATE 16, 1: PRINT SPC(70); : LOCATE 16, 1
1920 PRINT "Do you want "; : COLOR 1: PRINT "R"; : COLOR : PRINT "andom words or "; : COLOR 1: PRINT "Y"; : COLOR : PRINT "our own words?";
1930 GOSUB 9000: IF GS$ <> "R" AND GS$ <> "r" AND GS$ <> "Y" AND GS$ <> "y" THEN 1910
1940 IF GS$ = "Y" OR GS$ = "y" THEN LOCATE 16, 1: PRINT SPC(70); : LOCATE 16, 1: PRINT "ENTER a word less than 16 charaters long"; : GOSUB 9100: LOCATE 16, 1: PRINT SPC(70); : RETURN
1945 LOCATE 16, 1: PRINT SPC(77);
1950 RANDOMIZE (VAL(RIGHT$(TIME$, 2)))
1960 R = INT(RND * 1000)
1970 IF R > WCNT THEN 1960
1980 RESTORE
1990 FOR X = 1 TO R: READ WD$: NEXT X: RETURN
2000 STOP
4000 REM DRAW GALLOWS
4010 LINE (100, 104)-(400, 104): LINE (130, 103)-(131, 97), 1, BF
4020 FOR X = 0 TO 4
4030 LINE (130 + (X * 13), 97 - (X * 7))-(143 + (X * 13), 98 - (X * 7)), 1, BF
4040 LINE (143 + (X * 13), 98 - (X * 7))-(144 + (X * 13), 91 - (X * 7)), 1, BF
4050 NEXT X
4060 LINE (195, 103)-(197, 63), 1, BF: LINE (195, 63)-(262, 61), 1, BF: LINE (260, 64)-(262, 103), 1, BF
4070 LINE (250, 62)-(252, 1), 1, BF: LINE (250, 1)-(220, 3), 1, BF
4080 LINE (223, 3)-(224, 10), 1, BF: LINE (222, 11)-(225, 15), 1, BF
4090 RETURN
4999 STOP
5000 REM DRAW RELATIVE MAN
5001 REM X OFFSET IS XOFF  Y OFFSET IS YOFF AT TOP OF PROGRAM
5010 FOR X = 1 TO 34: PSET (XOFF, YOFF - X): NEXT X
5020 PSET (XOFF + 1, YOFF - 35): PSET (XOFF + 1, YOFF - 36): PSET (XOFF + 2, YOFF - 37)
5030 FOR X = 38 TO 40: PSET (XOFF + 3, YOFF - X): NEXT X
5040 PSET (XOFF + 1, YOFF - 41): PSET (XOFF + 2, YOFF - 41)
5050 FOR X = 42 TO 46: PSET (XOFF + 1, YOFF - X): NEXT X: PSET (XOFF + 2, YOFF - 47)
5060 FOR X = 3 TO 10: PSET (XOFF + X, YOFF - 48): NEXT X
5070 PSET (XOFF + 10, YOFF - 47): PSET (XOFF + 10, YOFF - 46): PSET (XOFF + 10, YOFF - 45)
5080 PSET (XOFF + 11, YOFF - 44): PSET (XOFF + 10, YOFF - 43): PSET (XOFF + 9, YOFF - 43)
5090 PSET (XOFF + 8, YOFF - 42): PSET (XOFF + 10, YOFF - 42): PSET (XOFF + 10, YOFF - 41)
5100 PSET (XOFF + 9, YOFF - 40): PSET (XOFF + 8, YOFF - 40): PSET (XOFF + 7, YOFF - 39)
5110 PSET (XOFF + 7, YOFF - 45): PSET (XOFF + 7, YOFF - 38)
5120 PSET (XOFF + 8, YOFF - 37): PSET (XOFF + 9, YOFF - 36): PSET (XOFF + 10, YOFF - 35)
5130 FOR X = 34 TO 26 STEP -1: PSET (XOFF + 10, YOFF - X): NEXT X
5140 LINE (XOFF + 7, YOFF - 34)-(XOFF + 9, YOFF - 26)
5150 LINE (XOFF + 4, YOFF - 34)-(XOFF + 7, YOFF - 24)
5160 LINE (XOFF + 10, YOFF - 25)-(XOFF + 16, YOFF - 22)
5170 LINE (XOFF + 8, YOFF - 23)-(XOFF + 15, YOFF - 21)
5180 FOR X = 1 TO 5: PSET (XOFF + X, YOFF - 26): NEXT X
5190 FOR X = 1 TO 7: PSET (XOFF + X, YOFF): NEXT
5200 PSET (XOFF + 7, YOFF - 1): PSET (XOFF + 6, YOFF - 2): PSET (XOFF + 5, YOFF - 2)
5210 FOR X = 3 TO 18: PSET (XOFF + 4, YOFF - X): NEXT X
5215 IF GLIM > 5 THEN 5600
5220 LINE (XOFF + 5, YOFF - 17)-(XOFF + 14, YOFF - 15)
5230 FOR X = 14 TO 7 STEP -1: PSET (XOFF + 14, YOFF - X): NEXT X
5240 FOR X = 15 TO 20: PSET (XOFF + X, YOFF - 7): NEXT X
5250 PSET (XOFF + 20, YOFF - 7): PSET (XOFF + 20, YOFF - 8): PSET (XOFF + 19, YOFF - 9)
5260 PSET (XOFF + 18, YOFF - 10)
5270 FOR X = 11 TO 17: PSET (XOFF + 18, YOFF - X): NEXT X
5280 LINE (XOFF + 17, YOFF - 18)-(XOFF + 10, YOFF - 21)
5290 RETURN
5300 REM ERRASE RELATIVE MAN
5301 REM X OFFSET IS XOFF  Y OFFSET IS YOFF AT TOP OF PROGRAM
5310 FOR X = 1 TO 34: PRESET (XOFF, YOFF - X): NEXT X
5320 PRESET (XOFF + 1, YOFF - 35): PRESET (XOFF + 1, YOFF - 36): PRESET (XOFF + 2, YOFF - 37)
5330 FOR X = 38 TO 40: PRESET (XOFF + 3, YOFF - X): NEXT X
5340 PRESET (XOFF + 1, YOFF - 41): PRESET (XOFF + 2, YOFF - 41)
5350 FOR X = 42 TO 46: PRESET (XOFF + 1, YOFF - X): NEXT X: PRESET (XOFF + 2, YOFF - 47)
5360 FOR X = 3 TO 10: PRESET (XOFF + X, YOFF - 48): NEXT X
5370 PRESET (XOFF + 10, YOFF - 47): PRESET (XOFF + 10, YOFF - 46): PRESET (XOFF + 10, YOFF - 45)
5380 PRESET (XOFF + 11, YOFF - 44): PRESET (XOFF + 10, YOFF - 43): PRESET (XOFF + 9, YOFF - 43)
5390 PRESET (XOFF + 8, YOFF - 42): PRESET (XOFF + 10, YOFF - 42): PRESET (XOFF + 10, YOFF - 41)
5400 PRESET (XOFF + 9, YOFF - 40): PRESET (XOFF + 8, YOFF - 40): PRESET (XOFF + 7, YOFF - 39)
5410 PRESET (XOFF + 7, YOFF - 45): PRESET (XOFF + 7, YOFF - 38)
5420 PRESET (XOFF + 8, YOFF - 37): PRESET (XOFF + 9, YOFF - 36): PRESET (XOFF + 10, YOFF - 35)
5430 FOR X = 34 TO 26 STEP -1: PRESET (XOFF + 10, YOFF - X): NEXT X
5440 LINE (XOFF + 7, YOFF - 34)-(XOFF + 9, YOFF - 26), 0
5450 LINE (XOFF + 4, YOFF - 34)-(XOFF + 7, YOFF - 24), 0
5460 LINE (XOFF + 10, YOFF - 25)-(XOFF + 16, YOFF - 22), 0
5470 LINE (XOFF + 8, YOFF - 23)-(XOFF + 15, YOFF - 21), 0
5480 FOR X = 1 TO 5: PRESET (XOFF + X, YOFF - 26): NEXT X
5500 PRESET (XOFF + 7, YOFF - 1): PRESET (XOFF + 6, YOFF - 2): PRESET (XOFF + 5, YOFF - 2)
5510 FOR X = 3 TO 18: PRESET (XOFF + 4, YOFF - X): NEXT X
5515 IF GLIM > 6 THEN 5700
5520 LINE (XOFF + 5, YOFF - 17)-(XOFF + 14, YOFF - 15), 0
5530 FOR X = 14 TO 7 STEP -1: PRESET (XOFF + 14, YOFF - X): NEXT X
5540 FOR X = 15 TO 20: PRESET (XOFF + X, YOFF - 7): NEXT X
5550 PRESET (XOFF + 20, YOFF - 7): PRESET (XOFF + 20, YOFF - 8): PRESET (XOFF + 19, YOFF - 9)
5560 PRESET (XOFF + 18, YOFF - 10)
5570 FOR X = 11 TO 17: PRESET (XOFF + 18, YOFF - X): NEXT X
5580 LINE (XOFF + 17, YOFF - 18)-(XOFF + 10, YOFF - 21), 0
5585 LINE (XOFF, YOFF)-(XOFF + 8, YOFF), 0
5590 RETURN
5600 REM DRAW SECOND LEG DOWN
5620 LINE (XOFF + 5, YOFF - 17)-(XOFF + 11, YOFF)
5640 LINE (XOFF + 11, YOFF)-(XOFF + 17, YOFF)
5650 PSET (XOFF + 17, YOFF): PSET (XOFF + 17, YOFF - 1): PSET (XOFF + 16, YOFF - 2)
5660 PSET (XOFF + 15, YOFF - 3)
5670 LINE (XOFF + 14, YOFF - 4)-(XOFF + 10, YOFF - 22)
5690 RETURN
5700 REM ERASE SECOND LEG
5720 LINE (XOFF + 5, YOFF - 17)-(XOFF + 11, YOFF), 0
5740 LINE (XOFF + 11, YOFF)-(XOFF + 17, YOFF), 0
5750 PRESET (XOFF + 17, YOFF): PRESET (XOFF + 17, YOFF - 1): PRESET (XOFF + 16, YOFF - 2)
5760 PRESET (XOFF + 15, YOFF - 3)
5770 LINE (XOFF + 14, YOFF - 4)-(XOFF + 10, YOFF - 22), 0
5790 RETURN
6000 REM WORDS THAT HANGMAN USES ADD FREELY BETWEEN 6000-6998 BUT BE SURE AND            NOT DISTURB 6998 AS PROGRAM USES THAT LINE TO TERMINATE LIST ALSO               USE LOWER CASE ONLY.  THE WORDS DO NOT HAVE TO BE IN ALPHA ORDER.
6010 DATA "aardvark","abdicate","acquiesce","adult","aerate","affluent","agriculture","ahead","ailment","ajar","akin","alleviate","ambient","ancient","aorta","append","aqueduct","asterisk"
6020 DATA "athlete","autumn","average","awaken","balcony","beard",birth","block","borrow","brake","butterfly","cabbage","celebrate","change","civilized","cloud","coffee","crown","clutch","curse","cypress"
6025 DATA "dangerous","dear","dilemma","domestic","driver","during","dynamite","ecstatic","east","edge","effectual","egress","elbow","embargo","enter","epilogue","escape","etiquette","evasion","exciting","eyebrow"
6031 DATA "facility","favorite","ferry","fiber","finite","flamboyant","forecast","frame","friend","furnish","galaxy","gelatin","ginger","glucose","gourmet","granite","grown","guilt","gypsum"
6037 DATA "half","harbor","heavy","hilarious","history","homicide","hangman","horrible","humor","hydrogen","icicle","ideal","illiterate","imaginary","inaugurate","indicate","irony","itself","itinerary"
6040 DATA "jade","jelly","joint","judge","juvenile","keel","kettle","kilowatt","kindergarten","knight","labor","lacquer","lecture","licence","lineage","lounge","luminance","luxury"
6045 DATA "machine","manifold","masterpiece","meadow","method","milk","mixture","modern","molecule","monument","mountain","mushroom","must","mystic"
6100 DATA "narcissism","nausea","necessitate","nerve","night","noodle","nourishment","nut","object","obsolete","occupation","officiate","only","operate","orange","ornament","outrageous","overlook","oyster"
6200 DATA "paddle","parallel","partial","patrol","peace","people","perpetuate","person","phrase","place","poet","possible","precinct","present","program","protection","psychiatrist","punch"
6251 DATA "pyramid","quaint","quarter","quilt","quiz"
6300 DATA "radiance","rapport","reasonable","reference","regular","resume","right","route","rubber","safe"
6400 DATA "salon","sandy","scale","script","sculpture","sensuality","series","sharp","shiny","simulate","skunk","sludge","social","solder","sound","specific","split","squash","stand","statistics","stereo","strategy","subtract"
6410 DATA "sufficient","suggestive","sulphur","superficial","surgeon","swallow","sweater","symbolism","system"
6500 DATA "table","talking","technical","tenure","terrific","there","thought","titanic","tolerant","touch","train","trap","tropical","typical"
6600 DATA "ultmate","umpire","under","universe","upstairs","urgent"
6700 DATA "valentine","valve","vault","vertical","video","voyage"
6710 DATA "waist","warranty","water","weather","weird","while","whose","window","withstand","world","write","xerox","xray","yeast","yield","young","your"
6720 DATA "zebra","zinc","zero","zone","zology"
6998 DATA "EOF"
6999 STOP
7000 REM DRAW HUNG MAN
7001 REM X OFFSET IS XOFF  Y OFFSET IS YOFF AT TOP OF PROGRAM
7005 LINE (50, 9)-(300, 64), 0, BF: XOFF = 196: YOFF = 64: GOSUB 4000: XOFF = XOFF + 23
7010 LINE (XOFF, YOFF - 2)-(XOFF, YOFF - 33), 1
7020 PSET (XOFF + 1, YOFF - 33): PSET (XOFF + 1, YOFF - 34): PSET (XOFF + 2, YOFF - 35)
7030 FOR X = 36 TO 38: PSET (XOFF + 3, YOFF - X): NEXT X
7040 S = 5: XREL = XOFF + 5: YREL = YOFF - 43: GOSUB 200
7050 FOR X = 36 TO 38: PSET (XOFF + 7, YOFF - X): NEXT X
7060 PSET (XOFF + 3, YOFF - 44): PSET (XOFF + 7, YOFF - 44): PSET (XOFF + 5, YOFF - 42)
7070 LINE (XOFF + 3, YOFF - 40)-(XOFF + 7, YOFF - 40)
7080 PSET (XOFF + 8, YOFF - 35): PSET (XOFF + 9, YOFF - 34): PSET (XOFF + 10, YOFF - 33)
7090 LINE (XOFF + 11, YOFF - 33)-(XOFF + 11, YOFF - 2)
7100 LINE (XOFF + 1, YOFF - 18)-(XOFF + 3, YOFF - 19)
7110 LINE (XOFF + 3, YOFF - 20)-(XOFF + 4, YOFF - 28)
7120 LINE (XOFF + 10, YOFF - 18)-(XOFF + 8, YOFF - 19)
7130 LINE (XOFF + 8, YOFF - 20)-(XOFF + 7, YOFF - 28)
7140 LINE (XOFF - 4, YOFF - 3)-(XOFF + 15, YOFF + 2), 0, BF
7150 LINE (XOFF - 6, YOFF - 1)-(XOFF - 4, YOFF + 12), , BF
7160 LINE (XOFF + 5, YOFF - 15)-(XOFF + 4, YOFF)
7170 LINE (XOFF + 5, YOFF - 15)-(XOFF + 6, YOFF)
7180 LINE (XOFF + 3, YOFF)-(XOFF - 1, YOFF)
7190 LINE (XOFF + 7, YOFF)-(XOFF + 13, YOFF)
7200 LINE (XOFF - 1, YOFF - 1)-(XOFF - 1, YOFF - 2)
7210 LINE (XOFF, YOFF - 3)-(XOFF, YOFF - 5)
7220 LINE (XOFF + 13, YOFF - 1)-(XOFF + 12, YOFF - 2)
7230 LINE (XOFF + 11, YOFF - 3)-(XOFF + 11, YOFF - 4)
7240 LOCATE 5, 50: PRINT "YOU LOSE!";
7250 LOCATE 7, 50: PRINT "DO YOU WANT TO PLAY AGAIN? ";
7260 GOSUB 9000: IF GS$ = "Y" OR GS$ = "y" THEN RUN ELSE STOP
7410 PRESET (XOFF + 7, YOFF - 45): PRESET (XOFF + 7, YOFF - 38)
7420 PRESET (XOFF + 8, YOFF - 37): PRESET (XOFF + 9, YOFF - 36): PRESET (XOFF + 10, YOFF - 35)
7430 FOR X = 34 TO 26 STEP -1: PRESET (XOFF + 10, YOFF - X): NEXT X
7440 LINE (XOFF + 7, YOFF - 34)-(XOFF + 9, YOFF - 26), 0
7450 LINE (XOFF + 4, YOFF - 34)-(XOFF + 7, YOFF - 24), 0
7460 LINE (XOFF + 10, YOFF - 25)-(XOFF + 16, YOFF - 22), 0
7470 LINE (XOFF + 8, YOFF - 23)-(XOFF + 15, YOFF - 21), 0
7480 FOR X = 1 TO 5: PRESET (XOFF + X, YOFF - 26): NEXT X
7500 PRESET (XOFF + 7, YOFF - 1): PRESET (XOFF + 6, YOFF - 2): PRESET (XOFF + 5, YOFF - 2)
7510 FOR X = 3 TO 18: PRESET (XOFF + 4, YOFF - X): NEXT X
7520 LINE (XOFF + 5, YOFF - 17)-(XOFF + 14, YOFF - 15), 0
7530 FOR X = 14 TO 7 STEP -1: PRESET (XOFF + 14, YOFF - X): NEXT X
7540 FOR X = 15 TO 20: PRESET (XOFF + X, YOFF - 7): NEXT X
7550 PRESET (XOFF + 20, YOFF - 7): PRESET (XOFF + 20, YOFF - 8): PRESET (XOFF + 19, YOFF - 9)
7560 PRESET (XOFF + 18, YOFF - 10)
7570 FOR X = 11 TO 17: PRESET (XOFF + 18, YOFF - X): NEXT X
7580 LINE (XOFF + 17, YOFF - 18)-(XOFF + 10, YOFF - 21), 0
7585 LINE (XOFF, YOFF)-(XOFF + 8, YOFF), 0
7590 RETURN
9000 REM INKEY$
9010 GS$ = INKEY$: IF GS$ = "" THEN 9010 ELSE RETURN
9050 REM MAKE LOWER CASE
9060 IF ASC(GS$) < 91 THEN GS$ = CHR$(ASC(GS$) + 32)
9070 RETURN
9100 REM INKEY$ ACCUMULATOR
9110 GOSUB 9000
9120 A = ASC(GS$): AL = LEN(GS$)
9130 WL = LEN(WD$)
9135 IF WL > 0 AND A = 13 THEN LOCATE 16, 1: PRINT SPC(77); : RETURN
9140 IF A = 8 AND WL > 0 THEN WD$ = LEFT$(WD$, WL - 1): LOCATE 16, 43: PRINT WD$; "  "; : LOCATE 16, 43 - GL - 1: GOTO 9110
9150 IF A < 97 THEN A = A + 32
9160 IF A < 97 OR A > 122 THEN GOTO 9110
9170 WD$ = WD$ + CHR$(A): LOCATE 16, 43: PRINT WD$; : GOTO 9110

