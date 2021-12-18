TUTOR1.ASM
01 Nov 84

An Assembly Language Tutorial for the Model 100
===============================================

By Mike Berro  [75765,473]

   (C) 1984 BCS Software


0.  Preface.
------------

	I have an ulterior motive for writing this.  I want to sharpen my
technical writing skills.  Any comments or criticisms about contents or style
would be appreciated.  Also, I will be happy to try to answer any questions
you have about assembly language.


1.  Switching Gears from Basic to Assembly Language.
---------------------------------------------------

	After programming in Basic, using assembly language may at first
seem like switching from the Model 100 to the HP-41 calculator.  Gone are
string variables and the print statements.  You don't even have a multiply
or a divide command like the HP-41.  You have to multiply or divide by using
successive additions or subtractions.  However, the benefits over Basic include

high speed and small size.
	My game Planet Protector (PLANET.SRC on CompuServe's Model 100 SIG)
is only 2.5K long, and the spaceships move reasonably smoothly across the
screen.  Compare tht to my earlier Basic game Starfighter (STARF.100), which
is over 10K long and slower than anything.  And doing what is essentially
bit-mapped graphics to produce your own shapes would slow Basic down by at
least another factor of ten.
	Anyway, since you're still reading this you probably already know
the advantages of assembly language, so we'll begin.

2.  How to Use This Tutorial.
-----------------------------

	It would be to your benefit to have at least a reference book on
8085 assembly language, if not a textbook.  I am not trying to write a
book here, so there may be some information left out.  This tutorial
is designed as an adjunct to a text book, and not a substitute.
	It will also be useful for you to have an assembler.  See HELP.ASM in
XA4 for help in choosing one.  The sample programs I use will be formatted
for Custom Software's assembler, but only because that happens to be the one
I have.  You should have no difficulty translationg to your own assembler.
	Also it is very important to backup all the files on your M100
before you assemble any program.  Basic (almost) always makes sure that it
doesn't clobber other files (unless you open a file for OUTPUT instead of
INPUT.)  If you assign a value to a variable, the value does get stored in
memory, but Basic will never store it in a protected area of memory.
	Machine language programs have no compunction about storing values
anywhere.  If you make a typo so that the program stores values where the
file directory should be you're in big trouble.  And it happens to the best
of 'em.  Maybe I'm being paranoid, but I'll say it again:

>>>>>> BACKUP ALL YOUR FILES BEFORE YOU BEGIN ASSEMBLY <<<<<<

	Our goal for this series is to be able to write a program that allows
you to design any shape, and then move it across the screen.  The shape table
will be stored in a text file created by the user.  The program will be called
SHAPE.  It will take several installments of TUTOR before we are finished.

3.  What an Assembler Does.
---------------------------

	An assembler converts your source file, which is a text file, into
a machine language file.  You create the source file using the built-in text
editor.  The source file contains the source code that the assembler converts
into a series of numbers that represent the instructions you want carried out
(machine language.)
	The numbers are stored in memory, and then the memory locations
used are identified by assigning a filename to them, with the suffix ".CO".
The .CO file is called a machine language file.
	It is possible to program directly in machine language by poke-
ing the numbers directly into memory, but that gets tedious quickly. Machine
language is all numbers, no english commands at all.  Assembly language
consists of "memnonics" that represent the machine language numbers.  You only
have to remember the memnonics, which by definition are supposed to be easy to
remember.  Then the assembler converts the memnonics into machine language for
you.
	The next section deals with binary and hex numbers, and with some
of the inner workings of the 80C85.

4.  The 80C85 and Number Systems.
---------------------------------

	At this point you need to know the binary and hexadecimal number
systems.  In this section I will try to explain why you need these other
number systems.  If you are not familiar with them, most books about assembly
language start with them.  If your book does not, it probably is not a
beginner's book.
	The CPU in the Model 100 is an 80C85 integrated circuit.  (The C
stands for CMOS, which is a battery conserving type of electrical device.)
As such it only responds to electrical signals, no matter how much you yell at
it.  It is an 8-bit CPU, which means it can respond to eight signals
simultaneously.  Each signal is a bit.  Now the CPU is also a digital device,
so each signal can only be a one or a zero.  Music is an analogue signal; you
can send Beethoven's fifth symphony through one wire (although it sounds
better through two.)  A digital signal can only be on or off, one or zero.
	Given an 8-bit digital CPU, there is a limit to the number of
different messages or commands that we can give it at any one time.  In fact
there are only 256.  00000000 is one message, 00000001 is another, 00000010
is the "next" one, up to 11111111.  These are all binary numbers since
each digit (bit) can be one of two values.  We normally use the decimal
numbers from 0-9 (ten values).  Assemblers very often use hexadecimal
numbers, which use 16 values.
	All three number systems are used in assembly language programming.
In fact, the only reason to use decimal numbers is because we are familiar
with them.  The CPU only recognizes ones and zeroes, eight at a time.  There
are 256 combinations possible.  Hexadecimal is used because of convenience.
	Look at Table 1.  Notice that the left hexadecimal digit precisely
-------------------------------------------------------------------------------

Dec  Binary    Hex  Oct
000  00000000  00   000
001  00000001  01   001
002  00000010  02   002
...  ........  ..   ...
010  00001010  0A   012
011  00001011  0B   013
012  00001100  0C   014
013  00001101  0D   015
014  00001110  0E   016
015  00001111  0F   017
016  00010000  10   020
017  00010001  11   021
...  ........  ..   ...

TABLE 1.  Number Systems
-------------------------------------------------------------------------------

corresponds the left four digits of the binary number, and the right hexa-
decimal digit corresponds to the right four digits of the binary number.
Binary numbers would be appropriate to use, but they take up more memory in
your source file (8 digits).  Hexadecimal numbers are the next logical
choice.
	Octal numbers are sometimes recommended for the 8085.  The first
two digits of the binary number correspond to the first octal digit, the next
three digits correspond to the second octal digit, and the last three binary
digits correspond to the last octal digit.
	I do not recommend that you learn octal arithmetic, although it
couldn't hurt.  Octal arithmetic is very useful for converting the source code
into the actual machine language, but since that is what our assembler is
supposed to be doing for us, there is no real need to master it.


