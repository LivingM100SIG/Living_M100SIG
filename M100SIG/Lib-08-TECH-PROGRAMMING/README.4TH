       *** fig-FORTH for the Model 100 with 32K & Chipmunk disk drive ***
                                      or
           "It's about time we had another language for this thing!"
                    by Michael Weiblen  CIS 72506,2072

CREDIT NOTICE
	This implementation is based on 8080 fig-FORTH v1.1, a public domain
program courtesy of the Forth Interest Group, Box 1105, San Carlos CA
94070.  Further distribution must include this credit notice.

INTRODUCTION
	The purpose of this file is not to teach you FORTH, but rather to
describe how to use this particular implementation.  To keep this file as short
as possible, I'll be making references to what I consider "the" FORTH
book, "Starting FORTH" by Leo Brodie.  Another very helpful publication
that deals specifically with the innards of fig-FORTH is the "fig-FORTH
Installation Manual".  Both of these are available from the FIG or Mountain
View Press, Box 4656, Mountain View CA 94040 (415)961-4103.

HOW TO GET IT GOING
	Ok, first download a copy of FORTH.4TH and save it on disk.  Then use
CHANGE.BA (also on this sig) to convert it into a .CO file.  When CHANGE
asks for a .CO output file, use a disk file name like 0:FORTH.CO.  The
reason for using the disk files is there ain't enough room in RAM to do
all this.  The FORTH.CO file occupies memory from 40960 to 47230 & uses
it all the way up to 57960 when running.

TIPS ON USING FORTH
	FORTH is case sensitive & all the predefined words are upper-case.
	Shift-Break is used to interrupt execution, but you have to hold it
	  down until it's recognized.
	Control P is used to toggle echoing to the printer.

ABOUT THE DICTIONARY
	Since every FORTH is a different dialect, here is a list of a few
fig-FORTH words that aren't described in "Starting FORTH".  For a full
description of the fig-FORTH dictionary, see the "Installation Manual".  The
stuff in the parens is a description of the stack before & after the word is
executed.  Please, read the books before asking me questions.
	VLIST will list the names of the definitions in the context vocabulary
	COLD is the FORTH equivalent of a cold start.
	INDEX (x y ---) displays the first line of each screen from x to y.
	WARNING (--- addr) is a variable containing a flag that determines the
	  operation of MESSAGE.  If = 0, messages will be displayed as a
	  number.  If = 1, message text will be fetched from disk.
	MESSAGE (x ---) will display (depending on WARNING) a message number
	  or the text of line x relative to screen 4.
	.LINE (x y ---) display line x of screen y.
	--> will continue interpretation with the next disk screen.
	;S will stop interpretation of a screen.
	?ERROR (f x ---) If flag f is true, display message x and abort.
	<BUILDS is used with DOES> to define defining words.  It marks the
	  beginning of the compile-time code.
	FENCE (--- addr) A variable containing the address below which
	  FORGETing is prohibitted.
	TRIAD (s ---) displays three screens.  Produces pretty listings when
	  echoed to the printer.
	VOCABULARY is a defining word to create new vocabularies.  By
	  convention, vocabulary names are to be declared IMMEDIATE.
	SMUDGE is used during word definition to toggle the "smudge bit".
Some words in "Starting FORTH" have different names in fig-FORTH:
	?DUP is -DUP			'S is SP@
	NEGATE is MINUS			DNEGATE is DMINUS
	>IN is IN			H is DP
I have added two words to the standard vocabulary:
	MENU does what you think it does.
	CALL (psw bc de hl addr --- psw bc de hl) allows you to call machine
	  language routines with full access to the 8085 registers.
I also had to change the definition of two words:
	ENCLOSE used to have a bug.
	TYPE now masks all characters with hex 7F before displaying, so it
	  will not display graphics.  Use EMIT if you need graphics.

ABOUT FORTH DISK
	There is one simple problem with FORTH and CDOS: Neither is aware of
the other's existence.  It is up to us to keep them from stepping on each
other's toes.  To keep FORTH from writing over the main directory cluster
& any other files I have on a disk, I use OFFSET.  OFFSET contains a sector
offset that is added to all block references before disk I/O.  I like
to use this command:   120 OFFSET !   This starts my FORTH disk area at
sector 120 (cluster 20) and leaves me about 29K at the low end to save
a copy of FORTH.CO & HELPER.BA.  Be careful when saving files to this
disk using Basic or CDOS since they are blissfully unaware of your OFFSET
setting.

ABOUT HELPER
	This is a Basic program to help FORTH & Basic interact with each other.
 It will create .DO files from FORTH screens & vice-versa.  It also can
scan the CDOS cluster allocation table & report the lowest safe OFFSET
for a given disk.  It is rather slow, so feel free to fix it up.

ABOUT SCREEN
	This is a file of FORTH screens to get you started.  Use HELPER.BA to
put them on your FORTH disk.  Among the items included are the error text
lines used by MESSAGE and a few useful definitions not normally part of
fig-FORTH.

MISCELLANY
	I have not included the fig-FORTH editor.  It is rather different than
the editor described in "Starting FORTH".  If you want it, it's in the
"Installation Manual" starting at page 51.
	I prefer to use the M100 TEXT to edit screens & transfer them to disk
with HELPER.  The format of a .DO file is a follows:  A file can contain
as many screens as you want.  Each screen consists of exactly 17 lines:
The first line is the screen number.  The next 16 lines are the actual
screen text lines. All screen text lines must be no longer than 64 characters
or HELPER will error.
	There are two other SIGs on CompuServe that have FORTH info.  The
Computer Languages Forum (GO CLM) has dedicted DL7 to it and the new FORTH sig
(GO FORTH) is nothing but.

	If your printer needs linefeeds, go into Basic and POKE 46144,0.

	Many thanks to Tim Ekdom for all his expert assistance.

	Michael Weiblen [72506,2072]  20 Feb 1986
