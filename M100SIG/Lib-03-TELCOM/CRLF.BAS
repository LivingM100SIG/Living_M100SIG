1 CLS:PRINT"CRLF.BAS  Copyright 1987 by R.G. Olson"
10 PRINT "BASIC FILTER TO ADD LF's AFTER CR'S IF NEEDED"
15 PRINT "                AND CR'S BEFORE LF'S , ALSO"
20 LF$=CHR$(10):CR$=CHR$(13)
30 INPUT"FILE TO PROCESS ";FILE$
40 IF FILE$="" GOTO 30
45 IF INSTR(FILE$,".")>0 THEN 300
50 OPEN FILE$ FOR INPUT AS #1
60 OPEN FILE$+".PRN" FOR OUTPUT AS #2
65 A$=INPUT$(1,#1):IF A$=LF$ GOTO 65
70 IF EOF(1) GOTO 110,ELSE B$=INPUT$(1,#1):IF B$=LF$ AND A$<>CR$ THEN PRINT#2,A$;CR$;:A$=B$:GOTO 70,ELSE IF A$=CR$ AND B$<>LF$ THEN PRINT#2,A$;LF$;:A$=B$:GOTO 70, ELSE PRINT#2,A$;:A$=B$:GOTO 70
110 IF B$=CR$ THEN PRINT#2,B$;LF$;:CLOSE:GOTO 120,ELSE PRINT#2,B$;:CLOSE
120 PRINT FILE$+".PRN COMPLETED"
130 SYSTEM
300 PRINT"REName or COPY your file to a filespec w/o an .EXT before using CRLF.BAS":INPUT"ANY KEY TO RETURN TO DOS....";R$:SYSTEM
