Load HCFORM.BA into Basic, then Merge the follow HCADD.DO, after deleting
this introduction.  This modification will save to a file SALES.DO 
< Date, Slip #, Amount without tax, and Name > to keep track of sales. 
This file can then be edited or printed from the TEXT program.  
Norm Leveillee 72327,1025
***DELETE LINES ABOVE BEFORE MERGIN****

290 CLS:PRINT:PRINT:PRINT"   Now ready for printer output!                Press ENTER when ready... ";:Q$=INPUT$(1)
300 PRINT:PRINT:PRINT"   Output now going to printer..."
550 PRINT:PRINT"        Do Another? (Y/N) ";:Q$=INPUT$(1)
740 PRINT TAB(2);ID$(A)
745 PRINT TAB(12);UP(A);TAB(20);Q(A);TAB(25);
830 IF X$="N" OR X$="n" THEN CLS:GOTO 10
840 IF X$="Y" OR X$="y" THEN GOTO 845
845 IF N$="1" OR N$="2" THEN GOTO 850 ELSE GOTO 880
850 OPEN "SALES" FOR APPEND AS 1
860 PRINT #1,DATE$;TAB(2)"#";FN$;TAB(2)"$";TT;TAB(2)NM$
870 CLOSE
880 PRINT:INPUT"   To Printer ? Y/N";X$
890 IF X$="Y" OR X$="y" THEN CLS:RETURN
900 IF X$="N" OR X$="n" THEN CLS:GOTO 550
910 END
