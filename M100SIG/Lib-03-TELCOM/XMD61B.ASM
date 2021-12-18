FRE	CALL	CRLF
	CALL	FRERAM
	JMP	CRLF
;***
DIR	CALL	CRLF
	JMP	FILES
;***
f2chkx	lda	$ff99
	rar
	jnc	xsnd
	jmp	check	;do checksum
;***
CRCTOG	call	f7chk	;check for SHIFT -> DIRACC if pressed
	LDA	Bfr+12
	XRI	$FF
LEB45	STA	Bfr+12
LEB48	LXI	D,KEYDSP+$60
	LXI	H,LF22D
	JMP	CHGDSP
;***
XSND	LXI	H,LF012
	SHLD	RTNADR
	PUSH	H
	LXI	H,LF081
	CALL	LEFCF
	ANA	A
	RZ	
;----
	mvi	a,1
	call	openit
	call	open2
	lxi	h,0
	shld	devout
;----
	CALL	LEF8D
	LXI	H,LF0AD
	CALL	PRTMSG
	XRA	A
	STA	Bfr+10
	STA	Bfr+9
	LXI	H,$0001
	SHLD	BFR
	JMP	LEBAF
;***
LEB96	LDA	Bfr+9
	INR	A
	STA	Bfr+9
	CPI	$0B
	RNC	
	LXI	H,LF112
	CALL	PRTMSG
	CALL	LEEE5
	CALL	LEF6D
	JZ	LEEA3
LEBAF	LXI	H,$FFFD
LEBB2	DCX	H
	MOV	A,L
	ORA	H
	JZ	LEB96
	LXI	B,$000C
	CALL	LEEC6
	CALL	RCVX
	JZ	LEBB2
	PUSH	H
	CALL	RV232C
	POP	H
	JNZ	LEBB2
	JC	LEEA3
	CPI	$15
	JNZ	LEBD8
	XRA	A
	JMP	LEBDF
;***
LEBD8	CPI	$43
	JNZ	LEBB2
	MVI	A,$FF
LEBDF	CALL	LEB45
LEBE2	XRA	A
	STA	Bfr+9

;---- Move block to be sent to buffer
	mvi	a,1
	call	select
	mvi	c,128
	lxi	h,Bfr+542	;buffer for record storage
BfrBlk	call	readio
	mov	m,a
	inx	h
	dcr	c
	jnz	bfrblk
	lxi	h,0
	shld	devout
;----
LEBE6	LDA	Bfr+9	;retry loop
	INR	A
	STA	Bfr+9
	CPI	$0B
	RNC	
	CALL	LEF6D
	JZ	LEEA3
	CALL	LEEF1
	MVI	C,$01
	CALL	LEEC2
	LDA	BFR
	MOV	C,A
	CMA	
	PUSH	A
	CALL	LEEC2
	POP	A
	CALL	LEEB5
	XRA	A
	STA	Bfr+8
	LXI	H,$0000
	SHLD	Bfr+13
;----
	lxi	h,bfr+542	;point to buffer
;----
	XCHG	
	MVI	C,$80
LEC1B	LDAX	D
	CPI	$1A
	JNZ	SNDB2	;new
	STA	Bfr+10
SNDB2	MOV	B,A
	LDA	BFR+10
	ORA	A
	JZ	NOEOF
	MVI	B,$1A
NOEOF	MOV	A,B	;end of new
	CALL	LEEA9
	CALL	LEEB5
	INX	D
	DCR	C
	JNZ	LEC1B
	LDA	Bfr+12
	ORA	A
	JNZ	LEC3F
	LDA	Bfr+8
	CALL	LEEB5
	JMP	LEC4A
;***
LEC3F	LHLD	Bfr+13
	MOV	A,H
	CALL	LEEB5
	MOV	A,L
	CALL	LEEB5
LEC4A	LXI	B,$FFFD
LEC4D	CALL	RCVX
	JZ	LEC6E
	PUSH	B
	CALL	RV232C
	POP	B
	CPI	$06
	JZ	LEC80
	CPI	$15
	JNZ	LEC6E
	LXI	H,LF14C
	CALL	PRTMSG
	CALL	LEEE5
	JMP	LEBE6
;***
LEC6E	DCX	B
	MOV	A,C
	ORA	B
	JNZ	LEC4D
	LXI	H,LF12E
	CALL	PRTMSG
	CALL	LEEE5
	JMP	LEBE6
;***
LEC80	LDA	Bfr+10
	ORA	A
	JNZ	LEC9B
	LHLD	Bfr+6
	LXI	D,$0080
	DAD	D
	SHLD	Bfr+6
	LHLD	BFR
	INX	H
	SHLD	BFR
	JMP	LEBE2
;***
LEC9B	XRA	A
	STA	Bfr+9
LEC9F	LDA	Bfr+9
	INR	A
	STA	Bfr+9
	CPI	$0B
	RZ	
	CALL	LEF6D
	JZ	LEEA3
	MVI	C,$04
	CALL	LEEC2
	LXI	B,$FFFD
LECB7	CALL	RCVX
	JZ	LECC7
	PUSH	B
	CALL	RV232C
	POP	B
	CPI	$06
	JZ	LECE1
LECC7	PUSH	B
	LXI	B,$0064
	CALL	LEEC6
	POP	B
	DCX	B
	MOV	A,C
	ORA	B
	JNZ	LECB7
	LXI	H,LF16A
	CALL	PRTMSG
	CALL	LEEE5
	JMP	LEC9F
;***
LECE1	POP	H
	LXI	H,LF184
	CALL	PRTMSG
	jmp	xdone
;***
XRCV	LXI	H,LF00C
	SHLD	RTNADR
	PUSH	H
	LXI	H,LF094
	CALL	LEFCF
	ANA	A
	RZ	
;----
	mvi	a,2
	call	openit
	lda	device
	cpi	$f8
	jnz	go_on
DIRCK1:	
	push	d
	call	finddo
	pop	d
	jz	go_on
	push	d
	call	beep
	LXI	H,LF1A6
	CALL	LEFCF
	CPI	$59
	pop	d
	RNZ
go_on:	call	open2
	call	rflptr
	lxi	h,0
	shld	devout
;----
LED29	LXI	H,$0001
	SHLD	BFR
	XRA	A
	STA	Bfr+10
	DCR	A
	STA	Bfr+15
	CALL	LEF8D
	LXI	H,LF1C1
	CALL	PRTMSG
	LXI	H,LF1E2
	MVI	C,$15
	LDA	Bfr+12
	ORA	A
	JZ	LED51
	LXI	H,LF1F7
	MVI	C,$43
LED51	PUSH	B
	CALL	PRTMSG
	POP	B
	CALL	LEEC2
LED59	XRA	A
	STA	Bfr+9
LED5D	LDA	Bfr+11
	ORA	A
	JNZ	LED68
	XRA	A
	STA	Bfr+10
LED68	LDA	Bfr+9
	INR	A
	STA	Bfr+9
	CPI	$0B
	RNC	
	CPI	$07
	JC	LED8F
	LDA	Bfr+15
	MOV	B,A
	LDA	Bfr+12
	ANA	B
	JZ	LED8F
	XRA	A
	STA	Bfr+12
	LXI	H,LF20C
	CALL	PRTMSG
	JMP	LED29
;***
LED8F	CALL	LEF6D
	JZ	LEEA3
	XRA	A
	STA	Bfr+8
	LXI	H,$0000
	SHLD	Bfr+13
	CALL	LEF3A
	JNZ	LEE67
	CPI	$04
	JZ	LEE98
	CPI	$01
	JNZ	LEE61
	XRA	A
	STA	Bfr+15
	CALL	LEF3A
	JNZ	LEE67
	MOV	E,A
	LDA	BFR
	CMP	E
	JNZ	LEE61
	CALL	LEF3A
	JNZ	LEE67
	CMA	
	CMP	E
	JNZ	LEE61
	MVI	D,$00
	MVI	E,$80
	LXI	H,Bfr+542
LEDD3	CALL	LEF3A
	JNZ	LEE67
	MOV	M,A
	CALL	LEEA9
	CPI	$1A
	JNZ	LEDE5
	STA	Bfr+10
LEDE5	LDA	Bfr+10
	ORA	A
	JNZ	LEDED
	INR	D
LEDED	INX	H
	DCR	E
	JNZ	LEDD3
	LDA	Bfr+12
	ORA	A
	JZ	LEE13
	MVI	C,$02
LEDFB	PUSH	B
	CALL	LEF3A
	POP	B
	JNZ	LEE67
	CALL	LEEA9
	DCR	C
	JNZ	LEDFB
	CALL	LF02D
	JNZ	LEE5B
	JMP	LEE21
;***
LEE13	CALL	LEF3A
	JNZ	LEE67
	MOV	B,A
	LDA	Bfr+8
	CMP	B
	JNZ	LEE55
LEE21	MOV	A,D
	ORA	A
	JZ	LEE3F
	MOV	C,A
	MVI	B,$00
;----
	push	b
	mvi	a,1
	call	select
	pop	b
	lxi	h,Bfr+542
movblk	mov	a,m
	call	writio
	inx	h
	dcr	c
	jnz	movblk
	lxi	h,0
	shld	devout
;----
LEE3F	CALL	LEF25
	CALL	LEF35
	LHLD	BFR
	INX	H
	SHLD	BFR
	LDA	Bfr+10
	STA	Bfr+11
	JMP	LED59
;***
LEE55	LXI	H,LF292
	JMP	LEE6A
;***
LEE5B	LXI	H,LF2A9
	JMP	LEE6A
;***
LEE61	LXI	H,LF24D
	JMP	LEE6A
;***
LEE67	LXI	H,LF235
LEE6A	CALL	PRTMSG
	CALL	LEEE5
	CALL	LEF7F
	MVI	C,$15
	LDA	Bfr+15
	MOV	B,A
	LDA	Bfr+12
	ANA	B
	JZ	LEE82
	MVI	C,$43
LEE82	CALL	LEEC2
	JMP	LED5D
;***
LEE98	POP	H
	LXI	H,LF2C0
	CALL	PRTMSG
	CALL	LEF35
	jmp	xdone
;***
openit:	sta	optype	;Operation type :1=input, 2=output
	call	getlen
	call	fmtfnm
	JNZ	spec	;device specified
	MVI	D,$F8	;no device specified: Default is RAM
spec:	mov	a,d
	sta	device	;remember if this was RAM file.
	ret

open2:	lxi	h,null
	lda	optype
	mov	e,a	;operation type
	mvi	a,1	;buffer #
	jmp	open
;***
LEEA3	LXI	H,LF2E5
	JMP	LF015
;***
LEEA9	PUSH	A
	PUSH	H
	LXI	H,Bfr+8
	ADD	M
	MOV	M,A
	POP	H
	POP	A
	JMP	LF063
;***
LEEB5	PUSH	A
	PUSH	B
	PUSH	D
	PUSH	H
	MOV	C,A
	CALL	LEEC2
	POP	H
	POP	D
	POP	B
	POP	A
	RET	
;***
LEEC2	PUSH	B
	JMP	SNDCOM
;***
LEEC6	PUSH	A
LEEC7	NOP	
	NOP	
	NOP	
	DCX	B
	MOV	A,C
	ORA	B
	JNZ	LEEC7
	POP	A
	RET	
;***
LEED2	PUSH	H
	MOV	L,A
	MVI	H,$00
	CALL	LEEDB
	POP	H
	RET	
;***
LEEDB	PUSH	A
	PUSH	B
	PUSH	D
	CALL	CONVD
	POP	D
	POP	B
	POP	A
	RET	
;***
LEEE5	PUSH	A
	LDA	Bfr+9
	CALL	LEED2
	CALL	CRLF
	POP	A
	RET	
;***
LEEF1	LXI	H,LEEF7
	JMP	LEF28
;***
LEEF7	DB	13
	DB	27
	DM	M   Sending block # 
	DB	0
;
LEF0E	DB	13
	DB	27
	DM	M  Received block # 
	DB	0
;
LEF25	LXI	H,LEF0E
LEF28	CALL	PRTMSG
	LHLD	BFR
	CALL	LEEDB
	MVI	A,$0D
	RST	4
	RET	
;***
LEF35	MVI	C,$06
	JMP	LEEC2
;***
LEF3A	LXI	B,$000F
LEF3D	PUSH	D
	PUSH	H
LEF3F	PUSH	B
	LXI	B,$0D05
LEF43	PUSH	B
	CALL	RCVX
	JZ	LEF55
	CALL	RV232C
	JNZ	LEF55
	POP	B
	POP	B
	POP	H
	POP	D
	RET	
;***
LEF55	LXI	B,$000A
	CALL	LEEC6
	POP	B
	DCX	B
	MOV	A,C
	ORA	B
	JNZ	LEF43
	POP	B
	DCX	B
	MOV	A,C
	ORA	B
	JNZ	LEF3F
	DCR	C
	POP	H
	POP	D
	RET	
;***
LEF6D	CALL	KEYX
	JZ	LEF7C
	CALL	CHGET
	CPI	$03
	RZ	
	CPI	$18
	RZ	
LEF7C	XRA	A
	DCR	A
	RET	
;***
LEF7F	LXI	B,$0001
	CALL	LEF3D
	RNZ	
	CALL	LEF6D
	RZ	
	JMP	LEF7F
;***
LEF8D	LXI	H,Bfr+24
	JMP	LEF96
;***
LEF93	LXI	H,Bfr+18
LEF96	MOV	A,M
	CPI	$4D
	JNZ	SETSER
	INX	H
	JMP	SETSER
;***
LEFA0	LXI	H,Bfr+18
	LXI	D,SERPRM
	LDAX	D
	STA	Bfr+24
	LXI	B,$0005
	JMP	LEFC4
;***
LEFB0	DM	8N1D
LEFB4	XRA	A	
	STA	Bfr+23
	STA	Bfr+29
	LXI	H,Bfr+25
	LXI	D,LEFB0
	LXI	B,$0004
LEFC4	MOV	A,C
	ORA	B
	RZ	
	LDAX	D
	MOV	M,A
	INX	D
	INX	H
	DCX	B
	JMP	LEFC4
;***
LEFCF	CALL	PRTMSG
	CALL	INPRMP
	RST	2
	JMP	UPCASE
;***
DNLD	CALL	DIRRST
	LDA	CAPTUR
	XRI	$FF
	STA	CAPTUR
	JZ	LEFED
	LXI	H,LEFF9
	JMP	DWNLDR
;***
LEFED	CALL	FNKSB
	JMP	L6383
;***
UPLD	LXI	H,LF006
	JMP	UPLDR
;***
LEFF9	XRA	A
	STA	CAPTUR
	CALL	FNKSB
	LXI	H,DWNMSG
	JMP	LF015
;***
LF006	LXI	H,UPLMSG
	JMP	LF015
;***
LF00C	LXI	H,LF0A5
	JMP	LF015
;***
LF012	LXI	H,LF08F
LF015	CALL	PRTMSG
	LXI	H,ABTMSG
	CALL	PRTNUL
	JMP	xdone
;***
LF021	LXI	H,LEAAA
	SHLD	Bfr+16
	LXI	H,LEAAA
	JMP	SETFNK
;***
xdone:
;----
	mvi	a,1
	call	closei
;----
	call	LEF93
	call	dirrst
	jmp	lea18
;***
LF02D	PUSH	H
	LHLD	Bfr+13
	MOV	A,H
	ORA	L
	POP	H
	RZ	
	MVI	A,$FF
	RET	
;***
LF038	LXI	H,Bfr+30
	MVI	C,$00
LF03D	XCHG	
	LXI	H,$0000
	MOV	A,C
	PUSH	B
	MVI	B,$08
	XRA	H
	MOV	H,A
LF047	DAD	H
	JNC	LF053
	MVI	A,$10
	XRA	H
	MOV	H,A
	MVI	A,$21
	XRA	L
	MOV	L,A
LF053	DCR	B
	JNZ	LF047
	POP	B
	XCHG	
	MOV	M,D
	INR	H
	MOV	M,E
	DCR	H
	INX	H
	INR	C
	JNZ	LF03D
	RET	
;***
LF063	PUSH	A
	PUSH	B
	PUSH	D
	PUSH	H
	LHLD	Bfr+13
	XCHG	
	MVI	B,$00
	XRA	D
	MOV	C,A
	LXI	H,Bfr+30
	DAD	B
	MOV	A,M
	XRA	E
	MOV	D,A
	INR	H
	MOV	E,M
	XCHG	
	SHLD	Bfr+13
	POP	H
	POP	D
	POP	B
	POP	A
	RET	
;***
;
;Start of macro code

macro	push	a	;store macro name
	lxi	de,mfile	;macro filename
	mvi	a,10	;fnam length
	call	chkf	;find file
	jz	merr1	;not found
	call	faddr	;get top
	pop	a	;get macro name back
	mov	c,a	;put it in c
mseek	mov	a,m	;get char from file
	cpi	26	;eof?
	jz	merr	;macro not found
	cmp	c	;is it the name of the macro?
	inx	hl	;move fwd in file
	jnz	mseek	;not it, keep looking
;
msend	mov	a,m	;get a char from macro file
	cpi	26	;eof?
	jz	mdone	;yes, exit
	cpi	128	;end of macro?
	jnc	mdone	;yes, exit
	call	sndchr	;send character
	inx	h
	jmp	msend	;loop
;
merr1	pop	a	;balance it
merr	call	beep2
mdone	xra	a	;clear a
	ret
;
mfile	dm	XMDMAC.DO
	db	0

;***
;Start of DIRACC code
;Base  code Copyright 1986 by Hugo Ferreya
;
f6chk	lda	$ff99	;routine to see if SHIFT is pressed
	rar		;
	rnc		;if not shift return
	jmp	f6lbl
;***
f7chk	lda	$ff99
	rar
	rnc
	jmp	f7lbl
;***
F6LBL	CALL	IDLBL	;F6 entry to Basic from TELCOM
	CALL	$6C7F	
	LXI	H,0000
	SHLD	$F652
	JMP	$6C4F	
F7LBL	CALL	IDLBL	;F7 entry to Text from TELCOM
	CALL	$4222	
	LXI	HL,FNLBL
	SHLD	$F652	
	LXI	H,$5E22	
	CALL	$5A7C	
	XRA	A
	STA	$F650	
FNLBL	CNZ	$4229	
	CALL	$5D53	
	LXI	H,$5E15	
	CALL	$27B1	
	CALL	$463E	
	RST	2
	JZ	HILBL
	CALL	$2206	
	PUSH	HL
	LXI	HL,0000
	SHLD	$F6E7	
	MVI	A,01
	LXI	HL,HILBL
	JMP	$5F71	
IDLBL	CALL	$4231	
	LXI	HL,CPLBL
	CALL	$27B1	
	MVI	L,0
	MVI	C,$C0
	CALL	$1F3A	
	CALL	$4222	
	CALL	$7EAC	
	RET
CPLBL	DB	$1b
	DB	$70
	DM	DIRACC 100  Copyright 1985 Hugo Ferreyra
	DB	$1b
	DB	$71
	DB	0
;***
jy200	mov	b,a	;!!!  Split screen routine
	lda	$f63d
	ora	a
	rz		;label on?
	lhld	jy224
	mov	a,l
	rar
	rnc		;on?
	mov	e,h
	mov	a,b
	mvi	d,0
	cpi	13
	jz	jy215
	cpi	21
	jnz	jy211
jy215	lxi	h,jy222
	mvi	b,39
	push	h
jy219	mvi	m,32
	inx	h
	dcr	b
	jnz	jy219
	pop	h
	mov	a,b
jy217	sta	jy225
	jmp	jy212
;***
jy211	lxi	h,jy222
	dad	d
	cpi	8
	jnz	jy213
	dcr	e
	rm
	mvi	m,32
	dcx	h
	mov	a,e
	jmp	jy217
;***
jy213	cpi	9
	jnz	jy214
	mvi	c,8
jy201a	mvi	a,32
	call	jy210
	dcr	c
	jnz	jy201a
	jmp	jy212
;***
jy210	mov	m,a
	inx	h
	mov	a,e
	inr	a
	cpi	39
	jnc	jy220
	mov	e,a
	sta	jy225
	ret
;***
jy220	lxi	h,jy222
	mov	d,h
	mov	e,l
	inx	h
	mvi	b,38
jy201b	mov	a,m
	stax	d
	inx	h
	inx	d
	dcr	b
	jnz	jy201b
	dcx	h
	mvi	e,38
	ret
;***
jy214	cpi	32
	rc
	call	jy210
jy212	mvi	m,233
	lhld	$f639
	push	h
	lxi	h,264
	shld	$f639
	call	$424e
	xra	a
	sta	jy223
	lxi	h,jy222
	call	$11a2
	pop	h
	shld	$f639
	jmp	$4249
;***
jy222	ds	39
jy223	db	0
jy224	db	0
jy225	db	0
;
;*** Checksum subroutine

Check:	lxi	h,error	;set BA error trap
	shld	errtrp
	call	restak
	call	close
	call	rflptr
	CALL	CLS	;clear screen
	CALL	FILES	;show user the files on menu
	LXI	H,FILMS	;prompt for the file to process
	CALL	PRTMSG
	CALL	inprmp	;line input the file name
	RST	2	;see if there is one
	jz	done	;done if no file name given
;

	mvi	a,1	;INPUT
	call	openit
	call	open2
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

done:	call	cls
	jmp	LE9E9

;Exit routines
;
EXITN	LXI	H,NTFND	;if file not found
	CALL	PRTMSG
ERROR	CALL	BEEP	;beep means an error
;
SPACE	LXI	H,PRESS	;say press space bar
	CALL	PRTMSG
	CALL	WAITSP	;wait for it to be pressed
EXIT	JMP	check	;back to QKRCHK menu

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
PRESS	db	'Tap Space Bar to continue',0
FILMS	db	'File to Check <CR to Term>',0
PRINT	db	'Checksum ='
CHKSM	DS	8	;decimal checksum
	DB	$00
;
;data storage
;
BINCK	DS	3	;binary checksum

LF081	DM	File to send 
	DB	0
;
LF08F	DM	Send
	DB	0
;
LF094	DM	File to receive 
	DB	0
;
LF0A5	DM	Receive
	DB	0
;
LF0AD	DB	13
	DB	10
	DM	File found - Ready to send
	DB	13
	DB	10
	DM	waiting...
	DB	0
;
LF0D6	DB	13	;not called in vers 1.00
	DB	10
	db	'     CRC request RECEIVED'
	DB	13
	DB	10
	DB	0
;
LF0F4	DB	13	;not called in vers 1.00
	DB	10
	DM	Checksum request received
	DB	13
	DB	10
	DB	0
;
LF112	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Initial NAK timeout # 
	DB	0
;
LF12E	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Block ACK/NAK timeout # 
	DB	0
;
LF14C	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Block NAKked - resend # 
	DB	0
;
LF16A	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Final ACK timeout # 
	DB	0
;
LF184	DB	13
	DB	10
	DB	10
	DB	7
	db	' Send OK (now in Term mode)'
	DB	13
	DB	10
	DB	0
;
LF1A6	DM	File exists - Overwrite (Y/N) 
	DB	0
;
LF1C1	DB	13
	DB	10
	DM	File open - ready to receive
	DB	13
	DB	10
	DB	0
;
LF1E2	DM	Checksum in effect
	DB	13
	DB	10
	DB	0
;
LF1F7	db	'     CRC in effect'
	DB	13
	DB	10
	DB	0
;
LF20C	DB	27
	DM	M
	DB	13
	DB	9
	DM	Switching to checksum mode
	DB	13
	DB	10
	DB	0
;
LF22D	DM	CRC CkSm
LF235	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Receive timeout # 
	DB	0
;
LF24D	DB	27
	DM	M
	DB	13
	DB	7
	DM	Bad header received - retry # 
	DB	0
;
LF270	DB	13
	DB	10
	DB	7
	DM	Out of memory - file deleted
	DB	13
	DB	10
	DB	0
;
LF292	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	DM	Checksum error # 
	DB	0
;
LF2A9	DB	27
	DM	M
	DB	13
	DB	7
	DB	9
	db	'     CRC error # '
	DB	0
;
LF2C0	DB	13
	DB	10
	DB	10
	DB	7
	db	' Receive OK (now in Term mode)'
	DB	13
	DB	10
	DB	0
;
LF2E5	DB	27
	DM	M
	DB	13
	DB	7
	DM	BREAK key -
	DB	0
;
LF2F5	DB	13
	Db	' XMDPW6 ---- Xmodem Program [7/10/88]'
	DB	13
	DB	10
	db	'  (XMDPW5 with Device File Support)'
	DB	13
	DB	10
	db	'             ---------'
	DB	13
	DB	10
	DB	0
;
;----
Device	db	0
Optype	db	0
;----
BFR	DS	672
;
	END
