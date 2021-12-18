      DF-LAY.BA(c) Randall W. Hess
          All Rights Reserved
      ----------------------------

     DF-LAY.BA will correctly format a "header" for a new DATFIL file from a
"plain language" layout file.  By simply opening a TEXT file and typing your
prompts on the screen as you would like them to appear when using DATFIL,
DF-LAY will automatically prepare a file containing all the field information
in "DATFIL" format.  DF-LAY works on the 100/102 and 200.

     Download this file, remove any extraneous characters, checksum it and
use TEXT F7 & F5 to paste a copy of the 17 lines of code below into BASIC. 
"Save" the program as DF-LAY and save a copy somewhere as a back-up.


    -- OPERATION --
     Open a new TEXT file with any name you choose.  Type all your prompts
where needed.  Use ONLY spaces between your prompts and be sure NOT to exceed
the number of lines your screen displays without scrolling: 8 for 100/102
and 16 for the 200.  If you need to separate two-word prompts by a space then
use a GRPH-SHIFT/Z, CHR$(239), or some other NON-space character BETWEEN the
words. (This prevents DF-LAY from mistaking an inter-word space as the end of
 a prompt and can be removed later by editing the file with TEXT.)  This will
 become your "layout" file and you'll use it to create the "header" lines of
your new DATFIL file.
     Cursor select DF-LAY from the main menu.  At the "Layout:" prompt enter
the name of the file you just created.  DF-LAY will print all your prompts,
one by one, and then erase them, one by one, and return you to the Main Menu.
(DF-LAY adds one space after each prompt for you.)
     There you'll find a new file using the first 5 letters of your layout
filename with a "#" as the 6th.  Try this file using DATFIL and practice with
a few sample records.  Do the prompts make sense?  Is there enough space for
all the info you'll need at each prompt?  Have you left a few "Extra" prompts
in case you decide to add one later?
     When you're satisfied that your layout is as planned then RE-RUN DF-LAY
as before using the same layout file.  NOW re-name your "#" file as needed for
your project.  It's ready for your "real" entries.  Just enter its name at
DATFIL's "File" prompt!

    - - - - - - - - - - - - - - - - -
0 'DF-LAY.BA(c)1990RWHess
1 CLS:CLEAR500:MAXFILES=2:DEFSTRA-F:D=" ":ONERRORGOTO17
2 FILES:PRINT:LINEINPUT"Layout: ";F:IFF=""THEN13ELSECLS
3 M=INSTR(F,"."):IFMTHENF=LEFT$(F,M-1)
4 A=LEFT$(F+"     ",5)+"#"
5 OPENFFORINPUTAS1:C="":I=-1
6 GOSUB15:N=0:IFB=DTHEN6
7 IFB=CHR$(9)THENI=I+7:GOTO6
8 IFB=CHR$(10)THENN=1:I=I+39-IMOD40:GOTO6
9 IFB=CHR$(13)THEN6ELSEK=I:L=L+1
10 C=C+B:GOSUB15:IFB>DTHEN10ELSEGOSUB14:GOTO6
11 IFJ=0THENJ=L:CLOSE:OPENAFOROUTPUTAS2:PRINT#2,J:PRINT@0,;:GOTO5
12 IFN=0THENGOSUB14
13 CLOSE:MAXFILES=1:MENU
14 IFJTHENPRINT#2,C" ":PRINT#2,MID$(STR$(K),2,3):C="":RETURNELSERETURN
15 IFEOF(1)THEN11ELSEB=INPUT$(1,1):I=I+1:PRINT@I,;:IFJTHENPRINTD;ELSEPRINTB;
16 RETURN
17 IFERR=55ORERR=52THENBEEP:RUNELSEPRINT"E"ERR"L"ERL:END
    - - - - - - - - - - - - - - - - - -

              CREDITS

     Wilson Van Alst suggested the idea for DF-LAY.  Paul Globman wrote
DATFIL.100/200 which gives us something to do with a file full of prompts. 
Tony Anderson's CRDFIL.BA got us all thinking about electronic file boxes.

             /-/-/-/-/
Randy Hess
73267,552
Omaha, Ne
1/90
