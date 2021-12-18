FULL12.100, FULL12.200, FULL-P.100 and FULL-P.200 started life as baby-fat
laden programs.

Sysop Tony Anderson's welcomed suggestions about how to trim the programs down
from over 1,000 bytes each to just under 300 bytes each were utilized in the
refined entries.

This was a case of not throwing the baby out with the bathwater.

FULL12.100 and FULL12.200 will allow a programmer to display the full name of
the day and month in his or her programs.

FULL-P.100 and FULL-P.200 will allow the user to stamp the full name of the
day and month on documents without typing them in.

=========PROGRAMMING NOTE===========

The value for the number of the day is stored at 63787 in the 100 and 61976
in the 200.

The value representing the number of the month is stored at 63788 in the 100
and at 61979 in the 200.

Anderson's suggestion to use DATA tables for the day and the month and to
PEEK the stored values improved both programs greatly.


The programs for the 100 and 200 are listed below the dotted lines


..............FULL12.100..............


1 DATASUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY:FORA=0TOPEEK(63787):READA$:NEXTA
2 DATAJANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER:RESTORE2:FORA=1TOPEEK(63788):READB$:NEXTA
3 CLS:PRINT@3,A$:PRINT@14,B$:PRINT@24,MID$(DATE$,4):PRINT@26,SPACE$(3):PRINT@28,"19"MID$(DATE$,7):PRINT@40,STRING$(40,241);



...............FULL12.200..............


1 DATASUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY:FORA=0TOPEEK(61976):READA$:NEXTA
2 DATAJANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER:RESTORE2:FORA=1TOPEEK(61979):READB$:NEXTA
3 CLS:PRINT@3,A$:PRINT@14,B$:PRINT@24,MID$(DATE$,4):PRINT@26,SPACE$(3):PRINT@28,"19"MID$(DATE$,7):PRINT@40,STRING$(40,241);


...............FULL-P.100..............


1 MAXFILES=1:CLS:PRINT:INPUT"FILE";F$:PRINT:INPUT"DATE";D$:OPENF$FORAPPENDAS1
2 DATASUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY:FORA=0TOPEEK(63787):READA$:NEXTA
3 DATAJANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER:RESTORE3:FORA=1TOPEEK(63788):READB$:NEXTA
4 PRINT#1,SPACE$(5)A$SPACE$(2)B$SPACE$(2)D$CHR$(44)SPACE$(2)"19"MID$(DATE$,7):MENU


...............FULL-P.200..............


1 MAXFILES=1:CLS:PRINT:INPUT"FILE";F$:PRINT:INPUT"DATE";D$:OPENF$FORAPPENDAS1
2 DATASUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY:FORA=0TOPEEK(61976):READA$:NEXTA
3 DATAJANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER:RESTORE3:FORA=1TOPEEK(61979):READB$:NEXTA
4 PRINT#1,SPACE$(5)A$SPACE$(2)B$SPACE$(2)D$CHR$(44)SPACE$(2)"19"MID$(DATE$,7):MENU
