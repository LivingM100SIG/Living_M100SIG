                    MILES PER GALLON COMPUTER
                     TECHNICAL DOCUMENTATION

                    Mark Lutton, 73106,1627
                 Copyright (c) 1988 Mark Lutton

                      Version 0.9, 9/24/88


     Normally when I write a program I include the technical
documentation right in with the source code.  However, BASIC programs
take up space in the memory of the computer, and so it is better for
the user to leave all the remarks out.  For the benefit of programmers
who may want to modify or customize this program (like me), here is a
complete description of all the routines, variables, and so forth.



                        FILE FORMAT

    Well, to start with, MPG is a database program and the data is
kept in the file MPGDAT.DO.  When you start the program MPGDAT.DO is
read in (if it exists), and when you exit the program it is written
out again.  Other than that, the file is not accessed at all during
execution of the program.

    Each line of the file represents one "record" or "datapoint" and
contains five fields which are REF/DATE (a string that uniquely
identifies this record, such as the date you got the gas), START
MILES, END MILES, GALLONS and CITY/MIXED/HIGHWAY.  REF/DATE is up to 10
characters.  Most likely the user will use it for the date as for
instance "9/18/88".  There is extra room in case you got gas twice in
one day; you might give the second one as "9/18/88b".  The user is
cautioned against putting a comma in this field.

    The numeric fields are internally floating point, and are stored
in the file in ordinary decimal format, usually with one decimal
place.  START MILES is the odometer reading the last time you got gas
(for instance 12358.2), END MILES is the odometer reading now (for
instance 12581.8), and GALLONS is the number of gallons of gas you got
(for instance 10.3).  The numbers are stored in English units whether
you entered them that way or not.  CITY/MIXED/HIGHWAY is "H" if you drove
mostly on the highway since the last time you got gas, "C" if mostly
in the city (stop-and-start driving gives you crummy gas mileage) and
"M" for mixed.

    Typically START MILES for one fill-up is the same as END MILES
for the previous one.  If START MILES is blank in a record, the value
for END MILES from the previous record is used (0 if it is the first
record of the file).

    A typical file:

    9/18/88,12358.2,12581.8,10.3,M
    9/24/88,,12724.3,8.5,C
    10/2/88,,13012.8,9.4,H




                    INTERNAL DATA

    The program uses double-precision, integer, and string variables. 
My normal style is to use only integer variables and give a DEFINT A-Z
command, but floating-point is more convenient for this program.  The
variable types are distinguished by their suffixes in the usual way.

    The program allows for 100 data points, which for me represents
nearly 2 years of driving.  MP% (think Maximum dataPoints) is a
constant set to 100.  The data arrays are dimensioned from 1 to MP%. 
This of course causes there to be an element 0 which is not used,
(except that if START MILES(1) is blank, 0 will be copied from END
MILES(0)).  100 datapoints will require about 1300 bytes of string
space; line 60 contains "CLEAR 1500".  If you increase MP% you should
change this too.

    Some other constants:  CR$ is a carriage return, ESC$ is an
escape (CHR$(27)), QU$ is a double quote ("), and RV$ and NR$ are
codes which when written to the LCD display cause the next outputs to
print in reversed (white-on-black) or normal letters.  LPG is the
number of liters in a gallon and KPL is the number of kilometers in a
mile.

    RF$(MP%) holds the REF/DATE fields,  SM(MP%) the start miles,
EM(MP%) the end miles, GL(MP%) the gallons of gas purchased, and
CMH$(MP%) an "H", "M" or "C" for CITY/MIXED/HIGHWAY.  Other statistics
for the current datapoint are calculated only as needed: SK = start
kilometers (SM * KPM), EK = end kilometers (EM * KPM), LI = liters (GL
* LPG), MI = miles traveled (EM - SM), MPG = miles per gallon (0 if GL
= 0 to avoid an error, else MI / GL), KPL = kilometers per liter
((MPG / LPG) * KPM).

    CP% is the Current Point, the one we are looking at on the
screen.  NP% is the Number of valid Points we have in memory.  CP% and
NP% must always be less than or equal to MP%.  CP% is one greater than
NP% when we are adding a new datapoint.  Otherwise 1 <= CP% <= NP%. 
Datapoint 0, although present in the array, is not used.  Any
datapoint in the range 1 to NP% is "valid" in the sense that it
contains data that has been checked for consistency -- assuming it was
valid in the file.  (There are no validity checks when reading the
file.)  Consistency is checked when the user tries to move from one
datapoint to another.

    Other variables will be introduced as the need arises.  There are
some temporary variables (T1$, T2$, T1%, T2%, T3) with no fixed meaning.



                        VISUAL DISPLAYS


    There are only three major types of display:  Primary, Stats, and
Graphs.  Stats and Graphs will be covered later.  The Primary display
looks like this:


         0    5   10   15   20   25   30   35  39
         +----------------------------------------+
     0   |              GAS MILEAGE     nnn (new) |
     1   |Ref/Date: xx/xx/xxxx  City/Mixed/Hwy:M  |
     2   |Start Miles:9999999.9     KM:9999999.9  |
     3   |  End Miles:9999999.9     KM:9999999.9  |
     4   |    Gallons:   9999.9 Liters:   9999.9  |
     5   |Miles/Gallon:  9999.9 KM/Liter: 9999.9  |
     6   |Press Spacebar to enter value.          |
     7   |Find Stat Prev Next Add  Del  Grph Menu |
         +----------------------------------------+


    The fields are numbered starting from 0: 0 = Ref/Date, 1 =
City/Mixed/Highway, 2 = starting miles, 3 = starting KM, 4 = ending
miles, 5 = ending KM, 6 = gallons, 7 = liters, 8 = miles per gallon, 9
= KM per liter.  CF% is the number of the current field, and this
field is in reverse letters on the screen.  Fields 8 and 9 cannot be
input.  CF% is set to 8 or 9 only to call a subroutine to display one
of these fields.

    Line 6 is the message line.



                    USER INTERFACE

    In the Primary display the user sees the screen with one field
reversed.  Here is what he can do:  he can press the spacebar to
change the value of the field (and then type the value on line 6),
press TAB or ENTER or the cursor control keys to move to a different
field, or press one of the 8 function keys.  Any other key does
nothing.  The Stats and Graphs displays are for looking at only; any
key goes on to the next screen.



                    PROGRAM STRUCTURE

    Lines 10-15 are my comments and copyright.  Lines 50-99 do
initialization.  The main loop is in lines 100-999 and the rest of the
lines are subroutines.  Lines 9000 and 9500 are the subroutines for
initialization and termination respectively.


            INITIALIZATION AND TERMINATION

    SUB 9000:  Set up our constants and dimension our arrays.  (The
array STAT will be explained later.)  We do not set MAXFILES; this
defaults to 1 which is what we need.  We assume that a user who knows
enough to set it to 0 also knows what a BF error is.

    We set EM(0) to 0 in case we have to copy it to SM(1) (although I
think this is not necessary because BASIC arrays are automatically
initialized to 0).  Open the file "MPGDAT.DO".  If the file does not
exist we will get an error 52 and goto 9100 (via 9400).  This is the
only time in the program where an "ON ERROR" is used.  If the file
does not exist we set NP% to 0 and CP% to 1, meaning there are no
datapoints and we are entering a new one. 

    If the file DOES exist we assume it is in the correct format and
read it into our arrays RF$, SM, EM, GL and CMH$, counting the number
of records in NP%.  Start Miles of 0 (two commas in a row in the input
file) are set to Ending Miles of the previous datapoint.  We close the
file and set CP% to 1.

    In either case we set CF% (the current field) to 0 and then set
up our function key interrupts to take us to the 8 function-key
subroutines (6100 through 6800).  Then we return.

    SUB 9500:  The user will request termination by pressing F8.  If
the currently-displayed datapoint is "valid" (or empty if it is the
"new" datapoint at NP%+1) we allow him to terminate and call 9500.

    For every valid datapoint we create a record.  We convert SM, EM
and GL to strings F2$, F3$ and F4$.  F2$ is the null string if SM(CP%)
= EM(CP%-1).  The STR$ function puts a blank space at the front of the
string for the minus sign if any.  We get rid of this blank space.  We
count on the user to enter his data with only 1 decimal place which is
how we will display it.  Entering it differently is no big deal, but
for instance if he entered "3.14159" it will be displayed as "   3.1"
and stored as "3.14159".  If the user entered the data right, the STR$
function as used here gives us a more efficient file (no blanks) than
PRINT USING.

    When we are done, we exit to the Model 100's MENU.



                    MAIN LOOP

    Just after calling 9000 and before entering the main loop we call
subroutine 1000.  This subroutine clears the screen, displays the
current datapoint (at CP%) (which may be the "new" one at NP%+1) and
sets the current field (CF%) to the Ref/Date field (0).

    The main loop begins at 100; it waits for a key and assigns it to
A$.  If the user hits a function key the ON KEY interrupt takes us to
the function key interrupt at 6n00.  Otherwise we KEY STOP to disallow
interrupts, process the key, KEY ON again and loop back.

    We set A to the numeric value of the key pressed and handle them
as follows:  TAB(9), ENTER(13) and right arrow(28) take us to the next
field (wrapping back to the first field on this same record); left
arrow(29) takes us to the previous field (wrapping to the last); up
arrow(30) takes us up one line which is back 2 fields (wrapping to the
last line) and down arrow(31) takes us to the next line which is
forward 2 fields.

    Shift-UpArrow(23) takes us to the first field and
Shift-DownArrow(25) to the last field of this record. 
Ctrl-UpArrow(20) takes us to record 1, field 0 and Ctrl-DownArrow(2)
takes us to the last record, field 0, but does nothing if we are in
the "new" record at NP%+1.  Space(32) lets us input a value into the
current field by calling SUB 2000.

    For cursor movement within the record we call 2250 to print the
current line in normal video, then set CF% to make a new field the
current field, then call 2200 to print the current field in reverse
video.  To go to the first or last record we set WP% (WishPoint) to
that record, then call 2600 which will validate the current record
and, if valid, go to the chosen record.



                TINY SUBROUTINES

    Tiny utility subroutines are at 8000-8999.

    SUB 8000:  Print "Press Spacebar to change value." on line 6.

    SUB 8100:  Blank line 6 and locate the cursor at the beginning of
that line.

    SUB 8200:  Beep and wait for the user to hit a key.




                DISPLAY CURRENT RECORD

    SUB 1000:  Clear the screen, display the current record, and set
the Ref/Date field as the current field.  We must call this subroutine
whenever we change CP%.  It also calculates metric figures,
miles/gallon etc. for the current datapoint.

    For a "new" record (CP%>NP%) it sets all the data to 0 and
displays just the labels with blanks for the data, except that
starting miles and kilometers are set to the previous ending values
(to make data entry more convenient).  Otherwise it calculates SK
(starting KM), EK (ending KM), LI (liters), MI (miles), MPG
(miles/gallon), and KPL (KM/liter), and then displays everything.  In
either case the Ref/Date field is reversed and CF% is set to 0.



                GET INPUT FOR CURRENT FIELD

    SUB 2000:  The user has hit Space, meaning he wants to type a
value into the current field.  GOSUB 8010 to clear line 6, ask "New
Value?" and get a response into R$.  If R$ is blank, assume the user
does not want to change the value and return.

    Set SC% to 0.  SC% means "Stats calculated."  Any change to a
value (except Ref/Date, but we don't make the exception) makes it
necessary to recalculate the stats if the user wants to see STATS or
GRAPHS.  By setting SC% we can avoid calculating the stats when not
necessary.

    Call subroutines 2400 through 2470 assign R$ to the right field and
advance to a new field.  Then we call 8000 to restore the "Press
spacebar" message and return.

    SUB 2200 reverse-prints and SUB 2250 normal-prints the current
field.  They share code, setting T1$ to the code for reverse or normal
print.  ON CF% GOTO takes us to the right line for this field.  (Note
that this is the subroutine where CF% can be 8 or 9.)  Whichever field
is required, we move the cursor to the right place, print the normal
or reverse code, print the field with a PRINT USING statement, print
the normal video code, and return to the caller.

    SUBS 2400 through 2470:  assign R$ to the field represented by
CF%, then normal-print the field, change CF%, and reverse-print the
new current field.  When you type into a "Metric" field we set PM%
(Prefer Metric) to 1; when you type into an "English" field we set it
to 0.  From Ref/Date we move to C/M/H; from C/M/H to starting miles or
kilometers (depending on KM%); and from each numeric field to the next
English or Metric field; from gallons or liters back to Ref/Date in
this same record.

    SUB 2400: Assign R$ to RF$(CP%), making sure that there is no
comma in the input (a comma will cause problems the next time we try
to read the file).  Normal-print this field; move to C/M/H;
reverse-print C/M/H; return.

    SUB 2410: Upper-case R$ and make sure it is C or M or H.  Beep if
not, else assign to CMH$(CP%).  Normal-print this field; move to the
next English or Metric field; reverse-print it; return.

    SUB 2420: Set Starting Miles = R$; calculate Starting Kilometers;
Prefer English (set PM%=0); normal-print both Starting fields;
calculate and print MPG and KPL (via GOSUB 2500); move to Ending
Miles; reverse-print Ending Miles; return.

    SUB 2430: Set Starting Kilometers = R$; calculate Starting Miles;
Prefer Metric (set PM%=1); normal-print both starting fields;
calculate and print MPG and KPL; move to Ending Kilometers;
reverse-print Ending Kilometers; return.

    SUB 2440: Set Ending Miles = R$; calculate Ending Kilometers;
Prefer English; Normal Print Ending Miles and Kilometers; calculate
and print MPG and KPL; move to Gallons; reverse-print Gallons; return.

    SUB 2450: Set Ending Kilometers = R$; calculate Ending Miles;
Prefer Metric; Normal Print Ending Miles and Kilometers; calculate and
print MPG and KPL; move to Liters; reverse-print Liters; return.

    SUB 2460: Set Gallons = R$; calculate Liters; Prefer English;
Normal Print Gallons and Liters; calculate and print MPG and KPL; move
to Ref/Date; Reverse Print Ref/Date; return.

    SUB 2470: Set Liters = R$; calculate Gallons; Prefer Metric;
Normal Print Gallons and Liters; calculate and print MPG and KPL; move
to Ref/Date; Reverse Print Ref/Date; return.

    SUB 2500: Calculate MI = EM - SM.  If Gallons = 0 then MPG = 0
(avoid a divide exception).  Otherwise MPG = MI / GL; if MPG less than
0 (as could happen if user sets SM before setting EM) set MPG = 0.  Do
the same for KPL.



                    VALIDATE DATAPOINT

    SUB 2700:  This subroutine will set V% = 0 (record not valid) or
1 (record is valid).  If record is not valid, VF% will indicate the
field that is causing trouble.  (Currently VF% is not used outside
this subroutine, but it could be.)

    If this is the "New" record (CP% = NP%+1), the record is "valid"
if all the fields are blank/zero.  In this case the user has not
entered any data into this record; we do not add the record.

    Check all the fields one by one.  If they all check out OK, set
V%=1, and if this is the "new" record, set NP% to officially add it.  Return.

    If a field did not check out, display an error message on the
message line, normal-print the current field, make the bad field the
current field and reverse-print it, then return.


                GO TO A DIFFERENT RECORD (DATAPOINT)

    SUB 2600:  Called with WP% = the record you want to go to. 
Validate this record by calling 2700.  If invalid, just return. 
Otherwise set CP% to equal WP% and call 1000 to make it the current
record.


                    HANDLE FUNCTION KEYS

    Hitting F1 through F8 causes an interrupt to a line in the range
6100 through 6800 (because of the ON KEY GOSUB 6100... we did during
initialization).  For each subroutine we KEY STOP to prevent
interrupts within interrupts, do some processing, then KEY ON and RETURN.

    SUB 6100 (F1, Find):  Ask for a value to find in the Ref/Date
field.  Input it into T1$.  If T1$ is blank, they don't want to look
for anything; just return.  Otherwise, look for the matching datapoint
starting with the first.  Do a "substring" match; this allows "8/20"
to match "8/20/88".  If not found, say so.  Otherwise set CP% and
GOSUB 1000 to make the found point the current one.

    SUB 6200 (F2, Stat): If we need to calculate the statistics
(SC%=0) then GOSUB 3000 to do so.  Then GOSUB 4000 to display them.

    SUB 6300 (F3, Prev):  If we are already on the first record, say
so.  Otherwise set WP%=CP%-1 (set the WishPoint) and GOSUB 2600 to
validate the current record and, if valid, go to the desired one.

    SUB 6400 (F4, Next):  Similar to SUB 6300.  Note that you can't
get to the NEW record this way -- you must hit F5 (Add) to do that.

    SUB 6500 (F5, Add):   Don't allow adding a record if we are full
(NP% = MP%).  Otherwise set WP%=NP%+1 (we Wish to go to the New
record) and proceed as for F3.

    SUB 6600 (F6, Del):  First, confirm that the user wants to delete
the record.  (If not, return.)  Then, two cases.  Case 1:  CP% > NP%, we
are on the new record:  just reset all the values and GOSUB 1000 to
display them.  Case 2: CP% <= NP%.  For all the records from CP% to
NP%-1 move the values in the next record to the ones in the current
record.  Reset the values in the last record (NP%) for the next time
this becomes the "new" record.  Decrement NP% (Number of Points).  If
CP% is now greater than NP% (we deleted the last record) set it to
NP%.  (This means that normally the current record will be the one
after the deleted one, but if the last one is deleted it will be the
one before.)  GOSUB 1000 to display the new current record.  Set SC%=0
because deleting a record affects the stats.

    SUB 6700 (F7, Grph):  Calculate the stats if SC%=0.  Then GOSUB
5000 to graph them.

    SUB 6800 (F8, Menu):  GOSUB 2700 to validate the current record. 
If valid, let user out (GOTO 9500 -- it will never return).  Otherwise
return.  The user must straighten up (or delete) the current record
before he can leave.




                        STATISTICS


    Statistics are kept in the array STAT(4,9).  The 0 subscripts are
not used (except for a little "just-in-case" stuff which you'll see
below).  STAT looks like this:


                    1        2        3        4
                    City      Mixed     Highway    All
    1  Number Points
    2  Total Miles
    3  Total Gallons
    4  Best MPG
    5  Average MPG
    6  Worst MPG
    7  Best KPL
    8  Average KPL
    9  Worst KPL

    (The first subscript (x) goes across; the second (y) goes down.)

    STAT (1,4) will equal NP%.  STAT(1,1) is the number of points
where CMH$ = "C"; likewise for M and H.  STAT(x,2) is the total miles
we have driven for each condition.

    We calculate MPG for each point so that we can set Best MPG to
the highest value and Worst MPG to the lowest.  

    SUB 3000:  Calculate Statistics.  Aside from the references
within the STAT array being cryptic, the code to calculate the
statistics is pretty straightforward.  In the (impossible) case where
CMH$ does not equal C, M or H, the statistics are dumped into column 0.

    SUB 4000:  Print Statistics.  This prints rows 4 through 9 of the
array above, in a screen that looks like this:


         0    5   10   15   20   25   30   35  39
         +----------------------------------------+
     0   |               STATISTICS               |
     1   |           CITY   MIXED  HIGHWAY ALL    |
     2   | Best MPG  ####.# ####.# ####.#  ####.# |
     3   |  Avg MPG  ####.# ####.# ####.#  ####.# |
     4   |Worst MPG  ####.# ####.# ####.#  ####.# |
     5   | Best KPL  ####.# ####.# ####.#  ####.# |
     6   |  Avg KPL  ####.# ####.# ####.#  ####.# |
     7   |Worst KPL  ####.# ####.# ####.#  ####.# |
         +----------------------------------------+


    We wait for the user to hit a key and then return.

    SUB 5000:  Graph Statistics.  We GOSUB 5100 four times, for City,
Mixed, Highway and All, then we return.

    SUB 5100:  First we make sure we have at least 2 datapoints.  If
not, we print a message and return.

    Otherwise, we set up a screen like this for graphing:

         0    5   10   15   20   25   30   35  39
         +----------------------------------------+
     0   |             CITY MILEAGE               |
     1   |MPG:   35|                              |
     2   |         |                              |
     3   |         |                              |
     4   |         |                              |
     5   |         |                              |
     6   |        0+----------------------------- |
     7   |          1/1/88               10/10/88 |
         +----------------------------------------+

    The number after MPG: is your best mileage ever, to give the
graph a reasonable scale.  The dates at the bottom are your first and
last Ref/Date, to give a reasonable range.  The gridlines are at
column 60 and row 55 (in terms of pixels).

    New variables:  YMAX is your best mileage ever, rounded up.  X1%
is a column subscript into STAT, XH$ C, H, M or A to correspond to
X1%, and XT$ is a corresponding title (City, Mixed, Highway, All). 
For each datapoint we will draw a line from the "old" mileage to the
"new" mileage (we draw one less line than the number of datapoints). 
XO and YO are the coordinates of the "old" mileage point on the graph;
XN and YN are the new ones.

    YO is set to 0 to start, as a signal that we don't plot a line
for the first data point.  XO is set to 60, the origin.  We must get
the X value from 60 to 239 in STAT(X1%,1)-1 steps (STAT(X1%,1) is the
number of datapoints we are plotting for this graph), so we set XD (X
Delta) to 179/(STAT(X1%,1)-1).

    We step through our datapoints, picking them all if XH$="A",
otherwise picking only the City, Highway or Mixed ones.  When we pick
a point we set XN and YN to represent it:  we set XN to XO plus XD to
take us across the graph by a step, we calculate MPG, and we set YN to
the proper value in the range 8 to 55, where 55 = 0 MPG and 8 = YMAX. 
Then if YO is not 0 we plot from (XO,YO) to (XN,YN).  Then we set the
old values to the new values and loop back.


                    SUBROUTINE SUMMARY


     100:  Main loop.
    1000:  Set CF% to 0.  Clear screen and display current datapoint.
    2000:  Get input for current field into R$ and assign it.
    2200:  Display current field in reverse.
    2250:  Display current field normally.
    2400:  Validate input for Ref/Date field and assign it.
    2410:  Validate input for City/Mixed/Highway and assign it.
    2420:  Assign Start Miles field.
    2430:  Assign Start KM field.
    2440:  Assign End Miles field.
    2450:  Assign End KM field.
    2460:  Assign Gallons field.
    2470:  Assign Liters field.
    2500:  Calculate and display miles/gallon, KM/Liter
    2600:  If current record is valid, go to record at WP%.
    2700:  Validate current record.  V%=valid, VF%=invalid field.
    3000:  Calculate statistics.
    4000:  Print statistics.
    5000:  Graph statistics.
    5100:  Graph one "column" of the statistics table (called 4 times).
    6100:  Function key 1: Find
    6200:  Function key 2: Stat
    6300:  Function key 3: Prev
    6400:  Function key 4: Next
    6500:  Function key 5: Add
    6600:  Function key 6: Del
    6700:  Function key 7: Grph
    6800:  Function key 8: Menu
    8000:  Print "Press Spacebar to change value."
    8010:  Clear message line.
    8200:  Beep and wait for a key.
    9000:  Initialize.
    9500:  Terminate.



            THE END
