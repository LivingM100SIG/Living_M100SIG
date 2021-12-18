; QKD.ASM is a version of QKRCHK to support device files
;
;Phil Wheeler -- 71266,125 [7/5/88]
;
;ROM Adresses
;
cls	equ	$4231	; clear screen
PRTMSG	EQU	$5791	;msg to lcd on new line
WAITSP	EQU	$5F2F	;wait for press and rtn
LINEIN	EQU	$463E	;input line from kbd
NTFND	EQU	$5CD6	;not found ROM msg
BEEP	EQU	$7662	;oops!
FILES	EQU	$1F3A	;display files
CRLF	EQU	$4222	;make a blank line

;		M100	 T200
;		-----	 -----
errtrp	equ	$f652	;61236
reterr	equ	$047b	;$04a6
maxfil	equ	$7f2b	;$9be1
restak	equ	$5d5d	;$7155
null	equ	7	;7 (point to 0)
open	equ	$4d12	;$5bd1
select	equ	$4cbf	;$5b7e
readio	equ	$4e7a	;$5d36
writio	equ	$4b44	;$5a05
close	equ	$4e27	;$5ce6
devout	equ	$fc8c	;$f73f

LoadBL	equ	$6c9c	;33756 (Load BA label)
Rflptr	equ	$2146	;11362
GetLen	equ	$21fa	;11587
FmtFnm	equ	$4c0b	;23242
;
;
	ORG	$FCC0	;put it alt lcd buffer
;
begin:	
;	call	LoadBL	;load label
	lxi	h,exitn	;set BA error trap
	shld	errtrp
	call	restak
	call	close
	call	rflptr
	CALL	CLS	;clear screen
	CALL	FILES	;show user the files on menu
;	CALL	CRLF	;make a blank line
	LXI	H,FILMS	;prompt for the file to process
	CALL	PRTMSG
	CALL	LINEIN	;line input the file name
	RST	2	;see if there is one
	RZ		;RTN IF NO FILE
;

	mvi	a,1	;INPUT
	call	openit

	mvi	a,1	;#1
	call	select

	XRA	A	;zero the binary counter
	MOV	L,A
	MOV	H,A
	MOV	C,A

AGAIN	PUSH	B
	PUSH	H
	CALL	READIO
	POP	H
	POP	B
	CPI	$0D
	JZ	AGAIN	;ignore CR
	CPI	$0A
	JZ	AGAIN	;ignore LF
	CPI	$1A
	JZ	EOF	;^Z -- all done
	MOV	E,A	;set up 24 bit add
	XRA	A
	MOV	D,A
	DAD	D
	ADC	C
	MOV	C,A
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
;
	lxi	h,0
	shld	devout	;turn off device for lcd output
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
PRTCK:	
	LXI	H,PRINT	;PRINT CHECKSUM
	CALL	PRTMSG
	JMP	SPACE

openit:
	push	a	;Operation type :1=input, 2=output
	call	getlen
	call	fmtfnm
	JNZ	spec	;device specified
	MVI	D,$F8	;no device specified: Default is RAM
spec:	
	lxi	h,null
	pop	a
	mov	e,a	;operation type
;	mvi	a,1	;buffer #
	jmp	open

err	jmp	error

;Exit routines
;
EXITN	LXI	H,NTFND	;if file not found
	CALL	PRTMSG
ERROR	CALL	BEEP	;beep means an error
;
SPACE	LXI	H,PRESS	;say press space bar
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
PRESS	DM	Tap SPC
	DB	$00
FILMS	DM	fl
	DB	$00
PRINT	DM	CK=
CHKSM	DS	8	;decimal checksum
	DB	$00
;
;data storage
;
BINCK	DS	3	;binary checksum
	END
