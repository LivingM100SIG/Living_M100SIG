SORT.CMD  By Tony Anderson

Original text and modifications Copyright 1990 Tony B. Anderson; All Rights
Reserved


For the Model 100/102 only!


This program is derived from Howard Sprow's 1987 Contest entry, HOWBIG.BA, and
support code by Wilson Van Alst in his ZIPSRT.DOC file, which tells how to call
his ZIPSRT.CO program from a BASIC program.  This is one of a series of main
menu command programs derived from the original concept.  As used here, the
program is designed to be a resident, invisible command program, which will
allow the user to sort a cursor-selected file at the main menu by simply typing
SORT and pressing the ENTER key.

Thanks to Arnold Silverman for suggesting this as a needed main menu utility.


How to make it operational:

1. Load the below program into BASIC - you can delete lines 0-2 to save RAM
space - and save it to the menu as SORT.BA.  This is important, because the
name becomes the command when you make the program invisible.

2. Download, Load and save CMD.100 to your menu as CMD.BA.  (CMD.100 is in
Library 8.)

3. With both programs on the main menu, move the wide cursor over SORT.BA,
type CMD.BA and press the ENTER key.  SORT.BA will disappear from the menu,
but will have been changed to SORT (no extension), and will have been made
invisible.  Once the program is invisible, you can remove CMD.BA from the
computer by killing it. (In BASIC, type KILL"CMD.BA" and press the ENTER key)

To use the program, you will also need to have ZIPSRT.CO available in the
computer.  ZIPSRT can be invisible if you wish.  To make it invisible, you can
run CHANGE.BA, or one of the invisible utilities in Library 7, DIREDT.100,
UNVISI.LG1, SEEFYL.BA, or INVISI.100.  Or you can use the INVIS.BA program at
the end of this file which will toggle it, invisible or visible.  It is not
necessary to have any of the invisiblity programs in RAM when you are using one
of the invisible utility programs.  So use it to make the selected program
invisible, then remove it from the computer.


To use SORT as a main menu command, move the wide cursor bar over the name of
the file you wish to sort, type SORT and press the ENTER key.  The screen will
clear, and you will see the report "Sorting...".  If it's a small file, it may
only flash for a second or two.

If the file sorts successfully, you will be returned to the main menu, if not,
if there was a problem of some sort, you will drop into BASIC with an error
report, usually a function call error.

SORT will remain resident and invisible until you have a cold-start, or until
you deliberately remove it.  To edit the program, you can use CHANGE.BA to
rename it as a normal .BA program and make it visible again.  If you only want
to kill SORT, you can enter BASIC and type KILL"SORT" and press the ENTER key.

The program, after removing lines 0 through 2, will use 277 bytes of RAM space.
You can save an additional 12 bytes of RAM space by combining lines 10-16 into
one line.

If you want an indication that the computer has an invisible program resident,
go into BASIC and type POKE 63850,43.  That will place a plus sign after BASIC
on the main menu as a reminder.  If you want to remove that indication - the
plus sign - use POKE 63850,32.


Note the statement C=1 at the end of line 14.  This causes ZIPSRT to sort the
entire file, starting at column #1.  If you normally need to sort on a different
column, change the value of C to equal the starting sort column.  If you want
to be prompted for what column to start the sort with, the way ZIPSRT normally
works, change C to 0.  This will also allow you to skip sorting some of the
lines at the top of the file.  See the ZIPSRT.DOC file for details on this
proceedure.

If you sometimes sort files starting at column 1, and sometimes start the sort
at other columns, then it would probably be best for you to make C=0, so you
could be prompted for the starting position each time.  However, if you ALWAYS
sort starting with column 1, then C=1 saves the step of responding to ZIPSRT's
prompt, and the sorting process becomes entirely invisible.

Another option is to load a second version of the program under a different
name.  You could have SORT as a general purpose sort program, and SORT10 to
start sorting at column 10, by changing the value of C to C=10 in the SORT10
version.


0 '  SORT.CMD  - Sorts cursor-selected file at the main menu. By TBA 11/18/90. For 100/102 only.

1 ' Based on original code by Howard Sprow (HOWBIG.BA), and Wilson Van Alst (ZIPSRT.DOC). Save as SORT.BA, then run Paul Globman's CMD.100 program (Lib 8).

2 ' Also requires Wilson Van Alst's ZIPSRT.CO to be loaded and resident in the computer, which can be invisible if you like.

4 CLS:X$="":M=PEEK(65006):D=(PEEK(64930+(2*M)))*256+PEEK(64929+(2*M)):IFPEEK(D)=192THEN10ELSEBEEP:MENU

10 POKE64990,INT(D/256):POKE64991,D-(INT(D/256)*256):LOADM"ZIPSRT":PRINT@42,"Sorting..."

12 X$="":X=VARPTR(X$):POKEX,11:POKEX+1,PEEK(64991):POKEX+2,PEEK(64990)

14 N$=MID$(X$,4,6)+CHR$(0):C=1

16 V=VARPTR(N$):V=PEEK(V+1)+256*PEEK(V+2):CALL64720,C,V:MENU



You may use this small program to make ZIPSRT.CO invisible or visible again:


0 ' INVIS.BA  Program makes ZIPSRT.CO file invisible or visible again.
1 ' Copyright 1990 Tony B. Anderson, All Rights Reserved
10 CLS:IFPEEK(1)=171THENW=62052:X=62034:Y=45 ELSEW=63860:X=63842:Y=24
15 Z=Y*11+X
20 FORA=XTOZSTEP11
30 IFPEEK(A)=160THENGOSUB100
35 IFPEEK(A)=168THENGOSUB100
40 NEXT:END
100 A$="":FORB=A+3TOA+8
110 A$=A$+CHR$(PEEK(B))
120 NEXT
130 IFA$="ZIPSRT"THEN150
140 RETURN
150 IFPEEK(A)=160THENPOKEA,168:POKEW,43:MENU
160 IFPEEK(A)=168THENPOKEA,160:POKEW,32:MENU
