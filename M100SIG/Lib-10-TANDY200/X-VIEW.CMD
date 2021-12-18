X-VIEW.CMD Operation documentation.
Copyright (c) 1989 by Paul Globman
                      [72227,1661]

X-VIEW.CMD is designed to run only as an XOS command.  Its compact code runs in
the ALTLCD BUFFER due to its effective use of various subroutines found within
the XOS-C program code.

X-VIEW (cross view) is designed to operate as a front end to the built-in TEXT
program in the Tandy 200.  The purpose of X-VIEW (XV.CO) is to provide the user
with a new and unique capability, found mostly in more expensive computer 
systems.  That is, the ability to open a "window" and VIEW another file from 
another bank (Bank #2), while editing the primary file in Bank #1.

THE SET-UP
----------
It is recommended that XOS users keep .CO and .BA programs in Bank #3, and .DO 
files should be stored in Bank #2.  Bank #1 is for working on the immediate
project.  To comply with this suggestion XV.CO should be stored in Bank #3.  If
you are a frequent user of the TEXT program, then XV.CO should be named CMD>.CO
(refer to XOS-C docs for a more detailed explanation).

The text file to be edited must already have been created, and on the MENU of 
Bank #1.  Place the cursor over the text file to be edited and press F3(Cmd>).
Type XV<enter> and you will immediately enter the cursored text file.  If XV.CO
is named CMD>.CO then press F3(Cmd>) with CAPS LOCK down.

THE FEATURES
------------
By entering text files via XV.CO you give the Tandy 200 the ability to open a
"window" (the lower half of the T200 LCD) while editing.  This is done by
pressing the GRPH + CODE keys.  Once the "window" is opened, editing functions
for the primary file are suspended.

Pressing GRPH/CODE will split the LCD, display Bank #2 files, and request the
name of the Bank #2 file you wish to view.  After entering the name of a valid 
Bank #2 file, that file is then scrolled up the lower half of the Tandy 200 
LCD, keeping the upper portion of the LCD intact.

As the secondary file is scrolling, the spacebar is used to pause/continue the
scroll.  The ESC key is used for an immediate abort.  When the scrolling file 
reaches the end of the file, or if ESC was pressed, a beep will sound, the
scrolling will stop, and the next key-stroke will restore the Tandy 200 LCD and
return the cursor to where it was prior to pressing GRPH/CODE.

MORE FEATURES
-------------
While in VIEW mode with the scrolling paused, the UP ARROW key will restart the
display of the secondary file (the file being viewed in the "window"). The 
window will clear and the file will begin to display again.

While in VIEW mode with the scrolling paused, the DOWN ARROW key will set a
"marker" at the beginning of the current line/paragraph being displayed.  If 
the scroll is paused at the BEGINNING of a line/paragraph then DOWN ARROW will 
move the "marker" to the beginning of the previous line/paragraph (see note).

The window will clear and the file will begin to display again, but from the 
"marked" position rather than the beginning of the file.  Subsequent use of the
UP ARROW will cause the file to display, beginning at the "marked" position 
rather than the beginning of the file.

Pressing <ENTER> at the "X-View:" prompt automatically displays the last file
viewed, beginning at the last "marker" set for that file.  If you have not yet
 viewed any secondary files then <ENTER> will gently return you to the primary
file being edited.  To review the last secondary file from its beginning you 
must enter the filename again.

NOTE:
-----
X-VIEW allows the position of the "marker" to be backed up one line/paragraph.
This is done by pressing UP ARROW as if you wanted to return to the "marked" 
location and IMMEDIATELY press SPACEBAR, BEFORE the text begins to scroll. 
With the scroll paused, press DOWN ARROW.  Your "marker" will be moved to the 
beginning of the line/paragraph above the curent "marker" setting.  If you 
somehow wind-up "above" the beginning of your selected file then you will have
to exit the "view" and re-enter the filename at the prompt.


WORD-WRAP
---------
Word-wrap is toggled on/off by pressing CTRL + SHIFT.  With word-wrap off the 
LCD will display more text and show the actual number of spaces between words 
on adjacent lines.  The LCD will immediately adjust to "wrap" or "no-wrap" 
mode, as you toggle between them.

IMPORTANT: The SHIFT/PRINT function of the Tandy 200 will NOT word-wrap when 
printing if word-wrap is disabled in the edit mode.  Be sure to enable word-
wrap before printing a document with the SHIFT/PRINT function.


TIPS
----
Since the top 8 lines of the Tandy 200 LCD are "locked" into place, you can
first move through the primary file and bring some significant portion of the
primary file into view on the top 8 lines, for comparison with the file 
being scrolled.

When in VIEW mode and have the scroll paused, the PRINT key will dump the LCD
to the printer, showing portions of the two files at once.  Depending upon your
printer, the line that splits the LCD will print as a graphic character or a
line of "q"s.

Credits
-------
Much thanks to Randy Hess for beta testing this project and offering some 
suggestions that were incorporated into the final version of X-VIEW.

Use HXFER.200 to convert the following file to XV.CO (cross-view).

54F8DC0154F82A0DF52284F82221F92192F8220DF52A45F5228AF82183F82245F5223DF5CDD5A1FEC0C4454FC283F823EBEDC31B73210000220DF52100002245
F5C301A0F5C5D5E5381AED11A973DFC21CF92A06EF2214F93A0DFDE60FFE0CCAC0F8FE03C21CF93A0CF2EE01320CF2C310F9CD594FCD11FA3E04CD44A1CD1CFA
2129FA06063E20CDC25DCD964F2121FACDCC11CD6D4FCDF654D7A7CA02F93E07B8DA02F9051129FAD5EBCDBA41D1CD226DCD23F93E01B8C210F92100007CBDC4
6FF9CD5680210000CD9B4FCDF313E1D1C1F1C3000021AAF2110B00190604CD86A1FEFFCA454FFEC0C226F923CD86A13209F923CD86A1320AF906062311F0FFD5
C50604CD86A1C1D112231305C24DF92323E50E062129FA11F0FFCD116EE1C22AF9E5E5E1E1CD11FACD1CFACD964F2A09F90604CD86A1FE1ACC454FCAF712E5CD
95F9E123C381F9FE20D2B0F9FE09CAB0F9FE0ACAB0F9FE0DCAB0F9F53E5EE7F1C640FE0DC4055ACC05FA2A06EF111028DFCCF8F9CD038BC8FE1BCAF3F9FE20C0
CDF712FE1ECA71F9FE1FCAE1F9FE20C2CEF9C9E1E12B2BCD86A1FE0DC2E4F92209F9C373F9E1E1C386F9C1D1E123E5D5C50604CD86A1E7210A01CD9B4FCD724F
C3964F210901CD9B4F0628C38FA13E4AC38F4F582D566965773A0000000000000000

end of data

