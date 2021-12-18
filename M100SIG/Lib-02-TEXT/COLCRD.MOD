1. Module for rotary type cards and labels.
    Merge into COLCRD.BAS. Make sure you keep copy of origional.
    Line 505 contains my printer code for 10/72" line feed
    Line 510 is code for unidirectional print (optional)
    You will probably have to experiment where the top of the card
    needs to be aligned with print head

7PRINT@172,"For card output"
145 PRINT@80,"A) 2 1/4 x 4 Rollodex Card (1,2,3) ?"
150 PRINT@120,"B) 3 x 5 Rollodex Card (4,5,6) ?"
155 PRINT@160,"C) 3 x 5 File Card (7,8,9) ?"
160 PRINT@200,"D) 3 1/2 x 1 Label (10,11,12) ?"
170 PRINT:INPUT"TYPE (1-12)";K1
175 ONK1 GOSUB 1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012
305 IF(Z+L1)>NTHENGOSUB 550
505 XY=S+CHR$(51)+CHR$(19)
510 XZ=S+CHR$(85)+CHR$(1)
518 LPRINTW+XY+XZ
525 GOSUB700
550 FOR I=1TO6:SOUND 11000,10:NEXT
555 PRINT@240,R;"BEWARE OUTPUT GREATER THAN ONE FORM";U
560 FORI=1TO900:NEXT
565 GOSUB585:Q=INKEY$:IFQ=""THEN565ELSEIFQ="C"ORQ="c"THEN125
570 RETURN
700 Z1=L1+C/NC:FORI=1TO(N1-Z1)
705 PRINT#D," ":NEXT:RETURN
1001 EC=36:N=12:N1=16:F=1:RETURN:'2 1/4 x 4 cards
1002 EC=44:N=12:N1=16:F=2:RETURN
1003 EC=64:N=12:N1=16:F=3:RETURN
1004 EC=50:N=19:N1=22:F=1:RETURN:'3 x 5 cards
1005 EC=60:N=19:N1=22:F=2:RETURN
1006 EC=80:N=19:N1=22:F=3:RETURN
1007 EC=50:N=22:N1=22:F=1:RETURN:'3 x 5 file cards
1008 EC=60:N=22:N1=22:F=2:RETURN
1009 EC=80:N=22:N1=22:F=3:RETURN
1010 EC=32:N=6:N1=7:F=1:RETURN:'labels
1011 EC=39:N=6:N1=7:F=2:RETURN
1012 EC=55:N=6:N1=7:F=3:RETURN


2. Alternate Print Module
    Set up YOUR codes (M1=) in lines 600, 603 and 605
     EXAMPLE: For my Gemini( 2 Byte codes) printer I use the following:
     Line 600: Code for normal print (10 cpi),printer reset
     Line 603: No code for elite (12 cpi) code
     Line 605: Code for condensed (17 cpi) print
     The program will not let you use that font if M1=999
    Merge into COLCRD.BAS

512 GOSUB600
600 IFF=1THEN M1=64:'NORMAL
603 IFF=2THENM1=999:'ELITE
605 IFF=3THENM1=15:'CONDENSED
607 IFM1=999THENPRINT@240,"NON USEABLE PRINT":FORH=1TO600:NEXT:CLOSE:GOTO125
608 W=S+CHR$(M1)
609 RETURN

Module 1 and 2 both can be merged into COLCRD.BAS at the same time.



3. Module for double sided printer output.
    This module,when merged into COLCRD.BAS will first print out to the
printer the odd numbered pages and the even numbered pages printed to the
specified output file. For large files it is recommended that an external
storage device be used for the output file.

Lines 357 and 423 contains a method to inbed your printer codes into the
output file. You add 128 to the printer ASCII code. For a better 
explanation see P100, Apr 89, page 24. You will see some graphics characters
inbedded into the output file.The printer must be in the 7-bit mode.

You first print out the odd pages to the printer and then remove the paper
and turn it over and insert it back into printer. Make sure you have an
extra sheet at the start and at the end of the printout. You then load the
saved file (even pages) into TEXT and use SHIFT PRINT to print out the file.
Use the necessary WIDTH: (80, 96, or 132).

0 '2SIDED COLCRD.BA
7 print@170,"For 2 sided output"
340 REM
345 REM
350 OPEN"LPT:"FOROUTPUTAS2
355 OPENYO$FOROUTPUTAS1:CC=0:A=1:CB=0
357PRINT#1,CHR$(155);CHR$(66);CHR$(F+128);:'Use your codes
365 FORK=1TOCD
366 IFK/2=INT(K/2)THEND=1ELSED=2
367 IFD=2 THENGOSUB490
368 IFD=2THENO="PRINTING "+YI$ELSEO="WRITING "+YO$
369 CLS:SS=O:GOSUB475
423 IFD=1THENPRINT#1,CHR$(140);:'Top of form
425IFD=2THENGOSUB525

Module 2 and 3 can be merged into COLCRD.BAS at the same time.

If you are using both module 2 and 3, you should delete line 357. Change
line 365 to: 365 FORK=1TOCD:IFK=2THENPRINT#1,CHR$(155);CHR$(M1+128);

PRINTER PROBLEMS REVISITED:

1.If the above method doesn't work with your printer delete line 357 and
change line 423 to: 423 IFD=1 THEN GOSUB 700

You would then have to set up the correct font for the printer
manually and use the same method to print out the file.

NOTE:
If you are using the single sided output to the printer, you might want
to remark out line 425. This would let you put several smaller files on
the same page.

Ralph D. Walthall [74016,1660]
