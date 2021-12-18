           TELNOD.CMD (c) 1990, Randall W. Hess & Paul Globman
                             All Rights Reserved
           ---------------------------------------------------
     
     
             TELNOD.CMD integrates the operation of TELCOM with
     RAMDSK.CO and permits you to fully access the Node DATAPAC while
     on-line with the internal modem, without losing the carrier!
     This greatly expands the amount of memory available for
     uploads and downloads while using the internal modem.  It uses
     Paul Globman's RAMDSK.CO(c) to access the DATAPAC while on-line
     and utilizes XOS-C.
             XOS-C/RAMDSK users can now choose between the on-line
     bank switching of XOS/XTLCM3's F7 or, by running TELNOD.CMD,
     F7 direct on-line access to the DATAPAC.  (And TELNOD doesn't
     affect XOS-C's F6 enhancements!)
     
                     SET-UP
     
             Remove all download "garbage" and checksum this file!
     The best way to create TELNOD is simply "Copy" the 5 lines of code at
     the end of these instructions using TEXT's F7 and F5.  Then go into
     BASIC, type NEW <ENTER> and "Paste" the code into BASIC, "Save"
     the code as TELNOD.BA and make a back-up copy.  XOS-C must be
     installed and RAMDSK.CO must be in Bank-3.  TELNOD.BA can be
     renamed as CMD>.BA or anything else but must also be on the menu in
     Bank 3 to operate properly.  TELNOD.BA is 405 bytes long.
     
     
                     OPERATION
     
             Run TELNOD.BA using XOS-C's F3(CMD>) function key.  TELNOD
     clears RAM space for RAMDSK.CO, loads it into HIMEM from Bank 3,
     and then goes to TELCOM: dial-up as usual.
             Once you are on-line, Function Key F7 will take you
     directly to RAMDSK.CO.  After incoming data stops, either at a
     prompt or after using a CTRL-O or CTRL-S, simply press F7 to access
     the DATAPAC: move files to/from RAM, rename etc.  When
     you've finished with the DATAPAC press F1 (now labeled "Term") to
     return on-line and, when the "term" label line displays, you can
     continue where you left off.
     

                     USAGE TIPS

             - REMEMBER that F6 will give you "bytes free" while on-line
     and SHIFT/F6 takes you to TEXT for editing RAM files while on-line.

             - STOP your download with the F2 key BEFORE accessing the
     DATAPAC.  Failure to turn F2 "off" will cause the "bytes-free"
     function of F6 to return an inaccurate value.  (Subsequent download
     to the same-named file followed by F2/"off" SHOULD restore accurate
     F6 operation but repeated DATAPAC access without first turning F2
     "off" may cause TELCOM to abort ALL downloads.)

             - If you're downloading and don't mind "losing" a few
     bytes, then simply keep an eye on the "down" label and send a
     CTRL-S when you see the "download aborted" (RAM full) message.
     Press F7, save the file to the DATAPAC, and press F1 to return
     on-line.  (Don't forget the CTRL-Q!)  Since RAMDSK only needs 1-2
     seconds to copy 17k of data to the DATAPAC, this is probably the
     fastest way to download a lot of message traffic etc.
   
             - You might find it helpful to use the same name for all
     downloads (e.g "TMP") and simply save the files to the DATAPAC with
     more meaningful names.  Subsequent downloads to "TMP" will, of course,
     "kill" the previous download to that file and restore RAM for the 
     next use.

             - Many information services will "hang-up" after a while if
     you don't remind them you're still around.  And remember: the
     "meter" is still running while you're using the DATAPAC.

             - DON'T move .BA files from the DATAPAC into RAM while on-line!


             When you've finished with TELCOM, exit Term & TELCOM as
     usual with F8.  The main menu will display briefly, clear and
     redisplay: TELNOD.BA has now removed itself and RAMDSK.CO,
     restored HIMEM to 61104 and reset all "hooks" to the XTLCM3 values
     used by XOS-C.
     
     
             If you have any problems, comments or suggestions please
     leave a message on the M100 SIG or drop a note via E-Mail.
     

     		Randy Hess        Paul Globman
     		73267,552         72227,1661
     		Omaha, Ne         Sunrise, Fl
               		May, 1990
     

=============================================================================
0 'TELNOD.CMD(c)1990,R.Hess&P.Globman
1 A=59778:IFHIMEM-ATHENCLEAR0,A:CALL41179:X$="3:RAMDSK.CO":CALL63600,8,VARPTR(X$):IFPEEK(61302)=0THEN3
2 IPL"":A=-738:POKEA,1:POKEA+1,7:POKEA+2,255:CLEAR0,MAXRAM:NEW
3 FORX=0TO59:READY:POKE59778+X,Y+X:NEXT:CALLHIMEM
4 DATA33,83,99,31,11,233,27,107,101,25,7,227,21,150,219,19,45,228,15,168,213,13,43,222,9,153,207,7,223,204,175,222,63,0,45,209,-2,28,207,-6,128,115,-8,18,201,160,-46,-47,157,50,29,154,25,26,151,65,43,148,31,20
