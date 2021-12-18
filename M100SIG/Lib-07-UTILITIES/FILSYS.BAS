The following programs allow you to save, check and load binary (.CO, .CA, .CW,
.CT) files as hexadecimal files on any type of storage device, cassette, ram,
wafer tape, or disk, which play by the rules of the M100 BASIC OPEN format.
The programs do not reset or alter HIMEM or any existing machine language
files. If you are careful, you shouldn't be making any quick trips to the first
day of the last year of the 19th Century.  If you suspect any problems with one
of the binary files you are loading, kill it, do not attempt to use it.

The first program is a save program.  This program must be SAVEed and appear in
the directory.  This program is completely harmless.  It peeks the directory,
finds the file you want, peeks out the bytes, converts them to hexadecimal, and
writes them to your storage device.

1 'COMMAND FILE SAVER - V1.0
2 '(c) J. TINGLE - 10 SEPT. 1986
10 'Get Info
15 INPUT "Ram file to be saved";RF$
16 NL=LEN(RF$):A$=""
17 IF NL<6 THEN A$=SPACE$(6-NL)
18 INPUT "File extension";EX$
30 RN$=RF$+A$+EX$:PRINT RN$
35 INPUT "File to write hex code to";HF$
100 'Get File Begin Address
105 BF=0
110 'Peek from directory
120 FOR I=63842 TO 64138 STEP 11
130   LET ST=PEEK(I)
135   IF ST<>160 THEN GOTO 220
140   ADR=PEEK(I+1)+256*PEEK(I+2)
150   NM$=""
160   FOR K=3 TO 10
170     NM$=NM$+CHR$(PEEK(I+K))
180   NEXT K
200   'Match file name
210   IF NM$=RN$ THEN BF=ADR:PRINT ST;" ";NM$;" ";ADR;
220 NEXT I
300 'Begin again if no match
310 IF BF=0 THEN CLS:PRINT "No match in directory, begin again.":GOTO 1
340 OPEN HF$ FOR OUTPUT AS 1
400 LE=PEEK(BF+2)+256*PEEK(BF+3)-1
410 EF=BF+LE+6
420 PRINT " Length = ";LE
500 'Hex conversion table
550 DIM H$(15)
600 FOR I=0 TO 9
610   H$(I)=CHR$(I+48)
620 NEXT I
630 FOR I=10 TO 15
640   H$(I)=CHR$(I+55)
650 NEXT I
900 PRINT "Begin = ";TIME$
1000 FOR I=BF TO EF
1010   'Peek in Bytes
1100   BY=PEEK(I)
1200   PRINT @ 260,I;" ";BY;
2000   'Convert to Hex
2100   HL$=H$(BY MOD 16)
2110   HH$=H$(BY\16)
3000   'Write to file
3010   PRINT #1, USING "!";HL$;
3020   PRINT #1, USING "!";HH$;
4000 NEXT I
5000 PRINT
5010 PRINT "End = ";TIME$
6000 CLOSE
6010 END

The second program is a checker.  It must also be SAVed.  It is also harmless,
comparing the ram file and the stored hex file. Not using it may be hazardous
to your health.

1 'COMMAND FILE CHECKER - V1.0
2 '(c) J. TINGLE - 11 SEPT. 1986
10 'Get Info
15 INPUT "Ram file to be checked";RF$
16 NL=LEN(RF$):A$=""
17 IF NL<6 THEN A$=SPACE$(6-NL)
18 INPUT "File extension";EX$
30 RN$=RF$+A$+EX$:PRINT RN$
35 INPUT "Hex file to be checked";HF$
100 'Get File Begin Address
105 BF=0
110 'Peek from directory
120 FOR I=63842 TO 64138 STEP 11
130   LET ST=PEEK(I)
135   IF ST<>160 THEN GOTO 220
140   ADR=PEEK(I+1)+256*PEEK(I+2)
150   NM$=""
160   FOR K=3 TO 10
170     NM$=NM$+CHR$(PEEK(I+K))
180   NEXT K
200   'Match file name
210   IF NM$=RN$ THEN BF=ADR:PRINT ST;" ";NM$;" ";ADR;
220 NEXT I
300 'Begin again if no match
310 IF BF=0 THEN CLS:PRINT "No match in directory, begin again.":GOTO 1
340 OPEN HF$ FOR INPUT AS 1
400 LE=PEEK(BF+2)+256*PEEK(BF+3)-1
410 EF=BF+LE+6
420 PRINT " Length = ";LE
500 'Hex conversion table
550 DIM H$(15)
600 FOR I=0 TO 9
610   H$(I)=CHR$(I+48)
620 NEXT I
630 FOR I=10 TO 15
640   H$(I)=CHR$(I+55)
650 NEXT I
900 PRINT "Begin = ";TIME$
1000 FOR I=BF TO EF
1010   'Peek in Bytes
1100   BY=PEEK(I)
1200   PRINT @ 260,I;" ";BY;
2000   'Convert to Hex
2100   HL$=H$(BY MOD 16)
2110   HH$=H$(BY\16)
3000   'Get hex from file
3010   FL$=INPUT$(1,1)
3020   IF FL$<>HL$ THEN GOTO 8000
3030   FH$=INPUT$(1,1)
3040   IF FH$<>HH$ THEN GOTO 8000
4000 NEXT I
5000 PRINT
5010 PRINT "End = ";TIME$
6000 CLOSE
6010 END
8000 'Error detected
8010 CLS
8020 PRINT "Hex file corrupted."
8030 PRINT "at ";I
8040 PRINT "Hex file data ";FL$;" ";FH$
8050 PRINT "Ram file data ";HL$;" ";HH$
8060 END

The third program is also harmless, but vital.  The program examines stored hex
files and tells you the size and configuration of the file.  YOU MUST then save
a dummy ram file to hold the hex code.  This cannot be done by a program, you
must do it as a command entered into BASIC.

EXAMPLE:

The hex file contains a 1.4K Lucid spreadsheet with a start address of 65535,
an end address of 66935, and an execute address of 63012. YOU MUST save a .CO
file with the parameters:

SAVEM "XXXXXX.CO",Y,Y+(66935-65535),63012

XXXXXX is the name you wish to use, Y is any integer, I suggest 0.

1 'COMMAND FILE LOADER SECT. 1- V1.0
2 '(c) J. TINGLE - 11 SEPT. 1986
10 'Get Info
12 DEFSNG A-Z
35 INPUT "Hex file to load from";HF$
100 'Hex conversion table
110 DIM HC%(22)
120 FOR I%=0 TO 9
130 HC%(I%)=I%
140 NEXT I%
150 FOR I%=10 TO 16
160 HC%(I%)=16
170 NEXT I%
180 FOR I%=17 TO 22
190 HC%(I%)=I%-7
200 NEXT I%
205 OPEN HF$ FOR INPUT AS 1
210 'Get Begin, Length, and Start Data
220 GOSUB 10000
230 BA=AD
240 GOSUB 10000
250 LE=AD
255 EA=BA+LE-1
260 GOSUB 10000
270 SA=AD
280 PRINT "Begin Address = ";BA
290 PRINT "  End Address = ";EA
300 PRINT "Start Address = ";SA
310 PRINT "If this is correct, save a dummy file"
315 PRINT "with these parameters and run program"
320 PRINT "    L2OD10.BA."
330 CLOSE
340 END
9000 'Convert hex to byte
9215 BY=0
9220 FOR K=0 TO 1
9230   IF EOF(1) THEN GOTO 7000
9240   HD$=INPUT$(1,1)
9250   HD=HC%(ASC(HD$)-48)
9260   IF(HD>15 OR HD<0) THEN GOTO 8000
9270   BY=BY+HD*(16^K)
9280 NEXT K
9300 RETURN
10000 'Get two byte address
10010 AD=0
10020 FOR J=0 TO 1
10030   GOSUB 9000
10040   AD=AD+BY*(256^J)
10050 NEXT J
10060 RETURN

Next LOAD and SAVE the fourth program.  This program MUST be SAVEed. If you
screw up here you may corrupt the directory and your files.  BE CAREFUL!  The
program then takes the hexadecimal data from your storage file and pokes it
into the reserved space.  Your file is then just as you saved it.

1 'COMMAND FILE LOADER - V1.0
2 '(c) J. TINGLE - 11 SEPT. 1986
10 'Get Info
12 DEFSNG A-Z
15 INPUT "Ram file to load to";RF$
16 INPUT "Extension";EX$
17 NL%=LEN(RF$):A$="":RN$=RF$
20 IF NL%<6 THEN A$=SPACE$(6-NL%)
21 RF$=RF$+A$:PRINT RF$+EX$
35 INPUT "Hex file to load from";HF$
40 OPEN HF$ FOR INPUT AS 1
100 'Hex conversion table
110 DIM HC%(22)
120 FOR I%=0 TO 9
130 HC%(I%)=I%
140 NEXT I%
150 FOR I%=10 TO 16
160 HC%(I%)=16
170 NEXT I%
180 FOR I%=17 TO 22
190 HC%(I%)=I%-7
200 NEXT I%
210 'Get Begin, Length, and Start Data
220 GOSUB 10000
230 BA=AD
240 GOSUB 10000
250 LE=AD
255 EA=BA+LE-1
260 GOSUB 10000
270 SA=AD
280 PRINT "Begin Address = ";BA
290 PRINT "  End Address = ";EA
300 PRINT "Start Address = ";SA
310 INPUT "Is this right";A$
320 IF (A$<>"Y") THEN END
330 CLOSE
1100 'Peek from directory
1150 BF=0
1200 FOR I=63842 TO 64138 STEP 11
1300   LET ST%=PEEK(I)
1350   IF ST%<>160 THEN GOTO 2200
1400   ADR=PEEK(I+1)+256*PEEK(I+2)
1500   NM$=""
1600   FOR K%=3 TO 8
1700     NM$=NM$+CHR$(PEEK(I+K%))
1800   NEXT K%
2000   'Match file name
2100   IF NM$<>RF$ THEN 2200
2110   BF=ADR
2120   POKE I+9,ASC(LEFT$((EX$),1))
2130   POKE I+10,ASC(RIGHT$((EX$),1))
2140   PRINT ST%;" ";NM$+EX$;" ";ADR
2200 NEXT I
3000 'Begin again if no match
3100 IF BF=0 THEN CLS:PRINT "No match in directory, begin again.":GOTO 1
4000 LE=PEEK(BF+2)+256*PEEK(BF+3)-1
4100 EF=BF+LE+6
4200 PRINT "Length = ";LE
4340 OPEN HF$ FOR INPUT AS 1
5000 FOR I=BF TO EF:POKE I,HC%(ASC(INPUT$(1,1))-48)+16*HC%(ASC(INPUT$(1,1))-48):NEXT I
6000 CLOSE
6010 END
9000 'Convert hex to byte
9215 BY=0
9220 FOR K=0 TO 1
9230   IF EOF(1) THEN GOTO 7000
9240   HD$=INPUT$(1,1)
9250   HD=HC%(ASC(HD$)-48)
9260   IF(HD>15 OR HD<0) THEN GOTO 8000
9270   BY=BY+HD*(16^K)
9280 NEXT K
9300 RETURN
10000 'Get two byte address
10010 AD=0
10020 FOR J=0 TO 1
10030   GOSUB 9000
10040   AD=AD+BY*(256^J)
10050 NEXT J
10060 RETURN
