PAKKEY.BAS By Carmen Paone [72677,42]

James Yi's version 1.2 of PAKDOS.CO, available for the Model 100 and 102 in
DL9 of this Forum and in DL10 for the Model 200, is a giant leap forward in
disk operating systems for our favorite laptops.

PAKDOS allows the user access to both sectors of a TDD-2 disk and also adds a
file packing and unpacking feature.

After using PAKDOS, I started to tinker with the idea of devising a key-driven
utility for it. The result is PAKKEY.BAS with the .BAS meaning it will work on
the Model 100, 102 and 200.

PAKKEY.BAS saves the PAKDOS user many key strokes when operating the nifty
DOS. It is divided into two sets of special keys. The first deals with the
functions of loading and saving files and the second deals with packing and
unpacking files.

PAKKEY.BAS will also work with the options outlined by Yi in PAKDOS.DOC.

The default for most operations is "0:" but the default can be changed to a
"1:" by using the "DEL/BKSP" key to remove "0:" and then typing in "1:"

As in all PAKDOS operations the name of the file to be loaded, saved, packed,
etc must be typed in after the command and the user must include the file
extension, too.

PAKKEY.BAS won't work unless PAKDOS.CO is in resident in RAM. There is no need
to clear space to MAXRAM before running PAKKEY.BAS because the program will do
that job for you. Also, there is no need to clear the space to MAXRAM after
PAKKEY.BAS has been used because the program will do that for you, too

For those users who are using the NODE DATAPAC and the NODE ROM chip,
PAKDOS.CO can be run from the DATAPAC in the 100/102 or the 200 by changing
line 7 to the following:

7
IFPEEK(1)=171THENCALL61162,8:CLEAR256,56313:A$="PAKDOS.CO":CALL61162,22,VARPTR(A$)ELSECALL63013,8:CLEAR256,58373:A$="PAKDOS.CO":CALL63013,22,VARPTR(A$)

This feature won't work with Paul Globman's RAMDSK.CO.

Users of Globman's XOS on the Tandy 200 can call PAKDOS.CO from Bank 3 by
modifying Line 7 of PAKKEY.BAS to read like this:

7
CLEAR256,56513:F$="3:PAKDOS.CO":CALL41179:CALL63600,8,VARPTR(F$):IFPEEK(61302)=0THENCALL56513


Programming notes:

When reading over the line listings for PAKKEY.BAS, you will see a number of
"CALL" statements. The folowing table will tell what each "CALL" is designed
to do.


100/102	  200	   FUNCTION
------    ---	   --------
17001	  20360	   REVERSE VIDEO ON
17006	  20365	   REVERSE VIDEO OFF
17034	  20393	   CLEAR LABEL LINE
17064	  20423	   DISPLAY LABEL LINE

CALL23164,0,23366:CALL27795 restores the normal function key set in the
100/102.
CALL28192,0,28357:CALL33747 restores the normal function key set in the 200.

The "IF PEEK(1)=171THEN" statement determines which laptop you are using when
running PAKKEY.BAS. It checks the ROM byte at address 01 Hex, or 1 decimal.
The "171" means the machine is a 200.


Cut and paste the program below the dotted line and put into a .DO file called
"PAKKEY"; run the file through BASIC and save it as "PAKKEY.BA"



.......................................


0 REM PAKKEY.BAS BY CARMEN PAONE [72677,42]
1 CLS:IFPEEK(1)=171THENRV=20360:NV=20365ELSERV=17001:NV=17006
2 PRINT@0,STRING$(40,239):CALLRV::PRINT@2,"PAKDOS COMMANDS":PRINT@20,"SET 1":PRINT@29,"SET 2":PRINT@86," 1 = SET 1 ":PRINT@166," 2 = SET 2 ":PRINT@246," ESC = RAM ":CALLNV
3 PRINT@60,"FILES"SPACE$(4)"FILES":PRINT@100,"DISK"SPACE$(5)"DISK":PRINT@140,"LOAD"SPACE$(5)"PACK":PRINT@180,"SAVE"SPACE$(5)"UNPACK":PRINT@220,"KILL"SPACE$(5)"OMIT":PRINT@260,"ERASE"SPACE$(4)"VIEW":PRINT@300,"TYPE"SPACE$(5)"READ";
4 K$=INKEY$:IFK$=""THEN4ELSEIFK$="1"THEN5ELSEIFK$="2"THEN9ELSEIFK$=CHR$(27)THEN:IFPEEK(1)=171THENCALL28192,0,28357:CALL33747:GOTO10ELSECALL23164,0,23366:CALL27795:GOTO10
5 CLS:KEY1,"FILE -L"+CHR$(13):KEY2,"DISK 0:":KEY3,"LOAD 0:":KEY4,"SAVE 0:":KEY5,"KILL -L"+CHR$(13):KEY6,"ERAS 0:":KEY7,"TYPE 0:":KEY8,"QUIT"+CHR$(13)
6 IFPEEK(1)=171THENCALL20423ELSECALL17064
7 IFPEEK(1)=171THENCLEAR256,56513:RUNM"PAKDOS"ELSECLEAR256,58373:RUNM"PAKDOS
8 IFPEEK(1)=171THENCALL20393:GOTO1ELSECALL17034:GOTO1
9 CLS:KEY1,"FILE -L"+CHR$(13):KEY2,"DISK 0:":KEY3,"PACK 0:":KEY4,"UNPK 0:":KEY5,"OMIT":KEY6,"READ 0:":KEY7,"VIEW 0:":KEY8,"QUIT"+CHR$(13):GOTO6:GOTO7:GOTO8
10 CLEAR256,MAXRAM:MENU
