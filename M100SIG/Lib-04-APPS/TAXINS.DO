                         Lucid Tax 1985                    Page 1



        INSTRUCTIONS FOR LUCID TAX CALCSHEETS FOR 1986

        Mark Lutton  
        Compuserve:  73106,1627
        Delphi: MARKLUTTON
        Revised for 1986 February 7, 1987

        The following files have been put into the DL database:

TAXINS.DO       These instructions
F1040.SRM       Form 1040 for Super ROM
SCHEDA.SRM      Schedule A for Super ROM
SCHEDB.SRM      Schedule B for Super ROM
TAXTBL.SRM      Tax Tables for Super ROM
F1040.LUC       Form 1040 for old Lucid (before Super ROM)
SCHEDA.LUC      Schedule A for old Lucid
SCHEDB.LUC      Schedule B for old Lucid
TAXTBL.LUC      Tax Tables for Super ROM
HEX2CA.100      Lucid Hex to .CA conversion utility (in 
                        UTILITIES database)

                DOWNLOADING AND PREPARING CALCSHEETS

        These are 4 LUCID calcsheets in .DO form as processed by 
Rick Perry's CHANGE.BA program.  In order to use these you must 
have the LUCID spreadsheet ROM or Super ROM from PCSG.

        The first thing you must do is decide whether you have 
the old Lucid or Super ROM.  If your ROM program includes Lucid, 
Thought, Write and Lucid Data you have Super ROM.  If it has 
Lucid only you have the old Lucid ROM.  The old and new Lucids 
use different files, and Super ROM files are not compatible with 
the old Lucid.  If you attempt to use the wrong combination you 
can cause a cold start!

        If you have the old Lucid, you need F1040.LUC, 
SCHEDA.LUC, SCHEDB.LUC, and TAXTBL.LUC.  If you have Super ROM 
you need F1040.SRM, SCHEDA.SRM, SCHEDB.SRM, and TAXTBL.SRM.  
Whichever you choose, download them into your Model 100 as 
F1040.DO, SCHEDA.DO, SCHEDB.DO and TAXTBL.DO.  You will also 
need HEX2CA.100 (or CHANGE.BA if you prefer) and TAXINS.DO 
(which you are reading right now).

        Convert the four calcsheet files to Lucid form as 
follows:  load the program HEX2CA.100 (as HEX2CA.BA) and 
F1040.DO into memory.  Run HEX2CA.  It will show a list of 
files.  At the "File to convert?" prompt type F1040 and hit 
ENTER.  It will say "Working..." and sit for several minutes.  
When it is done it will beep and say "Kill input file?".  Type 
"y" and hit ENTER.  Then save the file F1040.CA to cassette or 
disk or whatever you use for storage.  Do the same for the other 

                         Lucid Tax 1985                    Page 2



three files.

                FILLING OUT YOUR TAX FORMS

        These five calcsheets will make it easy for you to do 
your Federal income tax (assuming you use the long form and 
Schedules A and B).  Note that I am not giving any guarantees as 
to the accuracy of the sheets.  I have made them as general and 
as accurate as I could; however, there may be mistakes in them 
-- you should check all the arithmetic when you fill out your 
final tax forms.  Also, there may be things you need that I have 
left out.  You can add these things easily.  I tested these 
forms by filling in the numbers from the examples in "Your 
Federal Income Tax" from the IRS and the totals came out right 
-- proving that there is at least one set of numbers for which 
these calcsheets are accurate!

        Note that these calcsheets do NOT produce printed forms 
as required by the IRS.  This would be impractical in a 
small-screen, small-memory machine.  (There are Lotus 1-2-3 
templates available for the IBM PC that do this.)  The easiest 
way to use these templates is to enter the figures and let the 
computer do the calculations and then read the numbers from the 
screen and write them by hand into the tax forms.

        All cells into which you can enter data are unprotected 
and contain a line of dashes.  Lucid treats dashes as 0 for 
calculations; if you do not need to enter data into a line you 
can leave these as they are.  (On the tax forms themselves, you 
can either enter "0" or draw a dash.)  All other cells in the 
worksheets are protected.  If you need to change a value, you 
can unprotect a cell by hitting F7, Enter, F4.  For instance, if 
you do not use Schedule B, you can delete the references in 
F1040.CA in cell C8 (line 8 of the form) and cell B9 (line 9A) 
and replace them with 0.  Protect the cell after changing it if 
you wish.

        Load F1040.CA, SCHEDA.CA, SCHEDB.CA and TAXTBL.CA into 
your Model 100.  I assume you itemize your deductions and have 
interest income; if not, you can make changes where necessary in 
F1040 to delete references to unused schedules. 

        Let's start with F1040.CA.  There are three columns 
visible; Column A has labels.  Column B is for line items that 
are entered in the middle of the form (for example lines 24 
through 30); column C is for line items on the right-hand edge 
of the form (for example lines 7, 8, and 9c).  Be sure to put 
the amounts into the proper cells or the totals will not come 
out right.

        I recommend you use the "whole-dollar" method of 

                         Lucid Tax 1985                    Page 3



reporting.  You will notice that the sheet is already set up 
that way.

        Check off box 1, 2, 3, 4 or 5 on the form and put the 
number of the box you checked into cell C3.  This is extremely 
important; it is used to calculate tax.

        After finishing item 6, put the total number of 
exemptions (line 6e) into cell C5.

        Put wages, salaries, tips etc. into C7.  Leave cell C8 
alone; it will be filled in automatically after you do Schedule 
B.  Likewise leave cell B9 alone.  (Notice that 9a and 9b go 
into column B because they are not in the right-hand column on 
the tax form.)

        Put exclusion, if any, into cell B10.  Continue down 
this side of the sheet.

        Now that you have side 1 of Form 1040 done, go and do 
Schedules A and B.  (Notice that you do most of your filling in 
into Column B on Schedule A, and mostly into Column C on 
Schedule B.)  Then come back and finish filling out Form 1040.

        After you have put in all the information, perform the 
following ritual, and do it again any time you change any 
information:

     Call up SCHEDB.CA.  Hit F2 (calc), F8 (exit).
     Call up F1040.CA.  Hit F2, F8.
     Call up SCHEDA.CA.  Hit F2, F8.
     Call up F1040.CA again. Hit F2, F8.
     Call up TAXTBL.CA.  Hit F2, F8.
     Call up F1040.CA again.  Hit F2.

        The reason you have to do it that way is:  Interest from 
Schedule B must be calculated and put into Form 1040 (lines 8 
and 9), then line 33 from Form 1040 goes into Schedule A (line 
4), then line 26 from Schedule A goes into 1040 line 34a, then 
you go to TAXTBL to calculate the tax, and finally back to 1040 
to enter it.

        Now save your LUCID files to tape or print them out.

        Now you have done all the hard part and the fun begins.  
Put $2000 into an IRA (F1040 line 26a, cell B32) and see how it 
affects your tax.  Give $3000 to your favorite charity (Schedule 
A, line 15b, cell B25).  Give yourself a $100 raise on F1040 
line 7 (C7).  The dollar difference on line 55 (C71) is your 
"marginal tax bracket."  That is, if a $100 raise increases your 
tax by $33 you are in the 33% bracket.

                         Lucid Tax 1985                    Page 4



        Thinking of refinancing your home?  Figure out how much 
interest you will pay under your current mortgage and enter it 
on Schedule A.  Then figure out how much you will pay after 
refinancing.  Don't forget deductable closing costs if any.  How 
much more (or less) tax will you pay?  What about that tax 
shelter your brother-in-law suggested?

        One last thing:  Please don't write to me asking for tax 
advice.  I don't know any more about taxes than you do.  But 
write or leave a message if you find bugs in the calcsheets or 
discover interesting "what-if" things to do.  Also, if there is 
a schedule you need and you feel like taking the time to set it 
up as a calcsheet, I hope that you will upload it here for the 
rest of us to use.


                        Mark Lutton

