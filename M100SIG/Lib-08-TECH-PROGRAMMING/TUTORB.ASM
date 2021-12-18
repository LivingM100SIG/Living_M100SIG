5.  The 80C85 Architecture.
---------------------------

	This section describes what's available for the programmer to use in
the 8085.  It is written from the programmer's point of view, and not the
engineer's.  A more complete analysis of the 8085 will be left for later.
	One of the most important functions of the CPU is to manipulate data.
In Basic we store the data in variables, both numeric and string.  We don't
know exactly where in memory the data is stored, but we know that Basic knows,
so we don't worry about it.  In assembly language we have to worry about it.
	We can store data directly inside the CPU.  The 8085 has seven 8-bit
registers.  Each register can store a value from $00 to $FF (0 to 255: a
dollar sign prior to a number indicates a hexadecimal value.)  The registers
are designated by single letters: A, B, C, D, E, H and L.  They are not all
created equal, and are used for different purposes.
	The A register is also called the accumulator.  All of the 8-bit
arithmetic is done on the value in the accumulator.  Addition, subtraction,
ANDing, EXCLUSIVE ORing, ORing, rotations and comparisons all involve the A
register (don't worry if you don't know what they all mean.  You can worry if
you don't know what the first two mean though.)  For example, the instruction
ADI $10 adds the value $10 to what is already in the A register.  The
instruction ADD B adds the value of the B register to the value of the A
register, and then stores the value back into the A register.  The B register
is unchanged.  Only the A register is affected by any of these operations.
Now that we know how to do arithmetic on the A register, how do we get a value
into it?
	There are five ways to get a value into the A register.  The first
is to load it with a preset value, called an immediate value, like $07,
or $AD.  The second is to transfer it from a different register.  The third
is to get the value from somewhere in memory.  The fourth is to get it from a
peripheral device, and the final method is to get the value from the serial
data port.
	The last two methods involve advanced topics.  The serial data port
is used solely for the cassette input. A peripheral device is something that
communicates with the 8085, something that facilitates input and output (I/O).
The keyboard, LCD display, modem, speaker, light-pen and printer (with
their associated circuitry) are all I/O devices.
	Luckily we don't have to learn the I/O instructions, because there
are subroutines already built-in that read data from these devices, or send
data to them.  Some of these subroutines are listed starting on page 79 of the
Model 100 Technical Manual.  We will return to them in section 9.

6.  The MoVe Immediate (MVI) Instructions.
------------------------------------------

	The MVI instructions move an immediate value into any specified
register.  The following examples should explain how it works better than
mere words:
	MVI	A,$08	;A will have the value 8 after this instruction
	MVI	C,$ED	;C will have the value $ED after this instruction
	MVI	H,$11	;H will have the value $11 after this instruction
	Technically speaking, MVI is an instruction by itself, part of the
8085 "instruction set".  The grouping following it is called the operand.
For any move instruction, including the move immediate, the operand always
consists of a source and a destination.  The destination always comes first,
then a comma, and then the source.  The source for the MVI instruction is
always an 8-bit number, a value between $00 and $FF.
	The destination is always either a register or a memory location.  One
of the nice features of the 8085 is the ability to treat a memory location
just like it was a register.  You have to set up certain conditions before
you can do so, and that will be covered in section 8.
	The MVI instruction takes up two bytes of memory.  A byte is an 8-bit
value, so each memory location stores one byte.  The first byte is the MVI r,
part, where r stands for any register.  The second byte is the immediate value,

the source.

7.  The MOVe (MOV) Instruction.
-------------------------------

	The MOV instruction moves data from one register to another.  The
instruction format is MOV dr,sr, where dr is the destination register, and
sr is the source register.  The content of the source register is the same
after this instruction is executed.  The destination register will contain the
same value as the source register.
	The MOV instruction takes only one byte of memory.

8.  Moving Data to and from Memory.
-----------------------------------

	So far we have moved immediate numbers into registers, and values
from register to register.  Now we will see how to retrieve data from memory.
In this section we will also see what a source program looks like.
	To move data into a memory location, we must first decide what
address to use.  Each of the 65,536 memory locations has a unique address,
a number from $0000 to $FFFF.  It takes a 16-bit number count that high, and
it can be done on the 8085.  We have already seen that the 8085 has seven
8-bit registers.  Six of the registers can be "doubled-up" to give you three
16-bit registers.  The B and the C register give you the BC register, the D
and E registers givve you the DE register, and the H and L registers give you,
surprise!, the HL register.
	The 16-bit registers are not separate from the 8-bit registers.  If
you store an 8-bit number in L, and then a 16-bit number in HL, the 8-bit
number is lost.  To add to the confusion, most assemblers allow you to use
only the first letter of a 16-bit register.  Then the only way to tell the
difference between an 8 or 16-bit register is from context, i.e. from the
instruction that precedes it.  Here we will use both letters for a 16-bit
register.
	The HL register is the only register that can be used to specify a
memory address.  It is called a pointer register because it points to a memory
location.  The H register contains the high byte of the address, and the L
register the low byte (that's why it's not called the FG register.)
	High and low bytes may be unfamiliar to you.  Consider the decimal
number 47.  From convention we know that 4 is the number of "tens", and the 7
is the number of "units", high and then low.  For the hex number $47, 4 is the
number of "sixteens", and 7 is the number of "units".  In the same way for
the number $4768, $47 is the number of "two-hundred-fifty-sixes", and $68 is
the number of "units".  We split it this way because the first two digits can
fit in the high byte (register) and the second two can fit in the low
register.  However, as we shall see later, sometimes the low byte comes
first, with the high byte following, but the HL register is always high-low.
	The instruction that loads an address into the HL register is the
LXI instruction.  The LXI instruction loads a 16-bit immediate value into
the register pair designated in the first half of the operand, the
destination.  The second half of the operand is the 16-bit immediate
value.  The format is LXI rp,$nnnn, where rp is any of the three register
pairs, and $nnnn is a 2 byte (up to four hex digit) number.
	Once HL points to a memory address, we can treat that memory location
just like it was a register.  We can use:
	MVI	M,$AB	;memory location pointed to by HL will equal $AB
	MOV	A,M	;A register will have value of memory location
	The LXI instruction requires three bytes of memory.  The first
specifies the instruction and the destination register (all in one byte),
and the last two contain the immediate 16-bit value.  It is interesting (and
confusing) to note that addresses in memory are always stored low byte first.
The instruction LXI HL,$1234 assembles into the three consecutive bytes $21,
$34, $12.  $21 is the LXI H, instruction.  The $34 and $12 is the address
with the low byte first.  You don't have to worry about the order when you are
programming because the assembler puts all the addresses in the proper order.
You do have to worry about it when debugging your program.  Sometimes you
have to examine the machine language code to find the problem, and this
high-low business can get confusing.  To repeat, addresses in the registers
are always stored high-low.  Addresses in memory are stored low-high.


