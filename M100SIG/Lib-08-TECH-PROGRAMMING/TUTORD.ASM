TUTORD.ASM

Mike Berro
BCS Software
Nov 12, 1984


11.  Using Labels.
------------------

	In section 9 a program was presented that displays "TIME = ",
followed by the seconds.  In this section a more useful way of displaying
messages is discussed.
	There are several ways to print characters to the LCD.  The sample
program in section 9 actually uses the most inefficient method.  However, the
Radio Shack Technical Manual doesn't tell you that there is a ROM subroutine
that prints a whole series of characters (a "string") for you.
	The subroutine to do that is located at $5A58.  I learned this from
the instruction manual for Custom Software's Model 100 Assembler.  The
assembler even has a nifty little "macro" that does it for you.  (A macro
is a one word abbreviation for any number of instructions.  They can make
the source code shorter.)
	To use the subroutine, you need to have the string stored in memory.
Each assembler has it's own way of assigning data to memory.  Here are
examples of how Custom Software does it:

-------------------------------------------------------------------------------

EL	DB	$4C	;stores ASCII "L" to memory location "EL"
JK	DW	$4A4B	;stores $4A to location "JK" & $4B to "JK"+1
MESSAGE	DM	TIME = 	;stores characters starting at location "MESSAGE"
-------------------------------------------------------------------------------


	DB means Define Byte.  DW means Define Word (two bytes), and DM means
Define Message.  DB and DW are pretty standard, but on some assemblers DM
is STR, for STRing.  DB, DW and DM are all assembler directives.  They tell
the assembler that there is data here, and not an instruction.  The assembler
stores the appropriate value(s) in memory for you.
	Notice the words "EL", "JK" and "MESSAGE" in the first column of each
assembler directive.  The first column is called the label field, and those
words are labels.  The use of labels is discussed below.
	Now that we have the message stored in memory, we can use the ROM
subroutine at $5A58.  According to Custom Software's manual, there are two
requirements that must be met (entry conditions).  The data to be displayed
must be terminated with a zero.  The subroutine will display character
after character until it reaches a zero, and then it will RETurn to your
program.  Remember, it is looking for the value zero, not the ASCII value
for zero, which is $30.  We must therefore add:
	DB	$00	;store the value zero as a terminator
after the message line above.
	The other entry condition is that HL should point to the characters
to be displayed.  That means the HL register needs to contain the address
of the message.  What is the address of the message?  If it is the first line
of the program, it will be wherever the program is ORG'ed.  If it isn't, we
would then have to count the number of bytes from the beginning of the program,

and add the ORG value to that.  If you change the program, you would then have
to recalculate each address.
	Luckily, there is a easier way, using labels.  In the example above,
MESSAGE is a label.  When the source code is assembled, the assembler keeps
track of all the labels.  In this case, it would know the memory location of
the label MESSAGE.  You can then use "MESSAGE" whenever you mean "the memory
location of the label MESSAGE".
	Now we can load the HL register with the address of the message:
	LXI	HL,MESSAGE	;load HL with the address of the message
and then call the subroutine to display it:
	CALL	$5A58	;display message
We don't even have to know what address MESSAGE stands for, the assembler will
take care of it for us.  However, most assemblers will give you a list of all
labels and their values at the end of the source code listing.
	Suppose now we wanted to call the subroutine at location $5A58
"DISPLAY".  If we could tell the assembler that the label DISPLAY means
$5A58, then we could use the label instead.  We can do that using the
EQUate directive.
	The EQUate directive tells the assembler to assign a value to the
label of the EQUate directive.  For example:
DISPLAY	EQU	$5A58	;assign $5A58 to the label DISPLAY
at the beginning of your program will tell the assembler to substitute $5A58
wherever it sees DISPLAY.
	Program 2 does the same thing as program 1, but a little more
elegantly.  Here we use labels, and the ROM subroutine at $5A58.

-------------------------------------------------------------------------------

	;PRTIME2
	;Nov 12, 1984
;
	ORG	$DAC0
	ENT	$DAC0
;
; These are all ROM subroutines
DISPLAY	EQU	$5A58	;print message pointed to by HL
LCD	EQU	$4B44	;print character in register A
CHGET	EQU	$12CB	;wait for keypress
MENU	EQU	$5797	;main MODEL 100 menu
;
SECS	EQU	$F933	;memory location for seconds
;
BEGIN	LXI	HL,MESSAGE	;set HL pointer to start of message data
	CALL	DISPLAY		;display message
;
	LXI	HL,SECS+1	;SECS+1 = $F933+1 = $F934
	MOV	A,M
	CALL	LCD
	LXI	HL,SECS
	MOV	A,M
	CALL	LCD
;
	CALL	CHGET
	JMP	MENU
;
MESSAGE	DM	TIME = 		;message data
	DB	$00		;terminator
;
	END

PROGRAM 2.  Print seconds to screen (using labels).
-------------------------------------------------------------------------------


	In program 2 you can see that you can perform arithmetic on labels.
Some assemblers can evaluate very complex expressions, while others can
handle only addition and subtraction.  Check the documentation for your
particular assembler.
	On page 80 of the Radio Shack Technical Manual is listed the
addresses for several useful display subroutines.  Also listed are the
cursor locations.  By moving different values into these two locations, you
can start your printing anywhere on the screen.  Experimenting is fun, but
don't forget to be prepared for those cold starts!

(Thanks to Greg Susong of Custom Software for permission to use information
taken from the Custom Software Assembler Manual.)

