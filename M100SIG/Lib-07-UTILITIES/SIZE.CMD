SIZE.CMD  By Tony Anderson

Original text and modifications Copyright 1990 Tony B. Anderson; All Rights
Reserved


This program is a modification of Howard Sprow's 1987 Contest entry, HOWBIG.BA,
which is used here as a resident, invisible program, which will report the size
of a cursor-selected file or program in bytes.  It is called by moving the wide
cursor bar over a file name on the main menu, typing SIZE and pressing the
ENTER key.

Load the below program into BASIC - you can delete lines 0 and 1 to save RAM
space - and save it as SIZE.BA.  This is important!

Download, Load and save CMD.100 to your menu as CMD.BA.  (CMD.100 is in Library
8.)

With both files on the main menu, move the wide cursor bar over SIZE.BA, and
type CMD.BA and press the ENTER key.  SIZE.BA will disappear from the menu,
but will have been changed to SIZE (no extension), and will have been made
invisible.  Once SIZE.BA is invisible, you can remove CMD.BA from the machine
by killing it. (In BASIC, type KILL"CMD.BA" and press ENTER key)

To use the program, at the main menu, move the wide cursor bar over a file or
program name, type SIZE and press the ENTER key.  The screen will clear, the
size of the file will be reported, and you can press any key to return to the
main menu.  Larger files and programs take slightly longer to report the size
than smaller programs, but should not be more than a few seconds.

SIZE will remain resident, and invisible until you have a cold-start, or
deliberately remove it.  To remove it, use CHANGE.BA to rename it as a normal
.BA program and make it visible.  Then it can be killed normally.

The program, after removing lines 0 and 1, will use less than 500 bytes of RAM
space.  Also, the first time you run it, it will add a + sign to BASIC, to
give you a reminder that you have an invisible file in RAM.  I add that to each
invisible file, so that I have a reminder on the screen that there is more
available in the computer than what is shown on the main menu. If you don't
want that indication, remove the poke in line 2 of the program.

This technique is also useful with KILL.100 (Lib. 7), LFUTL.PW1 (Lib. 7), and
RUN.100 (Lib. 8).  KILL will kill a file by moving the wide cursor bar over a
file name, typing KILL and pressing ENTER.  LFUTL will install TELCOM and
Printer linefeed patches, and can be modified to do either automatically and
return to the menu.  RUN will clear memory space, load and run .CO programs.



0 ' SIZE.CMD from HOWBIG.BA  c1987 H.Sprow 73625,365

1 ' Modified by TBA 11/15/90 to indicate size of cursor selected file on main menu. For 100/102 only. Save as SIZE.BA, then run Paul Globman's CMD.100 program

2 CLS:X$="":POKE63850,43:MN=PEEK(65006):DP=(PEEK(64930+(2*MN)))*256+PEEK(64929+(2*MN)):S=PEEK(DP):RP=PEEK(DP+2)*256+PEEK(DP+1):IFS=128ORS=160ORS=192THEN8ELSEBEEP:MENU

4 X=VARPTR(X$):A=INT(J/256):B=J-A*256:POKEX,240:POKEX+1,B:POKEX+2,A:RETURN

6 J=RP:GOSUB4:Q=INSTR(1,X$,M$):IFQ=0THENRP=RP+240:CT=CT+1:GOTO6ELSESZ=CT*240+Q:IFS=128THENSZ=SZ+2:RETURNELSERETURN

8 J=DP:GOSUB4:N$=MID$(X$,4,6)+"."+MID$(X$,10,2)

10 PRINT@128,N$;:CT=0:IFS=192THENM$=CHR$(26):GOSUB6ELSEIFS=128THENM$=CHR$(0)+CHR$(0)+CHR$(0):GOSUB6ELSESZ=PEEK(RP+3)*256+PEEK(RP+2)+6

12 PRINT@138,"="SZ"bytes":PRINT@208,"Press any key ";:Q$=input$(1):MENU

