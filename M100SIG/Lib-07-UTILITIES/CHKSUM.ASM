COMMENT	*

CHKSUM	Version: 1.6  A. Ryan  2/July/1989

CHKSUM.COM is a program to calculate the checksum of a file.    This can be
used to verify the integrity of a file that has been downloaded  from a BBS
for example, or for other file verification purposes.  In order to make the
program as general as possible, this assembly language version incorporates
a number of other features to enhance its utility.  The general syntax is:-

	CHECKSUM filespec [options]

The option switches are:-

	/A	Default, ASCII file
	/B	Binary file
	/C	Chatty mode
	/L	CR and LF are significant
	/N	Default, Ignore CR/LF

If the command line is incorrect, a help message is displayed.  The option
switches have the following significance.

ASCII	The default file type is ASCII, this means that the file is expected
to contain only ASCII characters, specifically the printable character set
from SPACE through to ~ (TILDE), plus CR, LF, FF, and TAB.  If any symbols
are found outside of this set, the program will pause with an error message
and ask if you wish to continue.  If you answer 'Y', then the mode is changed
to BINARY and the program will continue.  A 'N' response will cause an abort
to occur.  In the ASCII mode the occurence of a CTRL-Z character, $1A, will
signify End-Of-File.  The CTRL-Z is not included in the checksum.  If you
wish to check files that contain CTRL-Z, or any other characters outside of
the ASCII set, use the BINARY mode.

BINARY	In this mode all bytes are significant, with the possible exception
of the CR/LF.  If the default mode is used, then any CR or LF byte is ignored.
If the /L option was invoked, any CR or LF will be summed together with all
the other bytes.

CHATTY	This mode will display a either a running checksum if the BINARY flag
is TRUE, or else will "echo" the contents of the file in the ASCII mode.
Obviously this will considerably slow down the program.  Note that when
"echo-ing" to the screen, the only permissible characters are the ASCII set
from SPACE to TILDE, plus CR, LF, and TAB.  Any formfeed characters will not
be sent to the console.  Thus, re-directing the output to a file or to the
printer will effectively strip out the formfeed symbol.  Using the /C option
sets the "chatty" flag.  It is named in honour of my daughter, who, like this
program, will drop into full auto-chat if given the oportunity.

The program returns an errorcode to DOS when it terminates.  The codes have
the following meanings:-

	0	Normal Termination
	1	Syntax Error
	2	Memory Allocation Error
	3	Insufficient Memory
	4	Filespec Too Long
	5	Unable To Open File - File Not Found
	6	Unable To Open File - Invalid Path
	7	Unable To Open File - Invalid/Insufficient File Handles
	8	Unable To Open File - Access Denied
	9	Unable To Open File - Unknown File Access Error
	10	Unexpected Error Reading File
	11	Checksum Overflow - File Too Large
	12	User Initiated Abort

Design Notes

The code is origined at the normal location for a .COM file of $100, and
extends to $0766.  At $0767 is the start of a buffer for the data from the
file specified on the command line, which extends for $F000 bytes as specified
by the equate BUFFERSIZE, to address $F767.  This leaves $0898 or 2200 bytes
for the stack.  This version of the program has been tested and uses 36 bytes
of stack space.  This use of a buffer greatly reduces the number of disc
operations which would otherwise be required, greatly improving the speed of
the program.

The use of the DOS Memory Allocation feature is a reasonable precaution in
case this program is run as a child process.  As a result, this program
requires a minimum of 64K bytes of free memory, and DOS 2.0 or higher.

This version corrects three minor bugs.  The first would have caused the
program to crash if it was executed under DOS 1.0, the second caused the
ASCII EOF character, CTRL-Z, HEX 1A, to be considered as an illegal character
if it was encountered in an ASCII file.  This version correctly recognises
this character as End-Of-File in the ASCII mode, and is not included in the
checksum.  The third bug would cause a blank checksum to be displayed if a
file was checked in the ASCII mode, and the file contained only a CTRL-Z
character.  This version will now disply a zero checksum.

	*

;Standard Equates

cr		equ	13
lf		equ	10
f_feed		equ	12
tb		equ	9
spc		equ	32
switch		equ	'/'
prtstr		equ	9
dos_call	equ	021h
read		equ	0
nl		equ	<cr,lf>
BUFFERSIZE	equ	30 * 2048	;Stack space left is 2498 bytes
_eof		equ	26		;ASCII text file EOF marker
EOF		equ	0ffh

;Macros

get_version	macro
		mov	ah,030h
		int	dos_call
		endm

terminate	macro
		mov	ah,04ch
		int	dos_call
		endm

dsp_chr		macro
		mov	dl,al
		mov	ah,2
		int	dos_call
		endm

dsp_msg		macro
		mov	ah,prtstr
		int	dos_call
		endm

display		macro	text
		mov	dx,offset text
		dsp_msg
		endm

clear		macro	reg
		xor	reg,reg
		endm

fopen		macro
		mov	ah,03dh
		int	dos_call
		endm

fclose          macro   file_handle
                mov     bx,file_handle
                mov     ah,03eh
                int     dos_call
                endm

code		segment	para public 'code'
		assume	cs:code, ds:code, es:code, ss:code

		org	080h
argc		label	byte

		org	081h
cmnd_line	label	byte

		org	0100h
main            proc    far

begin:		jmp	start

;Standard Messages

copyright	db	nl,'CHKSUM Version: 1.6 A.Ryan 2/JULY/89',nl,'$'
syntax_err	db	nl,'Syntax Error!',nl
		db	nl,'Usage: CHKSUM filespec [/A] [/B] [/C] [/L] [/N]'
		db	nl,'/A - ASCII File, Default'
		db	nl,'/B - BINARY File'
		db	nl,'/C - CHATTY Mode'
		db	nl,'/L - CR/LF significant'
		db	nl,'/N - Ignore CR/LF, Default',nl,'$'

version_err	db	nl,'Incorrect DOS Version, must be DOS 2.0 or higher.',nl,'$'
mem_alloc	db	nl,'Memory Allocation Error.',nl,'$'
mem_err		db	nl,'Insufficient Memory.',nl,'$'
filespec_err	db	nl,'Filespec Too Long.',nl,'$'
file_err	db	nl,'Unable to open file - ','$'
not_found	db	'File Not Found.',nl,'$'
path		db	'Invalid Path.',nl,'$'
handle		db	'Invalid/Insufficient File Handles.',nl,'$'
access		db	'Access Denied.',nl,'$'
unk_err		db	'Unknown File Access Error.',nl,'$'
input_err	db	'Unexpected Input File Error.',nl,'$'
overflow	db	'Checksum Overflow, File too large.',nl,'$'
prompt		db	nl,'Non-ASCII Characters in file.',nl
		db	'Do you wish to continue (Y/N): $'
abort_msg	db	nl,'User Initiated Abort.',nl,'$'
new_line	db	nl,'$'

filespec	db	80 dup (0)	;File specification buffer

sum		db	nl,'Checksum: $'
chksum		db	9 dup ('0')
lsbchk		db	'0'
		db	'$'
chk_sum_lo	dw	0
chk_sum_hi	dw	0
scrn_flg	db	0		;Set if 'Checksum:' already displayed
scrnpage	db	?		;Current Video Page
cursrow		db	?		;Row of 'Ckecksum:' message

data_buffer	dw	himem		;Address of internal data buffer
bufptr		dw	?		;Internal data buffer pointer
bufcount	dw	0		;Count of remaining characters in buffer
file_ptr	dw	0		;DOS File Handle
eof_flg		db	0		;Internal End-Of-File Flag

asc_flg		db	1		;ASCII/BINARY mode flag
c_flg		db	0		;CHATTY flag
nl_flg		db	0		;NEWLINE flag

start:		call	init		;Initialise the program
		jnc	init_ok

quit:		push	ax		;Save exit code
		call	newline		;display a newline sequence
		pop	ax		;recover exit code and
		terminate		;exit.

init_ok:	call	getchar		;get a character from the file
		jc	chk_eof
		call	check_char	;Check the character
		jc	quit		;Exit if error
		clear	ah
		add	chk_sum_lo,ax
		jnc	init_ok
		inc	chk_sum_hi
		jno	init_ok		;If no errors, do it again
		display	overflow
		mov	al,12		;Overflow error code
		jmp	quit

chk_eof:	cmp	eof_flg,EOF	;Are we at EOF?
		jne	quit		;No, so must be an error.
		call	print		;Display the result
		fclose	file_ptr	;close the file
		clear	al		;Errorlevel for Normal Exit
		jmp	quit

COMMENT	*

INIT performs the main program initialisation.  First the number of characters
on the command line tail are checked.  If none are present the copyright and
syntax error messages are displayed.  Then the DOS version is checked, and if
DOS 2.0 or higher is present, then an attempt is made to shrink the allocated
memory to 64K. Next, the command line tail is scanned for a file spec. Finally
the option switches are checked and verified.  If no errors are detected, the
routine returns with the C flag clear.  If an error is detected, the routine
returns with C set and the exit errorcode in AL.

	*

init		proc	near
		display	copyright
		cmp	argc,2		;Any command line arguments?
		jae	args_ok		;Yes, so process them.
		display	syntax_err	;No, so display error message.
		mov	al,1
		stc
		ret

args_ok:	mov	ah,0fh
		int	dos_call
		mov	scrnpage,bh
		call	check_dos	;Check DOS version, returns if OK.
		call	malloc		;Attempt to allocate memory
		jnc	mem_ok
		ret

mem_ok:		call	scan		;Scan line for a filespec
		jnc	scan_ok
		ret

scan_ok:	push	si		;save command line pointer
		mov	dx,offset filespec
		mov	al,read		;Set up for READ access.
		call	open		;Attempt to open file,
		pop	si		;recover pointer,
		jnc	open_ok		;Any errors?
		ret

open_ok:	mov	file_ptr,ax	;No, so save file handle, and
		call	parse		;get command line option switches.
		ret

init		endp

check_dos	proc	near
		get_version		;Get the current version of DOS
		cmp	al,2
		jae	dos_ok
		display	version_err	;Display error message. If not DOS 2
		clear	ah		;or higher, then simply exit via the
		int	021h		;DOS 1.xx method.

dos_ok:		ret

check_dos	endp

malloc		proc	near
		mov	bx,1000h	;First attempt to shrink memory to 64K
		mov	ah,4ah		;All good .COM programs should do this.
		int	dos_call
		jnc	init_mem_ok	;No errors, so continue
		display	mem_alloc
		mov	al,2		;Memory Allocation Error
		stc			;ensure error flag is set

malloc_ok:	ret

init_mem_ok:	cmp	bx,1000h	;did we get 64K?
		je	malloc_ok
		display	mem_err
		mov	al,3		;Insufficient Memory
		stc
		ret

malloc		endp

COMMENT	*

SCAN will examine the command line tail and attempt to locate the filespec.
If any characters are encountered they are converted to U/C and inserted in
the filespec buffer.  If more than 79 characters are found the routine ends
with the C flag set after displaying the error message that the filespec is
too long.  Leading spaces in the command tail are ignored, but a CR, space or
/ delimiter character will also terminate the sacn.

	*

scan		proc	near
		mov	si,offset cmnd_line
		mov	di,offset filespec
		mov	cx,79		;Maximum number of chars to scan
		cld

scan1:		lodsb			;Get the first characters
		cmp	al,spc		;is character a space?
		je	scan1		;yes, so skip leading spaces

scan2:		call	toupper		;convert character to U/C
		cmp	al,cr		;EOL?
		je	scan_done	;Yes, so we are done.
		cmp	al,spc		;Command line delimiter?
		je	scan_done	;Yes, also done
		cmp	al,switch	;Switch character?
		je	scan_done	;Also done.
		stosb			;Save character in filespec buffer,
		lodsb			;and get the next character
		loop	scan2
		display	filespec_err	;Filespec too long
		mov	al,4
		stc
		ret

scan_done:	dec	si		;point back to last character
		ret

scan		endp

COMMENT	*

OPEN attempts to open a file for the access mode contained in [AL].
On entry, [DX] points to an ASCIIZ file description string.  On exit,
if C is set, an error occured, and the errorlevel exit code is in [AL]
otherwise, [AX] contains the file handle returned by DOS.

	*

open		proc	near
		fopen
		jc	open_error
		ret

open_error:	push	ax		;Save error code
		display	file_err
		pop	ax
		cmp	al,2
		jne	no_path
		display	not_found	;File Not Found Error
		mov	al,5
		stc
		ret

no_path:	cmp	al,3
		jne	no_handles
		display	path		;Invalid Path Error
		mov	al,6
		stc
		ret

no_handles:	cmp	al,4
		jne	no_access
		display	handle		;Insufficient File Handles Error
		mov	al,7
		stc
		ret

no_access:	cmp	al,5
		jne	unknown
		display	access		;Access Denied Error
		mov	al,8
		stc
		ret

unknown:	display	unk_err		;Unknown Error
		mov	al,9
		stc
		ret

open		endp

COMMENT	*

PARSE will examine the command string for delimiters and option switches.
On entry, [SI] points to start of option switch characters or end-of-line.
If any errors are discovered the routine exits with the C flag set, otherwise
the C flag is clear.

	*

parse		proc	near
		lodsb
		cmp	al,cr		;Have we reached the end of the line?
		jne	parse_1
		ret

parse_1:	cmp	al,switch	;Have we reached a delimiter?
		jne	parse		;No, so try again
		lodsb			;Yes, so get option switch
		call	toupper		;Convert it to U/C
		cmp	al,'A'		;Is it the ASCII switch?
		jne	parse_2
		mov	asc_flg,1
		jmp	parse

parse_2:	cmp	al,'B'		;Is it the BINARY switch?
		jne	parse_3
		mov	asc_flg,0
		jmp	parse

parse_3:	cmp	al,'C'		;Is it the CHATTY switch?
		jne	parse_4
		mov	c_flg,1
		jmp	parse

parse_4:	cmp	al,'L'		;Is it the NEWLINE switch?
		jne	parse_5
		mov	nl_flg,1
		jmp	parse

parse_5:	cmp	al,'N'		;Is it the NONEWLINE switch?
		jne	parse_err
		mov	nl_flg,0
		jmp	parse

parse_err:	display	syntax_err
		mov	al,1
		stc
		ret

parse		endp

COMMENT	*

PRINT is the numeric print routine.  Leading spaces are suppressed.

	*

print		proc	near
		mov	ax,chk_sum_lo
		mov	dx,chk_sum_hi
		mov	di,offset lsbchk
		call	long2asc	;Convert number to ASCII
		cmp	scrn_flg,0
		jne	print_checksum	;Already printed message
		mov	dx,offset sum
		dsp_msg
		mov	scrn_flg,1
		mov	ah,3
		mov	bh,scrnpage
		int	010h		;Get cursor position
		mov	cursrow,dh	;save row

print_checksum:	mov	ah,2
		mov	bh,scrnpage
		mov	dh,cursrow
		mov	dl,10		;Column 10
		int	010h
		mov	si,offset chksum
		mov	cx,9

print_1:	mov	al,spc
		cmp	byte ptr [si],'0'
		jne	print_2
		push	cx
		dsp_chr
		pop	cx
		inc	si
		loop	print_1

print_2:	mov	dx,si
		dsp_msg
		ret

print		endp		

COMMENT	*

LONG2ASC will convert a 32 bit unsigned integer to an ASCII string.  On entry,
[AX] contains the low order word, [DX] contains the high order word, [DI]
points to the LS Digit position of the buffer in which to store the result.

	*

long2asc	proc	near
		xchg	bp,dx		;Save HI word in [BP]
		mov	bx,10		;put divisor in [BX]
		mov	cl,'0'		;and conversion for ASCII in [CL]

long2asc1:	cmp	bp,0		;are we done with HI word?
		jz	long2asc2	;Yes, so process LO word.
		xchg	ax,bp		;HI word in [AX], LO word in [BP]
		clear	dx
		div	bx		;divide HI word by 10
		xchg	bp,ax		;new HI word in [BP], LO word in [AX]
		div	bx		;divide LO word + HI word remainder,
		or	dl,cl		;and convert remainder to ASCII.
		mov	[di],dl		;Save the quotient, and
		dec	di		;step back one byte toward MS digit.
		jmp	long2asc1

long2asc2:	clear	dx
		div	bx		;divide LO word by 10, then
		or	dl,cl		;convert remainder to ASCII,
		mov	[di],dl		;save quotient.
		dec	di		;Step back one byte to next digit.
		cmp	ax,0		;Are we done?
		jnz	long2asc2	;No, so repeat
		ret

long2asc	endp

toupper		proc	near
		cmp	al,'a'
		jb	is_upper
		cmp	al,'z'
		ja	is_upper
		sub	al,32
is_upper:	ret

toupper		endp

COMMENT	*

GETCHAR gets characters from the file pointed to by FILE_PTR.  In order to
reduce the number of disc access required, the function will fill the buffer
INBUF with characters or until an EOF is detected.  The variable BUFCOUNT
contains the number of characters remaining in the buffer, and the variable
BUFPTR points to the next character to get.  The variable EOF contains 0 if
this is not the last buffer, and FF if it is.  If the mode is ASCII, then a
CTRL-Z, $1A, character will also signal EOF.  The size of the buffer is
declared in the equate BUFFERSIZE.  The character is returned in [AL].  If
the C flag is clear no errors occured, otherwise the C flag is set.

	*

getchar		proc	near
		cld
		cmp	bufcount,0	;Are there any characters in buffer?
		je	empty		;No, so try to re-fill the buffer
		mov	si,bufptr	;Get current buffer pointer
		lodsb			;Get the next character,
		cmp	asc_flg,1	;Is mode = ASCII?
		jne	getchar1	;No, so skip next steps
		cmp	al,_eof		;Is character ASCII EOF?
		jne	getchar1	;No, so skip next section
		mov	bufcount,0	;Set bufcount to zero,
		mov	eof_flg,EOF	;Set EOF flag
		jmp	getchar

getchar1:	mov	bufptr,si	;save the new pointer,
		dec	bufcount	;decrement the counter
		clc
		ret

empty:		cmp	eof_flg,EOF	;Is this the last buffer?
		jne	more_data
		stc
		ret

more_data:	call	fill_buffer
		jnc	getchar
		mov	al,10		;Unexpected I/O error code.
		ret

getchar		endp

COMMENT	*

FILL_BUFFER attempts to re-fill the buffer.  The file handle is stored in the
variable FILE_PTR.  The buffer start address is contained in the variable
DATA_BUFFER, and the size of the buffer is defined in the equate BUFFERSIZE.
If the number of bytes transferred is the same as BUFERSIZE, then this is
not the end of the file.  On the other hand, if the number of bytes
is less than BUFFERSIZE, then this is the last file block.  In this latter
case the variable EOF is set to FF.  If some error occured, then the C flag
is set.

	*

fill_buffer	proc	near
		mov	eof_flg,0		;Clear End Of File flag
		mov	cx,BUFFERSIZE
		mov	dx,data_buffer
		mov	bufptr,dx		;Reset buffer pointer
		mov	bx,file_ptr
		mov	ah,03fh
		int	dos_call
		jnc	fill_ok
		display	input_err
		stc
		ret

fill_ok:	cmp	ax,BUFFERSIZE
		je	not_eof
		mov	eof_flg,EOF

not_eof:	mov	bufcount,ax
		clc
		ret

fill_buffer	endp

COMMENT	*

CHECK_CHAR compares the mode status flags and checks the character accordingly.
If the ASCII flag is set, then any character that is not CR, LF, FF, TAB, or
in the range $20 - $7E causes an error.  The user is given the choice of
aborting or continuing as BINARY.  If the /N switch is set, a CR or LF is
discarded.  If the /L switch is set, CR or LF is counted.  If the CHATTY flag
is set, and the mode is ASCII, then the file is echo-ed to the console screen,
otherwise, in the BINARY mode the running checksum is displayed.

	*

check_char	proc	near
		cmp	asc_flg,1	;Is mode ASCII?
		jne	binary		;No, so must be binary
		cmp	al,07fh
		jb	next_asc

change_mode:	push	ax		;Save current character
		call	mode_chg	;Mode error
		pop	ax		;recover character
		jnc	check_char
		display	abort_msg	;Mode error
		mov	al,12		;User abort error code
		stc
		ret

next_asc:	cmp	al,spc		;Is character printable?
		jb	asc_tst		;No, so test for CR/LF discard

asc_chat1:	cmp	c_flg,1		;CHATTY mode selected?
		je	asc_chat3	;Yes

asc_chat2:	clc
		ret

asc_chat3:	push	ax
		dsp_chr
		pop	ax
		clc
		ret

asc_tst:	cmp	al,tb
		je	asc_chat1
		cmp	al,f_feed
		je	asc_chat2
		cmp	al,cr
		je	asc_nl_chk
		cmp	al,lf
		je	asc_nl_chk
		cmp	al,_eof		;Is character ASCII EOF?
		jne	change_mode	;no, so an illegal character.
		mov	eof_flg,EOF	;ASCII EOF, so set EOF flag,
		clear	ax
		mov	bufcount,ax	;and buffer count to zero.
		jmp	asc_chat2

asc_nl_chk:	cmp	nl_flg,1	;Discard CR/LF?
		je	asc_chat1	;No
		cmp	c_flg,1		;CHATTY mode selected?
		je	asc_chat4

asc_discard:	clear	al
		ret

asc_chat4:	push	ax
		dsp_chr
		pop	ax
		jmp	asc_discard

binary:		cmp	nl_flg,1	;Discard CR/LF?
		je	test_binchat	;No
		cmp	al,cr		;Is character CR?
		jne	try_binlf

bin_discard:	clear	al

test_binchat:	cmp	c_flg,1		;CHATTY mode selected?
		je	bin_chat	;Yes
		clc
		ret

try_binlf:	cmp	al,lf		;Is character LF?
		jne	test_binchat
		jmp	bin_discard

bin_chat:	push	ax
		call	print
		pop	ax
		clc
		ret

check_char	endp

COMMENT	*

MODE_CHG is entered as a result of encountering a non-ASCII character in a file
when the ASCII flag was set.  It will display an error message and prompt the
user whether they wish to continue.  If the user answers either 'y' or 'Y' then
the mode is changed to BINARY and the program continues.  Any other response
will cause the program to abort with the errorlevel flag set.

	*

mode_chg	proc	near
		display	prompt

mode_chg1:	mov	ah,1
		int	dos_call
		cmp	al,0
		je	mode_chg1	;to cater for extended ASCII codes
		call	toupper		;convert to U/C
		cmp	al,'Y'
		je	set_binary
		stc
		ret

set_binary:	mov	asc_flg,0
		call	newline
		ret

mode_chg	endp

newline		proc	near
		display	new_line
		ret

newline		endp

himem		equ	$+1		;First free byte in code segment

main            endp
code		ends
		end	begin
