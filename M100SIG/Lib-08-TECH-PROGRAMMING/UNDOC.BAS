
The following are a few undocumented features of M100 BASIC. Many of these have
been discovered thanks the NEC 8201 BASIC manual.

ERROR	ERRORx is normal format. But ERROR(x) will also work. (mainly of
	interest for converting programs from other Microsoft BASICs)
IF	GOTO may be used instead of THEN. This even works in the form
	IF ... GOTO ... ELSE ...
IPL	the IPL program is run when you turn on the computer *if* you were in
	one of the following when you turned off the machine:
	BASIC (but not while a program is running), TEXT (any .DO file)
	ADDRSS, SCHEDL, some .CO files.
	Note: you must give the FULL name of the file to run.
LET	useful only for compatibility with older BASICs. Unlike some BASICs,
	use of LET does *not* speed up the operation.
	Syntax: LET variable = formula
		LET variable = constant
ON COM GOSUB	if ON MDM GOSUB is also being used please note that *both*
	store the line # in the same memory location. Thus they *must* use the
	same routine. This also means that you only need use one or the other,
	not both.
PEEK	addresses above 32767 may be specified 2 different ways:
		a single precision number	 32768 to 65535
		an integer			-32768 to -1
POKE	addresses may be specified as for PEEK
PRESET	an extra argument can be placed in the ()
	PRESET(x,y,c) where even values of c are black, odd values are white.
PSET	an extra argument can be placed in the ()
	PSET(x,y,c) where even values of c are white, odd values are black.
REM	REM uses one byte of memory. ' uses *three*! (it is stored as a :, a
	REM token and a chr$(255))
RND	if you use a negative number as the argument (ie RND(x) where x is less
	than 0) you will "re-seed" the random number generator. The same
	sequence will always follow a given negative number, but different
	numbers give different sequences.
SCREEN	syntax is SCREEN display,label *OR* SCREEN,label (the latter is not
	documented in the manual but works, is shorter, and avoids causing
	problems for those of us with DVI's)
	display 0 = LCD, 	    1 = CRT (DVI display)
	label   0 = label line off, 1 = label line on
SOUND	the NEC manual says that 5586 produces a 440 Hz tone. Working from this
	we can derive the following formula for the output frequency of the
	SOUND command:
		freq = 2457600/tone argument
		tone arg = 2457600/freq
	(2457600 being the clock frequency of the 100/102 & NEC)
			NEC sound value chart
				octave
	+------+-------+-------+-------+-------+-------+-------+
	| note |   1   |   2   |   3   |   4   |   5   |   6   |
	+------+-------+-------+-------+-------+-------+-------+
	|  C   |   -   |  9394 |  4697 |  2348 |  1171?|   587 |
	|  C#  |   -   |  8866 |  4433 |  2216 |  1103?|   554 |
	|  D   |   -   |  8368 |  4184 |  2092 |  1045?|   523 |
	|  D#  | 15800 |  7900 |  3950 |  1975 |   987 |   493 |
	|  E   | 14912 |  7456 |  3728 |  1864 |   932 |   466 |
	|  F   | 14064 |  7032 |  3516 |  1758 |   879 |   439 |
	|  F#  | 13284 |  6642 |  3321 |  1660 |   830 |   415 |
	|  G   | 12538 |  6269 |  3134 |  1567 |   783 |   -   |
	|  G#  | 11836 |  5918 |  2954 |  1479 |   733?|   -   |
	|  A   | 11172 |  5586*|  2793 |  1396 |   693?|   -   |
	|  A#  | 10544 |  5272 |  2636 |  1316?|   653?|   -   |
	|  B   |  9952 |  4968?|  2486?|  1244 |   622 |   -   |
	+------+-------+-------+-------+-------+-------+-------+
			* 440 Hz
			? differs from value in M100 manual
VARPTR	VARPTR(#x) will return the address of file buffer #x
