
DOC's:

With today's high unemployment rate, I thought it might be helpful to have a
quick-and-easy program to figure out unemployment benefits.  I have only the
information and formula for my own state, of course, but you can follow the
general program concept, inserting your own state's method of calculation to
arrive at the figures you want.

Put your state's weekly benefit amount in line 100.  Then check the method of
computation in lines 265-300; and again in lines 380-410.  Of course, change
"Nevada" to your state's name, wherever it appears.

In Nevada, the amount you will be paid weekly, is based on the amount you made
in the highest quarter during the qualifying period, which is the first four of
the last five completed calendar quarters.  The weekly benefit amount is 1/25th
of the total wages earned in the highest quarter, but not more than the highest
weekly benefit amount currently being paid.  In Nevada, that's $214.00.

The total amount you will be paid is one-third of the total amount you earned
during the qualifying quarters.

The number of weeks you will get a check, is the total amount you will be paid,
divided by the amount paid weekly.

By reversing the figures, you can figure out how much you have to earn, both to
get the highest weekly benefit, and to get it for the longest period of time.
For example, knowing that $214 is the highest weekly benefit, and that the
award is 1/25th of the wages earned in the highest quarter, 214 * 25 = 5350. In
Nevada, in order to get the full weekly benefit, in at least one quarter of the
qualifying period, you had to have earned at least $5,350.

In order to figure how much of the year you'd have to work to get the full 26
weeks benefits, figure 214 * 26 * 3.  That equals $16,692. So in order to get
the full weekly benefit for 26 weeks, you had to have earned $16,692 in the
qualifying period.

I know this may seem to be a lot of detail, but it may be important to know,
especially for seasonal workers, or those preparing to file a new claim.  For
example, a part-time worker can use the information to "schedule" his work, so
that he maximizes the benefit, by working all the time he can get during at
least one quarter of the year, then slacking off the rest of the year - using
his unemployment as a form of "vacation pay".  Or, when filing a new claim, you
may find that if you wait until the next quarter to file, the benefits would be
higher, or be for more weeks.  An example of this would be where filing at the
end of a quarter would yield one benefit, but waiting until the next quarter
would increase that amount significantly.


The below program will give you figures based on filing now, and waiting to
file in the next quarter.  Sometimes there is a significant difference.


Check with your Unemployment Office to determine the computaion method in your
state.  There may also be an alternate method of calculation which may apply to
seasonal workers.  In Nevada, "seasonal worker" is defined as anyone who has
earned wages in two or less quarters per year.  It applies mainly to ski resort
employees who work mainly during the winter skiing season.  (Yes, we have a few
Ski Resorts in Nevada... and even more in the Sierra Nevada across the
California line, many of whose employees actually live on the Nevada side.)


Hope this is useful to you. It runs interchangeably on either the Model 100/102
or Tandy 200.



0 ' UNEMP.BA  Unemployment Calculator
1 '
2 ' Copyright 1992 Tony B. Anderson, All Rights Reserved
3 '
100 WB=214 :' Maximum weekly benefit amount currently paid in your state
110 CLS:IFPEEK(1)=171THENM=600ELSEM=280
120 PRINT@48,"Unemployment Calculator                 for the State of Nevada":PRINT
130 PRINT"Unemployment is based on the amount you earned in the first four of the last    five completed quarters."
140 GOSUB 500
150 CLS:PRINT"Enter the amount you earned in each of  the qualifying quarters:":PRINT
160 INPUT"  1st Quarter:  $ ";Q(1)
170 Q(0)=Q(1)
180 INPUT"  2nd Quarter:  $ ";Q(2)
190 IFQ(2)>Q(0) THEN Q(0)=Q(2)
200 INPUT"  3rd Quarter:  $ ";Q(3)
210 IFQ(3)>Q(0) THEN Q(0)=Q(3)
220 INPUT"  4th Quarter:  $ ";Q(4)
230 IFQ(4)>Q(0) THEN Q(0)=Q(4)
235 INPUT"  5th Quarter:  $ ";Q(5)
240 GOSUB500
250 CLS:PRINT
260 PRINT"Your highest quarter earnings were      $";Q(0);CHR$(8);".":PRINT
265 ' Benefit (X) is 1/25th of the amount you earned in the highest quarter, 
266 ' but not more than the weekly benefit amount paid in your state
270 X=INT(Q(0)/25)
280 IFX>WBTHENX=WB
285 ' The number of weeks you collect is equal to the total amount you earned 
286 ' in the qualifying quarters, divided by 3, then divided by the weekly 
287 ' benefit amount - but not more than 26 weeks
290 Y=INT(((Q(1)+Q(2)+Q(3)+Q(4))/3)/X)
300 IFY>26THENY=26
310 PRINT"Under Nevada law, you are qualified to  receive $";:PRINTUSING"###.## per week, for ## weeks.";X;Y
320 GOSUB500
330 CLS:PRINT:PRINT"If you file NEXT quarter, Your highest  quarter earnings would be $";Q(0);CHR$(8);","
340 PRINT"and your benefits would be: ";
350 Q(0)=Q(5):IFQ(2)>Q(0)THENQ(0)=Q(2)
360 IFQ(3)>Q(0)THENQ(0)=Q(3)
370 IFQ(4)>Q(0)THENQ(0)=Q(4)
380 X=INT(Q(0)/25)
390 IFX>WBTHENX=WB
400 Y=INT(((Q(5)+Q(2)+Q(3)+Q(4))/3)/X)
410 IFY>26THENY=26
420 PRINTUSING"$###.## per week, for ## weeks.";X;Y
430 GOSUB500
490 END
500 PRINT@M,"Press ENTER to continue...";:Q$=INPUT$(1):RETURN
