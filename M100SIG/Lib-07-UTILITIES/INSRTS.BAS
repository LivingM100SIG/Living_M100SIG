0 'INSRTS, prints label inserts for hanging folders, (C) Copyright 1991 by Henry Glover, 72256,2564
1 CLS:PRINT@41,"Select label size:":PRINT@167,"1"SPACE$(12)"2"SPACE$(12)"3":LINE(7,27)-(78,44),1,B:LINE(87,25)-(158,47),1,B:LINE(167,25)-(232,47),1,B
2 S=VAL(INKEY$):IFS<1ORS>3THEN2
3 CLS:Y=81:Z=1:IFX>1THENPRINT"new label or hit <ENTER> to exit program"ELSEPRINT"turn printer on"
4 IFS=3THENX=19ELSEX=21
5 PRINT@Y,"line"Z"to read: ";:Y=121:A$="":PRINTSTRING$(X,239);STRING$(X,8);
6 Q$=INPUT$(1):IFQ$=CHR$(13)THENPRINTSPACE$(X-LEN(A$)):IFZ=2THEN12ELSE11
7 IFLEN(A$)=0ANDQ$=CHR$(8)THENBEEP:GOTO6
8 IFQ$=CHR$(8)THENPRINTQ$;CHR$(239);Q$;:A$=LEFT$(A$,LEN(A$)-1):GOTO6
9 IFLEN(A$)=>XTHENBEEP:GOTO6
10 PRINTQ$;:A$=A$+Q$:GOTO6
11 IFA$=""THEN14ELSEB$=A$:Z=2:PRINT@0,"hit <ENTER> to skip line 2"+SPACE$(14):GOTO5
12 K$=STRING$((X-LEN(B$))/2," "):IFZ=0THENB$=K$+B$ELSEC$=K$+B$:B$=A$:Z=0:GOTO12
13 GOSUB15:GOSUB16:GOSUB16:C$="":IFS>1THENGOSUB16:GOTO3ELSE3
14 GOSUB15:MENU
15 LPRINTCHR$(124)+STRING$(X,45)+CHR$(124):RETURN
16 LPRINTCHR$(124)+C$+SPACE$(X-LEN(C$))+CHR$(124):C$=B$:RETURN
17 'Size of different brands of plastic tabs may vary slightly. This program gives you a choice of 3 label sizes to accomodate these differences.
18 'A trial run will tell you which size label you need - snip out the label along the cut-out lines and try slipping it into your plastic tab - select that size which gives the snuggest fit.
19 'Thanks to Tony Anderson for his key input routine in lines 5-10!
