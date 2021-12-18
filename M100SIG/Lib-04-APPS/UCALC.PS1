0 CLS:INPUT" 1)A+B 2)A-B 3)A*B 4)A/B 5)A%B <EN>";C:IFC<1ORC>5THEN0ELSEC$=MID$("+-*/%",C,1):PRINTTAB(5)C$;:INPUT" A,B";A,B
1 A(1)=A+B:A(2)=A-B:A(3)=A*B:A(4)=A/B:A(5)=A*B/100:PRINTTAB(10)STR$(A)" "C$STR$(B)" ="STR$(A(C)):INPUT"<EN>";D:GOTO0
2 '1 line Calculator by Peter Stanwyck
 may