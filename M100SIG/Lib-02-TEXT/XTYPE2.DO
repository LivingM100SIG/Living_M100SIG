     Date: Feb 16,1987, TYPE II.DO          Page 1



     =============================================
     TYPE II - The Model 100 Electronic Typewriter
     =============================================

     This documentation explains the use of two programs on the SIG. The
     first of these is the 'X' version of the program. This version is in
     DL2 as TYPEII.BA. It is referenced in the doc as X-TYPE. The other
     version is the 'C' version that is in DL4 as CTYPE2.BA. It is
     referenced in the doc as C-TYPE. TYPE II, when used, refers to both
     programs.

     This doc file is supplied in two segments. This is the first segment
     that is in DL2 as XTYPE2.DO. This segment explains the common features
     of both programs and refers to some of the special features of C-TYPE.
     The remainder of the doc, dealing exclusively with C-TYPE's extra
     features and customization is in DL4 as CTYPE2.DO. If you will be
     using only X-TYPE this is all the doc you will need.

     Both versions are 'electronic typewriter' programs that use the Model
     100 and virtually any printer to create an effective simulation of a
     modern typewriter. Both X-TYPE and C-TYPE are greatly improved and
     enhanced versions of my original program, TYPE.BA. X-TYPE and C-TYPE
     are far faster than the original and are overall far smoother and
     easier to operate.

     To use either version simply load the program and turn on the printer.
     If the printer is not on-line you will be beeped if you select it for
     output and requested to select again. If you choose no printer output
     you will go directly to the file selection screen. Since the lines are
     sent formatted with CR's to the RAM/disk file you can correct typos
     and add imbedded printer commands in TEXT if desired and then print
     the document using the 'Save to:LPT:' feature of TEXT. I use this
     method to edit my kid's letters produced with TYPE II. Both versions
     work great with Powr-DOS and should be fine with any DOS that supplies
     BASIC extensions for normal file operations.

     After selecting the output you will go to the editor. Just type in
     your text and press ENTER to send the line to the output. The program
     defaults to left=5 and right=75 for editing. Line count defaults to
     66. The current spacing, line count, left, and right margin settings
     will be displayed on the line editor screen. If you are using C-TYPE
     the current out/indent value will be displayed above the current
     column value.

     The only editing keys available in X-TYPE are the DEL-BKSP, which
     deletes one character, and the SHIFT+DEL-BKSP, which kills the whole
     line. The 'ESC' key brings up a selection that allows you to send
     multiple blank lines to the printer. This is used for moving the paper
     up rapidly when needed. The TAB key inserts 5 spaces if you are using
     X-TYPE. With C-TYPE you have a variable TAB that asks for a parameter
     from 1-9 after pressing TAB. Select the number you want to tab and
     that many spaces will be sent to the edit line immediately.










     Date: Feb 16,1987, TYPE II.DO          Page 2



     ====================================
     Common features of X-TYPE and C-TYPE
     ====================================

     The programs will beep with each keypress after you reach the right
     margin value. This is only a reminder. The line will be sent to the
     output as typed.

     ENTER sends the line in the editor to the output. The top line of the
     screen is the context display and will always show the last 33
     characters of the last line sent to the output. Only the last typed
     line entry will be displayed. Blank lines have no effect on the
     context display.

     The function keys are pretty self explanatory. The function key
     selections may be called at any time from anywhere in the program
     using X-TYPE and from everywhere except the file selection screen when
     using C-TYPE. In the line editor the function keys will respond
     immediately. If the program is waiting for an input, such as the
     number of lines to move up, you must press the function key and follow
     it with ENTER to get it to execute.

     All of the function key selections except (F7) 'Cent' leave the edited
     line untouched. The various line parameters will adjust automatically
     to the new selections.

     The selections are:

     (F1) Go

     This selection is used to go to the line editor from anyplace in the
     program. You can use it to abort operations that you decide you don't
     want. It can also be used to clear and redraw the screen to eliminate
     any garbage that may appear. Remember that if the program is waiting
     for input you must press ENTER after F1 to execute 'Go'.

     (F2) Page

     This selection allows you to select a new page, which sets the line
     count to 66, or to manually set the line count as you wish.

     (F3) Outp

     Cycles through the output selections so you can select/deselect the
     printer or RAM/disk file or change output files.

     (F4) Spce

     Selection for single or double line spacing

     (F5) Left

     Select the left margin for the line. ENTER will retain the current









     Date: Feb 16,1987, TYPE II.DO          Page 3



     setting. You will then be asked for an outdent or indent value. A
     default value will be displayed. TYPE II will remember the last
     selection you made and default to that if you just press ENTER. At
     startup the default is set to 0, no indent or outdent. Positive values
     specify an outdent, negative values specify an indent.

     (F6) Rght

     Specify the value of the right margin. ENTER with no specified value
     retains the current setting.

     (F7) Cent

     This is the only selection that kills the line in the editor. Just
     enter the text that you want centered. TYPE II centers text between
     the margins that are currently selected, ignoring any out/indent
     values. This allows you to be very selective about the way that your
     text is centered.

     (F8) Exit

     You will be asked if you want to restart the program or go to the main
     menu.

     The above pretty well explains all of the common features of TYPE II.
     If you want a printer initialization string to be sent to your printer
     when you are using X-TYPE go to line 7 and define the printer string
     as PR$. It will be sent to the printer with the first line and then
     ignored. To send it again you must restart the program.

     CTRL-S will pause both versions. Just press it again to restart. CTRL-
     I, CTRL-M, and CTRL-H work as TAB, ENTER, and DEL as usual. The other
     keys are masked out. If you press 'LABEL' accidentally and hash the
     display just press it again to turn off the label line and use (F1)
     'Go' to redraw the screen. There will be no other effect on the
     program.

     If the most you need a typewriter program for is to type labels,
     rolodex cards, envelopes etc., you will probably have all that you
     need with X-TYPE. If you want automated format selection, a built-in,
     interactive calculator, and full control of your printers special
     features then you probably will want to use C-TYPE. This version is
     about twice as large as X-TYPE but it has a lot more features. It is
     also easier to use in the long run if you take the time to customize
     and learn it.

     -ronnie- (70337,3727)
















