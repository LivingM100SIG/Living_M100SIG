0 ' (c) 1983, Howard J. Benner [70235, 1337].
1 ' Submitted 10/23/83 for the personal use of Model 100 SIG members.
2 ' Modified by Byte Fyter 1/29/84
3 GOTO10
4 PRINT@280,"<+><-><*></><%><^><S>q rt<N>ew<M>enu";:RETURN
5 IFO="+"THENC=A+BELSEIFO="-"THEN C=A-BELSEIFO="*"THENC=A*B
6 IFO="/"THENC=A/BELSEIFO="%"THEN O="% of":C=A*B/100
7 IFO="^" THEN C=A^BELSEIFO="S"THENC=SQR(A)
8 RETURN
10 CLS:DEFSTRO:ONERRORGOTO200:PRINT@83,"Seven-function calculator program"
12 PRINT:PRINT" This calculator uses <Enter>, not <=>          to perform calculations.
20 PRINT@280,"Enter any key; <D> for double precision";
30 O=INKEY$:IFO=""THEN30ELSEIFO<>"D"ANDO<>"d"THENDEFSNGA-C
100 PRINTCHR$(27)"q":CLS:PRINT@41," ";:INPUT"First number: ";A:GOSUB4
107 FORX=1TO39:PRINT@239+X,CHR$(153);:NEXT:PRINT@317,CHR$(27)"p"CHR$(147);CHR$(148);:O=INKEY$
108 IFO=""THENFORX=1TO100:NEXT: PRINT@317,CHR$(148);CHR$(147);:GOTO107
109 IFO="N"ORO="n"THENCLS:GOTO100 ELSE IFO="M"ORO="m"THENMENU
110 IFO="="THENO="+"ELSEIFO="_" THENO="-"ELSEIFO="?"THENO="/"
111 IFO="x"ORO="8"ORO="X"THEN O="*"ELSEIFO="6"THENO="^"
112 IFO="5"THENO="%"ELSEIFO="S" ORO="s"THENO="S":GOTO125
115 IFO<>"+"ANDO<>"-"ANDO<>"*" ANDO<>"%"ANDO<>"^"ANDO<>"/"THEN BEEP:GOTO107
116 PRINT@122," ";O;" ";:INPUT"Next number: ";B:GOSUB5:PRINTCHR$(27)"q"
125 CLS:IFO="S"THENGOSUB5:PRINTCHR$(27)"q":PRINT@40,"The sq root of";A;"=";C:GOTO140
126 PRINT@41,A;O;B;"=";C
140 A=C:O="":GOSUB4:GOTO107
200 PRINT:BEEP:PRINT"error#";ERR; "...reenter function and number";: O="":RESUME107

