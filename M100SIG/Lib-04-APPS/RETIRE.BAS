10 CLS: 'RETIRE.BA By Don Galt, 70126,1417, (MODEL-100 Basic).
15 ' COPYRIGHT 1989 DON GALT
20 PRINT"	This program estimates PRESENT 		INVESTMENTS to pay FUTURE COSTS"
30 PRINT"	Use as retirement planing tool."
40 PRINT"	For actual planning you should 		seek assistance."
50 PRINT""
100 INPUT"    Present ANNUAL COST of living, 	    college, etc.";A
110 INPUT"    Expected level of future costs	    i.e. present level=100, normal 	    retirement=75";C
120 INPUT"    Number of YEARS until money 	    needed";R
130 INPUT"    Expected annual INFLATION rate 	    ex.<4>";W
140 INPUT"    Enter average RETURN expected	    during fund accumulation period  	    ex.<9>%";SI
150 INPUT"    Enter number of years fund is to be     used   ex.<Ret.=20, school=4 or 6>      ";T
160 INPUT"    Enter expected % rate during time       fund is being used  ex.<6>%";I
200 W=(W/100)+1:I=I/1200:C=C/100
210 PMT=(A*C*((W)^(R)))/12
230 T=T*12
240 PV=PMT*(1+I)*(1-(1+I)^-T)/I
300 FV=PV:SI=SI/1200:N=R*12
310 PT=(FV/(1+SI))*(SI/(((1+SI)^N)-1))
320 CLS
400 PRINTUSING"    MONTHLY INVESTMENTS OF $$#,### WILL     YIELD";PT;
500 PRINTUSING"$$##,###,### IN SAVINGS";PV;
600 PRINTUSING" GIVING     YOU A MONTHLY DIVIDEND OF$$###,###";PMT;
610 PRINT"      WHICH IS ADJUSTED FOR INFLATION AND	    EXPENSE LEVEL"
620 PRINT"":PRINT""
700 INPUT"    ANONTER CALCULATION Y/N";Z$
710 IF Z$="Y"GOTO10ELSEMENU


