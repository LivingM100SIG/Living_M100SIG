                    MILES PER GALLON COMPUTER
                        USER DOCUMENTATION

                    Mark Lutton, 73106,1627
                 Copyright (c) 1988 Mark Lutton

                      Version 0.9, 9/24/88


     About the version number:  I don't know of any bugs in this
program, but I don't consider a program bug-free until someone else
(other than me) has tested it.  Version 1.0 will be the same as this
version except that bugs (if any) will be fixed, and I may be
persuaded to change minor things in the user interface if enough
people complain.  I'd rather do it this way and ensure that 1.0 is
perfect than do the usual thing, which is to release a buggy 1.0
followed by a less-buggy 1.01A.


                         INTRODUCTION


     MPG.BA is a gas-mileage computer for your car.  Features:

     o  Runs on Tandy Model 100 or Model 102.  (I think it runs on a
Model 200 but I haven't tested it.)

     o  Stores and maintains 100 datapoints (more if you want).

     o  Easy, fast data entry.

     o  Instant on-screen display of miles per gallon.

     o  Automatic conversions between metric and English!  If you buy
your gas by the liter you can see the equivalent in gallons!

     o  Display of statistics: your best and worst mileage for city,
highway and mixed driving and your best and worst mileage overall.

     o  Graphs:  see a plot of your mileage over time.  Has it been
getting worse over the last few weeks?  Time for a tune-up!

     Now, to be honest, nothing comes easy, and to get the most out of
MPG you have to do this:  every time you get gas you must fill it up,
and you must also write down your odometer reading and the amount of
gas you bought and whether the driving you did since the last fill-up
was mostly fast steady driving on the highway, mostly stop-and-go
driving in the city, or mixed.  You don't have to wait until the tank
is nearly empty to get gas; you can fill up at any time.  

     Of course you can't fill the tank to exactly the same amount
every time, and so your mileage will appear to fluctuate from week to
week, but the average mileage will be valid.



                    GETTING STARTED

     MPG uses a data file called MPGDAT.DO to keep its database of gas
mileage.  If this file does not exist when you run the program, it
will be built for you automatically.  Between executions of the
program you can keep the MPGDAT.DO file in memory or store it on
cassette, floppy disk, another computer or anywhere.

     When you run the program you will see a screen like this:


          +----------------------------------------+
          |              GAS MILEAGE     1 (New)   |
          |Ref/Date:             City/Mixed/Hwy:   |
          |Start Miles:              KM:           |
          |  End Miles:              KM:           |
          |    Gallons:          Liters:           |
          |Miles/Gallon:         KM/Liter:         |
          |Press Spacebar to enter value.          |
          |Find Stat Prev Next Add  Del  Grph Menu |
          +----------------------------------------+

     There are no records of data yet so the program is letting you
enter a new one.  (You know this because you can see "New" in the
upper right-hand corner of the screen.)  You can use the cursor keys
to move around the fields.  Notice that the cursor will not go into
the Miles/Gallon or KM/Liter fields.  That is because these fields are
calculated, not typed in by you.  Shift-Down Arrow goes to the last
field (Liters) and Shift-Up Arrow goes to the first.

     The TAB key also goes to the next field, just like the Right
Arrow key.  The Enter key also moves from field to field but with a
difference.  Notice how it skips the KM and Liters fields.  This is
because you have not entered anything into these fields; it thinks you
prefer English units.  If the last odometer reading or gas amount you
entered was metric, it skips the English fields instead.

     The rule for entering data is the same for a new record as for an
existing record:  you must tell the computer you wish to change the
value in the field by pressing the spacebar.  Try it now.  The "Press
Spacebar" message is replaced by "New value?" followed by the cursor. 
The current field stays highlighted.  If you hit Enter without typing
a value the old value will remain unchanged.  Otherwise, type in a
value and hit Enter.

     The Ref/Date field (Reference or Date) is intended for the date
on which you bought the gas, but you can put any string here as long
as it does not contain commas.  There are 10 spaces so that if you buy
gas twice in one day you can enter the dates as "10/31/88a" and
"10/31/88b".  The value in this field should be unique so that you can
find it later.

     Put a date in the field and hit Enter.  The cursor moves to the
next field.  Again you must press the space bar to enter a value. 
Enter "C" if most of your driving was stop-and-go in the City, "H" if
it was on the Highway, or "M" if it was Mixed.  If you don't know or
don't care, enter "M".

     Now the Start miles field is highlighted.  The first time you
enter a record you must know the odometer reading the PREVIOUS time
you bought gas.  (When you add records later you will see that the
previous Ending mileage is automatically copied over.  But there will
be times when you have to change this, for instance if you skip a few
fill-ups.)

     If your odometer reads in miles, enter the previous reading here. 
It will be displayed with one decimal point.  (The maximum is 9
million miles, and I don't think any car has lasted that long.)  If
your odometer reads in Kilometers, press the TAB key once to move into
the KM field.  Whichever unit you enter, the other one will be
calculated and displayed automatically!

     Now enter your current reading in the End Miles or KM field.

     Remember that whenever you buy gas, the "End miles" and "Gallons"
are the CURRENT odometer reading and the amount of gas you bought; the
"Start miles" is the reading on the odometer the LAST time you bought
gas (not the last time you entered a record, if you bought gas a few
times since then).  Enter your Gallons or Liters.  It will be
displayed with 1 decimal place.  If you used one of those new-fangled
pumps that measures to the hundredth of a gallon, you can enter your
number with two (or more) decimal places if you wish.  It will still
be displayed with only one decimal place.  The maximum amount you can
enter is 9999.9 gallons or liters (sorry about that, jumbo-jet pilots!)

     As soon as you type in all three numbers your gas mileage for
that period will be displayed.

     Now you can do one of two things:  enter another record or press
F8 to save the data and return to the menu.  Try pressing F8.  If you
have filled in all the data (or have not filled in any), you will see
the message "Saving data, please wait..." and then you will be back at
the Model 100's main menu.

     If you forgot to enter one of the fields, you will get an error
message on the error line.  This is to prevent you from saving invalid
records in the data file.  You can either put in a value or else
delete this record by pressing F6 (Del).  Then you can press F8
without getting a complaint.

     (You may be thinking: What if I want to exit the program NOW
without saving any of my changes?  In this case you can press Ctrl-C
or Shift-Break.  You'll see a message like "Break in 100" in the
middle of the screen and you can then hit F8 to go back to the Model
100 menu.  None of your changes will be saved; your MPGDAT.DO file
will be as it was before you ran the program.  But what if you hit
Ctrl-C by mistake and don't want to quit?  No problem; instead of
going back to the main menu, just type "CONT" and press Enter.)


               MORE FEATURES

     Every time you want to add a record you must press F5 (Add).  New
records are added only to the END of the data -- you have to enter the
records in the order you got the gas.  The record you enter is
automatically added whenever you move to a different record, add
another record or exit from the program.

     Add a few new records now so that we can try out some other features.

     All set?  Try Ctrl-Up Arrow and Ctrl-Down Arrow.  These take you
to the first and last records respectively.  Try F3 (Prev) and F4
(Next).  These keys bring you to the previous and next records.  The
serial number of the current record is shown in the upper right-hand
corner.

     If you want to see the record for a particular date, press F1
(Find).  This allows you to search for the first record with a certain
value in the Ref/Date field.  It matches by "leading substring".  For
instance if you want to see the first purchase you made in July,
search for "7". (Or "07" if you enter your dates as "07/04/88".)

     After a year or so, you may approach the limit of 100 records. 
You can make some more space by deleting the current record; just
press F6 (Del).  The program will ask if you really want to delete the
record.  Type "Y" (Enter) to delete.

     You might find it more convenient to delete records by editing
the data file directly.  See "Data File Format" below.

     After you have entered a few records you can see statistics. 
Press F2 (Stat).  The program will calculate the statistics for you
and then display a chart that looks like this:

          +----------------------------------------+
          |               STATISTICS               |
          |           CITY   MIXED  HIGHWAY ALL    |
          | Best MPG    35.5   36.0   36.7    36.7 |
          |  Avg MPG    25.7   31.3   34.1    30.2 |
          |Worst MPG    20.8   24.5   29.2    20.8 |
          | Best KPL    15.1   15.4   15.6    15.6 |
          |  Avg KPL    11.3   12.6   14.5    12.8 |
          |Worst KPL     8.7   10.4   12.4     8.7 |
          +----------------------------------------+


     MPG is Miles Per Gallon; KPL is Kilometers Per Liter.

     Press any key (no, NOT Ctrl-C!) to return to the main screen.

     Now press F7 (Grph).  You will see graphs for City, Mixed,
Highway and All mileage, but you won't get a graph where you have only
2 records for that style of driving.  For instance you may see the
message "Can't graph City data: fewer than 2 data points."

     The graph will look something like this:

          +----------------------------------------+
          |             CITY MILEAGE               |
          |MPG:   35| ---       -     ___          |
          |         |-   --- --- -__--   ----__--- |
          |         |       -                      |
          |         |                              |
          |         |                              |
          |        0+----------------------------- |
          |          1/1/88               10/10/88 |
          +----------------------------------------+

     The "Ref/Date" fields for the first and last datapoints are shown
along the bottom of the graph.  The lowest point is 0 miles per gallon
and the highest point is your all-time best rounded up (in this case
the all-time best mileage was less than 35 MPG).

     Press any key to see the next graph.  After the last graph you
will be back at the main screen.  Press F8 (Menu) to save the file and
exit the program.



               PROGRAM SUMMARY

     Spacebar:  Change a value in a field.
     Enter:  Move to next field, skipping Metric (or English).
     Tab:  Move to next field.
     Arrow keys:  Move from field to field on the screen.
     Shift-Up Arrow, Shift-Down Arrow:  Move to first or last field on
          screen.
     Ctrl-Up Arrow, Ctrl-Down Arrow: Move to first or last record.


     F1:  Find a record by matching on Ref/Date field.
     F2:  Show statistics.
     F3:  Show previous record.
     F4:  Show next record.
     F5:  Add a new record.
     F6:  Delete this record.
     F7:  Graph the data.
     F8:  Save your work and exit the program.

     Ctrl-C, Shift-Break:  Emergency exit.


               DATA FILE FORMAT


     The data file MPGDAT.DO is an ordinary ASCII file which you can
display or edit.  Each record is one line and has five fields:

     Ref/Date,StartMiles,EndMiles,Gallons,City/Hwy/Mixed

     If StartMiles is omitted, the previous EndMiles value is used.

     For example:

     12/4/87,73053,73299,7.86,M
     12/12/87,,73551,8.6,M
     12/15/87,,73694,4.9,M

     If you clear out old records by editing the file directly,
remember that you MUST enter the starting mileage for the first record
by copying from the previous one.  Otherwise you may find yourself
getting 9,000 miles to the gallon!




                    PROGRAM MODIFICATIONS

     You may want to make your own modifications to the program.  Here
are a few of them:

     MORE DATA POINTS:  100 isn't enough?  Change the value of MP% in
line 9010, and change CLEAR 1500 in line 60 to CLEAR the value of MP%
times 15.  If you want 200, CLEAR 3000.  This will make the program
need more RAM memory when it runs.  OM error?  Reduce the memory
requirement by giving MP% a lower value and CLEARing less space.

     BEEP:  Can't stand the beeping after each graph is displayed? 
Edit the program and remove all BEEP's.

     MORE THAN ONE CAR:  If you want to use the program for more than
one car, you will need to use more than one data file.  You will have
to give the file name every time you run the program.  Change line
9040 as follows:

     9040 EM(0)=0:FILES:LINE INPUT "Data file? ";FN$:OPEN FN$ FOR
INPUT AS 1

     Change line 9500 as follows:

     9500 CLS:PRINT@85,"Saving data, please wait...":OPEN FN$ FOR
OUTPUT AS 1


     LITERS AND MILES:  If you buy your gas in liters but your
odometer reads miles, you will want to skip into the liters field. 
Change line 207:  Just before 
     
     ":ELSECF%=CF%+2" 
     
     insert

     "ELSEIFCF%=4ORCF%=5THENCF%=7".  
     
     In line 2442 change "CF%=6" to "CF%=7".

     In line 2470 change "PM%=1" to "PM%=0".

     (PM% means Prefer Metric.  This change lets you enter liters and
still Prefer English, but skip directly into liters from Ending Miles. 
You must use TAB if you want to get into Gallons.)




          END OF MPG USER DOCUMENTATION.

