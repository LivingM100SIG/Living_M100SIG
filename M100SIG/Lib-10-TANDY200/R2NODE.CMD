          R2NODE.CMD(c)1990 R.W.Hess
             All Rights Reserved
          --------------------------


     R2NODE.CMD will quickly and automatically copy ALL "visible" RAM files
directly to the Node DATAPAC: 5-10 seconds for 18K of files.  It is written
as a RAMDSK.CO(c) utility for use in conjunction with XOS-C(c) but may be
modified for non XOS-C use.  R2NODE.BA is 566 bytes: needs 500 free to run.

       SET-UP
       -----
     Download this file and checksum it. Copy the lines of code below into
the Paste Buffer, enter BASIC, type NEW and press "Paste".  After the lines
have printed on the screen, "Save" the program as R2NODE.BA!  (This name is
important because it is used within R2NODE.BA to avoid any problems associated
with trying to copy a running program!)  Return to the Main Menu and
back-up R2NODE.BA to another medium.  Copy R2NODE.BA to Bank 3.


       OPERATION
       ---------
     With RAMDSK.CO in Bank 3 and the Cmd>/F3 key on the XOS-C menu, cursor
over BASIC and press F3: type R2NODE and press <ENTER>.  (R2NODE.BA will also
run fine by cursor selection if kept in the "current" bank.)
     Visible files will display along with an "Overwrite?" prompt. 

     "Y" or "y" will copy files to the DATAPAC with the same name as stored
in RAM and will OVERWRITE any same-named DATAPAC files.  (This is particularly
useful for copying groups of files from RAM to DATAPAC during Disk-RAM-DATAPAC
transfers but BE CAREFUL if you use this option as a way to "quick-save" a
"working" RAM file to DATAPAC: you could inadvertently overwrite an "original"
in the DATAPAC that you wanted to keep.)

     "N" or "n" copies RAM files to the DATAPAC with a "}" (GRPH/0, CHR$(125))
substituted for the 6th file-name character.  (This preserves any "original"
file in the DATAPAC and is useful during re-writes of files: a better choice
when updating.)

     ANY other key aborts R2NODE and returns to the T200 Main Menu.
     As files save to the DATAPAC their names will scroll up the screen. 
When R2NODE is finished it clears RAMDSK.CO from memory and returns to the
main menu.


   NOTE:
     Only visible RAM files with valid extensions will be copied but EACH time
R2NODE is run ALL eligible files copy.
     EACH time you "back-up" files the "new" back-up will overwrite the
previous back-up copy in the DATAPAC.
     R2NODE "calls" F8 when it exits and expects F8 to return to the T200
Main Menu.


      NON XOS-C users
      ---------------
     The "cross-bank" loading code in Line 1,"CALL41179 ... ELSE:", can be
removed and :LOADM"RAMDSK": substituted.  RAMDSK.CO would then need to be on
the "running" bank's menu.  Otherwise operations are the same.


       ------ CREDITS -----
     Paul Globman wrote RAMDSK.CO. of course, and provided the technical help
needed to make R2NODE work!
     ------------------------

     Please send comments and suggestions to me via E-Mail or the SIG.

Randy Hess
73267,552
3/90
Omaha, NE


----------------------------------------------------------------------------
0 'R2NODE.200(c)1990,R.W.Hess
1 CLEAR500,59838:IPL"":CALL41179:X$="3:RAMDSK.CO":CALL63600,8,VARPTR(X$):IFPEEK(61302)THENENDELSEDEFSTRA-H:DEFINTI-R:C=CHR$(13):E=CHR$(27):K=-739
2 CLS:PRINTE"p RAM files: "E"q":PRINT:FILES:PRINTE"p":LINEINPUT" OVERWRITE same-name DATAPAC files? ";H:J=INSTR(" YyNn",H):IFJ<2THEN6ELSEJ=J>3
3 CLS:PRINTE"q":FORX=62133TO62628STEP11:IFPEEK(X)=255THEN6ELSEIFPEEK(X)<128ORPEEK(X)MOD16THEN5ELSEFORZ=3TO10:B=B+CHR$(PEEK(X+Z)):NEXT:IFMID$(B,7,1)=" "ORB="R2NODEBA"THEN5ELSEF=LEFT$(B,6)+"."+RIGHT$(B,2):G=F:IFJTHENMID$(G,6,1)=CHR$(125)
4 D=F+C+G+C+"Y":FORM=1TOLEN(D):POKEK+2*M,ASC(MID$(D,M)):POKEK+1+2*M,0:NEXT:POKEK+1,M-1:CALL60053:CALL60218:PRINT@544,E"K":PRINT@615,E"K":PRINT
5 B="":NEXT
6 POKEK+1,1:POKEK+2,7:POKEK+3,255:CLEAR0,MAXRAM:NEW
