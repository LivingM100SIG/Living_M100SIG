0 'RAMFYI.BA	(c)1989 Wilson Van Alst	v1.0		  All rights reserved.
1 'Uses ZIPFYI.CO to search every .DO
2 ' file in RAM for a specified string.
3 'Records containing the string are
4 ' appended to a file called MATCH.DO.
5 '        -----------------
10 LOADM"ZIPFYI":M$="MATCH ":IFPEEK(33)=68THENC=64755:D=63908ELSEC=63625:D=62122
20 CLS:LINEINPUT"Search for:";S$:IFLEN(S$)THENS$=S$+CHR$(0)ELSEMENU
30 D=D+11:IFPEEK(D)=255THENRUNELSEIFPEEK(D)-192THEN30
40 F$="":FORI=3TO8:F$=F$+CHR$(PEEK(D+I)):NEXT:IFF$=M$THEN30
50 OPENM$FORAPPENDAS1:PRINT#1,STRING$(10,"-");"  File: "F$".DO  "STRING$(10,"-"):CLOSE
70 OPENF$FORINPUTAS1:CLOSE
60 PRINT@90,CHR$(27)"KSearching: "F$;
80 V=VARPTR(S$):CALLC,,PEEK(V+1)+256*PEEK(V+2)
90 GOTO30
