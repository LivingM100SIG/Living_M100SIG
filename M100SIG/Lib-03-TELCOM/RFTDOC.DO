+-------------------------------------+
|				      |
|	Remote File Transmitter	      |
|				      |
|	Documentation and	      |
|	commented listing.	      |
|				      |
+-------------------------------------+

	The Remote File Transmitter
program is useful when you need to send
several files to someone, but you don't
have time to send each one individually
from TELCOM.  The remote user can look
at each file and download them at his
leasure.

	The ADRS.DO and the NOTE.DO
files are explictly protected from
prying eyes.  And any file with a
backslash as the first character can be
implictly protected.  Since it is
assumed that you are going to start the
program for the remote user, no
password protection is provided.

	As listed here, the program
allows input from both the keyboard and
the serial port.  If you would rather
use the built-in modem, change all
occurences of COM to MDM.  If you open
a file to the modem, you cannot run the
program from your keyboard until a
carrier has been established.

	All input is buffered.  This
means that you do not have to wait for
the input prompt before you can begin
typing.  This also applies to the
remote user; either one may
"type-ahead" as many responces as
necessary.

	Occasionally the program will
"lock up" on an I/O error and not
recover.  When this happens, press
SHIFT+BREAK and enter RUN.

	The commented listing follows:

10 CLS
	Clear screen for a RUN from
	BASIC.
:GOTO 60
	Skip the remote input routine
	placed at the beginning for
	faster input.
'Remote File Transmitter,		
written by Rex Rivers [70155,1365]
	Any improvements gladly
	accepted through E-MAIL.
20 I$=INPUT$(1,1)
	When a remote character comes
	in, store it in I$.
30 IN$=IN$+I$
	Add the character to the input
	buffer called IN$.
40 IF LEN(IN$)>250 THEN RUN
	If the input buffer gets too
	big, start over again.
50 RETURN
	Go back to main program
60 MAXFILES=3
	Tell BASIC to reserve 801
	bytes for buffers.
70 DEF INT A-Z
	Unless declaired otherwise all
	variables are integer for
	fastest operation.
80 CLEAR 1024
	Save enough string space for
	temporary buffers.
90 DIM F$(99)
	Reserve a vector to store the
	names of the DO files in
	memory.
100 ON ERROR GO TO 370
	Trap any errors.
110 CL$=CHR$(27)+"Q"+CHR$(12)
	Create a variable called CL$
	that clears the screen and
	turns off the cursor.
:PM$="Which one? "+CHR$(27)+"P"+CHR$(7)
	Create a variable called PM$
	that prompts for input, turns
	on the cursor, and beeps the
	bell.
120 OPEN "COM:38N2E" FOR INPUT AS 1
	Tell BASIC that buffer #1 will
	input the remote characters.
130 OPEN "COM:38N2E" FOR OUTPUT AS 2
	Buffer #2 outputs characters.
	Eight bit, no parity with 2
	stop bits is recommended to
	allow sending graphic
	characters while still
	remaining compatable with 7
	bit, ignore parity with 1 stop
	bit.
140 ON COM GO SUB 20
	When a remote character comes
	in, go and get it.
150 COM ON
	Enable the remote character
	interrupt.
:PRINT CL$;
	Clear the screen.
:PRINT #2,CL$;
	Clear the remote screen.
160 FOR X=-1408 TO -1639 STEP -11
	Step through the file
	directory.  Numbers are
	negative because they are
	integers.
:IF PEEK(X) THEN Y=Y+1
	If the third character in the
	file name is a zero, it has
	been deleted.
:FOR Z=0 TO 7
	If it is not a zero step
	through the letters in the name
	and extension.
:F$(Y)=F$(Y)+CHR$(PEEK(X+3+Z))
	Add the current letter to the
	current element in F$.
:NEXT
	Loop until finished.
:IF RIGHT$(F$(Y),2)<>"DO" THEN F$(Y)=""
	If the extension is not DO then
	erase the current element in
	F$.
:Y=Y-1
	Move the current element
	pointer back one.
ELSE F$(Y)=LEFT$(F$(Y),6)
	If the extension is DO then 	
	delete the extension.
:IF F$(Y)="ADRS  " OR F$(Y)="NOTE  " OR 
LEFT$(F$(Y),1)="\" THEN F$(Y)=""
	If the file is the ADRS.DO or
	NOTE.DO file, or it begins with
	a backslash, delete the name.
:Y=Y-1
	If the name was deleted, set
	the current element pointer
	back one.
170 NEXT X
	Loop until finished.
180 F=FRE("")
	Force BASIC to do housekeeping
	on string stack.
:PRINT CL$;
	Clear the screen.
:PRINT #2,CL$;
	Clear the remote screen.
:FOR N=1 TO Y
	Step through the file names.
:PRINT #2,USING "##>\    \ ";N;F$(N);
	Format the name of the file on
	the remote screen.
:PRINT USING "##>\    \ ";N;F$(N);
	Format the name of the file on
	the screen
:NEXT
	Loop until finished.
190 PRINT #2,""
	Send a carriage return and line
	feed to the remote screen.
:PRINT #2,,PM$;
	Print the prompt on the remote
	screen.
:PRINT:PRINT,PM$;
	Print the prompt.
200 L=LEN(IN$)
	Get the length of the input
	buffer.
:I=INSTR(1,IN$,CHR$(13))
	Look for a carriage return in
	the input buffer.
:IF I>0 THEN N$=LEFT$(IN$,I-1)
	If a carriage return was found,
	move all the characters up to
	the carraige return into the
	number buffer.
:IN$=RIGHT$(IN$,L-I)
	Delete the moved characters
	from the input buffer.
210 IN$=IN$+INKEY$
	If a character was pressed at
	the keyboard, add it to the
	input buffer.
:IF LEN(IN$)>250 THEN RUN
	If the input buffer gets too
	full, start again.
220 IF N$="" THEN L=LEN(IN$)
	If the number buffer is empty,
	get the length of the input
	buffer.
:R$=RIGHT$(IN$,L-P)
	Get all the characters after
	those that have already been
	printed.
:PRINT #2,R$;
	Print them on the remote
	screen.
:PRINT R$;
	Print them.
:P=L
	Set the pointer to the last
	letter printed.
:GO TO 200
	Check the input buffer again.
ELSE IF P=0 THEN PRINT #2,N$
	If the number buffer has not
	been displayed, print it on the
	remote screen.
:PRINT N$
	Print it.
230 P=0
	Set the displayed characters
	pointer back to zero.
:N=VAL(N$)
	Extract the number from the
	number buffer.
:N$=""
	Delete the characters in the
	number buffer.
240 N=FIX(ABS(N+.5))
	Filter out any negative numbers
	and round up any fractions.
:IF N>Y OR N=0 THEN 180
	If there is no such file, try
	again.
250 CLOSE #3
	Make sure the file input buffer
	is closed.
:OPEN F$(N) FOR INPUT AS 3
	Tell BASIC that buffer #3 will
	input the file characters.
260 PRINT CHR$(12);
	Clear the screen.
:PRINT #2,CHR$(12);
	Clear the remote screen.
270 IF EOF(3) THEN 180
	If there are no more characters
	in the file, try another.
280 LINE INPUT #3,A$
	Get a record from the file.
290 L=LEN(A$)
	Get the length of the line.
300 IF L=0 THEN 270
	If the record is empty, skip
	the next routine.
310 FOR N=1 TO L
	Step through the letters in the
	line.
320 M$=MID$(A$,N,1)
	Get the current letter.
330 PRINT M$;
	Print the current letter.
:PRINT #2,M$;
	Print the current letter on the
	remote screen.
340 NEXT N
	Loop until finished.
350 PRINT "":PRINT #2,""
	Print a carriage return and
	line feed on both screens.
360 GOTO 270
	Go back and try another.
370 PRINT STRING$(7,7);
	Beep to show an error has
	occured.
380 IF EOF(1) OR ERR=18 THEN COM OFF
	If the remote has sent a
	CONTROL+Z, disable the remote
	interrupt.
:CLOSE #1
	Close the remote buffer.
:OPEN "COM:38N2E" FOR INPUT AS 1
	Reopen the buffer.
:COM ON
	Enable the remote interrupt
	again.
:RESUME
	Go back to error line.
390 RESUME NEXT
	If it was some other error, go
	to the next line fillowing the
	error.

