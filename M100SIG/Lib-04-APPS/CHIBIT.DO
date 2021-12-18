10 ' CHIBIT codes/decodes hi-bit
20 ' data from .DO files.  Use it
30 ' to convert files for sending
40 ' through CompuServe, which
50 ' can handle the coded files.
60 ' Convert files that contain
70 ' graphics characters.
80 '
90 ' W Hubbard, 70346,1716, 5/4/85
95 MAXFILES = 2
100 CLS:FILES:LINE INPUT ".DO file to convert: ";FI$:IF RIGHT$(FI$,3)<>".DO" AND RIGHT$(FI$,3)<>".do" THEN FI$=FI$+".DO"
105 OPEN FI$ FOR INPUT AS 1
107 OPEN "CHIB$$.do" FOR OUTPUT AS 2
110 CLS:PRINT FI$:PRINT @123,"F1 - Code":PRINT "   F2 - Decode":PRINT "   F8 - Menu"
120 ON KEY GOSUB 200,300,,,,,,140
130 KEY ON:GOTO 130
140 CLOSE:MENU
200 KEY OFF:CLS:PRINT "working..."
210 IF EOF(1) THEN PRINT "Done."CHR$(7);:KILL FI$:NAME "chib$$.do" AS FI$:CLOSE:END
220 A$=INPUT$(1,1)
230 IF A$="^" THEN A$="^^"
240 IF ASC(A$)>127 THEN A$="^"+RIGHT$(STR$(ASC(A$)),3)
250 PRINT #2,A$;:PRINT A$;
260 GOTO 210
300 KEY OFF:CLS:PRINT"working..."
310 IF EOF(1) THEN 210
320 A$=INPUT$(1,1)
330 IF A$="^" THEN GOSUB 400
340 PRINT #2,A$;:PRINT A$;
350 GOTO 310
400 A$=INPUT$(1,1)
410 IF A$="^" THEN RETURN
420 A$=A$+INPUT$(2,1)
430 A$=STRING$(1,VAL(A$))
440 RETURN
