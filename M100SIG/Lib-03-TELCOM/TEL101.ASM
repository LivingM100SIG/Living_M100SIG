;TEL100.ASM -- Source for RAM version of Model 100 TELCOM
;
;New version add macro capability (thanks to Jon Diercks)
;and DIRACC capability (Hugo Ferrerya)
;
;Phil Wheeler  [11/27/87]
;
;Includes split screen modification
;Model 100 version of James Yi's TELCOM.200
;
;Phil Wheeler -- 71266,125 <11/9/87>
;
chkf	equ	$5aab
faddr	equ	$5ae3
beep2	equ	$7662
sndchr	equ	$6E32
getec	equ	$6D7E

;
	ORG	60000	;ARBITRARY, WILL BE RELOCATED.
;***
HILBL	POP	H	;DIRACC exit from Basic (F6 call in Basic)
	INR	L
	CALL	$2C63	
	CALL	$4231	
	JMP	L5468
;***
BEGIN	CALL	$4244	
	ENT	BEGIN
	LXI	HL,$51A4	
	CALL	$42A5	
	JMP	L51C7	
;***
L5152	CALL	$4229	
	LXI	HL,$51A4	
	CALL	$5A7C	
L515B	CALL	$5D53	
	LXI	HL,L5152	
	SHLD	$F652	
	LXI	HL,$517C	
	CALL	$5791	
	CALL	$4644	
	RST	2	
	ANA	A	
	JZ	L515B	
	LXI	DE,L5185	
	CALL	$6CA7	
	JZ	L5152	
	RET		
;***
L5185	DM	STAT
	DW	L51C0
	DM	TERM
	DW	L5455
	DM	CALL
	DW	L522F
	DM	FIND
	DW	L524D
	DM	MENU
	DW	$5797
	RST	7
;
L51C0	DCX	HL	
	RST	2	
	INR	A	
	DCR	A	
	JNZ	L51ED	
L51C7	LXI	HL,$F65B	
	MVI	B,$05	
L51CC	MOV	A,M	
	RST	4	
	INX	HL	
	DCR	B	
	JNZ	L51CC	
	MVI	A,$2C	
	RST	4	
	LDA	$F62B	
	RRC		
	MVI	A,$32	
	SBB	B	
	RST	4	
	LXI	HL,$51E7	
	CALL	$27B1	
	JMP	L515B	
;***
L51ED	JC	L51FE	
	CPI	$2C	
	JZ	L520A	
	CALL	$0FE9	
	CPI	$4D	
	JNZ	L5152	
	INX	HL	
L51FE	CALL	$17E6	
	CALL	$6ECB	
	DCX	HL	
	RST	2	
	ANA	A	
	JZ	L515B	
L520A	RST	1	
	INR	L	
	CALL	$112E	
	CPI	$14	
	JZ	L521A	
	SUI	$0A	
	JNZ	L5152	
	INR	A	
L521A	STA	$F62B	
	JMP	L515B	
;***
L5220	LXI	HL,$5244	
	CALL	$5A58	
	POP	DE	
	CALL	L5284	
	JZ	L5152	
	XCHG		
	DB	$F6	;PATCH MADE HERE FOR CORRECT LABEL POINT
L522F	STC
	PUSH	HL	
	LXI	HL,$5244	
	CC	$5A58	
	POP	HL	
	CALL	L532D	
	JC	L5152	
	JNZ	L515B	
	JMP	L5468	
;***
L524D	SUB	A	
	CALL	$5DB1	
	PUSH	HL	
	CALL	$5AA6	
	JZ	L5152	
	CALL	$5AE3	
	XCHG		
	POP	HL	
L525D	CALL	$5C3F	
	JNC	L515B	
	PUSH	HL	
	PUSH	DE	
	CALL	$5DC5	
	CALL	L5284	
	CNZ	L5292	
	CALL	$4222	
	CALL	$5C7F	
	JZ	L515B	
	CPI	$43	
	JZ	L5220	
	POP	DE	
	CALL	$5C6D	
	POP	HL	
	JMP	L525D	
;***
L5284	CALL	L52A8	
	RZ		
	RST	4	
	CPI	$3A	
	INX	DE	
	JNZ	L5284	
	JMP	L52AE	
;***
L5292	CALL	L52A8	
	RZ		
	CPI	$3C	
	JZ	L52A3	
	CPI	$3A	
	RZ		
	RST	4	
	INX	DE	
	JMP	L5292	
;***
L52A3	RST	4	
	MVI	A,$3E	
	RST	4	
	RET		
;***
L52A8	CALL	$5C74	
	DCX	DE	
	LDAX	DE	
	RZ		
L52AE	CPI	$1A	
	JZ	L5152	
	RET		
;***
L52B4	IN	$BA	
	ANI	$7F	
	OUT	$BA	
	RET		
;***
L52BB	CALL	L52D8	
	CALL	L5351	
L52C1	IN	$BA	
	ORI	$80	
	OUT	$BA	
	RET		
;***
L52C8	LDA	$FAAE	
	ORI	$01	
	JMP	L52DD	
;***
L52D0	CALL	L52B4	
	MVI	A,$03	
	JMP	L52DD	
;***
L52D8	LDA	$FAAE	
	ANI	$01	
L52DD	STA	$FAAE	
	OUT	$A8	
	STC		
	RET		
;***
L52E4	IN	$BB	
	ANI	$10	
	JZ	L52F9	
	CALL	L52D0	
L52EE	CALL	$729F	
	RC		
	CALL	$6EEF	
	JNZ	L52EE	
	RET		
;***
L52F9	CALL	L52C8	
	CALL	L52B4	
	NOP		
	NOP		
	NOP		
	CALL	L52EE	
	RC		
	MVI	A,$05	
	CALL	L5316	
	CALL	L52D0	
	ANA	A	
	RET		
;***
L5310	XRA	A	
	MVI	A,$05	
L5313	CNZ	L531A	
L5316	DCR	A	
	JNZ	L5313	
L531A	MVI	C,$C8	
L531C	CALL	L5326	
	CALL	L5326	
	DCR	C	
	JNZ	L531C	
L5326	MVI	B,$AC	
L5328	DCR	B	
	JNZ	L5328	
	RET		
;***
L532D	IN	$BA	
	PUSH	AF	
	ORI	$08	
	OUT	$BA	
	CALL	L5359	
	POP	BC	
	PUSH	AF	
	MOV	A,B	
	ANI	$08	
	MOV	B,A	
	IN	$BA	
	ANI	$F7	
	ORA	B	
	OUT	$BA	
	POP	AF	
	RNC		
	CALL	L52BB	
	CALL	L52C8	
	MVI	A,$03	
	CALL	L5316	
L5351	LDA	$FAAE	
	ANI	$02	
	JMP	L52DD	
;***
L5359	XRA	A	
	STA	$FAAE	
	CALL	L52C1	
	CALL	L52C8	
	CALL	L531A	
	CALL	L52D0	
	CALL	L52D8	
	CALL	L5310	
	DCX	HL	
L5370	CALL	$729F	
	RC		
	PUSH	HL	
	XCHG		
	CALL	$5C74	
	DCX	DE	
	LDAX	DE	
	POP	HL	
	JZ	L539E	
	CPI	$1A	
	JZ	L539E	
	RST	2	
	JZ	L539E	
	PUSH	AF	
	CC	L540A	
	POP	AF	
	JC	L5370	
	CPI	$3C	
	STC		
	JZ	L539E	
	CPI	$3D	
	CZ	L5310	
	JMP	L5370	
;***
L539E	PUSH	AF	
	LDA	$F62B	
	RRC		
	CNC	L531A	
	POP	AF	
	JNC	L52BB	
	LDA	$F65B	
	CPI	$4D	
	STC		
	RNZ		
	PUSH	HL	
	LXI	HL,$F65C	
	ANA	A	
	CALL	$17E6	
	MVI	A,$04	
	CALL	L5316	
	POP	HL	
	CALL	L52E4	
	RC		
L53C3	CALL	L5673	
	CALL	L5406	
	RZ		
	CPI	$3E	
	RZ		
	CPI	$3D	
	JZ	L53E7	
	CPI	$5E	
	JZ	L53FD	
	CPI	$3F	
	JZ	L53ED	
	CPI	$21	
	CZ	L5406	
	RZ		
L53E2	CALL	$6E32	
	XRA	A	
	INR	A	
L53E7	CZ	L5310	
	JMP	L53C3	
;***
L53ED	CALL	L5406	
	RZ		
L53F1	CALL	$6D7E	
	RC		
	RST	4	
	CMP	M	
	JNZ	L53F1	
	JMP	L53C3	
;***
L53FD	CALL	L5406	
	RZ		
	ANI	$1F	
	JMP	L53E2	
;***
L5406	INX	HL	
	MOV	A,M	
	ANA	A	
	RET		
;***
L540A	RST	4	
	DI		
	ANI	$0F	
	MOV	C,A	
	JNZ	L5414	
	MVI	C,$0A	
L5414	LDA	$F62B	
	RRC		
	LXI	DE,$161C
	JNC	L5421	
	LXI	DE,$2440	
L5421	CALL	L52C1	
L5424	CALL	L5326	
	DCR	E	
	JNZ	L5424	
	CALL	L52B4	
L542E	CALL	L5326	
	DCR	D	
	JNZ	L542E	
	DCR	C	
	JNZ	L5414	
	EI		
	LDA	$F62B	
	ANI	$01	
	INR	A	
	JMP	L5316	
;***
L5455	LXI	HL,$F65A	
	RST	2	
	CNC	$3457	
	PUSH	AF	
	CALL	$17E6	
	POP	AF	
	CMC		
	CC	L52E4	
	JC	L5739	
L5468	MVI	A,$40	
	STA	$F650	
	STA	$F67B	
	XRA	A	
	sta	jy224	;!!!
	STA	$FAC2	
	STA	$FAC3	
	CALL	$45D3	
	LXI	HL,$5443	
	CALL	$5A7C	
	CALL	$5544	
	CALL	$5556	
	CALL	$5562	
	CALL	$42A8	
	CALL	$4249	
L548F	CALL	$5D5D	
	LXI	HL,L54EF	
	SHLD	$F652	
	LDA	$FF42	
	ANA	A	
	JZ	L54AA	
	LDA	$FF40	
	LXI	HL,$F7D9	
	XRA	M	
	RRC		
	CC	$5562	
L54AA	CALL	$13DB	
	JZ	L54C6	
	CALL	$12CB	
	JC	L54FC	
	MOV	B,A	
	LDA	$F658	
	ANA	A	
	MOV	A,B	
	CZ	$4B44	
	cpi	128	;macro cut-out
	cnc	macro
	push	a	;split screen mod
	call	jy200
	pop	a
	ANA	A	
	CNZ	$6E32	
	JC	L54E2	
L54C6	CALL	$6D6D	
	JZ	L548F	
	CALL	$6D7E	
	JC	L548F	
	RST	4	
	MOV	B,A	
	LDA	$F659	
	ANA	A	
	MOV	A,B	
	CNZ	$4B55	
	CALL	L56C5	
	JMP	L548F	
;***
L54E2	XRA	A	
	STA	$FF40	
L54E6	CALL	$729F	
	JC	L54E6	
	JMP	L548F	
;***
L54EF	CALL	$4229	
	XRA	A	
	STA	$F659	
	CALL	$5556	
	JMP	L548F	
;***
L54FC	MOV	E,A	
	MVI	D,$FF	
	LXI	HL,L551D	
	DAD	DE	
	DAD	DE	
	MOV	A,M	
	INX	HL	
	MOV	H,M	
	MOV	L,A	
	LXI	DE,L548F	
	PUSH	DE	
	PCHL		
L550D	DW	jy129	;PREV
L550F	DW	L567E	;DOWN
L5511	DW	L559D	;UP
L5513	DW	$553E	;FULL/HALF
L5515	DW	$5550	;ECHO
L5517	DW	F6LBL	;Basic entry
L5519	DW	F7LBL	;Text entry
L551B	DW	L571E	;BYE
L551D	RST	7	
	DB	$32
	RET
L5520	RST	7
	DB	$34
	RET		
;***
jy129	lda	$f63d	;new prev  !!!
	ora	a
	jz	$5523	;label on?
	lda	$ff99
	rar
	jnc	$5523	;shift?
	lxi	h,jy224
	inr	m
	mov	a,m
	rar
	jnc	$42ab
	cmc
	jmp	jy215
;***
L559D	LXI	H,L56EF	;UP
	SHLD	$F652	
	PUSH	HL	
	LDA	$FAC2	
	ANA	A	
	RNZ		
	CALL	$2146	
	LXI	HL,$5751	
	CALL	$5791	
	CALL	$463E	
	RST	2	
	ANA	A	
	RZ		
	STA	$FAC6	
	CALL	$21FA	
	CALL	$4C0B	
	RNZ		
	CALL	$208F	
	LXI	HL,$577C	
	JZ	$5791	
	XCHG		
	XTHL		
	PUSH	HL	
	LXI	HL,$670C	
	CALL	$5791	
	CALL	$4644	
	RC		
	RST	2	
	ANA	A	
	MVI	A,$01	
	STA	$FAC3	
	STA	$F920	
	JZ	L55FD	
	CALL	$112E	
	CPI	$0A	
	RC		
	CPI	$85	
	RNC		
	LXI	HL,$F894	
	SHLD	$F892	
	STA	$F922	
	STA	$FAC3	
	POP	AF	
	POP	DE	
	DB	1
L55FD	POP	AF
	POP	HL	
	PUSH	DE	
	PUSH	HL	
	CALL	$5A9E	
	POP	HL	
	POP	DE	
L5606	LDA	$FAC3	
	DCR	A	
	JZ	L562D	
	PUSH	DE	
	XCHG		
	LHLD	$F892	
	XCHG		
	RST	3	
	POP	DE	
	JNZ	L562D	
	CALL	$67DF	
	MOV	A,D	
	ANA	E	
	INR	A	
	JNZ	L562A	
	LHLD	$F892	
	MVI	M,$1A	
	INX	HL	
	SHLD	$F892	
L562A	LXI	HL,$F894	
L562D	MOV	A,M	
	CPI	$1A	
	RST	7	
	MVI	M,$CA	
	MOV	L,H	
	MOV	D,M	
	CPI	$0A	
	JNZ	L5646	
	LDA	$F65A	
	ANA	A	
	JNZ	L5646	
	LDA	$FAC6	
	CPI	$0D	
L5646	MOV	A,M	
	STA	$FAC6	
	JZ	L5653	
	CALL	$6E32	
	CALL	L5673	
L5653	INX	HL	
	CALL	$13DB	
	JZ	L5606	
	CALL	$12CB	
	CPI	$03	
	JZ	L566C	
	CPI	$13	
	CZ	$12CB	
	CPI	$03	
	JNZ	L5606	
L566C	XRA	A	
	STA	$FAC3	
	JMP	$5A9E	
;***
L5673	CALL	$6D6D	
	RZ		
	CALL	$6D7E	
	RST	4	
	JMP	L5673	
;***
L567E	CALL	$2146	;DOWN
	LDA	$FAC2	
	XRI	$FF	
	STA	$FAC2	
	JZ	L56BF	
	LXI	HL,L56E2	
	SHLD	$F652	
	PUSH	HL	
	LXI	HL,$5760	
	CALL	$5791	
	CALL	$463E	
	RST	2	
	ANA	A	
	RZ		
	STA	$FAC6	
	POP	AF	
L56A3	PUSH	HL	
	CALL	$2206	
	JC	L56B7	
	SHLD	$FAC4	
	CALL	$6B2D	
	POP	AF	
	CALL	$634A	
	JMP	$5A9E	
;***
L56B7	XCHG		
	CALL	$1FBF	
	POP	HL	
	JMP	L56A3	
;***
L56BF	CALL	$5A9E	
	JMP	$6383	
;***
L56C5	MOV	C,A	
	LDA	$FAC2	
	ANA	A	
	MOV	A,C	
	RZ		
	CALL	L56FE	
	RZ		
	JNC	L56D8	
	CALL	L56D8	
	MVI	A,$0A	
L56D8	LHLD	$FAC4	
	CALL	$6396	
	SHLD	$FAC4	
	RNC		
L56E2	XRA	A	
	STA	$FAC2	
	CALL	$5A9E	
	LXI	HL,$5768	
	JMP	L56F2	
;***
L56EF	LXI	HL,$5759	
L56F2	CALL	$5791	
	LXI	HL,$5771	
	CALL	$27B1	
	JMP	L548F	
;***
L56FE	MOV	C,A	
	ANA	A	
	RZ		
	CPI	$1A	
	RZ		
	CPI	$7F	
	RZ		
	CPI	$0A	
	JNZ	L5711	
	LDA	$FAC6	
	CPI	$0D	
L5711	MOV	A,C	
	STA	$FAC6	
	RZ		
	CPI	$0D	
	STC		
	CMC		
	RNZ		
	ANA	A	
	STC		
	RET		
;***
L571E	LXI	H,$5786	;BYE
	CALL	$5791	
	CALL	$463E	
	RST	2	
	CALL	$0FE9	
	CPI	$59	
	JZ	L5739	
	LXI	HL,$5771	
	CALL	$5791	
	JMP	L548F	
;***
L5739	XRA	A	
	STA	$F650	
	MOV	L,A	
	MOV	H,A	
	SHLD	$FAC2	
	CALL	$6ECB	
	CALL	$424E	
	CALL	L52BB	
	CALL	$6370	
	JMP	BEGIN	
;***
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
;	call	getec	;wait for echo
;	rst	4	;print character
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


;****
jy200	mov	b,a	;!!!  New Split screen routine
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
	END
