1 CLS:CLEAR2000:MAXFILES=2:DEFINTA-L:DEFSTRM-Z:FILES:O=CHR$(27)+CHR$(69)
2 P=SPACE$(4):Y=CHR$(32)
3 Q=CHR$(27)+CHR$(74):C=0:D=1:E=1
4 GOSUB10:INPUT".DO file to print  ";N:IFN=""THENMAXFILES=1:MENU
5 GOSUB10:INPUT"Enter page title";R:CLS:PRINT@120,"Don't ask me now Chief, I'm busy!!"
6 GOSUB10:M="Y"
7 GOSUB10:L=8:A=86:IFL=0THENL=1:REM L is left margin & A is line length
8 S=SPACE$(L-1):GOSUB10:B=1
9 OPENNFORINPUTAS1:W="LPT:":OPENWFOROUTPUTAS2:GOTO11
10 PRINT@205,Q:PRINT@205,"";:RETURN
11 IFR=""THENT=S+TIME$+P+DATE$:GOTO14
12 T=SPACE$(A-20)+TIME$+P+DATE$
13 MID$(T,L,(LEN(R)))=R
14 IFM="Y"ORM="y"THENU=S:GOSUB35
15 U=S
16 IFC>=55THENGOTO32: C is # of printed lines including header
17 FORJ=LEN(U)TOA
18 U=U+INPUT$(1,1)
19 IFEOF(1)THENCLOSE1:E=2:GOTO27
20 IFRIGHT$(U,1)=CHR$(10)THEN26
21 IFRIGHT$(U,1)=CHR$(128)THENU=LEFT$(U,J-1):GOTO32
22 NEXT
23 IFMID$(U,J,1)=YTHEN25
24 J=J-1:GOTO23
25 V=MID$(U,J+1,A):U=MID$(U,1,J):GOTO27
26 U=LEFT$(U,LEN(U)-2)
27 IFMID$(U,L,3)="   "THEN29
28 IFMID$(U,L,1)=YTHENU=MID$(U,2,LEN(U)):GOTO28
29 PRINT#2,U:C=C+1:IFE=2THEN32
30 IFB=2THENPRINT#2,Y:C=C+1
31 U=S+V:V="":GOTO16
32 PRINT#2,CHR$(12);:D=D+1
33 IFE=2THEN1
35 PRINT#2,O:PRINT#2,T:PRINT#2,S"Page "D
36 PRINT#2,Y:C=4:GOTO17
40 REM Strange place for comments.
41 REM Byte Fyter's version of Ed Juge's PRINTR.100
42 REM Variable "O" sets Prowriter to Elite font; adjust for your printer.
43 REM This is 848 with REM removed.
44 REM Byte Fyter knows how to remove 57 more bytes but Mortimer won't let him.

