;===========================================================
;             DEBUG  for the TRS-80 Model 100
;               Version: 4.13  14/JUNE/1990
;           Copyright 1987/88/89/90 Adrian Ryan
;                      P.O. Box 222
;      Carp, Ontario, CANADA, K0A-1L0 (613) 256-2487
;===========================================================

;===========================================================
;                        DISCLAIMER
;This program is provided  "as-is" with no warranties of any
;kind.    In particular, the user assumes all responsibility
;for  any loss or damage that may occur from the use of this
;program.     The author makes no representation of any kind
;that  this  software  will  execute   correctly  under  all
;circumstances.    It  is  up  to  the user to determine the
;suitability   of  this  software for his or her  particular
;purposes.
;===========================================================

;Version 4.13 14-JUNE-1990  fixes  a  bug in the 'R' command
;caused by the change in Version 4.00

;Version 4.12 13-JUNE-1990  fixes a bug in the ASMBL routine
;revealed by Version 4.11.

;Version 4.11 13-JUNE-1990  fixes  a  minor bug in the CNVRT
;routine  that  prevented  an  overflow  error  from  being
;recognised.

;Version 4.10 9-JUNE-1990 adds the 'H' DEC to HEX conversion
;command, and reduces the size of the .CO file by relocating
;various internal buffers, flags,  and variables that do not
;need to be initialised to the end of the code space.

;Version 4.00 6-JUNE-1990  enhances  the program by removing
;the  necessity  of providing leading  zeros for the numeric
;arguments.  Arguments must now be de-limited with spaces or
;tabs.

;Version 3.22 3-JUNE-1990 removed 38 bytes of redundant code.

;Version 3.21 19-NOVEMBER-1988 modifies the display order of
;the  machine  registers,  and fixes an inconsistency in the
;R command.  The SP register was never intended to be set by
;DEBUG.   If you use your own local stack then you must save
;the  return  address  that  is  on the DEBUG stack prior to
;using your own stack if control is to be recovered by DEBUG
;after a 'G' command.

;Version 3.20 16-NOVEMBER-1988 modifies the code in the WALK
;routine  to  correctly execute the illegal op-codes JD/JND.
;NOTE: This  operation  will only be supported if your 80C85
;actually  correctly  executes these codes.  It is up to the
;user  to  verify  correct  operation  of this modification.
;In  addition,  support  is  provided  for the other illegal
;codes:-  $08/DSUB B,  $10/RHR,  $18/RDL,  $28/DMOV H,$nn,
;$38/DMOV S,$nn,  $D9/SHLX,  $DD/JND $nnnn,  $ED/LHLX,
;$FD/JD $nnnn,  as  well  as the undocumented flags in bit 1
;and  bit  5  of  the  F register.  To remind you that these
;flags  are not "official", they are displayed as lower case
;letters 'v' for bit 1, and 'd' for bit 5.

;Version 3.19 13-NOVEMBER-1988 modifies the mnemonic op-code
;table  to  bring  it  more  in line with the standard INTEL
;mnemonics.   The only difference between the INTEL op-codes
;and DEBUG is that PSW is called AF.    Thus PUSH/POP PSW is
;now PUSH/POP AF.

;Version 3.18  22-APRIL-88 fixes a minor bug in the REGISTER
;command  that  caused invalid flag settings to be displayed
;instead of having the invalid bits masked out.  In addition
;a  minor  change  was made to the ASSMBL routine so that no
;prompt is given when waiting for a new line to assemble.

;Version 3.17   17-APRIL-88 removes 6 bytes from the file by
;re-writing the DECMNT sub-routine.

;Version 3.16   11-APRIL-88 removes 11 bytes from the object
;file  by replacing all occurences of the op-code CPI 0 with
;ORA A.

;Version 3.15   31-JULY-87 removes 14 bytes from the file by
;re-structuring the command table and the code that accesses
;it.

;Version 3.14  29-MAY-87  fixes  a  low level bug in the S/E
;commands  whereby the commands would process a string of 65
;bytes  correctly, and then complain with a beep that it was
;an error.  No  harm  was  caused  by  this bug,  but in the
;interests  of  consistency  I  felt that it was time it was
;eliminated. This version will beep if an attempt is made to
;process a string that is longer than 64 characters.

;Version 3.13  26-MAY-87  improves the error handling.  With
;this  revision,  a  major  error,  such  as  a non-existent
;command,  will  provoke  a  dual tone beep, whilst an error
;in an otherwise legal command will produce only a beep.

;Version 3.12  25-MAY-87  fixes a bug in the UNASSEMBLE code
;that  caused  the  command  to  abort at the end of a range
;instead of returning to the command processor. It also adds
;a  feature  to  the  GO command so that it now displays the
;dis-assembled  code  at  the  breakpoint  as  well  as  the
;contents of the registers.  The GO command has been altered
;to make it self-terminating.

;A sub-command has been added to the WALK command.  The  'G'
;sub-command  will  execute  the code at full speed.  It has
;the  same  effect  as  exiting from WALK and executing a GO
;command.  The  'X' sub-command has been improved to include
;a  code  check.  This  ensures  that  the command will only
;execute  if it is pointing at a CALL, RST, or a conditional
;CALL instruction.  All other instructions are ignored.

;Version  3.11  22-MAY-87  removes 2 bytes of redundant code
;from the SAVREG routine.

;Version  3.10  18-MAY-87  removes  the stack space from the
;file,  and  fixes  a bug in the BREAKPOINT SET routine that
;caused  the  routine  to  abort to the command line handler
;when an illegal address was entered,  rather than the error
;return point.

;Version  3.09  17-MAY-87  centralises  the sign-on message.

;Version  3.08  16-MAY-87  re-arranges  the code in the FILL
;command to remove 2 redundant bytes.

;Version  3.07 09-MAY-87 re-arranges the code in the command
;line handler.

;Version  3.06  17-APR-87 removes 5 bytes of redundant code.

;Version  3.05  12-APR-87  fixes a bug in the VERIFY routine
;that  caused  the  printer output to remain diverted to the
;printer when the code terminated at the end of range.

;In  addition,  it  fixed  a  bug that caused the routine to
;return to the command line even when an incorrect entry was
;made.

;Version 3.04 11-APR-87 adds the screen length check feature
;to the SEARCH routine.

;Version  3.03 fixes a bug in the VERIFY routine that caused
;incorrect  operation  when  the  output was diverted to the
;printer.

;Version  3.02  fixes  a bug in the BREAKPOINT CLEAR routine
;that  caused  the incorrect contents to be stored in the HL
;register.

;Version  3.01  cleans  up some code by removing a jump that
;would never have executed.

;Version  3.00  adds  the  WALK,  GO,  BREAKPOINT and VERIFY
;commands.

;Version  2.00  adds  the  ASSEMBLE, DIS-ASSEMBLE and SEARCH
;commands.  Modification record no longer maintained.

;Version 1.00 contained the CALCULATE, DISPLAY, ENTER, FILL,
;LENGTH,  MOVE,  PRINTER TOGGLE,  QUIT, REGISTER, and EXPAND
;command set.  Modification record no longer maintained.

	org	0e2d9h
;	org	0e1d9h	;Use this ORG for difference file

;===========================================================
;Model 100 ROM Routine Equates
;===========================================================

pause	equ	05f2fh	;Wait for SPACEBAR to be pressed
movup	equ	06bdbh	;Move block of data upwards
movdwn	equ	06be6h	;Move block of data downwards
curpos	equ	0427ch	;Cursor positioning routine
prtasc	equ	01be0h	;Print ASCII characters only
prtstr	equ	05a58h	;Print NUL terminated string
revon	equ	04269h	;Turn reverse video ON
revoff	equ	0426eh	;Turn reverse video OFF
crlf	equ	04222h	;Print a newline sequence
prtint	equ	039d4h	;Convert and print HEX to DEC
beep	equ	04229h	;BEEP routine
menu	equ	05797h	;Return to system menu
getuc	equ	00fe8h	;Get upper case character
touper	equ	00fe9h	;Convert to U/C
getln	equ	0463eh	;Get line from KB with prompt
getlnp	equ	04644h	;Get line from KB no prompt
keyx	equ	07270h	;Check KB queue for chars or BRK
chrget	equ	012cbh	;Wait and get char from KB
chkchr	equ	05d46h	;Check character
clrscr	equ	04231h	;Clear screen
clreol	equ	0425dh	;Clear to end of line
sound	equ	072c5h	;Sound routine

;===========================================================
;Model 100 Reserved RAM
;===========================================================

inbuf	equ	0f685h	;Line Input Buffer
prtflg	equ	0f675h	;Screen/Printer flag
scrpos	equ	0f639h	;Current Cursor Position

;===========================================================
;Standard Character and Key Equates
;===========================================================

spc	equ	32
cr	equ	13
lf	equ	10
tab	equ	9
up	equ	30
down	equ	31
quote	equ	39
comma	equ	','

;===========================================================
;DEBUG Command Table Size
;===========================================================

tblsiz	equ	012h

;===========================================================
;DEBUG Main Program Entry Point
;===========================================================

entrpt  lxi	h,entrpt-020h
	sphl			;Set stack pointer
	shld	pssp		;Update pseudo-sp
	call	clrscr		;Clear the screen,
	lxi	h,cpyrt		;and blow my own trumpet.
	call	prtstr

;===========================================================
;We arrive here under the following conditions:-

;       [1]     When an EOL is found (NUL byte)
;       [2]     At the conclusion of ASSEMBLE, GO, or WALK
;       [3]     At start-up
;===========================================================

start	lxi	h,entrpt-020h	;Get default stack pointer
	sphl			;and restore it
	call	getln		;Get line from keyboard
	lxi	h,inbuf-1	;Setup inbuf pointer
	shld	bufptr

;===========================================================
;We arrive here at the successful completion of a command
;===========================================================

return	mvi	a,16
	sta	base	;Ensure flag is set to HEX
	lhld	bufptr	;Restore inbuf pointer

loop1	inx	h	;Point to next character in buffer

loop2	call	chkchr	;Get character and remove spaces
	jz	loop2
	call	touper	;convert to U/C
	ora	a
	jz	start	;End of line?
	cpi	':'	;Is it a command delimiter?
	jz	loop1	;Yes
	shld	bufptr	;Update buffer pointer
	mvi	c,tblsiz
	lxi	h,cmdtbl	;Point to command table

loop3	cmp	m	;Valid command?
	jz	cmdexc	;Yes, go to command entry point
	inx	h	;No, try again
	inx	h
	inx	h
	dcr	c
	jnz	loop3	;At end of table?
	call	beep	;Yes, not a valid command

;===========================================================
;We enter here if an error is discovered during the command
;processing, e.g, illegal address, invalid characters, etc.
;===========================================================

error	lxi	d,01000h;Start set-up for sound
	mov	b,d
	call	sound
	jmp	start	;Abort command line

;===========================================================
;This is the jump off point for executing a command.
;===========================================================

cmdexc	inx	h	;Point to execute address in cmdtbl
	mov	e,m	;Get LO byte of address
	inx	h	;Point to next byte of address
	mov	d,m	;Get HI byte of address
	xchg		;Swap HL and DE
	pchl		;Jump to command

;===========================================================
;ASSEMBLE Command
;Syntax  : A addr
;Example : A C000
;===========================================================

assmbl	call	carg3	;Get command argument
	jc	error	;Abort if illegal or missing
	lhld	arg3	;Get address
	call	chkadr
	jc	error	;Abort if a ROM address

a_loop	call	asmbl
	jc	start	;Quit if blank line
	lhld	scrpos	;Get current cursor position
	dcr	l	;Move up 2 lines
	dcr	l
	call	curpos	;Re-position it
	call	disasm	;Display line just assembled
	jmp	a_loop	;Get next line

;===========================================================
;BREAKPOINT Command
;Syntax : B [addr]
;Example: B C009
;===========================================================

brkpt	call	carg1	;Get address, if any
	push	psw	;Save status
	lda	bpflg	;Get current breakpoint status
	cpi	0ffh	;Is break point set?
	jnz	bpset	;No, so set breakpoint
	call	bclear	;Yes, so reset breakpoint

bpset	pop	psw	;Restore status
	jc	return	;Exit if illegal chars/no address
	call	brkset
	jc	error	;Abort if illegal address
	jmp	return

;===========================================================
;We arrive here whenever a breakpoint is discovered during
;the execution of the GO command.
;===========================================================

break	call	savreg	;Save current register contents
	lhld	bpaddr	;Get breakpoint address
	shld	pspc	;Restore pseudo-pc
	shld	arg3	;Set up for dis-assembler
	lxi	h,bmsg1	;"Breakpoint "
	call	prtstr
	lxi	h,bmsg4 ;"reached "
	call	prtstr
	call	bclear	;Clear breakpoint
	call	disasm	;Disassemble code at breakpoint
	call	dspreg	;Display register contents,
	jmp	start	;and exit

;===========================================================
;CONVERT DECIMAL to HEXADECIMAL
;Syntax : H arg1 [arg2]
;Example: H 65535 12345
;===========================================================

hexdec	mvi	a,10
	sta	base	;Set conversion base to DECIMAL

;===========================================================
;CALCULATE Command
;Syntax : C arg1 [arg2]
;Example: C 1234 5678
;===========================================================

calc	call	carg1	;Get first command line argument
	jc	error	;Argument invalid, so exit
	call	carg2	;Get second command line argument
	push	psw	;Save status
	lhld	arg1	;Get first argument value,
	xchg		;and put it in [DE]
	lxi	h,buf1	;Point [HL] to temp buffer,
	call	itoasc	;and convert [DE] to ASCII
	mvi	a,1	;Set [A] to column 1
	call	rprint	;Display first argument in reverse
	pop	psw	;Examine status
	jc	onearg	;Only 1 argument?
	lhld	arg2	;No, so get second value,
	xchg		;and put it in [DE]
	push	d	;Save arg2
	lxi	h,buf2	;Point [HL] to temp buffer
	call	itoasc	;Convert [DE] to ASCII
	mvi	a,6	;Set [A] to column 6,
	call	rprint	;and reverse video display,
	pop	d	;Get arg2 from stack,
	push	d	;and save it
	lhld	arg1	;Get arg1 from its buffer,
	push	h	;and put on stack
	dad	d	;Perform ARG1 + ARG2,
	xchg		;and put result in [DE]
	lxi	h,buf3	;Point [HL] at temp buffer
	call	itoasc	;Convert [DE] to ASCII
	mvi	a,'+'	; + symbol
	rst	4	;Display [A]
	mvi	a,12	;Set [A] to column 12,
	call	print	;and display in normal video
	pop	h	;Get ARG1 from stack
	pop	d	;Get ARG2 from stack
	call	sub	;Perform ARG1 - ARG2
	lxi	h,buf3	;Point [HL] at temp buffer
	call	itoasc	;Convert [DE] to ASCII
	mvi	a,'-'	; - symbol
	rst	4	;Display [A]
	mvi	a,18	;Set [A] to column 18,
	call	print	;and display ASCII
	jmp	quit1

;===========================================================
;We arrive here if there is only 1 argument, or if the
;second argument contains any illegal characters.
;===========================================================

onearg	lhld	arg1	;Retrieve argument value,
	push	h	;and save it on the stack
	call	prtint	;Display argument as decimal value
	lhld	scrpos	;Get current cursor position
	mvi	h,12	;Set column to 12
	call	curpos	;Restore new cursor location
	lhld	arg1	;Put ARG1 in
	xchg		;[DE]
	mov	h,e	;Swap high
	mov	l,d	;and low bytes
	shld	arg1	;and put back in ARG1
	lxi	h,arg1	;Put address of arg1 in [HL]
	mvi	b,2	;2 characters to display
	call	prtasc	;Display ARG1 as ASCII or spaces
	mvi	a,spc	;Space character
	rst	4	;Display [A]
	pop	h	;Get ARG1 from stack
	call	binary	;Convert it to binary and display

quit1	call	crlf	;Perform newline sequence
	jmp	return

;===========================================================
;DISPLAY Memory Contents Command
;Syntax : D addr1 [addr2]
;Example: D C000 C300
;===========================================================

dsply	call	carg1	;Get first address
	jc	error	;Abort if illegal chars
	call	carg2	;Get second address
	jc	dsone	;Skip if only one argument
	call	swap	;Swap order, if necessary,
	xchg		;and set up for subtraction
	call	sub	;Perform subtraction
	mvi	a,8	;8 bytes/line
	call	div	;[DE] = number of lines
	lhld	arg1	;[HL] = start address
	xchg		;[HL] = count, [DE] = address
	call	ps_set	;Set printer/screen flags

dslp	push	h	;save count
	call	putlin	;Put line of dump on O/P device
	pop	h	;restore count
	mov	a,l	;16 bit counter routine
	ora	a	;is LO byte zero ?
	jnz	dsp1	;no, so continue
	cmp	h	;yes, so is HI byte zero ?
	jz	dsp2	;yes, so we are done
	ana	a	;Ensure carry flag is clear

dsp1	dcx	h	;decrement counter
	call	keychk	;Check for BREAK/PAUSE
	jc	dsp2	;do PAUSE or BREAK
	jmp	dslp	;continue display

dsp2	call	ps_clr	;Clear printer/screen flags
	jc	start	;Abort if BREAK
	jmp	return	;Else normal return to command line

;===========================================================
;We arrive here if there was only one argument, or if the
;second argument contains illegal characters.
;===========================================================

dsone	lhld	arg1	;Get ARG1 value
	xchg

dnext	call	putlin	;Display single line of the dump

dwait	push	d	;Save [DE]
	call	chrget	;Get character from keyboard
	pop	d	;Restore [DE]
	cpi	cr	;Is character ENTER?
	jz	return	;Yes, normal return
	cpi	down	;Is it down-arrow?
	jz	dprev	;Yes, display previous 8 bytes
	cpi	up	;Is it up-arrow?
	jnz	dwait	;No, so get another character
	jmp	dnext	;Yes, so display next 8 bytes

;===========================================================
;This section deals with displaying the previous 8 bytes of
;memory.  We arrive here if the down-arrow key was pressed.
;Note that we must subtract 16 from [DE] because [DE] is
;pointing to the next higher address to dump, so we must
;subtract 8 to point to the start of the line just dumped,
;and then another 8 to point to the start of the previous
;line.
;===========================================================

dprev	mov	a,e	;Get current address
	sbi	16	;Subtract 16,
	mov	e,a	;and restore to [E]
	jnc	dnext	;Check for an underflow
	dcr	d	;There was, so decrement [D]
	jmp	dnext

;===========================================================
;ENTER DATA Command
;Syntax : E addr1 <HEX DIGITS>/<Delimited ASCII><...>
;Example: E C000 0D 0A 'Adrian Ryan' 0D 0A 00
;===========================================================

enter	call	setup	;Perform the set-up for ENTER
	jc	error	;Abort if error
	mvi	a,64	;Find out how long was the string
	sub	d	;That was entered, and convert
	mov	e,a	;To a 16 bit value and put in
	mvi	d,0	;[DE]
	lhld	arg1	;Get first address
	call	chkadr	;Check for ROM target address
	jc	error	;Abort if illegal address
	dad	d	;[HL] now points to end of range

movlop	dcx	b	;Decrement buffer pointer
	dcx	h	;and address pointer
	ldax	b	;Get character/byte from string
	mov	m,a	;Put it in memory
	dcr	e	;Decrement numbytes
	jnz	movlop
	lxi	h,mmsg	;"Done"
	call	prtstr
	jmp	return	;Normal return

;===========================================================
;FILL MEMORY Command
;Syntax : F addr1 addr2 <HEX DIGIT>/<Delimited ASCII Char>
;Example: F C000 C100 FF
;Example: F C000 C100 'a
;===========================================================

fill	call	carg1	;Get first address
	jc	error	;Illegal characters
	call	carg2	;Get second address from inbuf
	jc	error	;Illegal characters
	lhld	arg1	;Get address value
	call	chkadr	;Check if a ROM address
	jc	error	;Illegal address
	lhld	arg2	;Get address value
	call	chkadr	;Check if a ROM address
	jc	error	;Illegal address
	call	getnum	;Get fill byte/delimiter from inbuf
	jnc	fskp2	;If valid, continue
	cpi	quote	;The ' character
	jz	fskp1
	jmp	error	;Illegal delimiter

;===========================================================
;We arrive here if the fill byte is an ASCII character, not
;a HEX digit pair.
;===========================================================

fskp1	inx	h	;Point past delimiter
	shld	bufptr	;Update buffer pointer
	mov	a,m	;Get ASCII character

fskp2	push	psw	;Save fill byte
	call	swap
	xchg
	call	sub	;How many bytes to fill
	pop	b	;Retrieve fill byte
	mvi	a,0ffh	;Set comparision value in [A]

floop2	cmp	e	;Yet another way of doing
	jnz	floop3	;Integer decrements
	cmp	d	;Are we all done?
	jz	floop4	;Looks like it!

floop3	dcx	d	;Decrement numbytes
	mov	m,b	;Store fill byte
	dcx	h	;Decrement memory pointer,
	jmp	floop2	;and do it again.

floop4	lxi	h,mmsg	;"Done"
	call	prtstr
	jmp	return

;===========================================================
;GO calls the desired code. Your code must end with a RET
;to allow DEBUG to regain control. When control returns to
;GO, the stack pointer is restored to its original value.
;This is an example of self-modifying code. Much as I
;deprecate the use of such things, this was the only simple
;way to effect this command.
;Syntax : G addr1
;Example: G C000
;===========================================================

go	call	carg1	;Get entry address
	jc	error	;Abort if illegal
	lhld	arg1	;Put entry address in [HL]

;===========================================================
;We arrive here either as part of the normal execution of
;this command, or if we hit the 'G' key whilst single
;stepping the code in the WALK command.
;===========================================================

g_entr	shld	gobuf2	;Insert address in code buffer
	mvi	a,0cdh	;[A] contains the call op-code,
	sta	gobuf1	;and put it in the code buffer
	lxi	h,0
	shld	pspc	;Clear pseudo-pc
	call	resreg	;Restore registers from pseudos

gobuf1	nop		;These bytes will

gobuf2	nop		;be filled when the
	nop		;code executes.
	call	savreg	;Save the registers to pseudos
	call	dspreg	;Display pseduo-register contents,
	jmp	start	;and exit

;===========================================================
;SET/DISPLAY SCREEN LENGTH Command
;Syntax : L [num]
;Example: L 0F
;===========================================================

length	call	getnum	;Get ASCII 2 digit number
	jc	lskip1	;Skip if illegal
	ora	a
	jz	lskip1	;Skip if missing
	sta	scrlen	;Else store new length value

lskip1	lxi	h,lmsg1 ;"Screen length: "
	call	prtstr
	lda	scrlen	;Get current screen length value
	mov	l,a
	mvi	h,0
	call	prtint	;Display it
	lxi	h,lmsg2 ;"lines."
	call	prtstr
	jmp	return

;===========================================================
;MOVE MEMORY Command
;Syntax : M addr1 addr2 numbytes
;Example: M C000 D000 0100
;===========================================================

move	call	carg1	;Get first address
	jc	error	;Abort if illegal chars
	call	carg2	;Get second address
	jc	error	;Abort if illegal chars
	call	carg3	;Get number of bytes
	jc	error	;Abort if illegal chars
	lhld	arg2
	xchg
	lhld	arg1
	rst	3	;Compare [HL] and [DE]
	jz	mquit	;Exit if equal
	push	h	;This section sets up the registers
	lhld	arg3	;For the ROM memory move routines
	push	h
	pop	b
	pop	h
	jc	mdown	;Select which way to move data
	call	movup
	jmp	mquit

mdown	dcx	h	;These "adjustments" are necessary
	dcx	d	;because the ROM routines are not
	dad	b	;complementary.
	xchg
	dad	b
	xchg
	call	movdwn

mquit	lxi	h,mmsg	;"Done"
	call	prtstr

	jmp	return

;===========================================================
;PRINTER/SCREEN Toggle Command
;Syntax : P
;===========================================================

prtr	lxi	h,pmsg1 ;Display message "D/S/U/V ...."
	call	prtstr
	lda	scrflg	;Get flag
	ora	a	;Is it set?
	jnz	pclr	;Yes, so clear it
	mvi	a,1	;No, so set it,
	sta	scrflg	;and save new flag value
	lxi	h,pmsg3 ;"Printer."
	call	prtstr
	jmp	return	;Normal return

pclr	xra	a	;Clear [A]
	sta	scrflg	;Update flag
	lxi	h,pmsg2 ;"Screen."
	call	prtstr
	jmp	return

;===========================================================
;QUIT DEBUG Command
;Any breakpoint that was set will be restored prior to exit
;===========================================================

quit	lda	bpflg	;Get breakpoint flag
	cpi	0ffh	;Is it set?
	jnz	menu	;No
	call	bclear	;Yes, so retore breakpoint and
	jmp	menu	;Exit to MENU

;===========================================================
;SET/DISPLAY REGISTERS Command
;This command will allow you to pre-set the registers prior
;to executing a GO/WALK command. Any register you wish to
;skip is indicated by a comma in the arglist. Registers are
;in the order:- AF BC DE HL
;Syntax : R [arglist]
;Example: R ,0000,7FA4
;===========================================================

regs	mvi	d,4	;argument counter
	lxi	b,psaf	;pseudo-register array pointer

reg1	push	d	;save loop counter
	lhld	bufptr	;get current INBUF pointer
	call	atoint	;convert argument to integer
	shld	bufptr	;save current buffer pointer
	jnc	reg2	;if valid, continue,
	inx	b	;else skip current array location
	inx	b
	cpi	comma	;valid skip symbol?
	jz	reg3	;yes, so continue
	pop	d	;clean up stack
	jmp	reg4	;and exit

reg2	mov	a,e	;get LO byte
	stax	b	;and save it,
	inx	b	;point to next array location
	mov	a,d	;get HI byte
	stax	b	;and save it
	inx	b	;point to next register

reg3	pop	d	;recover loop counter
	dcr	d	;are we done?
	jnz	reg1	;no, so continue

reg4	lda	psaf	;get pseudo-flag contents and
	ani	0f7h	;mask the bit that cannot be
	sta	psaf	;altered.
	call	dspreg	;display settings,
	jmp	return	;and return to command line.

;===========================================================
;SEARCH MEMORY Command
;This command will search memory and display all occurences
;of the target string.
;Syntax : S addr1 addr2 <HEX DIGITS>/<Delimited ASCII><...>
;Example: S 1000 8FFF 0D 0A 'Adrian' 20 'Ryan' 0D 0A 00
;===========================================================

search	call	carg2	;Get first address, use ARG2 buffer
	jc	error	;Abort if error
	call	setup	;Get second address and arglist
	jc	error	;Abort if error
	call	ps_set	;Set printer/screen flags
	push	b
	pop	h
	dcx	h	;Point to last valid character
	shld	buf1	;Save end of search string address
	mvi	a,64
	sub	d
	sta	buf2	;Save numchars
	call	swap	;ARG1 = lo addr, ARG2 = hi addr
	xchg
	call	sub	;DE = numbytes
	xchg
	shld	arg1	;ARG1 = numbytes left to scan

schagn	call	schstr
	push	psw
	lda	nmflg
	cpi	1	;Did we find the string?
	jnz	schskp	;No
	lxi	h,buf3	;Temp buffer for current address
	call	itoasc	;Convert it to ASCII
	call	prtstr	;Print current address
	call	crlf	;Execute newline sequence
	call	keychk	;Check for BREAK/PAUSE/QUIT,
	jc	schqit	;and exit if ENTER was pressed

schskp	pop	psw
	jnc	schagn

vquit	call	ps_clr	;Reset printer/screen flags
	jmp	return	;Normal end of range exit point

schqit	pop	psw	;Fix up stack

vabort	call	ps_clr	;Reset printer/screen flags
	jmp	start	;BREAK exit point

;===========================================================
;UN-ASSEMBLE Command
;This command will dis-assemble the machine code at ADDR1
;and display the result using the mnemonic table used by the
;ASSEMBLE command.
;Syntax : U addr1 [addr2]
;Example: U C000 C100
;===========================================================

unassm	call	carg1	;Get first address
	jc	error	;Must be an error so abort
	call	carg2	;Get second address, if any
	jc	u_one	;Only one argument
	call	swap	;Ensure ARG1 < ARG2
	shld	arg3	;HL = start, DE = end address
	call	ps_set	;Set printer/screen flags

;===========================================================
;This is the loop used to display the dis-assembly of a
;range of code.
;===========================================================

u_loop	push	d
	call	disasm
	call	keychk	;Check for BREAK/PAUSE,
	pop	d
	jc	u_quit	;and quit if BREAK
	lhld	arg3
	xchg		;HL = end, DE = next address
	rst	3	;Compare [HL] and [DE]
	xchg
	jnc	u_loop	;If (end >= next) then continue
	cmc		;Clear carry and
	jmp	u_quit	;Exit normally

;===========================================================
;We arrive here if there is only one valid address argument.
;===========================================================

u_one	lhld	arg1	;Get start address
	shld	arg3	;Set up for dis-assemble routine

u_agn	call	disasm

u_wait	call	chrget	;Get character from keyboard
	cpi	cr	;Is it ENTER?
	jz	u_quit	;Yes, so exit
	cpi	up	;Is it up-arrow?
	jz	u_agn	;Yes, so dis-assemble next line
	jmp	u_wait	;None of the above

;===========================================================
;This is the entry point for the exit routine. If C is set
;then abort, else normal return to command line.
;===========================================================

u_quit	call	ps_clr	;Clear printer/screen flags
	jc	start	;BREAK detected
	jmp	return

;===========================================================
;VERIFY MEMORY CONTENTS Command
;This command will compare the contents of memory in range1
;with that in range2, displaying all differences
;Syntax : V addr1 addr2 numbytes
;Example: V C000 D000 100
;===========================================================

verify	call	carg1	;Get first address
	jc	error	;Abort if illegal
	call	carg2	;Get second address
	jc	error	;Abort if illegal
	call	carg3	;Get numbytes
	jc	error	;Abort if illegal
	call	ps_set	;Set printer/screen flags
	lhld	arg3
	xchg		;[DE] = numbytes
	lhld	arg2	;Get target
	dad	d
	push	h
	pop	b	;[BC] = target + numbytes
	lhld	arg1
	dad	d	;[HL] = source + numbytes

vloop	ldax	b	;Get target byte
	cmp	m	;Same as source?
	jz	vcont	;Yes, so continue
	call	vline	;No, so display differences
	push	d	;save current count
	push	b	;save target
	push	h	;save source
	push	b	;swap source/target
	pop	h
	call	vline
	call	crlf	;print newline
	call	keychk	;check for break/pause
	pop	h	;restore source
	pop	b	;restore target
	pop	d	;restore count
	jc	vabort	;abort if break

vcont	call	decmnt
	jc	vquit	;Exit if end of range
	dcx	b
	jmp	vloop

;===========================================================
;WALK Command single steps the code. On entry ARG3 must
;contain the address of the next instruction to step. All PC
;modifying instructions are converted to their equivalent
;jump forms. ARG3 will contain the next address to walk if
;a jump is not taken, and OPERND will contain the address
;if the jump is taken.
;The DISASM routine sets up the data used by WALK to determine
;the actions required. OPLEN contains the number of immediate
;data bytes, (0, 1, 2), OPERND contains the immediate data. If
;a single byte instruction is to be executed, OPLEN = 0, and
;OPERND contains $0000. The contents of OPERND is inserted in
;the walk buffer, and becomes NOP's. If OPLEN = 1, then OPERND
;contains a single byte of data plus a $00 byte. This is put
;in the WALK buffer, and becomes a single byte of data plus a
;NOP.
;This routine is deliberately designed as in-line code so
;that if any stack corruption occurs then control can be
;recovered by DEBUG.
;This is also an example of self-modifying code, and again
;despite my innate dislike of this technique, it was the
;only simple way to implement this feature.
;WALK will clear any breakpoint that is set.
;Syntax : W addr1
;Example: W C000
;===========================================================

walk	call	carg3	;Get address, use ARG3 buffer
	jc	error	;Abort if illegal chars
	lda	bpflg	;Get breakpoint flag
	cpi	0ffh	;Is it set?
	jnz	wlkreg	;No
	call	bclear

wlkreg	call	resreg	;Restore registers from pseudos,
	call	savreg	;and save them to pseudos

wlkagn	lhld	arg3	;Get address to walk
	shld	pspc	;Update pseudo-PC
	mov	a,m	;Get actual code byte
	sta	wbuf1	;Store in walk buffer
	call	disasm	;Dis-assemble code
	call	dspreg	;Display registers

wlkwat	call	chrget	;Get character
	call	touper	;Convert [A] to U/C
	cpi	cr	;Is it ENTER?
	jz	start	;Yes, so quit
	cpi	up	;Is it an up-arrow?
	jz	xecute	;Yes, so single step the code
	cpi	'G'	;Is it a GO?
	jnz	wlkskp	;No
	lhld	pspc	;Get current address
	jmp	g_entr	;Execute via GO command

wlkskp	cpi	'X'	;Is it an EXECUTE SUBROUTINE?
	jnz	wlkwat	;None of above
	call	xcheck	;Check for CALL/RST op-code
	jz	xcute1	;OK, so execute sub-routine
	jmp	wlkwat	;Get next keypress

xecute	lda	jmpflg	;Get jump flag
	ora	a
	jnz	fixup

xcute1	lhld	opernd
	shld	wbuf2

xcute2	call	resreg	;Restore registers

wbuf1	nop		;These bytes will

wbuf2	nop		;be filled when
	nop		;the code executes.
	call	savreg	;Save registers, JMP not taken
	jmp	wlkagn

jtakn1	call	savreg	;Save registers, JMP taken
	lhld	opernd	;Get next address
	shld	arg3
	jmp	wlkagn

jtakn2	call	savreg	;RET taken
	pop	h	;Get next address
	shld	arg3
	lhld	pssp
	inx	h
	inx	h	;Fix up psuedo-SP
	shld	pssp
	jmp	wlkagn

jtakn3	call	savreg	;CALL taken
	lhld	arg3	;Put return address
	push	h	;On the stack
	lhld	opernd	;Get next address
	shld	arg3
	lhld	pssp
	dcx	h
	dcx	h
	shld	pssp	;Fix up psuedo-SP
	jmp	wlkagn

fixup	lda	wbuf1	;Get op-code byte
	mov	b,a	;Save it
	cpi	0fdh	;Is it illegal op-code	JD?
	jz	jfix	;Yes
	cpi	0ddh	;Is it illegal op-code	JND?
	jz	jfix	;Yes
	cpi	0cdh	;Is it an unconditional CALL?
	jz	calfix	;Yes
	cpi	0c9h	;Is it an unconditional RET?
	jz	retfix	;Yes
	cpi	0c3h	;Is it an unconditional JMP?
	jz	jfix	;Yes
	ani	0c7h
	cpi	0c7h	;Is it an RST?
	jnz	fix1	;No
	mov	a,b	;Get op-code byte
	sui	0c7h	;Calculate actual address,
	mov	l,a
	mvi	h,0
	shld	opernd
	jmp	calfix	;and treat RST as CALL

fix1	mov	a,b	;Get op-code byte
	cpi	0e9h	;Is it PCHL?
	jnz	fix2	;No
	lhld	pshl	;Get contents of pseudo-HL register
	shld	opernd
	mvi	a,0c3h	;Convert to a JMP
	sta	wbuf1
	jmp	jfix

calfix	mvi	b,0c5h

fix2	mov	a,b	;Get op-code byte
	ani	0c4h
	cpi	0c4h	;Is it a conditional CALL?
	jnz	fix3	;No
	lxi	h,jtakn3
	shld	wbuf2
	mov	a,b
	dcr	a
	dcr	a	;Convert to equivalent JMP
	sta	wbuf1
	jmp	xcute2

fix3	mov	a,b	;Get op-code byte
	ani	0c2h
	cpi	0c2h	;Is it a conditional JMP?
	jnz	fix4	;No

jfix	lxi	h,jtakn1
	shld	wbuf2
	jmp	xcute2

retfix	mvi	b,0c1h

fix4	lxi	h,jtakn2
	shld	wbuf2
	mov	a,b
	inr	a
	inr	a	;Convert to equivalent JMP
	sta	wbuf1
	jmp	xcute2

;===========================================================
;EXPAND REGISTER Command
;This command will display the flag register setting
;Syntax : X [num]
;Example: X 0F
;===========================================================

xpand	call	getnum	;Get 2 digit ASCII HEX number
	jnc	xarg	;Use this value if legal or
	lda	psaf	;Use pseudo-AF value

xarg	ani	0f7h	;Mask bit that cannot be changed
	mov	c,a
	mvi	b,7
	lxi	h,flgmsg
	call	prtstr

xpnd1	mov	a,c
	rlc
	mov	c,a
	jnc	xpnd2
	mvi	a,'1'
	jmp	xpnd3

xpnd2	mvi	a,'0'

xpnd3	rst	4
	dcr	b
	jp	xpnd1
	call	crlf
	jmp	return

;===========================================================
;Common Subroutines
;These are the low level sub-routines that are used by most
;of the main DEBUG commands
;===========================================================

;===========================================================
;XCHECK
;This routine is used by the WALK command to check that the
;op-code is a CALL, RST, or conditional CALL. It ensures
;that the 'X' sub-command only excutes for these op-codes.
;It relies on the fact that the bit pattern of a cond CALL
;is:- 11xxx100, and for an RST is:- 11xxx111. A specific
;check is made for an unconditional CALL on entry.
;===========================================================

xcheck	lda	wbuf1	;Get op-code byte
	cpi	0cdh	;Is it a CALL?
	rz		;Yes, so its OK
	ani	0c7h	;Mask off 'don't care' bits
	cpi	0c4h	;Is it a conditional CALL?
	rz		;Yes, so its OK
	cpi	0c7h	;Is it RST?
	ret		;Check for Z flag on return

;===========================================================
;PRINTER/SCREEN Flags
;This routine is used by the D, S, U, and V commands to
;set/clear the flags depending on the current output device.
;===========================================================

ps_clr	push	psw
	xra	a
	jmp	pskip

ps_set	push	psw
	lda	scrflg

pskip	sta	prtflg
	lda	scrlen
	sta	scrtmp
	pop	psw
	ret

;===========================================================
;CHKADR is used by the ENTER and FILL commands to signify
;that the target address is in ROM.
;===========================================================

chkadr	push	h
	push	d
	lxi	d,08000h;Start of RAM
	rst	3
	pop	d
	pop	h
	rnc		;No error
	lxi	h,bmsg5 ;"Illegal address!"
	call	prtstr
	stc
	ret

;===========================================================
;VLINE is used to print a line in the VERIFY command
;===========================================================

vline	push	h	;save source
	push	b	;save target
	push	d	;save count
	mov	a,m	;Get byte
	xchg
	lxi	h,buf3
	push	h
	push	psw
	call	itoasc
	mvi	a,spc	;Space character
	stax	b
	inx	b
	pop	psw
	call	bytasc
	mvi	a,spc	;Space character
	inx	b
	stax	b
	xra	a	;EOL byte
	inx	b
	stax	b
	pop	h
	call	prtstr
	pop	d	;restore count
	pop	b	;restore target
	pop	h	;restore source
	ret

;===========================================================
;BRKSET is used to set the break point
;===========================================================

brkset	lhld	arg1	;Get address
	call	chkadr	;Is it in ROM?
	rc
	lxi	b,3
	lxi	d,bpbufr
	shld	bpaddr
	push	h
	call	movup
	mvi	a,0ffh
	sta	bpflg
	pop	h
	mvi	m,0c3h	;JMP op-code
	lxi	d,break
	inx	h
	mov	m,e
	inx	h
	mov	m,d
	lxi	h,bmsg1 ;"Breakpoint "
	call	prtstr
	lxi	h,bmsg3 ;"set"
	call	prtstr
	ret

;===========================================================
;BCLEAR clear the breakpoint
;===========================================================

bclear	lxi	b,3
	lhld	bpaddr
	xchg
	lxi	h,bpbufr
	call	movup
	xra	a
	sta	bpflg
	lxi	h,bmsg1 ;"Breakpoint "
	call	prtstr
	lxi	h,bmsg2 ;"cleared"
	call	prtstr
	ret

;===========================================================
;ASSMBL this routine assembles a single line of code
;directly to memory. On entry ARG3 must contain the address
;at which to load the code.
;===========================================================

asmbl	lhld	arg3	;Get current address
	xchg
	lxi	h,buf1	;[HL] = BUF1, [DE] = assemble address
	call	itoasc	;Convert address to ASCII
	call	prtstr	;Print it
	call	clreol	;Clear to end of line,
	call	crlf	;and print a new line
	call	getlnp	;Get input line, no prompt
	lxi	h,inbuf ;Point to input buffer

asmbl1	call	chkchr	;Skip leading spaces
	jz	asmbl1
	push	h	;Save inbuf address pointer
	mvi	b,4	;Field width
	lxi	h,buf3
	xthl		;[HL] points to INBUF, stack points to buffer
	call	get	;Get the character
	dcx	h	;Fix up pointer,
	jnz	asmbl2	;and start processing line
	pop	h	;Fix up stack
	stc		;Set error flag
	ret

asmbl2	call	get	;Get next character
	jz	pad1	;End of line
	jnc	asmbl3
	cmc		;Found delimiter
	jmp	pad3

asmbl3	xthl		;Point to temp buffer
	mov	m,a	;Save character
	inx	h	;Point to next buffer space
	dcr	b	;Decrement field counter
	jz	gtopnd	;Get operand if end of mnemonic
	xthl		;Point to input buffer
	jmp	asmbl2

pad1	inr	b	;Pad with space

pad2	inr	b	;Op-code and operand field
	stc		;Set carry to force a jump later

pad3	xthl		;Point to temp buffer
	push	psw	;Save current status

pad4	mvi	m,spc	;Pad loop
	dcr	b
	inx	h
	jnz	pad4
	pop	psw	;Restore status,
	jc	schtbl	;and search for mnemonic if carry set

gtopnd	xthl		;Point to input buffer

gopnd1	call	get	;Get next character
	jz	pad1
	jc	gopnd1	;Found a delimiter, so skip it
	xthl		;Point HL to temp buffer
	mov	m,a	;Save character
	inx	h	;Point to next temp buffer space
	cpi	'$'	;Is char a $?
	jnz	nextchr	;No, get next char
	mvi	m,spc
	xthl		;Point to input buffer,

gtdata	dcx	h	;point back to character
	call	atoint	;get immediate data
	jc	asmerr1	;overflow, so error
	lxi	b,opernd
	mov	a,e
	stax	b	;Save LO byte
	inx	b	;Point to HI byte
	mov	a,d
	stax	b	;and save it,
	jmp	schtbl	;and search table

skipit	call	get	;Get next char
	jz	asmerr1	;EOL or a
	jc	asmerr1	;Delimiter is illegal here
	ori	080h
	xthl		;Point to temp buffer
	mov	m,a	;Save character
	xthl		;Point to input buffer
	cpi	0a4h	;Was char a $ or-ed with $80?
	jnz	schtbl	;No, so search table
	jmp	gtdata	;yes, so get the data

nextchr	xthl		;Point to input buffer
	call	get	;Get next character
	jz	pad2	;EOL found
	jc	skipit	;Comma found
	xthl		;No, point to temp buffer
	mov	m,a	;Save character,

schtbl	pop	h	;Clean up stack
	lxi	h,1536
	shld	arg1	;Store numbytes to search
	lxi	h,optbl+1536
	shld	arg2	;Address to start search

serch1	lxi	h,buf3+5
	shld	buf1	;End of string address
	mvi	a,5
	sta	buf2	;5 characters to search
	call	schstr
	lda	nmflg
	ora	a	;Find a match?
	jz	asmerr2	;No, then error
	dcx	d	;Yes, found last 5 characters
	ldax	d	;Get first character
	ani	01fh	;Convert it back to ASCII
	ori	040h
	lxi	h,buf3	;Point HL at first character
	cmp	m	;Are they the same?
	jz	found	;Yes
	xchg
	shld	arg2	;No, point to next address to search
	lhld	arg1
	dcx	h	;Update numbytes
	shld	arg1
	jmp	serch1	;Try again

found	ldax	d	;Get first byte of mnemonic,
	push	psw	;and save it
	xchg
	lxi	d,optbl
	call	sub	;[DE] = [HL] - [DE]
	mvi	a,6
	call	div	;[DE] = [DE] / [A]
	lhld	arg3	;Point to memory location
	mov	m,e	;Save op-code
	pop	psw	;Get coded mnemonic byte
	rlc		;Discard jump status
	rlc		;Check op-code length
	rnc		;Single byte
	rlc		;More than 2 bytes?
	lhld	opernd	;[HL] contains operand data
	xchg		;[DE] = operand data
	lhld	arg3	;[HL] = current address
	inx	h	;point to LO data byte
	mov	m,e	;Save LO byte
	rnc		;Only 1 data byte

twobyt	inx	h	;Point to HI byte
	mov	m,d	;Save it
	xra	a	;Clear C flag
	ret

asmerr1	pop	h	;clean up stack

asmerr2	call	beep
	lhld	scrpos	;Get current cursor position
	dcr	l
	mvi	h,1	;Set to column 1
	call	curpos	;Re-position it
	call	clreol
	lhld	scrpos
	dcr	l
	call	curpos
	jmp	asmbl	;Get another line

;===========================================================
;GET is used by the ASMBL routine to get a character pointed
;to by [HL], convert it to U/C, and check it.
;It will return with the character in [A], Z set if EOL,
;C set if a delimiter, and [HL] pointing to the next char
;in INBUF if not EOL.
;===========================================================

get	call	getuc	;Get next char and convert to U/C
	ora	a	;Is it end-of-line?
	rz		;Yes
	inx	h	;Point to next char
	cpi	comma	;Is it a comma?
	jz	getlim	;Yes
	cpi	spc	;Is it a space?
	jz	getlim	;Yes
	cpi	tab	;Is it a tab?
	rnz		;No

getlim	cpi	0ffh	;Ensure Z flag is clear,
	ret		;and C is set

;===========================================================
;DISASM this routine dis-assembles the code in memory.
;On entry ARG3 must contain the current address at which to
;start the process. On exit, ARG3 will point to the next
;address, OPERND will contain the immediate data,
;if there is no data, OPERND will contain $0000.
;OPLEN will contain the number of valid immediate data bytes
;(0, 1, or 2). JMPFLG will be 0 if this instruction does
;not modify the PC, or a 1 if a possible modification can
;occur.
;===========================================================

disasm	xra	a
	sta	jmpflg	;Clear the jump flag,
	sta	oplen	;and op-code length
	lxi	h,0
	shld	opernd	;Clear OPERND
	lhld	arg3	;Get current address
	push	h	;Save it for later
	xchg
	lxi	h,buf1
	call	itoasc	;Convert address to ASCII
	call	prtstr
	mvi	a,spc
	rst	4
	pop	h
	mov	a,m	;Get op-code
	push	psw
	call	prtbyt	;Print it
	pop	psw
	mov	e,a
	mvi	d,0
	mvi	a,6
	call	mul	;[DE] = index into table
	lxi	h,optbl
	dad	d	;HL now points to opcode mnemonic
	mov	a,m	;Get first byte of mnemonic
	inx	h	;Point to second character
	push	h	;Of mnemonic and save pointer
	push	psw	;Save first byte of mnemonic also
	rlc
	jnc	dskp1	;Check for jump status
	push	psw	;This is a jump type op-code
	mvi	a,1	;So set the jump flag
	sta	jmpflg
	pop	psw

dskp1	rlc
	jc	dskp10	;Check if more than 1 byte
	mvi	a,6
	call	spaces
	jmp	dskp2

dskp10	push	psw	;Yes, 2 or 3 byte op-code
	lxi	h,oplen
	inr	m	;Increment op-code length
	call	nxtadr	;Update address
	mov	c,m	;Get data byte
	mvi	b,0
	push	b	;Save current operand value
	pop	h
	shld	opernd	;Update operand
	push	h
	mov	a,c
	call	prtbyt	;Print first data byte
	pop	b	;Restore operand value
	pop	psw
	rlc
	jc	dskp11	;Check if a 2 byte op-code
	mvi	a,3
	call	spaces
	jmp	dskp2

dskp11	lxi	h,oplen ;Yes
	inr	m	;Update op-code length
	call	nxtadr	;Update address
	mov	b,m	;Get second byte
	push	b
	mov	a,b
	call	prtbyt	;Print second byte
	pop	h	;[HL] = operand
	shld	opernd	;[OPERND] = operand value

dskp2	call	nxtadr	;Update address
	pop	psw	;Get mnemonic saved earlier
	ani	01fh
	ori	040h	;[A] now contains character
	cpi	05fh	;Is it a masked "?" ?
	jnz	dskp3	;No
	mvi	a,'?'	;Yes

dskp3	rst	4	;Print first character
	mvi	d,3
	pop	h	;Finally get index into table

dskp4	mov	a,m
	rst	4
	inx	h
	dcr	d
	jnz	dskp4	;Print remainder of mnemonic
	mvi	a,spc	;Space
	rst	4
	mov	a,m	;Get first character of
	cpi	'$'	;Operand and check for a "$"
	jnz	dskp7

dskp9	rst	4	;Yes it is a "$"
	lhld	opernd	;Get operand value
	xchg		;Put in DE
	lxi	h,buf3	;[HL] = address of buf3
	lda	oplen	;Check operand length
	cpi	2	;Is it an integer?
	jnz	dskp5
	call	itoasc	;Yes

dskp6	call	prtstr	;Print it,
	jmp	dsexit	;and exit

dskp5	push	h	;No, it's a byte
	pop	b
	mov	a,e
	call	bytasc
	xra	a
	inx	b	;Put string delimiter in the
	stax	b	;Buffer
	jmp	dskp6	;Print it

dskp7	rst	4	;Print first byte
	inx	h	;Point to next byte,
	mov	a,m	;and get it,
	push	psw	;and save it
	ral		;See if we need a comma
	jnc	dskp8
	mvi	a,comma	;Yes, so print it
	rst	4

dskp8	pop	psw	;Retrieve character
	ani	07fh
	cpi	'$'	;Is it an immediate operand?
	jz	dskp9	;Yes
	rst	4	;No

dsexit	call	crlf	;Print new line
	ora	a	;Clear flags
	ret

;===========================================================
;NEXTADDRESS is used to update the address counter in
;the DISASM routine.
;===========================================================

nxtadr	lhld	arg3	;Get address
	inx	h	;Point to second byte
	shld	arg3	;Update address counter
	ret

;===========================================================
;PRINTBYTE prints the HEX value of the byte in [A] at the
;current cursor position.
;===========================================================

prtbyt	lxi	b,buf3	;Use BUF3
	push	b	;Save for later
	call	bytasc	;Convert to ASCII
	inx	b
	xra	a	;Put in terminator byte
	stax	b
	pop	h	;Get BUF3 address
	call	prtstr
	mvi	a,spc	;Space
	rst	4	;Print a space
	ret

;===========================================================
;SPACES prints the number of spaces contained in [A]
;===========================================================

spaces	push	b
	mov	b,a
	mvi	a,spc

spclop	rst	4
	dcr	b
	jnz	spclop
	pop	b
	ret

;===========================================================
;SEARCHSTRING routine. Used by the S and A commands.
;ARG1 = number of memory bytes to search
;ARG2 = current address to start search
;BUF1 = end of string address
;BUF2 = length of string
;BUF4 = temporary current number of chars to compare
;NMFLG = no match flag. Set if string found
;Returns with DE containing address of first character,
;and NMFLG set to 1. Carry set if end of range.
;===========================================================

schstr	xra	a
	sta	nmflg	;Clear no-match flag

srch0	lhld	buf1	;Get end of string address
	push	h
	pop	b	;[BC] = current string pointer
	lda	buf2
	sta	buf4	;BUF4 contains numchars left to search
	lhld	arg1
	xchg		;[DE] = numbytes left to scan
	lhld	arg2	;Current memory address to start scan

srch1	ldax	b	;Next character
	cmp	m
	jz	srch2
	call	nxtchr
	jc	schxit
	jmp	srch0

srch2	dcx	b	;Point to next char
	lda	buf4
	dcr	a
	sta	buf4	;Update number of bytes to compare
	jz	fndstr
	call	decmnt
	jc	schxit
	jmp	srch1

fndstr	push	h	;Save pointer
	call	nxtchr	;Update pointers
	pop	d	;Restore pointer
	mvi	a,1
	sta	nmflg	;Set no-match flag

schxit	ret

;===========================================================
;NEXTCHR decrements DE and HL and checks for underflow
;===========================================================

nxtchr	call	decmnt
	rc
	shld	arg2	;Update next start address
	xchg
	shld	arg1	;Update numbytes left to scan
	xchg
	ret

;===========================================================
;SAVE registers
;===========================================================

savreg	push	psw
	push	b
	push	d
	shld	pshl
	pop	h
	shld	psde
	pop	h
	shld	psbc
	pop	h
	shld	psaf
	lxi	h,2
	dad	sp
	shld	pssp
	ret

;===========================================================
;RESREG is used to restore the register contents. Used by
;the GO and WALK routines.
;===========================================================

resreg	lhld	psaf	;Get pseudo-AF register contents
	push	h
	pop	psw	;Restore to AF
	lhld	psbc	;Get pseudo-BC register contents
	push	h
	pop	b	;Restore to BC
	lhld	psde	;Get pseudo-DE register contents
	xchg		;Restore to DE
	lhld	pshl	;Restore pseudo-HL contents
	ret

;===========================================================
;DISPLAY REGISTERS used by the G, R, and W commands.
;===========================================================

dspreg	lxi	h,regmsg
	call	prtstr
	mvi	l,6
	lxi	b,pspc

dsplop	ldax	b
	mov	e,a
	inx	b
	ldax	b
	mov	d,a
	push	psw
	push	b
	push	d
	push	h
	lxi	h,buf1
	call	itoasc
	call	prtstr
	mvi	a,spc
	rst	4
	pop	h
	pop	d
	pop	b
	pop	psw
	inx	b
	dcr	l
	jnz	dsplop
	call	crlf
	ret

;===========================================================
;DECREMENT is used in the search routine to decrement the
;DE and HL register, and check if the DE register underflows.
;If an uderflow is detected, the routine returns with the
;carry set, otherwise it is clear.
;===========================================================

decmnt	mov	a,d
	ora	e
	jnz	decskp
	stc
	ret

decskp	dcx	d
	dcx	h
	xra	a	;Clear carry
	ret

;===========================================================
;SETUP sets up the buffers and arguments for the 'ENTER' and
;'SEARCH' commands
;===========================================================

setup	call	carg1	;Get command line argument
	rc		;Exit if error detected
	mvi	d,64	;Maximum length third argument
	lxi	b,arg3	;Point to string buffer

sloop	push	d	;save current count
	push	b	;save buffer pointer
	call	getnum	;Get a HEX number
	pop	b	;restore buffer pointer
	pop	d	;and count
	jc	sskip	;So it is not a number but a string
	stax	b	;Put number in buffer
	inx	b	;Point to next space in buffer
	dcr	d	;Decrement the numchars counter
	jnz	sloop	;Reached maxchars?

squit	mvi	a,64	;Have we got any characters?
	cmp	d
	rnz		;We entered some chars
	stc		;Something wrong with the string so
	ret		;Set error flag and return

;===========================================================
;We arrive here if instead of finding a valid pair of HEX
;digits, we discovered some invalid characters. We need to
;find out if these are delimiters or something else.
;===========================================================

sskip	cpi	quote	;Is character a quote delimiter?
	jz	scont	;Yes, so process the string
	cpi	':'	;Is it a command delimiter?
	jz	squit	;Yes, so exit
	ora	a	;Is it EOL?
	jz	squit	;Also a good reason to exit
	stc		;None of the above, so it is an
	ret		;Error

;===========================================================
;At this point we have found a valid string delimiter, so we
;can now go and collect the delimited ASCII characters.
;===========================================================

scont	call	getstr	;Get the characters
	rc		;EOL detected?
	xra	a	;Did we reach a delimiter or
	cmp	d	;Maximum line length?
	rz		;Reached maxchars
	jmp	sloop	;Simply found another delimiter

;===========================================================
;GETSTRING
;On entry, [HL] points to next character in input buffer
;          [BC] points to next slot in destination string
;           [D] contains maximum number of characters count
;exits when $00 encountered, or another delimiter is found,
;or when D=0. [HL] left pointing at last non-NUL byte.
;===========================================================

getstr	inx	h	;point to next character
	mov	a,m	;and get it
	ora	a	;EOL detected?
	jz	getout	;yes, so exit
	cpi	quote	;no, so is it the QUOTE symbol?
	jz	getxit	;yes, so just exit
	stax	b	;no, so still part of string
	inx	b	;point to next buffer location
	dcr	d	;decrement counter
	jnz	getstr	;and try again
	inx	h	;We have reached maxchars, now we
	mov	a,m	;need to know if the next char is a
	cpi	quote	;delimiter. If a delimiter, it is OK
	jz	getxit	;otherwise it is an error.

getout	dcx	h	;EOL detected, so point back to line
	stc		;set error flag

getxit	shld	bufptr	;save current INBUF pointer
	ret		;and exit

;===========================================================
;GET ARGUMENTS
;Scans I/P buffer for ASCII HEX arguments and places the
;values in the memory locations pointed to by BC. On entry,
;HL points to next character in I/P buffer. On exit, HL is
;left pointing to last character used.
;===========================================================

getnum	lhld	bufptr	;get current buffer position
	call	atoint
	jc	exit	;error, so leave character in [A]
	xra	a
	cmp	d	;is returned number valid?
	jc	exit	;no, too large for a byte
	mov	a,e	;yes, so return it,
	jmp	exit	;and exit

carg1	lxi	b,arg1
	jmp	getarg

carg2	lxi	b,arg2
	jmp	getarg

carg3	lxi	b,arg3

getarg	lhld	bufptr	;get buffer pointer
	call	atoint	;get a 16 bit unsigned number
	push	psw	;save character and status
	mov	a,e	;get LO byte
	stax	b	;and save it,
	inx	b	;point to HI byte position
	mov	a,d	;get HI byte,
	stax	b	;and save it
	pop	psw	;restore character and status

exit	shld	bufptr	;save buffer pointer
	ret		;and exit.

;===========================================================
;ASCII to Integer
;On entry [HL] points to last character used in I/P buffer.
;On exit, [DE] contains number.  If an error occured, the
;CARRY flag is set.  Errors would be too many digits causing
;an overflow, or no valid digits.  If an error occurs, [DE]
;is set to 0. Legal separator characters are SPACE and TAB.
;===========================================================

atoint	lxi	d,0	;set accumulated value to 0
	call	gtfirst	;skip delimiters and get first byte
	jnc	atoint4	;found a digit, so contiunue
	ora	a	;EOL detected?
	jnz	atoint3	;no, only illegal characters
	dcx	h	;yes, so point back to EOL byte

atoint3	stc		;set error flag,
	ret		;and exit

atoint4	call	cnvrt	;multiply [DE] by conversion base
	jc	atoint6	;an overflow error occured
	inx	h	;point to next digit
	call	atonibl	;attempt to convert to digit
	jnc	atoint4	;good digit, so add in value
	cpi	':'	;command delimiter?
	jz	atoint5	;yes
	cpi	comma	;this check is necessary for the R
	jz	atoint5	;command.
	ora	a	;EOL detected?
	jnz	atoint6	;no, only non-digits

atoint5	dcx	h	;yes, so adjust pointer

atoint6	rnc		;return if no errors,
	lxi	d,0	;else clear [DE] and return.
	ret

;============================================================
;CONVERT converts the digits to the correct base, 10 or 16
;============================================================

cnvrt	push	h	;save buffer pointer
	push	psw	;and [A]
	lda	base	;get conversion base
	call	mul
	xchg		;restore number to [HL]
	jnc	cnvrt1	;no overflow, so continue
	pop	psw	;clean up stack
	pop	h	;restore buffer pointer
	lxi	d,0
	stc
	ret

cnvrt1	pop	psw	;recover [A]
	mov	e,a	;make [A] a 16 bit number
	mvi	d,0
	dad	d	;and add in this digit
	xchg		;restore accumulated value to [DE]
	pop	h	;restore buffer pointer
	ret

;============================================================
;GETFIRST examines the input buffer, skips delimiters, and
;attempts to get the first digit.  If an invalid byte is
;found, the C flag is set, and the actual byte discovered is
;returned in [A].  If the C flag is clear, the nibble is in
;[A].  The calling routine must check for EOL.
;============================================================

gtfirst	call	skpdlim	;skip valid delimiters

;===========================================================
;ASCII to Nibble
;[HL] points to character, and returns with value in [A]
;and carry clear if valid, or character in [A] and carry set
;if invalid. [HL] is undisturbed.
;===========================================================

atonibl	call	getuc	;Get char and convert to U/C

atonib1	cpi	'0'	;is digit > ASCII 0 ?
	rc		;No, so it is not a digit
	cpi	':'	;Is digit in range ASCII 0 - 9 ?
	jnc	alpha	;No, so convert from A - F
	sui	'0'	;Yes, so just ASCII conversion
	ret

alpha	push	psw	;save digit
	lda	base	;get current conversion base
	cpi	16	;is current base HEX?
	jz	is_hex	;yes, so continue
	pop	psw	;no, so this is an invalid
	stc		;digit for DECIMAL base
	ret

is_hex	pop	psw
	cpi	'A'
	rc		;Not a digit
	cpi	'G'
	jc	digit
	stc
	ret

digit	sui	55
	ret

;===========================================================
;SKPDLIM will skip valid delimiters
;===========================================================

skpdlim	inx	h	;point to next character in buffer

skpdlm1	call	chkchr	;get character and skip spaces
	jz	skpdlm1
	cpi	tab	;is character a TAB?
	jz	skpdlim	;yes, so skip it also
	ret

;===========================================================
;Integer to ASCII
;On entry [HL] points to 5 byte buffer [DE] contains number.
;[HL] is preserved.
;===========================================================

itoasc	push	h
	pop	b
	mov	a,d
	call	bytasc
	inx	b
	mov	a,e
	call	bytasc
	xra	a
	inx	b
	stax	b
	ret

;===========================================================
;Byte to ASCII
;[BC] contains address of 2 byte buffer, [A] contains number
;on exit, [BC] points to second byte.
;===========================================================

bytasc	push	psw
	rrc
	rrc
	rrc
	rrc
	call	ntoa
	inx	b
	pop	psw

;===========================================================
;Nibble to ASCII
;[BC] contains address of buffer, [A] contains nibble in
;bits 0-3.
;===========================================================

ntoa	ani	00fh	;Mask any high order bits
	adi	'0'
	cpi	':'
	jc	num
	adi	7

num	stax	b
	ret

;===========================================================
;RPRINT/PRINT prints either in reverse video (RPRINT) or
;normal (PRINT) [HL] points to string to print, [A] contains
;column number.
;===========================================================

rprint	push	psw
	call	revon
	pop	psw

print	push	h
	lhld	scrpos
	mov	h,a
	call	curpos
	pop	h
	call	prtstr
	call	revoff
	mvi	a,spc
	rst	4
	ret

;===========================================================
;BINARY prints the 16 bit binary equivalent of the [HL]
;register at the current cursor location.
;===========================================================

binary	mvi	c,2

bin0	mvi	e,2
	mov	a,h

bin1	mvi	d,4

bin2	rlc
	push	psw
	jc	one
	mvi	a,'0'
	jmp	zero

one	mvi	a,'1'

zero	rst	4
	pop	psw
	dcr	d
	jnz	bin2
	push	psw
	mvi	a,spc	;Space
	rst	4
	pop	psw
	dcr	e
	jnz	bin1
	mvi	a,spc	;Space
	rst	4
	mov	h,l
	dcr	c
	jnz	bin0
	ret

;===========================================================
;MAKELIN makes a line for the DUMP command.
;On entry, [BC] = address of string buffer
;          [DE] = address of memory to dump
;===========================================================

maklin	lxi	h,buf3	;point to string buffer
	call	itoasc	;put current address in buffer,
	mvi	a,spc
	stax	b	;and a space
	inx	b	;point to next buffer location
	mvi	l,8	;loop counter

mkloop	ldax	d	;get byte from memory
	call	bytasc	;convert to ASCII and put in buffer
	inx	b	;point to next buffer location
	mvi	a,spc	;and stash a space
	stax	b
	inx	b	;point to next location
	inx	d	;point to next memory location
	dcr	l	;decrement loop counter
	jnz	mkloop	;and continue
	xra	a	;and finally put a NUL byte
	stax	b	;in string buffer
	ret		;and quit

;===========================================================
;PUTLIN puts a line of memory dump
;[DE] contains address.
;===========================================================

putlin	push	d	;Save current address
	call	maklin
	lxi	h,buf3
	call	prtstr
	pop	h
	push	d
	mvi	b,8
	call	prtasc
	call	crlf
	pop	d
	ret

;===========================================================
;SUBTRACT subtracts [DE] from [HL] and puts answer in [DE]
;[DE] = [HL] - [DE]
;===========================================================

sub	mov	a,l
	sub	e
	mov	e,a
	mov	a,h
	sbb	d
	mov	d,a
	ret

;===========================================================
;SWAP exchanges ARG1 and ARG2 if ARG2 < ARG1.
;===========================================================

swap	lhld	arg2
	xchg
	lhld	arg1
	rst	3	;Compare [HL] and [DE]
	rz		;HL = DE
	rc		;HL < DE
	xchg
	shld	arg1
	xchg
	shld	arg2
	xchg
	ret

;===========================================================
;DIV divides the [DE] register by the contents of the
;[A] register, and returns the result in the [DE] register.
;This repeated subtraction method is used in preference to
;more conventional methods to minimise the size of the
;object file. Speed is a secondary consideration in this
;case.
;[DE] = [DE] / [A]
;===========================================================

div	xchg
	lxi	b,0
	sui	1
	cma
	mov	e,a
	mvi	d,0ffh

divlp	dad	d
	jnc	divskp
	inx	b
	jmp	divlp

divskp	mov	e,c
	mov	d,b
	ret

;===========================================================
;MULTIPLY the contents of the [DE] register by the contents
;of the A register, and returns the result in the [DE]
;register. This repeated addition multiply routine is used
;in preference to the more conventional shift and add type
;in order to save object file space. This routine uses only
;15 bytes of memory, versus 29 that would be required for a
;conventional routine. In this case, speed is a secondary
;consideration.
;[DE] = [DE] * [A]
;===========================================================

mul	lxi	h,0
	ora	a
	jz	mulxit

muloop	dad	d
	dcr	a
	jnz	muloop

mulxit	xchg
	ret

;===========================================================
;KEYCHECK is used in the D, S, U, and V  commands to check
;if an ABORT (ENTER) or PAUSE (ALPHA) key has been pressed.
;===========================================================

keychk	push	psw
	push	b
	push	d
	push	h
	call	keyx	;Check keyboard queue
	jnz	kychk1	;Check for BREAK/PAUSE
	lda	prtflg
	ora	a	;Is screen selected?
	jnz	k_exit	;No, so exit
	call	scrchk	;Yes, so check for screen over-run
	jmp	k_exit

kychk1	call	chrget	;Get the character
	cpi	cr	;Is it ENTER?
	jz	k_quit	;Yes
	call	hold

k_exit	pop	h
	pop	d
	pop	b
	pop	psw
	ret

k_quit	pop	h
	pop	d
	pop	b
	pop	psw
	stc
	ret

;===========================================================
;SCREENCHECK checks if we have reached the end of the
;defined screen.
;===========================================================

scrchk	lda	scrtmp
	dcr	a
	jz	schk1
	sta	scrtmp
	ret

schk1	call	hold
	lda	scrlen
	sta	scrtmp
	ret

;===========================================================
;HOLD displays the PAUSE message, and waits for a SPACE
;===========================================================

hold	xra	a	;reset printer flag
	sta	prtflg
	lxi	h,wmsg	;Display PAUSE message
	call	prtstr
	call	pause
	call	crlf
	lda	scrflg	;restore printer flag
	sta	prtflg
	ret

;==========================================================
;Start of Command Execution Table
;Table consists of 17 entries each coded thus:-

;  <command letter><execution address>

;==========================================================

cmdtbl	db	'A'
	dw	assmbl
	db	'B'
	dw	brkpt
	db	'C'
	dw	calc
	db	'D'
	dw	dsply
	db	'E'
	dw	enter
	db	'F'
	dw	fill
	db	'G'
	dw	go
	db	'H'
	dw	hexdec
	db	'L'
	dw	length
	db	'M'
	dw	move
	db	'P'
	dw	prtr
	db	'Q'
	dw	quit
	db	'R'
	dw	regs
	db	'S'
	dw	search
	db	'U'
	dw	unassm
	db	'V'
	dw	verify
	db	'W'
	dw	walk
	db	'X'
	dw	xpand

;====================================================================
;Mnemonic Op-Code Table, in coded form. Used by the ASSEMBLE and
;UNASSEMBLE commands.  The table entries are 6 bytes in length, and
;are coded as follows:-

;	BYTE	CONTENTS
;	________________

;	1	coded first op-code letter
;	2	U/C second op-code letter
;	3	U/C third op-code letter or space
;	4	U/C fourth op-code letter or space
;	5	U/C first operand field letter or space
;	6	coded second operand field letter or space

;Byte 1 coding is as follows:-

;	BIT	FUNCTION
;	________________

;	7	PC modifier flag
;	6-5	Op-Code length descriptor
;	4-0	U/C ASCII char with bit 5 set to '0'

;PC modifier bit is set to '1' if op-code can modify PC.
;The JMP, CALL, RET, PCHL, and conditional JMP, CALL and RET
;instructions fall into this class. Used by WALK command.

;Op-Code length descriptor bits are set as follows:-

;	6  5	LENGTH
;	_________________

;	0  0	1 byte
;	1  0	2 bytes
;	1  1	3 bytes

;Operand Field byte coding is:-

;	BIT	FUNCTION
;	________________

;	7	comma flag
;	6-0	U/C ASCII char

;Comma flag is set to '1' if this character is preceded by a
;comma.

;As an example of the coding, consider the the following:-

;NOP is coded as:    0E 4F 50 20 20 20
;MOV A,B             0D 4F 56 20 41 C2   C2 B is preceded by a comma
;MVI A,$<data>       4D 56 49 20 41 A4   A4 $ is preceded by a comma
;LXI H,$<data><data> 6C 58 49 20 48 A4
;RET                 92 45 54 20 20 20   92 this is a PC modifier
;JMP $<data><data>   EA 4D 50 20 24 20   EA this is a PC modifier
;====================================================================

;                              TABLE        MNEMONIC           HEX
;====================================================================

optbl   db	00Eh,04Fh,050h,020h,020h,020h ;NOP		00
	db	06Ch,058h,049h,020h,042h,0A4h ;LXI  B,$nnnn	01
	db	013h,054h,041h,058h,042h,020h ;STAX B		02
	db	009h,04Eh,058h,020h,042h,020h ;INX		03
	db	009h,04Eh,052h,020h,042h,020h ;INR  B		04
	db	004h,043h,052h,020h,042h,020h ;DCR  B		05
	db	04Dh,056h,049h,020h,042h,0A4h ;MVI  B,$nn	06
	db	012h,04Ch,043h,020h,020h,020h ;RLC		07
	db	004h,053h,055h,042h,042h,020h ;DSUB B	*	08
	db	004h,041h,044h,020h,042h,020h ;DAD  B		09
	db	00Ch,044h,041h,058h,042h,020h ;LDAX B		0A
	db	004h,043h,058h,020h,042h,020h ;DCX  B		0B
	db	009h,04Eh,052h,020h,043h,020h ;INR  C		0C
	db	004h,043h,052h,020h,043h,020h ;DCR  C		0D
	db	04Dh,056h,049h,020h,043h,0A4h ;MVI  C,$nn	0E
	db	012h,052h,043h,020h,020h,020h ;RRC		0F
	db	012h,048h,052h,020h,020h,020h ;RHR	*	10
	db	06Ch,058h,049h,020h,044h,0A4h ;LXI  D,$nnnn	11
	db	013h,054h,041h,058h,044h,020h ;STAX D		12
	db	009h,04Eh,058h,020h,044h,020h ;INX  D		13
	db	009h,04Eh,052h,020h,044h,020h ;INR  D		14
	db	004h,043h,052h,020h,044h,020h ;DCR  D		15
	db	04Dh,056h,049h,020h,044h,0A4h ;MVI  D		16
	db	012h,041h,04Ch,020h,020h,020h ;RAL		17
	db	012h,044h,04Ch,020h,020h,020h ;RDL	*	18
	db	004h,041h,044h,020h,044h,020h ;DAD  D		19
	db	00Ch,044h,041h,058h,044h,020h ;LDAX D		1A
	db	004h,043h,058h,020h,044h,020h ;DCX  D		1B
	db	009h,04Eh,052h,020h,045h,020h ;INR  E		1C
	db	004h,043h,052h,020h,045h,020h ;DCR  E		1D
	db	04Dh,056h,049h,020h,045h,0A4h ;MVI  E,$nn	1E
	db	012h,041h,052h,020h,020h,020h ;RAR		1F
	db	012h,049h,04Dh,020h,020h,020h ;RIM		20
	db	06Ch,058h,049h,020h,048h,0A4h ;LXI  H,$nnnn	21
	db	073h,048h,04Ch,044h,024h,020h ;SHLD		22
	db	009h,04Eh,058h,020h,048h,020h ;INX  H		23
	db	009h,04Eh,052h,020h,048h,020h ;INR  H		24
	db	004h,043h,052h,020h,048h,020h ;DCR  H		25
	db	04Dh,056h,049h,020h,048h,0A4h ;MVI  H,$nn	26
	db	004h,041h,041h,020h,020h,020h ;DAA		27
	db	044h,04Dh,04Fh,056h,048h,0A4h ;DMOV H,$nn *	28
	db	004h,041h,044h,020h,048h,020h ;DAD  H		29
	db	06Ch,048h,04Ch,044h,024h,020h ;LHLD		2A
	db	004h,043h,058h,020h,048h,020h ;DCX  H		2B
	db	009h,04Eh,052h,020h,04Ch,020h ;INR  L		2C
	db	004h,043h,052h,020h,04Ch,020h ;DCR  L		2D
	db	04Dh,056h,049h,020h,04Ch,0A4h ;MVI  L,$nn	2E
	db	003h,04Dh,041h,020h,020h,020h ;CMA		2F
	db	013h,049h,04Dh,020h,020h,020h ;SIM		30
	db	06Ch,058h,049h,020h,053h,0A4h ;LXI  S,$nnnn	31
	db	073h,054h,041h,020h,024h,020h ;STA		32
	db	009h,04Eh,058h,020h,053h,050h ;INX  SP		33
	db	009h,04Eh,052h,020h,04Dh,020h ;INR  M		34
	db	004h,043h,052h,020h,04Dh,020h ;DCR  M		35
	db	04Dh,056h,049h,020h,04Dh,0A4h ;MVI  M,$nn	36
	db	013h,054h,043h,020h,020h,020h ;STC		37
	db	044h,04Dh,04Fh,056h,053h,0A4h ;DMOV S,$nn  *	38
	db	004h,041h,044h,020h,053h,050h ;DAD  SP		39
	db	06Ch,044h,041h,020h,024h,020h ;LDA		3A
	db	004h,043h,058h,020h,053h,050h ;DCX  SP		3B
	db	009h,04Eh,052h,020h,041h,020h ;INR  A		3C
	db	004h,043h,052h,020h,041h,020h ;DCR  A		3D
	db	04Dh,056h,049h,020h,041h,0A4h ;MVI  A,$nn	3E
	db	003h,04Dh,043h,020h,020h,020h ;CMC		3F
	db	00Dh,04Fh,056h,020h,042h,0C2h ;MOV  B,B		40
	db	00Dh,04Fh,056h,020h,042h,0C3h ;MOV  B,C		41
	db	00Dh,04Fh,056h,020h,042h,0C4h ;MOV  B,D		42
	db	00Dh,04Fh,056h,020h,042h,0C5h ;MOV  B,E		43
	db	00Dh,04Fh,056h,020h,042h,0C8h ;MOV  B,H		44
	db	00Dh,04Fh,056h,020h,042h,0CCh ;MOV  B,L		45
	db	00Dh,04Fh,056h,020h,042h,0CDh ;MOV  B,M		46
	db	00Dh,04Fh,056h,020h,042h,0C1h ;MOV  B,A		47
	db	00Dh,04Fh,056h,020h,043h,0C2h ;MOV  C,B		48
	db	00Dh,04Fh,056h,020h,043h,0C3h ;MOV  C,C		49
	db	00Dh,04Fh,056h,020h,043h,0C4h ;MOV  C,D		4A
	db	00Dh,04Fh,056h,020h,043h,0C5h ;MOV  C,E		4B
	db	00Dh,04Fh,056h,020h,043h,0C8h ;MOV  C,H		4C
	db	00Dh,04Fh,056h,020h,043h,0CCh ;MOV  C,L		4D
	db	00Dh,04Fh,056h,020h,043h,0CDh ;MOV  C,M		4E
	db	00Dh,04Fh,056h,020h,043h,0C1h ;MOV  C,A		4F
	db	00Dh,04Fh,056h,020h,044h,0C2h ;MOV  D,B		50
	db	00Dh,04Fh,056h,020h,044h,0C3h ;MOV  D,C		51
	db	00Dh,04Fh,056h,020h,044h,0C4h ;MOV  D,D		52
	db	00Dh,04Fh,056h,020h,044h,0C5h ;MOV  D,E		53
	db	00Dh,04Fh,056h,020h,044h,0C8h ;MOV  D,H		54
	db	00Dh,04Fh,056h,020h,044h,0CCh ;MOV  D,L		55
	db	00Dh,04Fh,056h,020h,044h,0CDh ;MOV  D,M		56
	db	00Dh,04Fh,056h,020h,044h,0C1h ;MOV  D,A		57
	db	00Dh,04Fh,056h,020h,045h,0C2h ;MOV  E,B		58
	db	00Dh,04Fh,056h,020h,045h,0C3h ;MOV  E,C		59
	db	00Dh,04Fh,056h,020h,045h,0C4h ;MOV  E,D		5A
	db	00Dh,04Fh,056h,020h,045h,0C5h ;MOV  E,E		5B
	db	00Dh,04Fh,056h,020h,045h,0C8h ;MOV  E,H		5C
	db	00Dh,04Fh,056h,020h,045h,0CCh ;MOV  E,L		5D
	db	00Dh,04Fh,056h,020h,045h,0CDh ;MOV  E,M		5E
	db	00Dh,04Fh,056h,020h,045h,0C1h ;MOV  E,A		5F
	db	00Dh,04Fh,056h,020h,048h,0C2h ;MOV  H,B		60
	db	00Dh,04Fh,056h,020h,048h,0C3h ;MOV  H,C		61
	db	00Dh,04Fh,056h,020h,048h,0C4h ;MOV  H,D		62
	db	00Dh,04Fh,056h,020h,048h,0C5h ;MOV  H,E		63
	db	00Dh,04Fh,056h,020h,048h,0C8h ;MOV  H,H		64
	db	00Dh,04Fh,056h,020h,048h,0CCh ;MOV  H,L		65
	db	00Dh,04Fh,056h,020h,048h,0CDh ;MOV  H,M		66
	db	00Dh,04Fh,056h,020h,048h,0C1h ;MOV  H,A		67
	db	00Dh,04Fh,056h,020h,04Ch,0C2h ;MOV  L,B		68
	db	00Dh,04Fh,056h,020h,04Ch,0C3h ;MOV  L,C		69
	db	00Dh,04Fh,056h,020h,04Ch,0C4h ;MOV  L,D		6A
	db	00Dh,04Fh,056h,020h,04Ch,0C5h ;MOV  L,E		6B
	db	00Dh,04Fh,056h,020h,04Ch,0C8h ;MOV  L,H		6C
	db	00Dh,04Fh,056h,020h,04Ch,0CCh ;MOV  L,L		6D
	db	00Dh,04Fh,056h,020h,04Ch,0CDh ;MOV  L,M		6E
	db	00Dh,04Fh,056h,020h,04Ch,0C1h ;MOV  L,A		6F
	db	00Dh,04Fh,056h,020h,04Dh,0C2h ;MOV  M,B		70
	db	00Dh,04Fh,056h,020h,04Dh,0C3h ;MOV  M,C		71
	db	00Dh,04Fh,056h,020h,04Dh,0C4h ;MOV  M,D		72
	db	00Dh,04Fh,056h,020h,04Dh,0C5h ;MOV  M,E		73
	db	00Dh,04Fh,056h,020h,04Dh,0C8h ;MOV  M,H		74
	db	00Dh,04Fh,056h,020h,04Dh,0CCh ;MOV  M,L		75
	db	008h,04Ch,054h,020h,020h,020h ;HLT		76
	db	00Dh,04Fh,056h,020h,04Dh,0C1h ;MOV  M,A		77
	db	00Dh,04Fh,056h,020h,041h,0C2h ;MOV  A,B		78
	db	00Dh,04Fh,056h,020h,041h,0C3h ;MOV  A,C		79
	db	00Dh,04Fh,056h,020h,041h,0C4h ;MOV  A,D		7A
	db	00Dh,04Fh,056h,020h,041h,0C5h ;MOV  A,E		7B
	db	00Dh,04Fh,056h,020h,041h,0C8h ;MOV  A,H		7C
	db	00Dh,04Fh,056h,020h,041h,0CCh ;MOV  A,L		7D
	db	00Dh,04Fh,056h,020h,041h,0CDh ;MOV  A,M		7E
	db	00Dh,04Fh,056h,020h,041h,0C1h ;MOV  A,A		7F
	db	001h,044h,044h,020h,042h,020h ;ADD  B		80
	db	001h,044h,044h,020h,043h,020h ;ADD  C		81
	db	001h,044h,044h,020h,044h,020h ;ADD  D		82
	db	001h,044h,044h,020h,045h,020h ;ADD  E		83
	db	001h,044h,044h,020h,048h,020h ;ADD  H		84
	db	001h,044h,044h,020h,04Ch,020h ;ADD  L		85
	db	001h,044h,044h,020h,04Dh,020h ;ADD  M		86
	db	001h,044h,044h,020h,041h,020h ;ADD  A		87
	db	001h,044h,043h,020h,042h,020h ;ADC  B		88
	db	001h,044h,043h,020h,043h,020h ;ADC  C		89
	db	001h,044h,043h,020h,044h,020h ;ADC  D		8A
	db	001h,044h,043h,020h,045h,020h ;ADC  E		8B
	db	001h,044h,043h,020h,048h,020h ;ADC  H		8C
	db	001h,044h,043h,020h,04Ch,020h ;ADC  L		8D
	db	001h,044h,043h,020h,04Dh,020h ;ADC  M		8E
	db	001h,044h,043h,020h,041h,020h ;ADC  A		8F
	db	013h,055h,042h,020h,042h,020h ;SUB  B		90
	db	013h,055h,042h,020h,043h,020h ;SUB  C		91
	db	013h,055h,042h,020h,044h,020h ;SUB  D		92
	db	013h,055h,042h,020h,045h,020h ;SUB  E		93
	db	013h,055h,042h,020h,048h,020h ;SUB  H		94
	db	013h,055h,042h,020h,04Ch,020h ;SUB  L		95
	db	013h,055h,042h,020h,04Dh,020h ;SUB  M		96
	db	013h,055h,042h,020h,041h,020h ;SUB  A		97
	db	013h,042h,042h,020h,042h,020h ;SBB  B		98
	db	013h,042h,042h,020h,043h,020h ;SBB  C		99
	db	013h,042h,042h,020h,044h,020h ;SBB  D		9A
	db	013h,042h,042h,020h,045h,020h ;SBB  E		9B
	db	013h,042h,042h,020h,048h,020h ;SBB  H		9C
	db	013h,042h,042h,020h,04Ch,020h ;SBB  L		9D
	db	013h,042h,042h,020h,04Dh,020h ;SBB  M		9E
	db	013h,042h,042h,020h,041h,020h ;SBB  A		9F
	db	001h,04Eh,041h,020h,042h,020h ;ANA  B		A0
	db	001h,04Eh,041h,020h,043h,020h ;ANA  C		A1
	db	001h,04Eh,041h,020h,044h,020h ;ANA  D		A2
	db	001h,04Eh,041h,020h,045h,020h ;ANA  E		A3
	db	001h,04Eh,041h,020h,048h,020h ;ANA  H		A4
	db	001h,04Eh,041h,020h,04Ch,020h ;ANA  L		A5
	db	001h,04Eh,041h,020h,04Dh,020h ;ANA  M		A6
	db	001h,04Eh,041h,020h,041h,020h ;ANA  A		A7
	db	018h,052h,041h,020h,042h,020h ;XRA  B		A8
	db	018h,052h,041h,020h,043h,020h ;XRA  C		A9
	db	018h,052h,041h,020h,044h,020h ;XRA  D		AA
	db	018h,052h,041h,020h,045h,020h ;XRA  E		AB
	db	018h,052h,041h,020h,048h,020h ;XRA  H		AC
	db	018h,052h,041h,020h,04Ch,020h ;XRA  L		AD
	db	018h,052h,041h,020h,04Dh,020h ;XRA  M		AE
	db	018h,052h,041h,020h,041h,020h ;XRA  A		AF
	db	00Fh,052h,041h,020h,042h,020h ;ORA  B		B0
	db	00Fh,052h,041h,020h,043h,020h ;ORA  C		B1
	db	00Fh,052h,041h,020h,044h,020h ;ORA  D		B2
	db	00Fh,052h,041h,020h,045h,020h ;ORA  E		B3
	db	00Fh,052h,041h,020h,048h,020h ;ORA  H		B4
	db	00Fh,052h,041h,020h,04Ch,020h ;ORA  L		B5
	db	00Fh,052h,041h,020h,04Dh,020h ;ORA  M		B6
	db	00Fh,052h,041h,020h,041h,020h ;ORA  A		B7
	db	003h,04Dh,050h,020h,042h,020h ;CMP  B		B8
	db	003h,04Dh,050h,020h,043h,020h ;CMP  C		B9
	db	003h,04Dh,050h,020h,044h,020h ;CMP  D		BA
	db	003h,04Dh,050h,020h,045h,020h ;CMP  E		BB
	db	003h,04Dh,050h,020h,048h,020h ;CMP  H		BC
	db	003h,04Dh,050h,020h,04Ch,020h ;CMP  L		BD
	db	003h,04Dh,050h,020h,04Dh,020h ;CMP  M		BE
	db	003h,04Dh,050h,020h,041h,020h ;CMP  A		BF
	db	092h,04Eh,05Ah,020h,020h,020h ;RNZ		C0
	db	010h,04Fh,050h,020h,042h,020h ;POP  B		C1
	db	0EAh,04Eh,05Ah,020h,024h,020h ;JNZ  $nnnn	C2
	db	0EAh,04Dh,050h,020h,024h,020h ;JMP  $nnnn	C3
	db	0E3h,04Eh,05Ah,020h,024h,020h ;CNZ  $nnnn	C4
	db	010h,055h,053h,048h,042h,020h ;PUSH B		C5
	db	041h,044h,049h,020h,024h,020h ;ADI  $nn		C6
	db	092h,053h,054h,020h,030h,020h ;RST  0		C7
	db	092h,05Ah,020h,020h,020h,020h ;RZ		C8
	db	092h,045h,054h,020h,020h,020h ;RET		C9
	db	0EAh,05Ah,020h,020h,024h,020h ;JZ   $nnnn	CA
	db	01Fh,03Fh,03Fh,020h,020h,020h ;??? Invalid  *	CB
	db	0E3h,05Ah,020h,020h,024h,020h ;CZ   $nnnn	CC
	db	0E3h,041h,04Ch,04Ch,024h,020h ;CALL $nnnn	CD
	db	041h,043h,049h,020h,024h,020h ;ACI  $nn		CE
	db	092h,053h,054h,020h,031h,020h ;RST  1		CF
	db	092h,04Eh,043h,020h,020h,020h ;RNC		D0
	db	010h,04Fh,050h,020h,044h,020h ;POP  D		D1
	db	0EAh,04Eh,043h,020h,024h,020h ;JNC  $nnnn	D2
	db	04Fh,055h,054h,020h,024h,020h ;OUT  $nn		D3
	db	0E3h,04Eh,043h,020h,024h,020h ;CNC  $nnnn	D4
	db	010h,055h,053h,048h,044h,020h ;PUSH D		D5
	db	053h,055h,049h,020h,024h,020h ;SUI  $nn		D6
	db	092h,053h,054h,020h,032h,020h ;RST  2		D7
	db	092h,043h,020h,020h,020h,020h ;RC		D8
	db	013h,048h,04Ch,058h,020h,020h ;SHLX	*	D9
	db	0EAh,043h,020h,020h,024h,020h ;JC   $nnnn	DA
	db	049h,04Eh,020h,020h,024h,020h ;IN   $nn		DB
	db	0E3h,043h,020h,020h,024h,020h ;CC   $nnnn	DC
	db	0EAh,04Eh,044h,020h,024h,020h ;JND  $nnnn *	DD
	db	053h,042h,049h,020h,024h,020h ;SBI  $nn		DE
	db	092h,053h,054h,020h,033h,020h ;RST  3		DF
	db	092h,050h,04Fh,020h,020h,020h ;RPO		E0
	db	010h,04Fh,050h,020h,048h,020h ;POP  H		E1
	db	0EAh,050h,04Fh,020h,024h,020h ;JPO  $nnnn	E2
	db	018h,054h,048h,04Ch,020h,020h ;XTHL		E3
	db	0E3h,050h,04Fh,020h,024h,020h ;CPO  $nnnn	E4
	db	010h,055h,053h,048h,048h,020h ;PUSH H		E5
	db	041h,04Eh,049h,020h,024h,020h ;ANI  $nn		E6
	db	092h,053h,054h,020h,034h,020h ;RST  4		E7
	db	092h,050h,045h,020h,020h,020h ;RPE		E8
	db	090h,043h,048h,04Ch,020h,020h ;PCHL		E9
	db	0EAh,050h,045h,020h,024h,020h ;JPE  $nnnn	EA
	db	018h,043h,048h,047h,020h,020h ;XCHG		EB
	db	0E3h,050h,045h,020h,024h,020h ;CPE  $nnnn	EC
	db	00Ch,048h,04Ch,058h,020h,020h ;LHLX	*	ED
	db	058h,052h,049h,020h,024h,020h ;XRI  $nn		EE
	db	092h,053h,054h,020h,035h,020h ;RST  5		EF
	db	092h,050h,020h,020h,020h,020h ;RP		F0
	db	010h,04Fh,050h,020h,041h,046h ;POP  AF		F1
	db	0EAh,050h,020h,020h,024h,020h ;JP   $nnnn	F2
	db	004h,049h,020h,020h,020h,020h ;DI		F3
	db	0E3h,050h,020h,020h,024h,020h ;CP   $nnnn	F4
	db	010h,055h,053h,048h,041h,046h ;PUSH AF		F5
	db	04Fh,052h,049h,020h,024h,020h ;ORI  $nn		F6
	db	092h,053h,054h,020h,036h,020h ;RST  6		F7
	db	092h,04Dh,020h,020h,020h,020h ;RM		F8
	db	013h,050h,048h,04Ch,020h,020h ;SPHL		F9
	db	0EAh,04Dh,020h,020h,024h,020h ;JM   $nnnn	FA
	db	005h,049h,020h,020h,020h,020h ;EI		FB
	db	0E3h,04Dh,020h,020h,024h,020h ;CM   $nnnn	FC
	db	0EAh,044h,020h,020h,024h,020h ;JD   $nnnn *	FD
	db	043h,050h,049h,020h,024h,020h ;CPI  $nn		FE
	db	092h,053h,054h,020h,037h,020h ;RST  7		FF

;===========================================================
;Standard Messages
;===========================================================

cpyrt	db	cr,lf,tab,'     TRS-80 MODEL 100'
	db	cr,lf,tab,'     DEBUG  Ver: 4.13'
	db	cr,lf,tab,'     A.Ryan 14-JUN-90'
	db	cr,lf,0

lmsg1	db	'Screen length: '
	db	0

lmsg2	db	' lines',cr,lf
	db	0

mmsg	db	' Done',cr,lf
	db	0

pmsg1	db	' D/S/U/V re-directed to '
	db	0

pmsg2	db	'screen.',cr,lf
	db	0

pmsg3	db	'printer.',cr,lf
	db	0

wmsg	db	'Press SPACE to continue...'
	db	0

flgmsg	db	'SZdA PvC',cr,lf
	db	0

regmsg	db	' PC   AF   BC   DE   HL   SP',cr,lf
	db	0

bmsg1	db	'Breakpoint '
	db	0

bmsg2	db	'cleared',cr,lf
	db	0

bmsg3	db	'set',cr,lf
	db	0

bmsg4	db	'reached',cr,lf
	db	0

bmsg5	db	'Illegal Address!',cr,lf
	db	0

;===========================================================
;Pseudo-registers
;These memory locations are used to store the machine
;register contents
;===========================================================

pspc	dw	0
psaf	dw	0
psbc	dw	0
psde	dw	0
pshl	dw	0
pssp	dw	0

;===========================================================
;Flags and Buffer Area
;===========================================================

scrflg	db	0	;Flag 0 = Screen 1 = Printer
scrlen	db	7	;Current Length of screen
scrtmp	db	7	;Temporary storage for SCRLEN
bufptr	dw	inbuf-1	;Current INBUF pointer

;===========================================================
;These variables and flags do not need to be initialised,
;and thus do not need to be saved with the .CO file in
;memory.  The CONFIG program has to have the highest address
;set to include only the last code bytes.
;===========================================================

base	equ	$		;Flag 16 = HEX  10 = DEC
nmflg	equ	base+1		;Flag 0 = No Match 1 = Match
jmpflg	equ	nmflg+1		;Flag 0 = No Jump  1 = Jump
bpflg	equ	jmpflg+1	;Flag 0 = BP Clear 1 BP Set
oplen	equ	bpflg+1		;Length of mnemonic OP code
opernd	equ	oplen+1		;Value of OPERAND
arg1	equ	opernd+2	;Command Argument 1 Value
arg2	equ	arg1+2		;Command Argument 2 Value
arg3	equ	arg2+2		;Command Arg 3/String Buffer
buf1	equ	arg3+65		;Internal Buffer #1
buf2	equ	buf1+5		;Internal Buffer #2
buf3	equ	buf2+5		;Internal Buffer #3
buf4	equ	buf3+41		;Internal Buffer #4
bpbufr	equ	buf4+5		;Buffer for code replaced by BP
bpaddr	equ	bpbufr+3	;Address of replaced code

	end	entrpt
