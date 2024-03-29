A treatise on the efficient and elegant use of Basic on the TRS-80 MOD-100
=======================================
by Richard Horowitz [75735,677]

   One of the greatest computers ever created is the one that I am using now
to write this essay.  Of course, it is our favorite baby, the MOD-100.  It has
a number of features that I have been used to for the past several years on
larger commercial computers, i.e. a real-time interrupt driven clock, the
interrupt structure itself, a typeahead buffer, a device structured I/O, etc.
I could rhapsodize a great deal more, but all of us know what a great machine
this is.  Withall, there are a number of shortcomings that exist as a result
of creating a totally portable machine. The most aggravating of these is the
shortage of memory.  For the last five years, I have been programming on a DEC
PDP-11/03, which also suffers the same deficiency.  As a consequence, I deve-
loped a number of strategies to cope with too much program in too little
memory. In the process I also discovered methods of speeding things up a bit.
Finally, I have uncovered a number of "features" unique to our own favorite
that can be useful in programming this machine.

    Speed & Conservation of Memory
    ===============================

   Every KEYWORD, quoted literal, punctutation mark, occupies a byte in mem-
ory.  Every line number uses two bytes for the number and a "Null" byte that
terminates each line.  Each space takes a byte.  Variables use a two-byte
pointer to the area in memory that the variable is stored in.  In addition,
each type of variable uses different amounts of storage space.  Integers -
require 2 bytes, reals - four bytes and double precision - eight bytes. Strings
take one byte for each character and they are allocated dynamically.  This
is all background for the following space & time saving tips:

 1: All variables should be typed at the beginning of each program.  Use
    DEFINT, DEFSNG, etc.  Even string variables should be typed because
    the "$" used with each such variable takes a byte of storage.
 2: Use integers wherever possible, especially in counting loops.  The
    time savings is dramatic.  Integers are 2 1/2 times faster than the
    default of double-precision.  Reals are only 25% faster than D.P.
 3: Eliminate the variable argument on the NEXT portion of FOR/NEXT loops.
    Here is a real kicker - besides the saving of one byte of storage for
    each such occurence, integers are 60% slower, reals are 50% slower
    and D.P. is 80% slower when you specify the variable than when you
    simply specify NEXT.
 4: Eliminate final quote marks on all literals that appear at the ends of
    lines. A byte is saved for each.
 5: Another surprise that violates all that I knew of previous Microsoft
    Basics is that semi-colons are NOT routinely needed as variable punc-
    tuation.  They only seem to be required after PRINT USING or if you
    want to keep the cursor from advancing to a new line or in an
    INPUT statement.  All other uses are gratuitous and can be left out
    to save one byte per occurence.
 6: Use as many multiple statements per line as you can since for each line
    number eliminated, you have a net savings of two bytes (the three
    needed for each separate line less the one byte used for each ":".
 7: Eliminate ALL spaces. Your archival copy should have them for intelli-
    gibility, but your running copy will save one byte for each space
    that is removed.
 8: Put all initialization code at the end of your program and do a GOTO
    or a GOSUB. Little used routines at the end make for a dramatic improv-
    ment in speed since MSBasic must search from the beginning of the
    file for each line referenced.
 9: Put all time critical code at the beginning of the program for the
    same reason as 8: above.
10: Initialize all variables before you start the main body of code.  This
    creates a stable, linear table of variables that are accessed more
    rapidly.
11: DO NOT use the supposed short-cut of raising a number to the .5 power
    to save some time over the SQR routine.  Inaccuracies in the 11th and
    12th decimal place might tend to screw up any further calculations
    in which you might use this result.
12: Assign literals that are used more than once in a program to a vari-
    able.  Do this in your initialization code.  Almost one byte per
    character is saved for each such duplication eliminated.
13: Use SPACE$(X) to assign X number of spaces rather than STRING$(X,32).
14: Another surprise: use REM instead of "'".  This save two bytes per
    occurence.  Of course, you should remove all REM statements of both
    types from your running copy.

   I hope that these random ramblings of mine will prove useful and will pro-
voke other users to add to this document to the benefit of us all.

=======================================

   One of the serious deficiencies of the built-in Basic interpreter is the
lack of user-defined functions.  I hope the RS will include them in any disk
extended basic that they come up with, when they come up with one, when and if
they come up with disk drives and an operating system.  At the same time,
perhaps they will implement the type of extended RAM addressing ala the NEC
MEWS.  Radio Shack, are you listening? With the DEFFN a great many subroutines
could be turned into callable functions A Trace feature as well as Random file
I/O would also be welcome. Let's hope!

=======================================

Lewis Rosenfelder's book "Basic Faster and Better & Other Mysteries" has a
wealth of information on sophisticated programming techniques.  Unfortunately
many of them require user defined functions.  It is, nonetheless worth buying
and reading.

=======================================

Good luck with all this.

Richard Horowitz [75735,677]

=======================================
