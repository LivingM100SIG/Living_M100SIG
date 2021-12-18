10 ' DOWNCK.BA WM3 05-Apr-84 Woods Martin.  Compute checksum for .DO files.
20 ' Modified by Paul MacDonald for the Epson Geneva 01-Jan-85.
30 ' Geneva users who plan to upload an M100 or NEC compatible MBASIC
40 ' program from their Geneva to the Model 100 SIG should include a checksum 
50 ' in their description. This program generates a checksum for the particular
60 ' program when run on the Geneva.
70 MAXFILES=1:CLEAR 1000:DEFINT I:DEFDBL C:DEFSTR S
80 SCREEN,,0
90 CLS:PRINT:FILES "*.BAS"
100 PRINT"------------------------------------------------------------------------------"
110 PRINT" ":PRINT"Enter name of file to check, or press RETURN to quit -> ";:BEEP 25:SI="":GOSUB 220:PRINT:IF LEN(SI)=0 THEN 180 ELSE SF=SI
120 ON ERROR GOTO 190:I=INSTR(1,SF,"."):IF I THEN SF=LEFT$(SF,I-1)
130 SF=SF+".BAS":OPEN"I",1,SF:CLS:PRINT SF;
140 IF EOF(1)=0 THEN LINE INPUT#1,S:IL=IL+1:PRINT IL;:IF LEN(S)=0 THEN 140 ELSE FOR I=1 TO LEN(S):C=C+ASC(MID$(S,I)):NEXT:GOTO 140
150 CLOSE:CLS:PRINT" ":PRINT SF;USING" Checksum = ###########,###";C
160 PRINT"------------------------------------------------------------------------------"
170 PRINT" ":PRINT"Press A to check another, or press RETURN to quit -> ";:GOSUB 250:IF S="A" THEN 70
180 CLS:PRINT:PRINT TAB(20)"Program terminated on request at ";TIME$;".":BEEP 25:SCREEN 0,0,1:END
190 IF ERL=130 THEN SOUND 261,25:RESUME 70
200 IF ERL=140 THEN RESUME 150
210 ON ERROR GOTO 0
220 GOSUB 250:IF S=CHR$(13) THEN 240 ELSE IF S=CHR$(8) THEN IF LEN(SI)>0 THEN PRINT S;" ";S;:SI=MID$(SI,1,LEN(SI)-1):GOTO 220 ELSE 240
230 IF S<" " THEN 220 ELSE SI=SI+S:PRINT S;:GOTO 220
240 RETURN
250 S=INPUT$(1):IF S>="a" AND S<="z" THEN S=CHR$(ASC(S)-32):RETURN ELSE RETURN
