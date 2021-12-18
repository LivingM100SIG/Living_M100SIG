Documentation for CHANGE.BA 1/10/85 by Rick Perry [75665,1045]

   CHANGE.BA is a Model 100 utility program that incorporates menu
driven directory access and manipulation, conversion of binary .CO files
into ASCII Hex .DO (and vice-versa), and also conversions between .CA
Lucid Calcsheet files and .CO.

   The program starts by displaying a complete directory menu.  Press
the arrow keys and/or spacebar & BKSP to position the cursor over a
particular file name.

   Press ENTER to "execute" the file, i.e. if it's a BASIC or binary
file (excluding .CO's with Exe address of 0) it will be executed (for
.CO's, HIMEM will be reset if necessary); if it's a text file you will
go into TEXT.

   Pressing LABEL cycles the bottom display line through four displays.
The initial label line describes the function key definitions.  The
function keys remain active even when the other three label line
displays are shown.

   The second label line displays info about a file, i.e. file type &
start address, and file length in bytes for non-ROM files, and Top, End,
& Exe addresses for binary RAM files.  Typical display for SECURE.CO
file is:

CO @ 45180 + 865  62101,62959,62101

indicating that file uses 865 bytes of RAM starting at address 45180.

   The third label line shows values of bytes free, HIMEM, and MAXRAM. 
The fourth shows time, date, and bytes free.  For both of these
displays, the value of bytes free represents space currently available
to the program and will be about 800 less than value shown on M100 Main
Menu screen (due to CLEAR 500 & storage of variables).

   The other available features are mostly function key driven:


[F1] >Hex -- Change binary to hex text

   When pressing F1, if cursor is currently over a valid .CO file name,
appropriate HIMEM space will be CLEARed, that file will be LOADMed
automatically, and its Top, End, & Exe addresses used in the conversion.
End address must be less than MAXRAM.

   If cursor is not over .CO file name, program will assume that you
want to convert binary code that is already loaded between HIMEM &
MAXRAM, and will prompt for desired Top, End, & Exe addresses (defaults
are HIMEM, MAXRAM-1, & HIMEM; if code is not executable from main menu,
enter Exe address as 0).

   Program prompts for "Hex output file:"; enter name for .DO file which
is to be created (can be CAS: or COM: etc.).  Null entry restarts
program.  Format of Hex file is: Top, End, Exe decimal addresses on
first line; following lines, up to 78 hex chars each, representing 39
bytes of binary code; decimal checksum on last line.  Checksum is
calculated as sum of Top, End, Exe addresses plus the binary code byte
values.

   After conversion, if .CO file was LOADMed by the program, HIMEM is
reset to MAXRAM before restarting.


[F2] >Bin -- Change hex text to binary

   When pressing F2, if cursor is currently over a .DO file name, that
file will automatically be used as input; otherwise, program prompts for
"Hex input file:" (null entry restarts program) which can come from RAM,
CAS: COM:, etc.

   If End address (read from hex input file) is not less than MAXRAM,
?FC ERROR is produced.  If Top address is less than HIMEM, then
appropriate space will be CLEARed before continuing.  In this case, if
input file name entry contained a colon (":"), you will be prompted to
"Rewind input file".  This is necessary because the file must be CLOSEd
& reOPENed before continuing, and, for example, if the input file was
being taken from CAS:, you would need to rewind tape to start of file.

   Next prompt is for ".CO output file:"; enter name for .CO file which
is to be created.  Null entry causes code to be loaded into RAM above
HIMEM, but not SAVEMed as additional RAM file.

   After conversion, if hex input file name did not contain colon (":"),
"Kill hex input file?" prompt appears.  Press "Y" or "y" and input file
will be KILLed before SAVEMing the .CO.  This feature is provided in
case you don't have sufficient free space to keep both the hex & .CO in
RAM.

   If .CO output file name was specified, HIMEM is reset to MAXRAM after
SAVEMing, before restarting.


[F3] >CA -- Change .CO file to .CA Lucid Calcsheet

   This function should only be applied to Lucid Calcsheet files
previously changed from .CA to .CO using function F4 of this program. 
The program can't absolutely check that the binary file, on which the
cursor is positioned, had a .CA origin.  But if the file is not binary
type, or if its End address is not MAXRAM-1, or if its Exe address is
not 0, then conversion won't be attempted and program will just make a
nasty buzz sound.

    Assuming the cursor was positioned over a valid file when pressing
F3, three things will happen: Top address of file will be changed to
65535, Exe address changed to 63012, and extension changed to "CA".


[F4] >CO -- Change .CA Lucid Calcsheet file to .CO

   Program checks that file, over which the cursor is positioned, is
binary type with Top address of 65535 & Exe address of 63012.  If so,
three things happen: Top address of file will be changed to MAXRAM minus
number of bytes of code in file, Exe address changed to 0, and extension
changed to "CO".  Resulting file can then be LOADMed, etc. from BASIC,
and processed via F1 (>Hex) and F3 (>CA) functions of this program.


[F5] Name -- Change file names and extensions

   Cursor should be positioned over target file before pressing F5. 
Program prompts for "New name:", then "New extension:".  Null entry
leaves name or extension unchanged.

   This function does not use the BASIC NAME command, rather it pokes
the new file name directly into the RAM directory.  Thus, you can do
strange things, like use lowercase names, blank extensions, etc.  It is
not advisable to change extensions from one type to another (e.g. from
BA to DO).  Also, note that use of lowercase file names and/or wierd
extensions, will prevent files from being accessed via BASIC, although
they should still be available from the M100 main menu.


[F6] Kill -- KILL a file

   Program prompts "Kill?" regarding file over which cursor is
positioned.  Press "Y" or "y" if you really want the file KILLed.

   Note that an error occurs in attempting to KILL a file whose name is
unacceptable to BASIC.  Also, program will not attempt to KILL ROM files
or Paste buffer.


[F7] Invs -- Change file visibility status

   As you move the cursor around on the program menu, the "Invs" key
label will change to inverse video if a file has been set invisible. 
Press F7 to switch the visibility status of any file.

   Cautions regarding access to invisible files:

   Only invisible BASIC files can be accessed safely directly from the
M100 main menu by typing in the name at the "Select:" prompt.  Invisible
text files can be accessed by first going into TEXT, then entering the
file name.  Invisible .CO files can still be LOADMed and/or RUNMed from
BASIC and .CA files can be accessed within Lucid.  Invisible ROM
programs can be accessed via CHANGE program or by CALLing the
appropriate address from BASIC.

   If you try to make Lucid invisible, the program will remove it from
the menu completely, same as CALL 63012,0,1 per Lucid manual.


[F8] Menu -- Return to M100 Main Menu


Additional information:

   The program uses an ON ERROR GOTO to detect and display (but not
recover from) errors.  An error can occur when trying to process a file
whose name has been altered to a form unacceptable to BASIC.  After
seeing an error message display, press ENTER to restart the program, or
press any other key to exit to BASIC.

   You may want to extract some of the code from this program in order
to include similiar features in your own programs.  Also, since the
functions are fairly modular, you can easily eliminate unwanted
functions by replacing the appropriate subroutines with RETURNs.  Please
feel free to do so.

   Some things I think are neat: the display of two character BASIC
error message in error handling section; file menu display (that code
was adapted from a program by Jesse Bob Overholt; possible modification
for use in other applications would be to check the file type code byte
or file extension and only display certain files, e.g. BA or DO, in menu
form for selection by user).

   Watch out for invisible files Suzuk.i (BASIC program with no name)
and Hayas.hi (the PASTE buffer).  It's Ok to rename and/or "execute"
them, but if you go into TEXT with Hayas.hi, don't use Select, Cut,
Copy, or Paste keys.

   Lucid users may notice a file, "4 PCS.G", which is the Calcsheet
formula paste buffer.  This can be renamed as Something.CO and then
KILLed if desired.


Programming note:

   This version does not use ON KEY interrupts to process the function
keys, rather it temporarily assigns chars 20...27 to F1...F8 and reads
function key presses via INKEY$ just like any other input (pressing
LABEL causes INKEY$ to return char(0)).  The alternate label line
displays are controlled by the variable  G, which takes values from 0 to
3 as LABEL is pressed.  Variables  K  &  E  are used as flags to
determine if label line needs to be refreshed.
