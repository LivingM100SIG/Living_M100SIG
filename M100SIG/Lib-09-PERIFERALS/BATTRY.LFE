10 'Battery run-time program
14 CLS:PRINT "BATTERY RUNDOWN TEST"
15 PRINT"If testing Chipmunk, remove disk NOW!"
20 OPEN"RUNTIM.do"FOR APPEND AS 1
30 T$=MID$(TIME$,4,1)
40 PRINT@250,TIME$
50 IF MID$(TIME$,4,1)=T$THEN40ELSEPRINT#1,TIME$;:PRINT@210,TIME$;"  last recorded"
55 IF INP(130)AND2THENPRINT#1,"Drive locked out";:GOTO60
58 IF INP(130)AND1THENPRINT#1,"Low Power Light CHIPMUNK";
60 PRINT#1,:CLOSE:GOTO20
99 '  Runs down battery, creates RAM file of times so you can judge later how far it got.  If CHIPMUNK attached, also notes RED LIGHT ON and subsequent DRIVES LOCKED OUT condition in RAMfile.
100 'CAUTION:  When Chipmunk batteries flat, it comes up with drive on.  So turn off its power, then recharge.
101 ' W.H.Calvin  71256,1353
