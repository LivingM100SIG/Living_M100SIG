9.  Subroutines and a Simple Program.
-------------------------------------

	Let us now jump into some actual programming.  Reading about
instructions is all very well, but the only way to learn is to use them.
	Let us suppose that we want to print the seconds from the real time
clock onto the LCD screen.  We will have our program print the word "Time = ", 
and then print the seconds.
	We don't know how the screen works, but browsing through the
technical manual, we find a ROM subroutine that seems like it will
do most of the work for us.  It is a subroutine that Radio Shack calls
"LCD".  The manual describes it as "Displays a character on the LCD screen
at current cursor position."  Sounds good, but what does current cursor
position mean?  We don't know, so we'll just use the subroutine and see where
the numbers get displayed.  It is now time to back-up every file in memory.
Twice.
	There is more information in the subroutine description.  It says the
entry address is (hex) 4B44, entry conditions: A=character to be displayed,
exit conditions: None.  The entry
address is simple the address of the subroutine.  In Basic we gosub to a
line number.  We dont have line numbers here, but we do have memory addresses.
	The entry condition tells us that the A register must contain the
character we want printed when we call the subroutine.  Of course registers
don't contain characters, they contain 8-bit numbers.  We need to know what
number represents each character.  The User's Manual tells us that starting
on page 211.  It gives us the numbers in decimal, hex and binary.  We will
use hex to be consistent.
	Look at program 1, and then we will discuss it.
-------------------------------------------------------------------------------

001	;PRTIME
002	;Oct 30, 1984
;
003	ORG	$DAC0
004	ENT	$DAC0
;
005	MVI	A,$54	;character code for "T"
006	CALL	$4B44	;print character in A onto screen
007	MVI	A,$49	;character code for "I"
008	CALL	$4B44	;print character
009	MVI	A,$4D	;character code for "M"
010	CALL	$4B44	;print character
011	MVI	A,$45	;character code for "E"
012	CALL	$4B44	;print character
013	MVI	A,$20	;character code for space
014	CALL	$4B44	;print character
015	MVI	A,$3D	;character code for "="
016	CALL	$4B44	;print character
017	MVI	A,$20	;character code for space
018	CALL	$4B44	;print character
;
019	LXI	HL,$F934	;load address of tens of seconds
020	MOV	A,M		;move tens of seconds into register A
021	CALL	$4B44		;print character
022	LXI	HL,$F933	;load address of unit seconds
023	MOV	A,M		;move unit seconds into register A
024	CALL	$4B44		;print character
;
025	CALL	$12CB		;wait for keypress
026	JMP	$5797		;jump to menu
;
027	END

PROGRAM 1.  Print seconds to screen.
-------------------------------------------------------------------------------

	Please note that the line numbers are NOT part of the program.  I
added them here for clarity, but the source code should not have them.  Line
numbers are often printed out by the assembler itself, when you direct the
assembler to produce a listing.
	The first thing you may notice are all the semicolons.  They indicate
that what follows is a comment.  Not all assemblers use the semicolon as the
comment indicator, so check your manual.
	There are no blank lines either.  Every line must have at least one
character.  However, it makes the program easier to read if different
portions of the program are separated by blank lines, so the next best thing
is to use a comment line without a comment, just a semicolon.
	I've also put a comment after every instruction.  Comments are
great if you have to come back to a program after not working on it for a
while, but they do take up space.  I would recommend you use comments
liberally at first, and then delete some of them if you need more memory.
	The second thing you may notice is the ORG and ENT commands.  These
commands are not commands for the 8085, but are commands for the assembler.
The ORG command is a standard (almost universal) command that tells the
assembler where the program is to reside in memory.  It is the address of the
first instruction (or data) of your program (the ORiGin.)  In this case
the program will start at $DAC0, which is 56000 in decimal.
	The highest available memory address for your programs is 62959.
Memory above that is used for the file directory, and other RAM data the M100
needs.  Never let your program extend past there, and don't write to an
address above 62959 unless you know what you're doing.
	The ENT instruction tells the assembler where the program should
begin execution.  I have never found it neccessary to make the ENT address
different from ORG.  Just make sure the first part of your program is an
instruction and not data.
	The final instruction is END, and that is also an assembler
directive.  It tells the assembler that that's all there is.  You can put
comments after the END command without using a semicolon.
	All the other lines contain 8085 assembly code.
	Line five is the move immediate command, and moves the value $54 into
register A.  $54 is the ASCII value for the letter "T".  It is important to
note that even though all computers use ASCII code, the ASCII values may be
different.  The ASCII value of "T" on the Apple is $D4.
	Line 006 says it prints the character in A onto the screen.  What
it actually does is CALL the subroutine at $4B44.  The CALL instruction is
just like the GOSUB command in Basic.  When a return instruction (and there
are several types) is encountered, program execution will resume at the
instruction immediately following the CALL instruction.
	In lines 007 to 018, each letter of the word "IME = " is moved into
the A register, and then $4B44 is CALLed.  The next section prints the
seconds from the real-time clock onto the screen.
	To do this, we need to know where the seconds are located in memory.
Information like this can be found on a "memory map" of the Model 100.  A
memory map tells what each address or range of addresses is used for.  Most
commercial assemblers come with one.  By looking in Custom Software's rather
extensive one, I discover that the tens of seconds are stored at address
$F934, and the unit seconds are at $F933.
	So now we want to move a value from a memory location into the A
register.  To do that we must first load the memory address into the HL
register (pointer register.)  Line 019 does that with the 16-bit load
immediate instruction.  Line 020 moves the value from memory pointed to by
HL ($F934), into the A register, and line 021 CALLs the subroutine at $4B44
print the value in A to the screen.
	Lines 022 through 024 do the same thing with the unit seconds at
$F933.
	Once the seconds have been displayed, we want the program to stop
and wait until we press any key before it returns to the menu.  Line 024
does that for us.
	Line 024 calls a subroutine at $12CB.  $12CB is the entry address for
the subroutine that the M100 technical manual calls CHGET, which "waits and
gets character from keyboard.  Since we don't care what key is pressed, that
is all we need to know.  As it happens, the ASCII value of the key we press
will be in the A register when execution returns from that subroutine.
	Line 025 will only be executed after a key has been pressed.  At line
025 execution JuMPs to address $5797.  The jump instruction is like the GOTO
instruction in Basic.  The jump is executed no matter what.  $5797
returns execution to the main menu, it is like the MENU command in Basic.
	Remember to leave out the line numbers when you type in this program.
Be careful to use either tabs or spaces as required by your assembler.  They
are usually very finicky, and a space where a tab should be, or vice versa,
may give you a strange error message when you assemble it.
	When you run the program from the menu, the screen clears, and the
message we programmed will be displayed in the upper-left corner.  Evidently
the "current cursor position" described in the technical manual is line 1 and
row 1.  What happens is that running any program from the menu automatically
clears the screen and sets the cursor to the upper-left cornaer of the screen.
If you run the program from Basic with a CALL 56000 command, the message will
appear wherever the cursor was.

10.  Sneak Preview.
------------------

	That concludes the first chapter of this tutorial.  The next chapter
will cover conditional branching.  The jump instruction used in the previous
section is an unconditional branch, it always occurs.  Suppose you want to
jump back to the beginning of the program if the key pressed was a "B",
and jump to the menu if it was not.  Two lines should be inserted between
lines 024 and 025:
024a	CPI	$42	;compare A with the immediate value $42 (= ASCII "B")
024b	JZ	$DAC0	;if equals, then jump to start of this program
As you can see, Conditional branching makes things a lot more interesting.

