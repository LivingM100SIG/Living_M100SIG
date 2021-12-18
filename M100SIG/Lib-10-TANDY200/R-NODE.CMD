        R-NODE.CMD (c)1990 R. W. Hess
        -----------------------------


     This is a small (140 bytes) BASIC "loader" for T200 users of XOS-C(c) and
RAMDSK.CO(c): the Node DATAPAC file transfer program by Paul Globman.  It is
written to use the Cmd>/F3 key to cross-bank load and run RAMDSK.CO from Bank
3 in either Bank 1 or Bank 2 and remove itself and RAMDSK.CO when finished. 
     It causes RAMDSK.CO to "self-clear" its operating area after DATAPAC
functions: RAMDSK.CO use becomes a simple, one-key, load and run operation
with HIMEM reserved ONLY when using RAMDSK.  R-NODE.CMD can be renamed
CMD>.BA so it AUTOMATICALLY runs RAMDSK.CO whenever Cmd>/F3 is pressed.
     R-NODE.CMD:
           1) Clears correct HIMEM for RAMDSK.CO
           2) Cross-bank loads RAMDSK.CO into its operating space
           3) Runs RAMDSK.CO
           4) Re-clears HIMEM to 61104 upon exit from RAMDSK.CO and removes
              itself


         SET-UP
         ------
     Download this file, remove extraneous CIS characters and checksum it! 
The program has only two lines: use TEXT to "Copy" both lines of the
program into the Paste-Buffer.  Go into BASIC, type NEW, press <ENTER>, and
press PASTE: the code will print on your screen.  When it is all printed,
"Save" it as a .BA file, named as you prefer.
     Return to the main menu, back-up as needed and copy to Bank 3.


         OPERATION
         ---------
     With RAMDSK.CO and the loader in Bank 3, bring the XOS-C "Cmd>" menu
into the current bank using F8 and move the cursor over BASIC.  If you've
named the loader CMD>.BA then just push CAPS/LOCK "down" and press F3:
otherwise leave CAPS/LOCK "up", press F3 and enter the loader name you've
chosen.
     The loader copies itself and the RAMDSK.CO code into place from Bank 3,
runs RAMDSK.CO and, upon exit from the DATAPAC, re-sets HIMEM to 61104,
removes itself and returns RAMDSK.CO's 1266 bytes of running space to RAM. 
At entry the Main Menu first displays briefly, clears and runs RAMDSK.CO: at
exit the Main Menu displays, clears and re-displays.


     IMPORTANT items to consider:
          The program assumes that your BASIC function-key F8 does a "menu"
call (or equivalent).
          The program uses the T200 IPL buffer so any previous IPL request
will be overwritten.
          Whenever the program finds HIMEM<>59838 it will try to CLEAR0,59838
and load RAMDSK.  If some other program has lowered MAXRAM below 59838 (e.g.
POWR-DISK and FLOPPY II) then the loader will NOT run.  (You MIGHT be able to
load and run RAMDSK.CO by itself on TOP of the other code but disaster may
await if you try to re-run what was there first!)  Using the loader keeps this
from happening: remove the other code and re-run the loader.
          If HIMEM in the current bank was left at 59838 because of some
previous operation then the loader will only CLEAR0,MAXRAM and return to the
Main Menu: simply run it again to re-try the RAMDSK load.  As before, if
MAXRAM < 59838 then some other M/L code may still be lurking around and the
loader WON'T run RAMDSK!

          That's all there is to it!  I hope you'll find it useful.  I use
XOS-C and R-NODE.CMD, re-named as CMD>.BA, for instant access to the DATAPAC
with ONE key-press.  I'd suggest that other XOS-C users at least re-name
R-NODE.BA to something easier to type!  Please let me know if you have
comments or suggestions.


          CREDITS
          -------
     Paul Globman wrote RAMDSK.CO, of course, and provided the technical
support needed to make R-NODE.CMD work!


Randy Hess
73267,552
3/90
Omaha, Ne



 -------------- R-NODE.CMD ----------
1 IFHIMEM-59838THENCLEAR0,59838:CALL41179:X$="3:RAMDSK.CO":CALL63600,8,VARPTR(X$):IFPEEK(61302)=0THENPOKE59899,0:POKE59900,0:CALLHIMEM
2 CLEAR0,MAXRAM:IPL"":A=-738:POKEA,1:POKEA+1,7:POKEA+2,255:NEW

