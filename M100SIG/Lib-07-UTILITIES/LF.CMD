LF.100  By Tony Anderson

Original text and modifications Copyright 1990 Tony B. Anderson; All Rights
Reserved



This program is derived from Phil Wheeler's LFUTL.PW1, which in turn was
developed from Hugo Ferreyra's FIXLF.HF1. It installs a hidden printer linefeed
patch, which sends a linefeed to the printer every time a cariage return is
sent.

This program is designed to be a resident, invisible utility, which will toggle
the linefeed patch by typing `LF' at the main menu, and pressing the ENTER key.
It's principal benefit is that you don't have to reload LFUTL each time you
need to toggle the linefeed function to connect to different printers.  The
invisible program uses 253 bytes of RAM space.



How to get it working:

Load the below program into BASIC - you can delete line 0 to save RAM space -
and save it to the menu as LF.BA.  This is important!

Download, Load and save Paul Globman's CMD.100 to your menu as CMD.BA. (CMD.100
is in Library 8.)

With both programs on the main menu, move the wide cursor bar over LF.BA, type
CMD.BA and press the ENTER key.  LF.BA will disappear from the menu, but will
have been changed to LF (with no extension), and will have been made invisible.
Once it's invisible, you can remove CMD.BA from the machine by killing it. (In
BASIC, type KILL"CMD.BA" and press the ENTER key)

To use the program, at the main menu, simply type LF and press the ENTER key.
The screen will clear, and the program will report whether the linefeed patch
is "on" or "off".  Press any key to return to the main menu.  If you want to
toggle the function, type LF and press the ENTER key again, and the the patch
will reverse it's current setting.

LF will remain resident, and invisible until you have a cold-start, or unless
you deliberately remove it.  To remove it, you can use CHANGE.BA to rename it
as a normal .BA program and make it visible, so it can be killed normally, or
you can enter BASIC and type `KILL"LF"' and press the ENTER key.

The program, after removing line # 0, will use 253 bytes of RAM space.  The
first time you run LF, it will add a + sign to BASIC on the main menu, to give
you a reminder that you have an invisible file in RAM.  I add that to each of
my invisible programs, so that I have a reminder on the screen that there is
more available in the computer than what is shown on the main menu.  If you
don't want that indication, remove the poke in line 2 of the program.


0 ' LF.100  Invisible, resident linefeed patch utilty installer, based on LFUTL.PW1 by Phil Wheeler. Modified by TBA 11/15/90.

2 CLS:POKE63850,43:A=64228:KEY8,"Menu"+CHR$(13)+CHR$(254)+CHR$(13)+CHR$(245)+CHR$(62)+CHR$(10)+CHR$(204)+CHR$(63)+CHR$(109)+CHR$(241)+CHR$(201)

3 F$="On":P=PEEK(A)+256*PEEK(A+1):IFP=63615THENF$="Off":POKEA,243:POKEA+1,127ELSEPOKEA,127:POKEA+1,248

4 PRINT@90,"Printer Linefeed "F$:PRINT@170,"Press any key ";:Q$=INPUT$(1):MENU

