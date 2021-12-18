0 '9/8/88
15 '<print record status>
21 '<varptr>
24 'to call:set LL=legnth,PT=memory pos
30 '<read random record>
33 'field data=MID$(RC$,FP(field#),FL(field#))
39 '<write random record>
45 '<command input>
63 '<save past cmds>
69 '<recall past cmds>
78 '<input>
79 'SP=screen position   RO=reverse video flag (1=rev,0=normal)
129 '<append>
141 '<edit>
195 'move record pointer
210 '<convert to upper case>
219 '<display structure>
231 '<get field list>
234 'F()=fields to list, etc
249 '<get expression>
252 'CF=expression field#,CO=condition operator,CD$=condition string,NG=flag for bad input
285 '<direct to device>
300 '<list>
321 'format printout
345 '<count>
372 '<sum,average>
387 '<test condition>
390 'NG=0 if condition met
405 'string
420 'val
435 '<format date for compare as string>
438 'D1$=date passed to sub,D2$=date reformatted
444 '<display>
453 '<locate>
468 '<cont>
477 '<evaluate command input>
478 'CS$():1=APPEND,2=DIR,3=AVERAGE,4=EDIT,5=USE,6=COUNT,7=LIST,8=GO,9=SUM,10=LOCATE,11=QUIT,12=DISPLAY,13=CONT,14=?,15=DISPLAY STRUCTURE,16=FILES,17=MENU
537 '<use>
540 'NR=#rec,SZ=rec size,NF=#fields,F$()=field data,RC$=records,FP()=field pos in rec,FL()=field lengths
591 '<errors>
599 '<assistant>
629 '<diplay field list>
