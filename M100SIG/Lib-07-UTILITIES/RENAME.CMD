RENAME.100  By Tony Anderson

Original text and modifications Copyright 1990 Tony B. Anderson; All Rights
Reserved


For the Model 100/102 only.


This program is derived from Howard Sprow's 1987 Contest entry, HOWBIG.BA, and
is one of a series of main menu command programs derived from the original
concept.  As used here, it is designed to be a resident, invisible command
program, which will allow the user to rename a cursor-selected file or program
at the main menu by simply typing RENAME and pressing the ENTER key.  User is
then prompted for the new name, the old file is renamed, and the user is
returned to the main menu.

The new name requires the file extension to be included, and the program checks
to make sure you have included the proper extension.  Only valid extensions are
allowed, .BA, .DO, and .CO.  If you forget to include the extension, or use a
non-standard extension, you will be asked to try again, or get a function call
error and be dropped into BASIC.

Thanks to Gene Nestro for suggesting this as a needed main menu utility.


How to make it operational:

1. Load the below program into BASIC - you can delete lines 0 and 1 to save RAM
space - and save it to the menu as RENAME.BA.  This is important, because the
name becomes the command when you make the program invisible.

2. Download, Load and save CMD.100 to your menu as CMD.BA.  (CMD.100 is in
Library 8.)

3. With both programs on the main menu, move the wide cursor over RENAME.BA,
type CMD.BA and press the ENTER key.  RENAME.BA will disappear from the menu,
but will have been changed to RENAME (no extension), and will have been made
invisible.  Once the program is invisible, you can remove CMD.BA from the
computer by killing it. (In BASIC, type KILL"CMD.BA" and press the ENTER key)

To use the program, at the main menu, move the wide cursor bar over the name of
a file or program you wish to rename, type RENAME and press the ENTER key.  The
screen will clear, and the program will ask for the new name.  Type the new
name, including the file extension.  If the file is renamed successfully, you
will return to the main menu.  If there was a problem, you will drop into BASIC
with an error report, usually a function call error.

RENAME will remain resident and invisible until you have a cold-start, or
deliberately remove it.  To remove or edit the program, you can use CHANGE.BA
to rename it as a normal .BA program and make it visible.  If you only want to
kill it, you can enter BASIC and type `KILL"RENAME"' and press the ENTER key.

The program, after removing lines 0 and 1, will use 319 bytes of RAM.


If you want an indication that the computer has an invisible program resident,
go into BASIC and type POKE 63850,43.  That will place a plus sign after BASIC
on the main menu as a reminder.  If you want to remove that indication - the
plus sign - use POKE 63850,32.

Program = 319 bytes when lines 0 and 1 are removed


 0 '  RENAME.100  - Renames Cursor-selected file at the main menu. by TBA 11/18/90
 
 1 ' Based on original code by Howard Sprow (HOWBIG.BA). For 100/102 only. Save as RENAME.BA, then run Paul Globman's CMD.100 program (Lib 8).
 
 2 CLS:X$="":M=PEEK(65006):D=(PEEK(64930+(2*M)))*256+PEEK(64929+(2*M)):S=PEEK(D):IFS=128ORS=160ORS=192THEN4ELSEBEEP:MENU
 
 4 X=VARPTR(X$):A=INT(D/256):B=D-A*256:POKEX,11:POKEX+1,B:POKEX+2,A
 
 8 N$=MID$(X$,4,6)+"."+MID$(X$,10,2)
 
 10 PRINT@122,"Rename "N$" as: ";:LINEINPUT"";A$:ONERRORGOTO20:NAMEN$ASA$:MENU
 
 20 CLS:PRINT@42,"Naming error: ";:IFINSTR(A$,".")THENPRINT"try again" ELSEPRINT"include extension"
 
 22 GOTO10
