          GETTING INTO ASSEMBLY LANGUAGE - from someone who did.
          ======================================================

By Mike Berro [75765,374]
   BCS Software
   27 Oct 84

	This started as a response to a request for information about assembly
language programming.  Opinions expressed herein are not necessarily the
opinions of anyone else.  If you disagree, please let me know.  If you
have specific questions, send 'em to me and I'll try to answer them.  I'm not
an expert on the Model 100, but it seems that sometimes the experts do not
have the time to help the beginner.


1.  Introduction
----------------

	Learning assembly language is difficult, but rewarding.  Basic
cannot come near it in speed and small size.  From my experience with Basic
compilers on the Apple and IBM computers,  compiled Basic is almost as
fast, but the size of the program may be 50% larger.  I don't think a compiler
is a viable alternative on the Model 100 (although I would like to be proven
wrong.)

2.  Learning Materials
----------------------

	The instruction set of the 80C85 is almost identical to the 8080.  The
8080 has been around a long time, and there have been many books written
about it.  I haven't found any really good books, though, like I have on the
6502 (Apple, Commodore, Atari.)  Many of the books were written at a time when
the only people who used assembly language were those that built their own
computers, and they assume that you know all about them.
	The best books are those written specifically for the computer you are
programming on.  Also, each assembler (even for the same computer) may use a
different format, and the program examples in the book may have to be
massaged into the right form.  I have not yet seen an assembly language
tutorial for the Model 100 (Please let me know if you have.)
	I use "8080/8085 Software Design" by Larsen, Titus & Titus.  It
is very comprehensive, but has two drawbacks for the first time assembler.
The instruction format is not used by any of the assemblers I've seen, and
it seems to assume some programming experience.
	If you can browse through the books at a local store, compare their
program formats with those from some of the assemblers you are considering
purchasing.  (The assemblers available through the SIG have the advantage of
allowing you to ask questions about them.)  If you can't browse, you may
just have to do a little more figuring out.
	A list of ROM entry points is a must.  If it does not come with your
assembler, the "Model 100 Reference Manual" has one.  Many of the sub-
routines that you will need have already been written.  For example, just about

every program prints something on the screen, and the program to do that is
already in ROM (read only memory.)  To print the letter 'X' on the screen, you
simply load the A register with the ASCII value 'X', which is (according to
the reference manual) 88 in decimal, or 58 in hex.  Then a 'CALL $4B44'
instruction does the printing.  The routine for printing is located at
address $4B44 (the dollar sign means the number is hex.)  Thus the ROM routines

can save you a lot of time and program space.








3.  Assemblers
--------------

	Assemblers turn your assembly language source file (text) into the
ones and zeroes that the 80C85 (CPU) central processing unit understands.
There are several differences between assemblers.  The ones I consider most
inportant are listed here.  Remember that the more features an assembler has,
the more memory it will take up.

A.  Format.  Each assembler will recognize only a certain format.
     Instructions and operands may need to be separated by spaces or a TAB.
     Comments may be identified with semi-colons, asterisks or what-not.
     The exact format has no bearing on the code produced, but some formats are

     easier to use than others, and some conform to tutorials better than
     others.

B.  Speed.  I would doubt that the speed difference between machine language
     assemblers is noticeable.  However, assemblers written in Basic are up to
     200 times slower.

C.  Size.  The size of the assembler determines how much space is left over
     for your program.  Your machine language program is probably going to
     be small, but the source code may be tremendous.  My game Planet
     Protector is only 2.5K long, but the source code is 18K, and I don't use
     as many comments as I should.  Most assemblers allow you to assemble your
     program from a source file on tape, but I program for fun, and that
     doesn't sound like fun to me.  After all, one mistake and you have to
     load the source file (>3 minutes), fix it, save the file (>3 minutes), and

     assemble it off tape (>3 minutes).  9 minutes may not seem bad, but I make

     a lot of mistakes.  Of course if you plan to sell your programs that may
     all seem worthwhile.

D.  Relocatability (is that a word?).  You don't want the assembler program
     residing in the same place in memory that your program wants to be, so
     the assembler may have to relocated somewhere else.  Writing a large
     program that is relocatable is not easy, but is important (judging by the
     complaints I get.  I'll get around to it one of these days...)

E.  Error Handling.  If the assembler encounters an instruction that it can't
     interpret, it will display an error message.  The error message should
     give as much information as possible.

F.  Printout.  Debugging a program can be the most difficult part of program
     development.  The wrong address could cause a coldstart that will erase
     everything in memory, even the date.  It is therefore very important
     that the assembler be able to print a readable listing to the printer.  A
     listing by the assembler is better than a listing from the text file
     because the assembler will print the opco`es and addresses it believes
     is what you wanted.  Then you can check to see if the numbers are what
     you thought they should be.  Formatting with title lines and page
     numbers is nice if you can stand the increase in program size.  (See
     PRINT.ASM in XA4 for a print program for source files.)

	The assembler I happen to use is from Custom Software.  I saw their ad
in XA6 of the M100 SIG ACCESS.  The manual is a big help.  It includes well
documented sample programs, and a large list of ROM entry points.  There is
at least one other assembler available.  Browse through XA6 and look at them
all before buying.  Talk to the authors via messages to get more information.
If you are on a low budget, or have plenty of time, there is a very good
assembler written by M. Henning in Basic in XA4.  For short programs it is
great.  Because of its size and speed long programs are difficult to manage.
My Millipede program took 75 minutes to assemble using it.  It took less than
20 seconds using Custom Software's.




4.  Uploading M/L Programs
--------------------------

	The machine language program the assembler creates will be stored in a
.CO file.  You cannot upload .CO files directly, mainly because CompuServe
only allows 128 different codes instead of 256.  What is usually done is to
create a text file with each memory location represented by a hex number.
A loader program is then used read the text file and poke the appropriate
value directly into memory.
	HEXMAK.100 in XA4 is a program to read a reange of memory and store
the hex values in a text file.  The text file can then be uploaded.  Also on
XA4 is LOADER.100 which will convert the text file to a .CO file.  I use this
procedure on all three of my M/L games on XA3.

