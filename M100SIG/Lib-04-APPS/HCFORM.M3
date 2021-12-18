Modification to HCFORM.BA with the merging of HCAD3.DO so that all
 information is saved to a .DO file. Load HCFORM.BA into Basic and MERGE the HCAD3.DO file and save as HCFORM.BA
***** DELETE the ABOVE LINES BEFORE MERGING *****
1000 PRINT #1,DATE$;TAB(2)"#";FN$;TAB(2);NM$;TAB(2)ST$;TAB(2);TN$;TAB(2)SZ$;TAB(2)TT;TAB(2)TT+TX
1002 FOR A=1TO N
1004 PRINT #1,ID$(A);TAB(2);UP(A);TABA(2);Q(A);TAB(2);TP(A):NEXT
1006 PRINT #1
