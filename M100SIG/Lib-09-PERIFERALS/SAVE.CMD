SAVE.100  By Tony Anderson

Original text and modifications Copyright 1990 Tony B. Anderson; All Rights
Reserved


For the Model 100/102 only.  Works with (requires) Power-Disk or POWR-DOS as
the resident Disk Operating System.


This program is derived from Howard Sprow's 1987 Contest entry, HOWBIG.BA,
which is used here as a resident, invisible program, which will save a cursor-
selected file or program to disk, simply by moving the wide cursor bar over a
file name on the main menu, typing SAVE and pressing the ENTER key.  If the
disk drive is connected and ready, the file will be saved, and will be reported
on the screen.  If the drive is not connected, or not ready, a save error will
be reported, and pressing any key will return you to the main menu.

This program does not kill the saved file in the computer or remove it from the
menu, and it will not overwrite an existing file on the disk that has the same
name, so it cannot be used for successive backups of developing files.  In the
event there is already a file existing on disk with the same name, you will
receive the save error message.


How to get it operational:

Load the below program into BASIC - you can delete lines 0 and 1 to save RAM
space - and save it to the menu as SAVE.BA.  This is important!

Download, Load and save CMD.100 to your menu as CMD.BA.  (CMD.100 is in Library
8.)

With both programs on the main menu, move the wide cursor bar over SAVE.BA, and
type CMD.BA and press the ENTER key.  SAVE.BA will disappear from the menu,
but will have been changed to SAVE (no extension), and will have been made
invisible.  Once SAVE.BA is invisible, you can remove CMD.BA from the machine
by killing it. (In BASIC, type KILL"CMD.BA" and press ENTER key)

To use the program, at the main menu, move the wide cursor bar over a file or
program name, type SAVE and press the ENTER key.  The screen will clear, and
the program will report the file is being saved or an error.  If the file is
saved successfully, you will return to the main menu.  If there was a save
error, you will be asked to press any key to return to the main menu.

SAVE will remain resident, and invisible until you have a cold-start, or
deliberately remove it.  To remove it, you can use CHANGE.BA to rename it as a
normal .BA program and make it visible, so it can be killed normally, or you
can enter BASIC and type `KILL"SAVE"' and press the ENTER key.

The program, after removing lines 0 and 1, will use 299 bytes of RAM space.
The first time you run SAVE, it will add a + sign to BASIC on the main menu, to
give you a reminder that you have an invisible file in RAM.  I add that to each
invisible program, so that I have a reminder on the screen that there is more
available in the computer than what is shown on the main menu. If you don't
want that indication, remove the poke in line 2 of the program.



0 '  SAVE.100  - Saves Cursor-selected file to disk. Requires Power-Disk or POWR-DOS to operate.

1 ' Modified by TBA 11/15/90 from original code by Howard Sprow (HOWBIG.BA) For 100/102 only. Save as SAVE.BA, then run Paul Globman's CMD.100 program

2 CLS:X$="":POKE63850,43:MN=PEEK(65006):DP=(PEEK(64930+(2*MN)))*256+PEEK(64929+(2*MN)):S=PEEK(DP):IFS=128ORS=160ORS=192THEN4ELSEBEEP:MENU

4 X=VARPTR(X$):A=INT(DP/256):B=DP-A*256:POKEX,12:POKEX+1,B:POKEX+2,A

6 N$=MID$(X$,4,6)+"."+MID$(X$,10,2):PRINT@128,"Saving "N$:ONERRORGOTO8:N$=":"+N$:SAVEMN$:MENU

8 PRINT@128,"Save Error"SPACE$(10):PRINT@208,"Press any key ";:Q$=INPUT$(1):MENU
