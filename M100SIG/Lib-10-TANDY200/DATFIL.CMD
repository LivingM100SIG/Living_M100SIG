DATFIL.CMD by Paul Globman
        Copyright (c) 1989

DATFIL.CMD is a data organizer/filer program with user defined prompts and
display parameters.  It is designed to run ONLY as an XOS command module.

Data files are initialized with the built-in TEXT program, and the data you
wish to organize is entered and displayed by using the DATFIL program.

Data file organization
----------------------
Before initializing the data file you should organize the file structure and
display layout.  Data files are organized into groups of records, and
records are organized into groups of fields.  You should determine:

a) the number of fields for the data file record.
b) the name (prompt) for each field.
c) the "location" on the LCD where each field prompt will appear.

The "location" is the print position that would be used by BASIC's PRINT@
function, and is calculated as follows:

 R = row (or line)
 C = column
 LOCATION = 40*(R-1)+(C-1)

So if you want a prompt to appear on the third line (row), column 5, you would
calculate the location as follows:

    LOCATION = 40*(R-1)+(C-1)
             = 40*(3-1)+(5-1)
             = 40*(2)+(4)
             = 84

Data is entered and displayed immediately following the prompt, so
for a comfortable appearance you should add a space after the prompt.

Since lines are 40 characters, you can make one prompt appear directly under
the previous prompt by just adding 40 to the location.  Add 80 if you wish to
skip a line, etc.

Data file initialization
------------------------
Create a new TEXT file using the TEXT program.  On the first line enter the
number of fields (prompts) you need for this data file.  For EACH field, enter
a prompt <cr> and a location <cr>.  For example:

3
Name   :
44
Phone  :
84
Comment:
124

This example is for a file with 3 prompts (first line).  The first prompt
is the word "Name   :", and it will display at location 45.  Lines 4/5 and
lines 6/7 represent fields 2 and 3.  Be sure there are no extra CR's (blank
lines), but be sure there is a carraige return at the end of each line.

That's all you do manually, to set up a data file.  Some programs do this minor
chore for you, but to keep the program small enough to run in the ALTLCD
buffer, this task is done manually.


The Program (an XOS-C command utility)
--------------------------------------
You do NOT run DATFIL.CMD!  You store the program in bank #3 and select the
data file on the T200 Menu with the widebar cursor.  With the data file
under the widebar cursor, you press F3(Cmd) and then enter DATFIL, or whatever
you choose to call this utility.

If you do not select a .DO file, or if the .DO file does not begin with a
number (ie, number of fields = 0) then the program will not execute and you
will be returned to the menu.

Once you enter the program, all operations will be confined to the data
file that was cursor selected.  The following menu will be displayed...


DataFiler

        <A>dd
        <D>isplay
        <E>xit

        =>

Only an A, D, or E will have any affect.  All other responses are considered
invalid.

Press A to add data records to your new data file.  Press D to display records.
Press E to returm to the Tandy 200 main menu.  The program accepts upper or
lower case characters.

ADD data
--------
You will NOT be prompted to enter the name of the data file you wish to use.
The file was selected before you entered the program.

DATFIL will read the "header" info (the number of prompts, field names, and
locations).  You will then be prompted to enter data by displaying the prompts
 you selected, and the program will accept your input.

After each record is entered, you will be prompted with "More?".  Press N for
no more!  You are in the ADD mode so the program assumes you wish to continue
to add data, and only a "N" will break out of the ADD mode and return to the
A/D/E menu.

If you feel that a mistake was made when entering data, you will be able to
correct that error with the TEXT program.

DISPLAY data
------------
You will NOT be prompted to enter the name of the data file you wish to use.
The file was selected before you entered the program.

DATFIL will read the "header" info (the number of prompts, field names, and
locations).  You will then be prompted to enter "String" data for selective
record display.

Press ENTER if you wish to display all records, or enter characters to be
matched.  Only records containing the match string will be displayed, if a
match string is specified.

Each record is displayed by printing the field prompt at its location, followed
by the data entry.

After each record is displayed, the cursor jumps to the upper left corner
of the LCD and waits for a keyboard input.  Any key will bring up the next
record except "N".  Press N for no more!  You are in the DISPLAY mode so the
program assumes you wish to continue to display data records, and only a "N"
will break out of the DISPLAY mode and return to the A/D/E menu.

A beep will sound when the last record of the file is displayed, and the next
keypress will return to the A/D/E menu.  If the last record doesn't match the
specified string, then a beep will sound with a blank screen when the file has
been completely searched.


ERRORS
------
The beep is the only indication of an error.  If it occurs during the ADDing
of data then it may indicate an out of memory condition and you should examine
the data file to see if the last entry is properly organized.  If only a
partial record is found, you should delete that last partial record, and
then see about making more room in RAM before continuing to ADD data records.

If the last record is not properly organized, DATFIL may display data
 which is past the "end of file" marker.  This is harmless to your programs or
data files and is easily corrected using TEXT to correct the last data record
in the file.  Use the N command to abort the display.


SUPPORT UTILITIES
-----------------
DATFIL data files are completely compatible with files created by
CRDFIL.BA, and there are many utilities in DL4 that will enhance the use of
DATFIL.  These utilities can be located with KEY = CRDFIL when scanning or
browsing DL4.


Enjoy the program.... 

Paul Globman [72227,1661]
-----------------------------
Use HXFER to create DATFIL.CO


54F8BC0154F8CDD5A1FEC0C2454F23EBED22F0FFCD688222F2FFCD41F97BA7CAD23237D4454F21C8F9CD90F832DCF8E7D641CAF1F8D603CA9CF83DC271F8C721
04FACDCC11CDF712CD1410FE4EC9CD41F9CD14F921CC79CDCC11CDF6540570CD41F93A6FEFFE00C280F9D5CD22F9D5CDC6262AF4FFE5CD4CF922F4FFE1CDC626
E1CD4CF9D11DC2B8F8CDEBF8F53E00FE1ACAE7F8F1C2ADF8F5F1C370F8210DFAC390F8CD41F9D5CD22F9D5CDC626CDF654CD62F9E1CD4CF9D11DC2F4F8CD8DF8
C2F1F8C370F87B874FCD4CF90DC217F922F4FFC9E5CD4CF9E5C5CD1609EB230128001100001C5508F233F9EBCD9B4FC1D1E1C9CD4D4F2AF0FFE5CD1609E13E0A
06FF2B2304BEC251F9237EFE1AC032DCF8C3454F0423E52AF2FF480600CDA882D141DA454FCDBA4122F2FF2B360A2B360DC9E5D5C54F7B328FF91170EF2AF4FF
0601E5D5C5CD116EC1D1E1CABCF97EFE0A23CAA6F9C390F905C290F97EFE1A22F4FFC28EF9CD5CF921D7F8C3BFF921B8F822C6F9C1D1E1C3B8F80C4461746146
696C65720A0A0D093C413E64640A0D093C443E6973706C61790A0D093C453E7869740A0A0D093D3E20000C576F726B66696C653F20000D0A0A4D6F72653F001B
4800

