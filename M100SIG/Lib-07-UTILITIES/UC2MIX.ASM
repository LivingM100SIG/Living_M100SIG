;UC2MIX.ASM -- Source Code UC2MIX.CO
;a version of MIX-IT.BA which
;runs in the Alt LCD buffer and is 
;self-contained
;
;Phil Wheeler -- 71266,125
; 8/2/87

;Concept based on 2MIXED.COM for PC's -- by Eric Grunin
;Logic and 8085 code original, with some front-end code
;from Rick Perry's SORT.ASM
;
;ROM Adresses
;
chkdc	equ	$5AAB	; lookup file in RAM Dir
gtxttb	equ	$5AE3	; get pointer to start of file
cls	equ	$4231	; clear screen
upcase	equ	$0FE8	; convert (M) to uppercase
buf	equ	$F685	; start of LINE INPUT buffer
PRTMSG	EQU	$5791	;msg to lcd on new line
WAITSP	EQU	$5F2F	;wait for press and rtn
LINEIN	EQU	$4644	;input line from kbd
MENU	EQU	$5797	;back to M100 menu
BEEP	EQU	$7662	;oops!
FILES	EQU	$1F3A	;display files
CRLF	EQU	$4222	;make a blank line
;
	ORG	64704	;put it alt lcd buffer
	ENT	64704
BEGIN	CALL	CLS	;clear screen
	CALL	FILES	;show user the files on menu
	CALL	CRLF	;make a blank line
	LXI	H,FILMS	;prompt for the file to process
	CALL	PRTMSG
	CALL	LINEIN	;line input the file name
	RST	2	;see if there is one
	JZ	EXIT	;main menu if none
;
	lxi	h,buf	;HL -> file name
	push	h
	dcx	h
;
lp1	inx	h	;make file name uppercase
	call	upcase
	mov	m,a
	cpi	'.'
	jz	do
	ora	a
	jnz	lp1
;
do	lxi	d,dotyp	;put in .DO extension
	mvi	b,4
	call	$3469
;
	pop	d	;try to lookup file in Dir
	mvi	a,10
	call	chkdc
	JZ	EXITN	;failure exit for 'file not found'
;
	call	gtxttb	;get pointer to start of file
;
;setup the state flag in b
;
	mvi	b,1	;initial flag
;
;character processing
;
getch	mov	a,m	;file char in a
	cpi	26	;chk eof
	jz	begin	;done - prompt for another
;
;set flags for following CAP
;
	cpi	'.'	;period?
	jz	setfl	;set end flag
	cpi	'?'	;question mk?
	jz	setfl	;set end flag
	cpi	':'	;colon?
	jz	setfl	;set end flag
	cpi	'!'	;exclam pt?
	jz	setfl	;set end flag
;
;Check to see if a CAP
;
	cpi	'['
	jnc	loop	;loop if >Z
	cpi	'A'
	jc	loop	;loop if <A
;
;Check the flag
;
	push	a
	mov	a,b
	cpi	1
	jnz	lower
	pop	a
	mvi	b,0	;reset flag, keep CAP
	jmp	loop
;
;now make it lower case
;
lower	pop	a	;get char back
	adi	32	;up it by 32
	mov	m,a	;put it in M
	mvi	b,0	;reset flag
	jmp	loop
;
;set the flag (if '.', '?', or ':')
;
setfl	mvi	b,1
;
;and loop back
;
loop	inx	h	;move pointer forward a byte
	jmp	getch	;get the next character
;
;Exit routines
;
EXITN	LXI	H,NTFND	;if file not found
	CALL	PRTMSG
ERROR	CALL	BEEP	;beep means an error
	LXI	H,PRESS	;say press space bar
	CALL	PRTMSG
	CALL	WAITSP	;wait for it to be pressed
EXIT	JMP	MENU	;back to m100 menu
;
;messages
;
PRESS	DM	Press Space Bar to Exit
	DB	$00
DOTYP	DM	.DO
	DB	$00
FILMS	DM	File to Process? 
	DB	$00
NTFND	DM	File not Found!
	DB	$00
;
	END
