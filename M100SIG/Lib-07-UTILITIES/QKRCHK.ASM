;"QKRCHK.ASM" -- Source for QIKRCK.CO,
; a QucKeR CHecKsum program, another
; version of QIKCHK.CO.  Loads on entry
; and runs in the Alt LCD buffer.
; Checksum calculation from QIKCHK and
; CHECK2.ASM. Add bytes at your peril!
; CO file length is 280 bytes loaded
; into Alternate LCD buffer (282 max).
;
;           Phil Wheeler -- 71266,125
;           Monterey, CA -- 3 Aug 1987
;
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
NTFND	EQU	$5CD6	;not found ROM msg
BEEP	EQU	$7662	;oops!
FILES	EQU	$1F3A	;display files
CRLF	EQU	$4222	;make a blank line
;
;
	ORG	$FCC0	;put it alt lcd buffer
	ENT	$FCC0
BEGIN	CALL	CLS	;clear screen
	CALL	FILES	;show user the files on menu
;	CALL	CRLF	;make a blank line
	LXI	H,FILMS	;prompt for the file to process
	CALL	PRTMSG
	CALL	LINEIN	;line input the file name
	RST	2	;see if there is one
	JZ	menu	;main menu if none
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
	xchg
;
	XRA	A	;zero the binary counter
	MOV	L,A
	MOV	H,A
	MOV	C,A
AGAIN	LDAX	D
	INX	D
	CPI	$0D
	JZ	AGAIN	;ignore CR
	CPI	$0A
	JZ	AGAIN	;ignore LF
	CPI	$1A
	JZ	EOF	;^Z -- all done
	PUSH	D	;save buffer pointer
	MOV	E,A	;set up 24 bit add
	XRA	A
	MOV	D,A
	DAD	D
	ADC	C
	MOV	C,A
	POP	D
	JMP	AGAIN
EOF	LXI	D,BINCK	;store the binary checksum (3 bytes)
	XCHG
	MOV	M,E
	INX	H
	MOV	M,D
	INX	H
	MOV	M,C
;
;convert to decimal
;can probably done using ROM calls
;with much less code.
;
	LXI	B,CHKSM	;PT TO ASCII CS BUFFER
	LXI	H,TABLE	;POWERS OF TEN TABLE
NXTDIG	MVI	A,$30	;PUT ZERO IN DIGIT
	STAX	B
REPEAT	PUSH	H	;SAVE TABLE PTR
	LXI	D,BINCK	;PT TO BINARY VALUE
	LDAX	D	;SUB PWR 10 FROM BINARY VALUE
	SUB	M
	STAX	D
	INX	D
	INX	H
	LDAX	D
	SBB	M
	STAX	D
	INX	D
	INX	H
	LDAX	D
	SBB	M
	STAX	D
	POP	H
	LDAX	B
	INR	A
	STAX	B
	JNC	REPEAT	;STILL >0
	DCR	A	;TOO FAR ADD BACK
	STAX	B
	LXI	D,BINCK
	LDAX	D
	ADD	M
	STAX	D
	INX	D
	INX	H
	LDAX	D
	ADC	M
	STAX	D
	INX	D
	INX	H
	LDAX	D
	ADC	M
	STAX	D
	INX	B	;PT TO NEXT DIGIT
	INX	H	;PT TO NEXT 10
	XRA	A
	CMP	M	;IF TABLE VALUE ZERO QUIT
	JNZ	NXTDIG
	MVI	D,4	;KILL LEADING 0
	MVI	A,48
	LXI	H,CHKSM
SPACES	CMP	M
	JNZ	PRTCK
	MVI	M,32
	INX	H
	DCR	D
	JNZ	SPACES
PRTCK	LXI	H,PRINT	;PRINT CHECKSUM
	CALL	PRTMSG
	LXI	H,PRESS
	CALL	PRTMSG
	CALL	WAITSP
	JMP	BEGIN
;Exit routines
;
EXITN	LXI	H,NTFND	;if file not found
	CALL	PRTMSG
ERROR	CALL	BEEP	;beep means an error
	LXI	H,PRESS	;say press space bar
	CALL	PRTMSG
	CALL	WAITSP	;wait for it to be pressed
EXIT	JMP	BEGIN	;back to QKRCHK menu
;
;powers of ten table
;
TABLE	DB	$80
	DB	$96
	DB	$98
	DB	$40
	DB	$42
	DB	$0F
	DB	$A0
	DB	$86
	DB	$01
	DB	$10
	DB	$27
	DB	$00
	DB	$E8
	DB	$03
	DB	$00
	DB	$64
	DB	$00
	DB	$00
	DB	$0A
	DB	$00
	DB	$00
	DB	$01
	DB	$00
	DB	$00
	DB	$00
;
;messages
;
PRESS	DM	Tap SPC Bar
	DB	$00
DOTYP	DM	.DO
	DB	$00
FILMS	DM	File? 
	DB	$00
PRINT	DM	Cks =
CHKSM	DS	8	;decimal checksum
	DB	$00
;
;data storage
;
BINCK	DS	3	;binary checksum
	END
