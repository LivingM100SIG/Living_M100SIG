10 'FORMAT -- John McDevitt [70526,601]
15 'This program was written to make my life easier when transferring files from the Model 100 to another computer over
20 'the phone lines using the built in modem.  Since the Model 100 does not transmit a line feed with a carriage
25 ' return when using the modem (I haven't tried a direct connection),and if the receiving computer
30 'doesn't give an automatic line feed with each carriage return received,
35 'you must imbed the necessary control codes in the text before it is sent via Telcom.
40 'Rather than go through the text, and manually imbed line feeds and carriage returns, running the following program
45 'will let the Model 100 do the work for you.  The program will prompt for the file name, file size, and the length
50 'of the lines you wish to send.  Then the program inserts a line feed and carriage return at the specified
55 ' line length (does not split words), and inserts a line feed wherever you already have a carriage return. 
60 ' When the program has finished formatting, you will be returned to Menu.  A new file (FILE.DO),
65 'will be on the menu.  The original file will still be there unchanged--the new file will be formatted with 
70 'imbedded control codes @ specified intervals.
75 'One of these days I'll insert a routine to calculate the file length automatically.
80 '  For now I use the Filen program from the Sig database to determine file length.
90 'Let me know how the program works for your application.
100 CLS:MAXFILES=2:ONERRORGOTO1000
110 KILL"FILE.DO"
120 DEFINTA-Z
130 INPUT"Enter file size (add 100/K)";S:CLEARS
140 INPUT"name of file";F$
150 INPUT"length of line";L
160 CLS:PRINT@85,"Formatting file for output"
170 OPENF$FORINPUTAS1:OPEN"file.do"FORAPPENDAS2
200 IFEOF(1)THEN250
210 A$=INPUT$(1,1)
220 Z$=Z$+A$
230 IFA$=CHR$(10)THENZ$=LEFT$(Z$,LEN(Z$)-2):Z$=Z$+CHR$(10):GOTO260
240 IFLEN(Z$)>LANDA$=CHR$(32)THEN250ELSE200
250 Z$=Z$+CHR$(10)
260 PRINT#2,Z$:Z$="":IFEOF(1)THEN280
270 GOTO200
280 CLOSE:MENU
1000 IFERR=52THEN120ELSESTOP
