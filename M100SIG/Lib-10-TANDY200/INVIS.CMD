   INVIS.CMD  operating instructions
   Copyright (c) 1990 by Paul Globman
   ==================================

INVIS.CMD requires that XOS-C is installed and INVIS.CO is stored in bank #3.

INVIS.CO is to be used _only_ via the F3(Cmd) key and will make the file under
the widebar cursor invisible.  DO NOT run INVIS.CO from the Menu or BASIC.

Invisible files can be killed from BASIC.  Text files can be entered through
TEXT, and programs can be run from BASIC or the XOS F3(Cmd) key.

Select the file or program that you wish to make invisible by placing the wide-
bar cursor over the filename, at the Tandy 200 menu.  Press the F3(Cmd) key and
at the Cmd> prompt type INVIS <cr>.

Invisible files are displayed along with visible files with the XOS F7(File)
key, at the menu.

  
1 '************************
2 '*  INVIS .CO           *
3 '*    by Paul Globman   *
4 '*  Copyright (c) 1990  *
5 '************************
10 FOR I = 63572 TO 63580 
20 READ X:POKE I,X:SM=SM+X
30 NEXT
40 IF SM = 1414 THEN 60
50 PRINT"error in data":STOP
60 SAVEM"INVIS .CO",63572,63580,63572
1000 DATA 205,213,161,246,8,119,195
1010 DATA 164,103 
1020 REM       END OF DATA
