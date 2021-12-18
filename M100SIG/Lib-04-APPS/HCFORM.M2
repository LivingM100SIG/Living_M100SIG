

Load HCFORM.BA into Basic, then Merge the following, after deleting this
introduction.  This modification will save the following information:

 < Date, Slip #, Amount without tax, and Name >.

to files SALES.DO, INVCE.DO, STAT.DO, or PO.DO.  These files can then be edited
or printed from the TEXT program.  

Norm Leveillee 72327,1025  Feb 21, 1988

***DELETE LINES ABOVE BEFORE MERGIN****

290 CLS:PRINT:PRINT:PRINT TAB(13);" >Printer ON<"
295 PRINT:PRINT:PRINT"   Now ready for printer output!                Press ENTER when ready... ";:Q$=INPUT$(1)
300 PRINT:PRINT:PRINT"   Output now going to printer..."
350 LPRINT:LPRINT TAB(40-LEN(S$))CHR$(14)S$:LPRINT TAB(38)FN$;LPRINT 'CHR$(14)=One line expanded mode
385 LPRINT:LPRINT TAB(13)"ITEM";TAB(35)"PRICE";TAB(44)"QNTY";TAB(58)"AMOUNT"
550 PRINT:PRINT"        Do Another? (Y/N) ";:Q$=INPUT$(1)
740 PRINT TAB(2);ID$(A)
745 PRINT TAB(12);UP(A);TAB(20);Q(A);TAB(25);
830 IF X$="N" OR X$="n" THEN CLS:GOTO 10
840 IF X$="Y" OR X$="y" THEN GOTO 850
850 IF N$="1" THEN GOTO 910
860 IF N$="2" THEN GOTO 920
870 IF N$="3" THEN GOTO 930
880 IF N$="4" THEN GOTO 940
910 CLOSE:OPEN "SALES" FOR APPEND AS 1:GOTO 1000
920 CLOSE:OPEN "INVCE" FOR APPEND AS 1:GOTO 1000
930 CLOSE:OPEN "STAT" FOR APPEND AS 1:GOTO 1000
940 CLOSE:OPEN "PO" FOR APPEND AS 1:GOTO 1000
1000 PRINT #1,DATE$;TAB(2)"#";FN$;TAB(2)"$";TT;TAB(3)NM$:CLOSE
1010 PRINT:INPUT"   To Printer ? Y/N";X$
1020 IF X$="Y" OR X$="y" THEN CLS:RETURN
1030 IF X$="N" OR X$="n" THEN CLS:GOTO 550
1040 END
