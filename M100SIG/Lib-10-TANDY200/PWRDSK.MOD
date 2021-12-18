0 'PWRDSK.MOD (c)1989 Wilson Van Alst			All rights reserved
1 'Changes LFILES and LFILES TO for a full-screen file display, instead of
2 'the usual 15-at-a-time.
3 'File length information is no longer given.
4 '
5 'Run this program with POWR-DISK active.
6 '
10 DEFINTA-Z:ONERRORGOTO50
20 IF58960-MAXRAMOR5-PEEK(33)THENBEEP:PRINT"T200 only.  POWR-DSK must be installed.":END
30 FORR=-6362TO-6357:POKER,CHIP:NEXT
40 POKE-Y,SEX:READY,SET:GOTO40
50 IFERL-40THENPRINT"Bad listing":ENDELSEMENU
60 DATA6378,10,6343,205,6342,62,6341,79,6266,201
