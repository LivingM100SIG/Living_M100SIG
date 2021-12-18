5 ' Copyright 1988 by John Arterburn Jr  [70721,1000]  All rights reserved

10 PRINT"This program converts Miles Per Hour,"
20 PRINT"into Feet Per Minute and vice versa!"
21 PRINT
22 PRINT
23 PRINT
24 CLEAR
25 PRINT"Enter M for MPH or F for FPM!"
30 INPUT"M or F ?";A$
35 IF INSTR(" ",A$)=1 THEN GOTO 23
40 IF INSTR("m",A$)=1OR INSTR("M",A$)=1 THEN GOSUB 1000
50 IF INSTR("f",A$)=1OR INSTR("F",A$)=1 THEN GOSUB 2000 
60 PRINT"Do you want another conversion?   Y/N"
70 INPUT"Y/N";B$
80 IF INSTR("y",B$)OR INSTR("Y",B$)=1THEN GOTO 25
90 MENU
1000 INPUT"Value in MPH";Z
1010 X=Z*5280/60
1020 PRINT"MPH="Z;"FPM="X
1030 RETURN
2000 INPUT"Value in FPM";W
2010  Y=W*60/5280
2020 PRINT"FPM="W;"MPH="Y
2030 RETURN
