PRINT is a machine language text processor for the Model 100.  
This file describes the procedure for modifying PRINT to suit 
your own printer.  PRN100.DOC describes the features and use of 
PRINT.

The response to my original upload of PRINT was much more than I
expected.  I had alot of mail and messages to answer.  To save 
me (and you) some time, I re-wrote PRINT so that it can be 
configured to any printer.

CONTROL CODES:

Any character from A-Z except C,I,J,M,P,W,X,Y, and Z can be set 
up as a user-defined control sequence.  (I,J,M,Z are used by 
M100; C,P,W,X,Y are used by PRINT.)  In addition, each character
actually stands for two codes.

VERY IMPORTANT:  A user defined control character embedded in a 
text file MUST be followed by a + sign or a - sign!  You won't 
crash the program if you don't do that, but you may get strange 
results.

Most user defined codes will be for Bold Print On/Off, Underline
On/Off, etc.  That's the reason for the +/- following the 
control character.  However, PRINT won't mind if a ^A+ is 
totally different from a ^A-.  This should give you maximum 
flexibility to tailor PRINT to your needs.  It is permissible to
leave the + or - undefined.

CONTROL SEQUENCE STORAGE:

The computer stores the control sequences in the following 
manner:

First, the control character itself.
Next, the control sequence for +
Next, the value 255 to indicate the end of the + code
Next, the control sequence for -
And, finally, a 255 to end the minus sequence.

The pattern repeats for each control character that you define. 
After the last control sequence, an extra 255 is added to end 
the table.  Here's what a simple table would look like:

Addrs  Cont  Description
59900    1   Code for ^A
59901   27   ^A+ = 27,87
59902   87
59903  255   End of ^A+
59904   27   ^A- = 27,38
59905   38
59906  255   End of ^A-
59907   19   Code for ^S
59908  255   ^S+ is not used
59909   27   ^S- = 27,31,9
59910   31
59911    9
59912  255   End of ^S-
59913  255   End of Control Code Table

Fortunately, you don't need to understand any of this to set up 
your copy of PRINT.  Download PRN100.BAS and you will have a 
program that will ask you for your control sequences and then 
store them in the proper format.  Right now, PRINT has set aside
60 storage locations for your control codes.  If that isn't 
enough, edit line 20 of PRN100.BAS and change I=59900 to a lower
value.  To determine your space requirement:

1.  A = # of user-defined control characters.
2.  Multiply A*3
3.  Count all the numbers used in all your control sequences
4.  Add results from 2 with results from 3.
5.  Add 1 to results from 4.
6.  If your answer is less than 60, then you are OK.  Otherwise,
change Line 20 as described earlier.

FONT SPECIFICATIONS:

In PRINT, one of the user options is [F]ont Code.  The font code
can be any integer from 1-254.  You can select any code that is 
meaningful to you.  (I use characters/inch.)  Set-up is similar 
to the Control Codes.  The Fonts have 40 bytes available 
starting at 59960.  A sample look at the memory would be:

59960  10   Font Code #10
59961  27   Sequence is 27,45,0
59962  45
59963   0
59964 255   End of Sequence
59965  12   Font Code #12
59966  27   Sequence is 27,31,13
59967  31
59968  13
59969 255   End of Sequence
59970 255   End of Font Table

To see if 40 bytes is enough for all your Font Codes, do this:

1.  Multipy # of codes times 2
2.  Add 1
3.  Add the total count (not the sum) of all your Sequence 
Numbers.

If you come up with 40 bytes or less, then you are OK.  
Otherwise, you need to edit line 20 in PRN100.BAS and change 
J=59960 to a lower number.  You may also have to change I=59900 
to a lower number if you change J.

USING PRN100.BAS

The program allows you to inspect the status of your stored 
control characters and Fonts.  It also allows you to input a new
SET of control characters or a new SET of Font codes.  I didn't 
program the capability to modify one specific code.  I did 
include all kinds of error checking in the program.  You can't 
overwrite PRINT, the Control Characters won't overwrite the Font
codes, and vice versa.  Unfortunately, if an error like that 
occurs, you lose all your input.  You have to type in your 
control sequence again.

So, now is the time to dust off your Printer Manual and find 
your Control Sequences and Font Sequences.  I recommend you get 
organized before you enter the PRN100.BAS program.  Know what 
your + and/or - control codes are going to be, and know your 
Font codes and sequences.

To run PRN100.BAS:

1.  Download PRN100.BAS as PRNMOD.DO
2.  Using TEXT, delete any leading or trailing garbage.
3.  Go to BASIC
4.  Load"PRNMOD"
5.  At the OK prompt, Kill"PRNMOD.DO"
6.  Save"PRNMOD"
7.  Run

CAUTION:  If you are saving PRINT to RAM competely (ie, 
SAVEM"PRINT",59900,62959,60503) then make sure you LOADM"PRINT" 
before you run PRNMOD and SAVEM again after running PRNMOD.

The program is really pretty easy to use.  I think you will be 
delighted with the results once you get PRINT configured to your
specifications.  I hope you enjoy using PRINT as much as I 
enjoyed writing it!

REMEMBER:  ^C, ^P, ^W, ^X, and ^Y are embedded WITHOUT 
modifiers.  They are used for various formatting features in 
PRINT and are not user-definable.  Any user-defined control 
codes are embedded WITH a plus (+) or minus (-) modifier.

To Support Multiple Printers:

The printer control codes are all stored between 59900 and 59999
(unless you have changed the location in your computer).  If you
go to BASIC and type:

SAVEM"name",59900,59999

then you will save all your printer codes in a file called 
NAME.CO.  The file will be about 110 bytes, so it's very small.

Next, you can store a new set of printer codes (using PRNMOD.BA)
and save that set the same way.  Before running PRINT, just 
place the cursor over the printer file you want to use.  Press 
ENTER.  The screen will clear for a moment and then return to 
the Model 100 menu.  What happened when the screen cleared was 
that your chosen set of printer codes was restored at 59900-
59999!  Now you can enter PRINT and process normally.

For example, at home I have a Dynax printer.  At work, we have 
Okidata printers.  My menu on my M100 shows OKIDAT.CO and 
DYNAX.CO.  I can switch printers very easily using this 
technique.  Perhaps this tip will help others in similar 
situations.

Any questions?

Contact: Jim Irwin  72346,1020
         1329 Spruce Brook Road
         Kalamazoo, MI 49004

