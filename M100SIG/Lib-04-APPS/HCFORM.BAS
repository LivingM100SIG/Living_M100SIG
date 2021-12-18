
I created a SALES SLIP printing program to be used with the Model 200/100, for
my wife's small Crafts business, which was subsequently modified and improved
by Tony Anderson to include other similar forms.  The modifications have truly
enhanced the original. **MERCI BIEN, Tony!

Except for the CHR$(12) form feed at the end, this program should work with any
printer.  I have used it with the Epson RX-80 and the TTXpress portable printer
from TTX Corporation.  There is only one printer specific command in the file,
in line 350.  CHR$(14) sets the "One-line Expanded Mode" on, for the form's
title.  Change to suit your own printer if necessary.

Lines 10, 310-340 and 530 will need to be customized by each user for the name
of the company, address, and phone.  Also line 50 for the value of Sales Tax in
your State.

Customize the program in the lines mentioned, and delete these Introductory
Remarks, then F8 to get back to the menu.  From BASIC, LOAD "HCFORM.DO" and
SAVE "Your Filename".

I prefer using upper-case only, and have a prompt in line 30 as a reminder.  If
you prefer Upeer/lower case, you can delete line 30; the program actually works
either way.

If you have problems or questions, please leave a message here or via EMAIL to
72327,1025.  I hope this will serve a purpose for someone else, as it has for
me. NORM LEVEILLE

******NOTE: Delete all the above lines before loading into Basic.******


0 ' HCFORM.BA Business Forms program created by Norm Leveillee 72327,1025 Copyright 1988
1 ' Modifications by Tony Anderson 76703,4062  2/19/88
10 CLEAR:CLS:PRINT:PRINTTAB(10);"HOMESTEAD CREATIONS"
20 PRINTTAB(13);"BUSINESS FORM":PRINT
30 PRINT:PRINT TAB(13);">Caps Lock ON<"
40 PRINT TAB(13);" >Printer ON<"
50 LET TAX=.06  ' Set for your sales tax percentage
60 PRINT:PRINT:PRINT:INPUT"            How many items";N
70 GOSUB580
80 DIMID$(N),UP(N),Q(N),TP(N)
90 CLS
100 PRINT:INPUT"     To: NAME";NM$
110 INPUT"       STREET";ST$
120 INPUT"         TOWN";TN$
130 INPUT"  STATE & ZIP";SZ$:CLS:PRINT
140 PRINTTAB(3)NM$;TAB(28)DATE$
150 PRINTTAB(3)ST$
160 PRINTTAB(3)TN$;" ";SZ$
170 PRINT:PRINT"   Is this correct? (Y/N) ";:Q$=INPUT$(1)
180 IFQ$="Y"ORQ$="y"THENPRINTQ$:GOTO190 ELSECLS:PRINT:PRINT"   Enter data again:":GOTO100
190 CLS:FORA=1TON
200 PRINT"   ITEM #"A:INPUT"   DESCRIPTION";ID$(A)
210 INPUT"   UNIT PRICE ";UP(A)
220 INPUT"   QUANTITY   ";Q(A)
230 PRINT:PRINT"   Is this correct? (Y/N) ";:Q$=INPUT$(1)
240 IFQ$="Y"ORQ$="y"THEN250 ELSECLS:PRINT:PRINT"   Enter data again:":GOTO200
250 TP(A)=Q(A)*UP(A):TT=TT+TP(A)
260 CLS:NEXT:CLS
270 PRINT:PRINT"   Sales Tax to be applied?  (Y/N) ";:T$=INPUT$(1):PRINTT$:PRINT
280 GOSUB 680
290 PRINT:PRINT:PRINT"   Now ready for printer output!                Press ENTER when ready... ";:Q$=INPUT$(1)
300 PRINT;PRINT:PRINT"   Output now going to printer..."
310 LPRINTTAB(30);"HOMESTEAD CREATIONS"
320 LPRINTTAB(29);"SHARPE STREET BOX 1361"
330 LPRINTTAB(28);"WEST GREENWICH, RI 02816"
340 LPRINTTAB(33);"401-397-5948"
350 LPRINT:LPRINTTAB(40-LEN(S$))CHR$(14)S$:LPRINT TAB(36)"#";FN$:LPRINT ' CHR$(14)=One line expanded mode
360 LPRINTTAB(12);NM$TAB(55);DATE$
370 LPRINTTAB(12);ST$;TAB(55);DAY$
380 LPRINTTAB(12);TN$;"  ";SZ$;TAB(55);LEFT$(TIME$,5)
390 LPRINT:GOSUB570
400 LPRINT
410 FORA=1TON
420 LPRINTTAB(10);ID$(A);TAB(35);UP(A);TAB(45);Q(A);TAB(55);
430 LPRINTUSING"$ #####,.##";TP(A)
440 NEXT
450 GOSUB570
460 LPRINT:LPRINTTAB(35);"TOTAL AMOUNT";TAB(55);:LPRINTUSING"$ #####,.##";TT
470 LPRINTTAB(35);"SALES TAX";TAB(55)"$";
480 IFT$="Y"ORT$="y"THENTX=TT*TAX:LPRINTUSING" #####,.##";TX ELSELPRINTUSING" ######.##";0
490 LPRINT
500 LPRINTTAB(35);"TOTAL AMOUNT DUE";TAB(55);:LPRINTUSING"$ #####,.##";TT+TX
510 LPRINT:IFN$="4"THEN530
520 LPRINTTAB(24);"THANK YOU FOR YOUR PATRONAGE"
530 LPRINTTAB(28);"ANNETTE S. LEVEILLEE":LPRINTCHR$(12)
540 CLS:BEEP:PRINT:PRINT"   This form is complete!"
550 PRINT"     Do Another? (Y/N) ";:Q$=INPUT$(1)
560 IFQ$="Y"ORQ$="y"THENRUN ELSE MENU
570 LPRINT"    __________________________________________________________________":RETURN
580 CLS:PRINT:PRINT"  Choose Form Title:":PRINTTAB(4)"1  Sales Slip"
590 PRINTTAB(4)"2  Invoice":PRINTTAB(4)"3  Statement":PRINTTAB(4)"4  Purchase order"
600 PRINT@280,"  Which Form? ";:N$=INPUT$(1):PRINTN$;
610 IFN$="1"THENS$="SALES SLIP":GOTO660
620 IFN$="2"THENS$="INVOICE":GOTO660
630 IFN$="3"THENS$="STATEMENT":GOTO660
640 IFN$="4"THENS$="PURCHASE ORDER":GOTO660
650 BEEP:PRINT@280,SPACE$(30);:GOTO600
660 RETURN
670 END
680 CLS:'PRINT RESULTS ON SCREEN
690 PRINT "TO:";TAB(5);NM$;TAB(30);DATE$
700 PRINT TAB(5);ST$;TAB(30);DAY$
710 PRINT TAB(5)TN$;" ";SZ$;TAB(30);LEFT$(TIME$,5)
720 PRINT
730 FOR A=1 TO N
740 PRINT TAB(2);ID$(A);TAB(12);UP(A);TAB(20);Q(A);TAB(25);
750 PRINTUSING"$ #####,.##";TP(A)
760 NEXT
770 PRINT:PRINT TAB(12);"TOTAL AMOUNT";TAB(25);:PRINTUSING"$ #####,.##";TT
780 PRINT TAB(12);"SALES TAX";TAB(25)"$";
790 IF T$="Y" OR T$="y" THEN TX=TT*TAX:PRINTUSING" #####,.##";TX ELSE PRINTUSING" #####,.##";0
800 PRINT:PRINT TAB(8);"TOTAL AMOUNT DUE";TAB(25);:PRINTUSING"$ #####,.##";TT+TX
810 PRINT:INPUT "         Form Number";FN$:PRINT "           #";FN$
820 PRINT:INPUT "    Is this correct? Y/N";X$
830 IF X$="Y" OR X$="y" THEN CLS:RETURN
840 IF X$="N" OR X$="n" THEN CLS:GOTO 10
850 END
