1 CLEAR800:MAXFILES=2:DEFINTA-Z:ONERRORGOTO80:DIMFL$(25),FL!(25):ES$=CHR$(27):RV$=ES$+"p":NV$=ES$+"q":CL$=ES$+"K":CF$=ES$+"J":CC$=CHR$(29)+CHR$(28)+CHR$(30)+CHR$(31)+CHR$(13):FORI=1TO3:READCT$(I):NEXTI:DATA"Duplication"
2 DATA"Line Concatenation":DATA"Text Replacement":ONKEYGOSUB14,17,41,43,58,73,76,78:GOSUB82:GOSUB87:IX=1:X$=RV$:GOSUB88
3 CALL23061:KEYON:X$=INKEY$:IFX$=""THEN3ELSECC=INSTR(CC$,X$):IFCC=0THEN3ELSEKEYOFF:X$=NV$:GOSUB88:PRINT@240,CL$;:ONCCGOSUB4,6,8,10,12:X$=RV$:GOSUB88:GOTO3
4 IFIX>1THENIX=IX-1ELSEIX=NF
5 RETURN
6 IFIX<NFTHENIX=IX+1ELSEIX=1
7 RETURN
8 IFIX>4THENIX=IX-4
9 RETURN
10 IF(IX+4)<=NFTHENIX=IX+4
11 RETURN
12 IFRIGHT$(FL$(IX),2)="BA"THENRUNFL$(IX)
13 IFRIGHT$(FL$(IX),2)="DO"THENX$="Menu"+CHR$(13)+FL$(IX)+CHR$(13):GOSUB89:CLS:ENDELSERETURN
14 KEYOFF:CLS:PRINT"File: ";RV$;" ";FL$(IX);NV$;TAB(20);"Location: ";FL!(IX):GOSUB90:PRINT:PRINT"File size: ";LN;"bytes.":IFRIGHT$(FL$(IX),2)<>"DO"THEN16ELSEX=INT(LN/30+.5):L=INT(X/60):X=X-L*60:PRINT
15 PRINT"Time to upload: ";L;"Min.";X;"Sec."
16 X$="to continue.":GOSUB92:GOSUB87:X$=RV$:GOSUB88:RETURN
17 KEYOFF:IFRIGHT$(FL$(IX),2)<>"DO"THEN79ELSEPRINT@240,CL$;"List to <D>isplay or <P>rinter?  < >";:PRINT@240+POS(0)-2,"";
18 X$=INPUT$(1):L=INSTR("DPdp",X$):IFL=0THEN18ELSEIFL>2THENL=L-2:X$=MID$("DP",L,1)
19 PRINTX$;:AD!=FL!(IX):CLS:ONLGOTO20,25
20 GOSUB39:FORI=1TO500:NEXTI:CLS
21 X=PEEK(AD!):AD!=AD!+1
22 IFX=26ORINKEY$=ES$THENPRINT:GOTO40ELSEIFX<33THENPRINTCHR$(X);:GOTO21ELSEX$=""
23 X$=X$+CHR$(X):X=PEEK(AD!):AD!=AD!+1:IFX>32THEN23ELSEI=40-POS(0):IFLEN(X$)>IANDLEN(X$)<40THENPRINT
24 PRINTX$;:GOTO22
25 CLS:P=66:T=3:B=3:L=64:M=8:N=1:PRINT"Page length (lines) [";P;"]";:INPUTP:PRINT"Top margin [";T;"]";:INPUTT:PRINT"Bottom margin [";B;"]";:INPUTB:PRINT"Line length [";L;"]";:INPUTL:PRINT"Left margin [";M;"]";:INPUTM:PRINT"Copies [";N;"]";
26 INPUTN:GOSUB39:GOSUB33
27 X=PEEK(AD!):AD!=AD!+1
28 IFX=26ORINKEY$=ES$THEN36ELSEIFX=13THENGOSUB32:X=PEEK(AD!):AD!=AD!+1:IFX=10THEN27ELSE28
29 IFX<33THENLPRINTCHR$(X);:GOTO27ELSEX$=""
30 X$=X$+CHR$(X):X=PEEK(AD!):AD!=AD!+1:IFX>32THEN30ELSEI=L-LPOS(0)+M:IFLEN(X$)>IANDLEN(X$)<LTHENGOSUB32
31 LPRINTX$;:GOTO28
32 LPRINT:C=C-1:IFC>0THEN35ELSEIFB=0THEN33ELSEFORI=1TOB:LPRINT:NEXTI
33 IFT=0THEN34ELSEFORI=1TOT:LPRINT:NEXTI
34 C=P-T-B
35 LPRINTSPACE$(M);:RETURN
36 C=C+B
37 IFC>0THENLPRINT:C=C-1:GOTO37ELSEIFX<>26THEN38ELSEN=N-1:IFN>0THENGOSUB33:AD!=FL!(IX):GOTO27
38 GOTO40
39 PRINT@280,"Push <ESC> to stop.";:RETURN
40 X$="for menu.":GOSUB92:GOSUB87:X$=RV$:GOSUB88:RETURN
41 KEYOFF:IFRIGHT$(FL$(IX),2)<>"DO"THEN79ELSEOPENFL$(IX)FORAPPENDAS1
42 PRINT#1,STRING$(39,"-"):PRINT#1,DAY$;"  ";DATE$;"  ";TIME$:CLOSE:GOTO13
43 KEYOFF:IFRIGHT$(FL$(IX),2)<>"DO"THEN79ELSECLS:PRINT"Copy ";RV$;" ";FL$(IX);NV$;" to: ";RV$;" ";:X=POS(0)
44 FL$="":LINEINPUTFL$:IFFL$=""THENPRINT@X,"";:GOTO44ELSEFORL=1TOLEN(FL$):I=ASC(MID$(FL$,L,1)):IFI>96ANDI<123THENMID$(FL$,L,1)=CHR$(I-32)
45 NEXTL:PRINT@X,FL$;NV$;:AP=0:IFINSTR(FL$,":")>0ANDLEFT$(FL$,4)<>"RAM:"THEN46ELSEPRINT@40,"Append to ";FL$;:GOSUB94:AP=(X$="Y")
46 PRINT@80,"Copy types available:":FORI=1TO3:PRINT"<";CHR$(I+48);"> ";CT$(I):NEXTI:PRINT@280,"Which type of copy?  < >";:PRINT@280+POS(0)-2,"";
47 X$=INPUT$(1):CT=INSTR("123",X$):IFCT=0THEN47ELSEPRINTX$;:PRINT@80,CF$:IFCT<3THEN48ELSEPRINT"Text string: ";:LINEINPUTS$:IFS$=""THENCT=1:PRINT@80,CF$:GOTO48ELSEPRINT"Replacement: ";:LINEINPUTR$
48 PRINT@80,CT$(CT);" copy in progress...";ES$;"P";:GOSUB90:LN=LN-1:OPENFL$(IX)FORINPUTAS1:IFAPTHENOPENFL$FORAPPENDAS2ELSEOPENFL$FOROUTPUTAS2:ONCTGOTO49,50,54
49 GOSUB97:GOTO57
50 L=0:FORI=0TO1:IFEOF(1)THENPRINT#2,"":GOTO53ELSEI=0:LINEINPUT#1,X$:IFLEN(X$)>0THEN52ELSEPRINT#2,"":IFLTHENPRINT#2,""
51 L=0:GOTO53
52 PRINT#2,X$;" ";:L=-1
53 NEXTI:GOTO57
54 X$="":L=LEN(S$):FORI=0TO1:I=0:X=L-LEN(X$):IFX=0THEN55ELSEIFX>LNTHENI=1:GOTO56ELSEX$=X$+INPUT$(X,1):LN=LN-X
55 IFX$=S$THENPRINT#2,R$;:X$="":GOTO56ELSEPRINT#2,LEFT$(X$,1);:X$=MID$(X$,2)
56 NEXTI:PRINT#2,X$;:IFLN>0THENPRINT#2,INPUT$(LN,1);
57 PRINTES$;"Q";:CLS:CLOSE:PRINT"Copy completed.":X$="for menu.":GOSUB92:GOSUB82:GOSUB87:IX=1:X$=RV$:GOSUB88:RETURN
58 KEYOFF:PRINT@0,CL$;"RAM file BACKUP to cassette";:X$=NV$:GOSUB88:PRINT@280,CF$;"<A>ll or <S>elected files? < >";:PRINT@280+POS(0)-2,"";
59 X$=INPUT$(1):M=INSTR("ASas",X$):IFM=0THEN59ELSEIFM>2THENM=M-2
60 PRINTMID$("AS",M,1);:CY$=STRING$(NF,"N"):FORIX=1TONF:X$="N":IFRIGHT$(FL$(IX),2)="CO"THEN61ELSEIFM=1THENX$="Y":GOTO61ELSEPRINT@280,CL$;"Copy ";FL$(IX);:GOSUB94
61 MID$(CY$,IX,1)=X$:IFX$="Y"THENX$=RV$:GOSUB88
62 NEXTIX:PRINT@280,CF$;"Pause before copy";:GOSUB94:P=(X$="Y"):X$="to begin BACKUP.":GOSUB92:PRINT@280,CF$;:PRINT@0,CF$;"Copying marked files to cassette:";:L=15000:GOSUB72:FORIX=1TONF
63 IFFL$(IX)="@.BA"THENGOSUB68:MID$(CY$,IX,1)="N":IX=NF
64 NEXTIX:L=2000:GOSUB72:PRINT@280,CF$;"Writing [DIR] file to cassette.";:OPEN"CAS:[DIR]"FOROUTPUTAS2:PRINT#2,"Backup as of ";DATE$:FORIX=1TONF:IFMID$(CY$,IX,1)="Y"THENGOSUB90:PRINT#2,FL$(IX);",";LN
65 NEXTIX:CLOSE:FORIX=1TONF:IFMID$(CY$,IX,1)="N"THEN67ELSEIFPTHENX$="to copy next file.":GOSUB92
66 GOSUB68
67 NEXTIX:PRINT@0,CL$;"RAM file BACKUP complete.":X$="for menu.":GOSUB92:GOSUB87:IX=1:X$=RV$:GOSUB88:RETURN
68 X=INSTR(FL$(IX),"."):FL$=LEFT$(FL$(IX),X-1):FX$=MID$(FL$(IX),X+1):GOSUB90:PRINT@280,CF$;"Copying: ";FL$(IX);"  Size:";LN;:L=2000:GOSUB72:IFFX$="BA"THENGOSUB71ELSEGOSUB70
69 PRINT@40,CF$;:RETURN
70 OPENFL$(IX)FORINPUTAS1:OPEN"CAS:"+FL$FOROUTPUTAS2:LN=LN-1:GOSUB97:CLOSE:RETURN
71 PRINT@40,"":X$="POKEAD!,B:POKEAD!+1,T:RETURN"+CHR$(13):GOSUB89:AD!=63100:B=PEEK(AD!):T=PEEK(AD!+1):X!=FL!(IX):POKEAD!+1,INT(X!/256):POKEAD!,X!-PEEK(AD!+1)*256:CSAVEFL$
72 MOTORON:FORI=1TOL:NEXTI:MOTOROFF:RETURN
73 KEYOFF:PRINT@240,CL$;:LINEINPUT"New file name: ";X$:FORI=1TOLEN(X$):X=ASC(MID$(X$,I,1)):IFX>96ANDX<123THENMID$(X$,I,1)=CHR$(X-32)
74 NEXTI:IFINSTR(X$,".")=0THENX$=X$+RIGHT$(FL$(IX),3)
75 NAMEFL$(IX)ASX$:FL$(IX)=X$:X$=RV$:GOSUB88:PRINT@240,CL$;:X$="":RETURN
76 KEYOFF:BEEP:PRINT@240,CL$;"OK to kill ";FL$(IX);:GOSUB94:IFX$="N"THENPRINT@240,CL$;:RETURNELSEPRINT@240,CL$;"Killing ";FL$(IX);:PRINT@0,"";:IFRIGHT$(FL$(IX),2)="BA"THENX$="RUN"+CHR$(13):GOSUB89
77 KILLFL$(IX):GOSUB82:GOSUB87:IX=1:X$=RV$:GOSUB88:X$="":RETURN
78 MENU
79 PRINT@240,CL$;"The file must be a .DO file!";:BEEP:RETURN
80 CLS:PRINT"**** Error trap taken! ****":PRINT:X=ERR:IFX>22THENX=X-27
81 X=(X-1)*2+796:PRINTCHR$(PEEK(X));CHR$(PEEK(X+1));" error in line";ERL:PRINT:X$="to restart.":GOSUB92:RUN
82 NF=0:FORX=-1694TO-1441STEP11:IFPEEK(X)<128THEN86ELSEIF(PEEK(X)AND24)>0THEN86ELSENF=NF+1:AD!=PEEK(X+1)+PEEK(X+2)*256:P=NF:IFP=1THEN84
83 P=P-1:IFAD!<FL!(P)THENFL!(P+1)=FL!(P):FL$(P+1)=FL$(P):GOTO83ELSEP=P+1
84 FL!(P)=AD!:X$=".  ":FORI=9TO10:MID$(X$,I-7,1)=CHR$(PEEK(X+I)):NEXTI:L=8
85 IFPEEK(X+L)=32THENL=L-1:GOTO85ELSEX$=STRING$(L-2,32)+X$:FORI=3TOL:MID$(X$,I-2,1)=CHR$(PEEK(X+I)):NEXT:FL$(P)=X$
86 NEXT:FL!(NF+1)=PEEK(64434)+PEEK(64435)*256:PB!=PEEK(63909)+PEEK(63910)*256:IFNF>0THENRETURNELSECLS:BEEP:PRINT@176,"NO FILES":X$="for Menu.":GOSUB92:MENU
87 CALL23058:X!=HIMEM-FL!(NF+1)-(MAXFILES+1)*267-16:PRINT"  Free:";X!;:L=1:FORI=1TONF:PRINT@L+40,FL$(I);:L=L+10:NEXTI:SCREEN0,0:PRINT@280,"Size List Memo Copy Bkup Name Kill Menu";:RETURN
88 FL$=" "+FL$(IX)+SPACE$(9-LEN(FL$(IX))):PRINT@(IX-1)*10+40,X$;FL$;NV$;:RETURN
89 X$=LEFT$(X$,32):FORI=1TOLEN(X$):X!=(I-1)*2+65451:POKEX!,ASC(MID$(X$,I,1)):POKEX!+1,0:NEXTI:POKE65450,LEN(X$):RETURN
90 X!=FL!(IX+1):IFFL!(IX)<PB!ANDPB!<X!THENX!=PB!
91 LN=X!-FL!(IX):RETURN
92 PRINT@280,CL$;"Push <ENTER> ";X$;:BEEP
93 IFINPUT$(1)<>CHR$(13)THEN93ELSERETURN
94 PRINT" (Y/N)? < >";:PRINT@CSRLIN*40+POS(0)-2,"";
95 X$=INPUT$(1):X=INSTR("YNyn",X$):IFX=0THEN95ELSEIFX>2THENX=X-2
96 X$=MID$("YN",X,1):PRINTX$;:RETURN
97 B=FIX(LN/255):LN=LN-B*255:IFB=0THEN98ELSEFORI=1TOB:PRINT#2,INPUT$(255,1);:NEXTI
98 IFLN>0THENPRINT#2,INPUT$(LN,1);
99 RETURN
