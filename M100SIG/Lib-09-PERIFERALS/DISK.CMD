DISK.CMD  By Tony Anderson

Copyright 1990 Tony B. Anderson, All Rights Reserved


For the Model 100/102 only!


This program is another Menu program for use with Power-Disk or POWR-DOS.  It's
principal claim to fame is that it can be used as a resident, invisible command
program at the main menu, to display disk files, then load and enter a TEXT
file, or load and run a cursor-selected program from the disk.

It can be used directly from the main menu, or made invisible, and a callable
function, by using Paul Globman's CMD.100 program,  In the latter case, if you
use the recommended program name, DISK.BA, it becomes DISK (no extension), and
can be run directly from the main menu by typing DISK and pressing the ENTER
key.  The screen clears, and the disk directory is displayed, in sorted order,
and you can select and use a file by moving the wide bar cursor around, just
like you do with RAM programs at the main menu.  Pressing ENTER will load and
enter a TEXT file, or load and run a BASIC program, or load and run alternate
LCD buffer .CO programs, or load, and indicate clear addresses for HIMEM-loaded
.CO programs, allowing you to clear memory manually, load and use the program
at will.

The program will also give you trouble reports, in case of disk or loading
errors.

After removing the remark lines, 0-11, the program uses 1222 bytes of RAM space.
It can be reduced further, to 1141 bytes by deleting the error report lines - 
details about that later.


If you want to use it as a normal BASIC program, just download it, convert it
into a BASIC program, and save it to the menu.  No further action is needed,
unless you want to remove the remark lines and/or modify the error report lines.

The program was originally designed to be an invisible utility, and in order to
make it operational in that mode, do the following:

1. Load the below program into BASIC and save it to the menu as DISK.BA.  The
name is important, because the name becomes the command when the program becomes
invisible.  You can delete lines 0-11 to save RAM space, and optionally, modify
the error report lines 158-162 as detailed later.

2. Download, load and save CMD.100 to your menu as CMD.BA.  (CMD.100 is in
Library 8.)

3. With both programs on the main menu, and after any editing you may wish to
do on the DISK.BA program, move the wide cursor bar over DISK.BA, type CMD.BA
and press the ENTER key.  DISK.BA will disappear from the menu, but will have
been changed to DISK (no extension), and will have been made invisible.  Once
the program is invisible, you can remove CMD.BA from the computer by killing it.
(In BASIC, type KILL"CMD.BA" and press the ENTER key.)


To use the program, simply type DISK and press the ENTER key at the main menu.
The screen will clear, and the program will attempt to read the disk directory.
If the disk drive is not ready, or not connected, you will receive a a Disk
Drive Error report, and a prompt to press any key.  A keypress will return you
to the main menu.

If the directory read is successful, the first 27 files will be listed on the
screen in the familiar menu format.  If there are more than 27 files on the
disk, "More" will be highlighted at the top of the menu.  Pressing the ENTER
key with the word "More" hightlighted, will bring up a second menu with the
balance of the files on the disk.  If the disk had less than 27 files, "Menu"
will be highlighted at the top of the menu.  Pressing the ENTER key will return
you to the computer's main menu.

You may move the cursor around on the disk menu with the space key, and the
arrow keys.  Other keys are ignored.  Pressing ENTER will load the selected
file into the computer.  If it's a TEXT file, you will move directly into the
file.  If it's a BASIC program, or an alternate LCD buffer .CO program, the
program will run immediately.  If the selected file is a .CO program which
requires that space be cleared between HIMEM and MAXRAM to load the file, it
will be loaded into the computer, and you will be prompted to clear RAM space,
and load/run the program manually.  The correct clear address will be indicated.

The program will temporarily load the disk directory into a file named AZ*.DO,
and will kill the RAM file before exit, if the program runs to normal conclusion.
If there is a problem, and the program is aborted, you may find the AZ*.DO file
still in RAM.  No problem, you can kill the file normally.  If you run DISK.BA
again, the file will be overwritten, and if the program proceeds normally, the
file will be killed before exit.  But generally, you should try to find out
what the problem was, and fix it before running the program again.  The most
common error is drive not ready, followed by Error #7, Out of Memory.  Refer to
the Model 100 manual for a list of other error messages.

To eliminate the error-message report lines from the program, you can make
lines 158 and 160 into remark lines, and change line 162 to "BEEP:END".  To
reduce the program even further, you can delete those three lines, and the
accompanying ONERROR statements in the body of the program - in lines 100, 148,
and 150 - but I'd leave the error reports intact, to assist in diagnosing error
conditions, by getting the error report, or finding the line in which an error
occured.


Program uses 1222 bytes when remarks are removed.


0 ' DISK.CMD  For Model 100/102 only. Another Disk Menu program, but this one
1 ' can also be used as an invisible command function from the main menu.
2 ' Requires Power-Disk or POWR-DOS as resident DOS in order to operate.
3 ' Copyright Tony B. Anderson, All Rights Reserved
4 ' Displays disk directory in menu format; allows user to cursor-select a disk
5 ' file; load and enter a selected TEXT file, load and run a selected BASIC
6 ' program, or load and run alternate LCD buffer .CO programs. It will not
7 ' run .CO programs that need to have HIMEM set before running, but will load
8 ' them into memory, drop into BASIC, tell you to clear HIMEM space and give
9 ' you the address to use in the CLEAR statement.  Or, you can type CLEAR256,X
10 ' and press the ENTER key, then LOADM or RUNM the program. "X" is the last
11 ' held variable, which happens to be the load address of the .CO program.

100 MAXFILES=1:CLEAR512:DIMA$(28):F=0:GOSUB154:X$=CHR$(27)+"J":R$=CHR$(27)+"p":N$=CHR$(27)+"q":CLS:PRINT@42,"Reading disk directory...":ONERRORGOTO158:LFILESTO"AZ*":ONERRORGOTO160:OPEN"AZ*"FORINPUTAS1

102 FORA=2TO28

104 IFEOF(1)THENCLOSE:KILL"AZ*.DO":F=1:GOTO110

106 A$="":LINEINPUT#1,A$:IFASC(A$)=32THEN104

108 A$(A)=LEFT$(A$,9):NEXT

110 CLS:PRINT"Disk Directory:":CALL16959:IFFTHENA$(1)=" Menu    "

112 FORB=1TO28:PRINTA$(B)" ";:NEXT:PRINT@40,R$A$(1)N$;:X=1

114 A$=INKEY$:IFA$=""THEN114

116 IFASC(A$)=13THEN140

118 IFASC(A$)<28THEN114

120 ONASC(A$)-27GOTO122,126,130,134,122:GOTO114

122 GOSUB138:X=X+1:IFX>28THENX=1

124 GOTO136

126 GOSUB138:X=X-1:IFX<1THENX=28

128 GOTO136

130 GOSUB138:X=X-4:IFX<1THENX=1

132 GOTO136

134 GOSUB138:X=X+4:IFX>28THENX=1

136 PRINT@30+10*X,R$A$(X)N$;:GOTO114

138 PRINT@30+10*X,A$(X):RETURN

140 IFF=1ANDX=1THENMENU

142 IFF=0ANDX=1THENGOSUB154:GOTO102

144 IFF=0THENKILL"AZ*.DO"

146 IFRIGHT$(A$(X),2)="BA"THENA$=":"+A$(X):B$="RUN"+CHR$(34)+MID$(A$,2)+CHR$(13):FORA=1TO14:POKE65449+2*A,ASC(MID$(B$,A,1)):POKE65450+2*A,0:NEXT:POKE65450,14:LOADMA$,F:END

148 ONERRORGOTO162:IFRIGHT$(A$(X),2)="CO"THENA$=":"+A$(X):LOADMA$,F:RUNMMID$(A$,2):MENU

150 ONERRORGOTO160:A$=":"+A$(X):LOADMA$,F:A$=MID$(A$,2)+CHR$(0):A=VARPTR(A$):CALL24079,0,PEEK(A+1)+256*PEEK(A+2)

152 END

154 FORA=2TO28:A$(A)="-.-      ":NEXT:IFF=0THENA$(1)=" More    "ELSEA$(1)=" Menu    "

156 RETURN

158 PRINT@42,"Disk Drive error..."X$:PRINT@122,"Press any key ";:Q$=INPUT$(1):MENU

160 CLS:PRINT@41,"Error"ERR"in line #"ERL:PRINT:END

162 CLS:PRINT@41,"Clear HIMEM and load manually. Loading  address is:";:X=PEEK(64206)+256*PEEK(64207):PRINTX:PRINT:END
