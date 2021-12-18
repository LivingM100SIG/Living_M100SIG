;HXFER.ASM - source code for M100 version of device-compatible HXFER
;Binary file to Hex ascii file
;conversion program.
;James Yi 73327,1653 - 04/27/1988.
; Fixed M100 version: PcW - 5/29/88
;
;List of ROM subroutines and RAM spaces outside the program:
;*NOTE: M100 version has embedded ROM addresses in code 
;in KILL and SAVECO subroutines.
;
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

swapnm	equ	$224c	;11711
INXD	EQU	$46d2	$5587
LoadBL	equ	$6c9c	;33756 (Load BA label)
Rflptr	equ	$2146	;11362
CLS	equ	$4231	;20301
OMmsg	equ	$60b1	;$69AC
Delay2s	equ	$5310	;25102
Bell	equ	$4229	;20293
Print	equ	$5791	;26526 (Print @ clmn 1)
InpA	equ	$463e	;21744
InpB	equ	$4644	;21750 (Input w/o '?')
Files	equ	$1f3a	;10794
GetLen	equ	$21fa	;11587
FmtFnm	equ	$4c0b	;23242
FindCO	equ	$2089	;11174
Top	equ	$face	;62715
Len	equ	$fad0	;62717
Exe	equ	$fad2	;62719
GetVal	equ	$08eb	;2326
ChGet	equ	$12cb	;4855
;
;Begin HXFER
	org	61997	;Put it here
;
	call	LoadBL	;load label
	lxi	h,trapit	;set BA error trap
	shld	errtrp
	mvi	a,1
	call	maxfil	;set maxfile=1
;Display Menu
Choose:	call	restak
	call	close
	call	Rflptr
	call	CLS
	call	Files
	lxi	h,Menu	;display menu
	call	Print
;Make a choice
Notchoosy
	call	ChGet
	CPI	13	;CR=exit
	jz	0
	sui	49
	jz	Hex
	dcr	a
	jz	Binary
	dcr	a
	jnz	choose
	rst	0

;.DO to .CO - Enter hex file
Hex:	lxi	h,msg1
	call	Print
	call	InpA
	rst	2
	jz	Choose
	mvi	a,1	;INPUT
	call	openit
	mvi	a,1	;#1
	call	select
;Load CO file parameters: Top,End,Exe
	mvi	c,6
	lxi	d,Top
L2	call	Getbyt
	stax	d
	inx	d
	dcr	c
	jnz	L2
;Prompt for relocating address
	lxi	h,0
	shld	devout	;turn off device for lcd output
	lxi	h,msg2
	call	Print
	call	InpB
	rst	2
	push	h
	lhld	Top
	xchg
	pop	h
	cnz	GetVal	;If a number is
	lhld	Top	;entered, use
	mov	b,h	;this as the
	mov	c,l	;new address
	xchg		;else keep old
	dsub	b
	shld	Diff	;Old-New
	push	h
	call	FindCO	;Does CO exist already?
	cnz	Kill	;then replace it - kill it.
	call	Rflptr	;Reset file ptr
	call	SaveCO	;Create a new CO
	mvi	a,1
	call	select
	call	FindCO	;Get its location
;Change the first 6 parameter bytes of the CO file according to the new addr
	pop	b	;Add difference of Old-New to TOP and EXE
	lhlx
	dad	b
	shlx
	inx	d
	inx	d
	inx	d
	inx	d
	lhlx
	mov	a,h
	ora	l
	jz	zero	;If EXE=0, don't change it
	dad	b
	shlx
zero	inx	d
	inx	d
;Poke program content into the created .CO file
	lhld	top
	MOV	B,D
	MOV	C,E
	DSUB	B
	SHLD	PCDIFF	;diffence of loading location and CO file location
	lhld	Len	;Get length of program
	mov	b,h
	mov	c,l
	push	d
	push	b
;DE=.CO addr, BC=Length
;Start poking the CO file with the program content
Load:	call	Getbyt
	jc	Err	;Reached EOF
	stax	d
	inx	d
	dcx	b
	mov	a,b
	ora	c
	jnz	Load
;Adjust addresses after loading - relocate
	pop	b	;get length
	lhld	Top
	dad	b
	dcx	h
	shld	Len	;addr of last byte of loading addr - for checking if JMP range is withing the program.
	pop	h	;CO location
	dad	b
	shld	Exe	;addr of last byte + 1 of CO file
	dsub	b	;reset to beginning
	xchg
	call	NxExcl	;Get relocate skip addr
AdjLoop	ldax	d
	INX	D
	call	ilen	;3 bytes long?
	cpi	3
	jnz	NOT3
;3 bytes - relocate it if neccessary
	lhld	PCDIFF	;get PC of 
	DAD	D	;actual loading
	MOV	B,H	;address
	MOV	C,L
	LHLD	EXCL	;Is this ok to
	DSUB	B	;relocate?
	jnz	L4	;If so, process in normally.
	PUSH	PSW	;Not relocated.
	call	NxExcl	;Load next one to skip
	POP	PSW
	jmp	NIR	;Get next instr
L4	lhlx		;If the operand points to an addr within range of program, relocate it.
	mov	b,h
	mov	c,l
	lhld	Top
	dsub	b
	jnc	NIR	;Not In Range
	lhld	Len
	dsub	b
	jc	Nir	;Not in range.
	lhld	Diff	;Adjust if
	dad	b	;in range
	shlx
NIR	INX	D
NOT3	CPI	2
	CNC	INXD	;point to next instr
	mov	b,d
	mov	c,e
	lhld	Exe
	dcx	h
	dsub	b	;Done?
	jnc	AdjLoop	;check next instr

;Use data leftover to relocate tables and such.
L8	lhld	Excl
	mov	a,h	;leftover?
	ora	l
	jz	choose	;if not, assume no table adjustments neccessary, done.
	xchg		;DE=relocating addr
	LHLD	PCDIFF	;Get program data location in the CO file for this addr
	MOV	B,H
	MOV	C,L
	XCHG
	DSUB	B
	XCHG
	lhlx		;instr to relocate is here
	mov	b,h
	mov	c,l
	lhld	Diff	;add the difference of Old and New addr
	dad	b
	shlx		;adjusted.
	call	NxExcl	;get next instr to relocate
	jmp	L8


;Read unused data at the end of hex file
NxExcl	call	Getbyt
	sta	Excl
	call	Getbyt
	sta	Excl+1
	ret

;Get length of instruction - 1,2, or 3
ilen	cpi	$3f
	jc	Grth1
	cpi	$c2
	jnc	Grth1
Eq1	mvi	a,1
	ret
Grth1	mov	b,a
	cpi	$ed
	jz	Eq1
	ani	$f7
	cpi	$d3
	jz	Eq2
	ani	$c7
	cpi	$c6
	jz	Eq2
	cpi	$6
	jnz	Grth2
Eq2	mvi	a,2
	ret
Grth2	mov	a,b
	ani	$ef
	cpi	$28
	jz	Eq2
	ani	$cf
	cpi	$01
	jz	Eq3
	cpi	$cd
	jz	Eq3
	mov	a,b
	ani	$e7
	cpi	$22
	jz	Eq3
	mov	a,b
	cpi	$c2
	jc	Eq1
	cpi	$c3
	jz	Eq3
	ani	$7
	jz	Eq1
	rar
	jc	Eq1
Eq3	mvi	a,3
	ret

;Read a byte from hex file.
GetByt:	call	Fetch	;get high hex digit
	cpi	26
	jz	Eof	;error
	rlc
	rlc
	rlc
	rlc
	mov	h,a	;move it to b7-4
	push	h
	call	Fetch	;get low hex digit
	pop	h
	cpi	26
	jz	Eof	;error
	ora	h	;or with b7-4
	ret
;EF error
Eof	xra	a
	stc
	ret

;Read a hex character, and convert it into binary number
Fetch:	call	readio
	cpi	26
	rz
L9	sui	48
	jc	Fetch	;not hex chr
	cpi	10
	rc
	cpi	17
	jc	Fetch	;not hex chr
	cpi	23
	jnc	Fetch	;not hex chr
	sui	7
	ret

;Error routine
trapit:
	mov	a,e
	cpi	52
	jz	FFerr
	cpi	7
	jz	OMerr
	cpi	55
	jz	NMerr
	jmp	reterr	;other errors: resume error processing.
FFerr	lxi	h,nofile
	jmp	prerr
NMerr	lxi	h,badnam
	jmp	prerr

Err:	call	FindCO	;.CO file is
	call	Kill	;unusable.
	lxi	h,errmsg	;Bad Hex file
	jmp	PrErr
OMerr:	lxi	h,OMmsg	;Out of Memory
PrErr:	push	h
	call	close
	pop	h
	call	Print
	call	Bell
	call	delay2s	;Wait
	jmp	choose	;and resume
;
SAVECO	CALL	$2089	;ROM routine, mod to give RET
	CNZ	$1FD9	;instead of JMP to Basic
	CALL	$20E4
	PUSH	H
	LHLD	$FBB0
	PUSH	H
	LHLD	$FAD0
	MOV	A,H
	ORA	L
	JZ	$3F17
	PUSH	H
	LXI	B,$6
	DAD	B
	MOV	B,H
	MOV	C,L
	LHLD	$FBB2
	SHLD	$FB99
	CNC	$6B6D
	JC	$3F17
	XCHG
	LXI	H,$FACE
	CALL	$2540
	LHLD	$FACE
	POP	B
	CALL	$6BDB
	POP	H
	SHLD	$FBB0
	POP	H
	MVI	A,$A0
	XCHG
	LHLD	$FB99
	XCHG
	CALL	$2239
	CALL	$2146
	LHLD	$FB8E
	RET
;
KILL	MOV	A,M	;from M200 ROM code
	INX	H	;no equiv M100 code found
	MOV	E,M
	INX	H
	MOV	D,M
	DCX	H
	DCX	H
	CPI	$C0
	JZ	$1FBF
	CPI	$80
	JZ	$2017
	JMP	$1FD9
;
;.CO to .DO - Enter .CO file
Binary:	Lxi	h,msg3
	call	Print
	call	InpA
	rst	2
	jz	Choose
	call	getlen
	call	fmtfnm
	call	FindCO
	jz	FFerr
	call	swapnm
	lxi	h,msg4
	call	print
	call	inpa
	rst	2
	jz	choose
	mvi	a,2
	call	openit
	call	rflptr
	mvi	a,1
	call	select
	call	swapnm
	call	findco
	lxi	h,linlen
	mvi	m,128
	inx	h
	mvi	m,0	;buflen
	push	d
	inx	d
	inx	d
	lhlx
	lxi	b,6	;Actual length
	dad	b	;to encode is
	mov	b,h	;len+parameters
	mov	c,l
	pop	d

;Encode binary into hex and store them.
L5	call	Store
	inx	d
	dcx	b
	mov	a,b
	ora	c
	jnz	L5
	jmp	choose	;Done

;Store one byte as two hex characters
Store	ldax	d
	rrc		;store high digit
	rrc
	rrc
	rrc
	call	Cnvert
	ldax	d	;store low digit

;Encode binary to hex - b3-0
Cnvert	ani	$F
	cpi	$A
	jc	Lest10
	adi	$7
Lest10	adi	$30
	call	chout
	lxi	h,linlen
	dcr	m
	rnz
	mvi	m,128	;CR&LF every 128 chrs
	mvi	a,13
	call	chout
	mvi	a,10
;write to hex output file
chout:	call	writio
	lxi	h,buflen
	dcr	m
	rnz
;Adjust CO pointer, if neces
	lda	device
	cpi	$f8	;is DO output to RAM?
	rnz
	inr	d	;if so, CO file is moved up 256 bytes.
	ret


openit:	push	a	;Operation type :1=input, 2=output
	call	getlen
	call	fmtfnm
	JNZ	spec	;device specified
	MVI	D,$F8	;no device specified: Default is RAM
spec:	mov	a,d
	sta	device	;remember if this was RAM file.
	lxi	h,null
	pop	a
	mov	e,a	;operation type
	mvi	a,1	;buffer #
	jmp	open


errmsg	db	'Corrupt Hex File',0
msg1	db	'.DO File',0
msg2	db	'Load at? (<CR> for Default): ',0
Msg3	db	'.CO File',0
msg4	db	'Hex Output File' 0
badnam:	db	'Bad file name' 0
nofile:	db	'File not found' 0


Menu	db	'1).DO-->.CO; 2).CO-->.DO; 3)Exit ? ',0

Diff	dw	0
linLen	db	0	;64 byte count
buflen	db	0
Excl	dw	0
PCDIFF	DW	0
device	db	0

