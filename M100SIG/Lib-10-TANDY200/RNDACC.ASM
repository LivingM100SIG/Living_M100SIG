;RNDACC.CO
;RaNDom access text FILe data
;Copyright (C) Apr. 5, 1989
;James Yi 73327,1653
;
;retrieve/insert/delete/replace/append records anywhere in a text file
;through a pair of CALL statements from BASIC
;
;See RNDACC.DOC in DL10 for how to use the program.
;RNDACC.200(DL10) and RNDACC.100(DL7) are the programs.
;
;
;Begin
md	equ	2
	if	md=2	;Tandy 200
	org	$f856	;Altlcd
;200 ROM routines:
ERROR	EQU	488H
BSERR	equ	57AAH
EFERR	equ	5F1AH
FCERR	equ	906H
MOERR	equ	483H
GETFNM	EQU	5ACAH
FINDDO	EQU	2BBDH
OPENDO	EQU	2D73H
DELETE	EQU	82DAH
INSERT	EQU	82A8H
UPTDIR	EQU	2C62H
MVDBI	EQU	41BAH
MVHCI	EQU	3C55H
ASGVAR	EQU	9F4H
VARTYP	EQU	F618H
NUMSTR	EQU	F69BH
PRNHL	EQU	470BH
	endif

	if	md=1	;Model 100
	org	F5F0H-472	;MAXRAM-pgm length
;100 ROM routines:
;		100	200
;		-----	-----
ERROR	EQU	45Dh	488H
BSERR	equ	48F6h	57AAH
EFERR	equ	5063h	5F1AH
FCERR	equ	8DBH	906H
MOERR	equ	458H	483H
GETFNM	EQU	4C0BH	5ACAH
FINDDO	EQU	20A0H	2BBDH
OPENDO	EQU	2206H	2D73H
DELETE	EQU	6B9FH	82DAH
INSERT	EQU	6B6DH	82A8H
UPTDIR	EQU	2146H	2C62H
MVDBI	EQU	3469H	41BAH
MVHCI	EQU	2EDDH	3C55H
ASGVAR	EQU	9C9H	9F4H
VARTYP	EQU	FB65H	F618H
NUMSTR	EQU	FBE8H	F69BH
PRNHL	EQU	39D4H	470BH
	endif
;
;
first_call:		;define string
	jmp  call1
second_call:		;execute commnd
	xchg
;check if first call was called
	mov	b,a
	lxi	h,call1_flag
	mov	a,m
	ani	$1f
	jz	moerr
	mov	a,m
	mvi	m,0
	inx	h
	mov	m,a	;eorchr
;validate commands
	mov	a,b
	cpi	8
	jnc	fcerr
;record number in DE
;get file location
	lhld	file
;execute
	sta	-2	;rem command
	dcr	a	;1
	jz	read_record
	dcr	a	;2
	jz	insert_record
	dcr	a	;3
	jz	delete_record
	dcr	a	;4
	jz	replace_record
	dcr	a	;5
	jz	append_record
	dcr	a	;6
	jz	delete_empty
	dcr	a	;7
	jz	check_stat

;0 - select file
select_file:
	lhld	string_loc
	lda	string_len
	mov	e,a
	call	opendo+3
	shld	file
	ret

;1 - read record
read_record:
	call	goto_recordc
	push	h
	call	goto_eor
	push	b
	mov	l,c
	mvi	h,0
;use SPACE$() function to set up variable space
	call	prnhl+4
	lxi	h,numstr+3
	lxi	d,spaces+2
	mvi	a,3
	sta	vartyp
	mov	c,a
	call	mvhci
	lhld	varptr
	push	h
	lxi	d,spaces
	call	asgvar
	pop	d
	inx	d
	lhlx
	xchg
	pop	b
	pop	h
	mov	a,c
	ora	a
	rz
	jmp	mvhci

;2 - insert a record
insert_record:
	call	goto_record
	call	ir1
;insert eor chr
	lxi	d,eors
	mvi	c,2
	lda	eorchr
	ani	$e0
	jz	ir3	;eor = CR+LF
;insert spc,tab,comma,or period
	rlc
	rlc	;divide by 32
	rlc
	cpi	5
	jnc	fcerr
	dcr	c
	inx	d
;get eor chr
ir2	inx	d
	dcr	a
	jnz	ir2
ir3	push	d
	call	insert
	pop	d
ir4	ldax	d
	mov	m,a
	inx	d
	inx	h
	dcr	c
	jnz	ir4
	ret


;3 - delete a record
delete_record:
	call	goto_recordc
	push	h
	call	goto_eor
	call	past_eol
	pop	b
	push	b
	dsub	b
	mov	b,h
	mov	c,l
	pop	h
	jmp	delete


;4 - replace record
replace_record:
	call	goto_recordc
	push	h
	call	goto_eor
	pop	h
	push	h
	mvi	b,0
	call	delete
	pop	h
	jmp	ir1
;5 - append to record
append_record:
	call	goto_recordc
	call	goto_eor
	jc	ir1
	dcx	h
;insert string
ir1	lda	string_len
	mov	c,a
	mvi	b,0
	ora	a
	rz
	call	insert
	mov	b,c
	xchg
	lhld	string_loc
	xchg
	jmp	mvdbi

;6 - delete all empty(length=0) records
delete_empty:
cmd6:	cnz	past_eol
cmd6b	call	goto_eor
	rc		;EOF
	mov	a,c
	ora	a	;test length
	jnz	cmd6
;delete it
;eor chr is length in B
	mov	c,b
	mvi	b,0
	dcx	h
	push	h
	call	delete
	pop	h
	jmp	cmd6b

;8 - get record count,length,location
check_stat:
	push	d
	call	goto_record
	sbb	a
	sta	-1
	xthl
	inx	d
	mov	b,d
	mov	c,e
	dsub	b
	shld	-4	;record count
	pop	h
	shld	-8	;location
	push	h
	call	goto_eor
	pop	b
	dsub	b
	dcx	h
	shld	-6	;length
	ret


;<goto record #DE
goto_recordc:
	call	goto_record
	rnc
	jmp	bserr
gr1	call	past_eol
goto_record:
	dcx	d
	mov	a,d
	ora	e
	jz	test_eor
;next record
	call	goto_eor
	jnc	gr1
	mov	a,c
	cpi	1
	rc
	stc
	dcx	d
	ret
;>

;<skip CR in CR+LF pair
;B=eor length
past_eol:
	mov	a,b
	cpi	2
	rnz
	inx	h
	ret
;>

;<goto end of record
;DE=record
;return length of record in C, length of eor in B
goto_eor:
	mvi	c,0	;initilize length to 0
ge1	call	test_eor
	rc
	inx	h
	rz
	inr	c
	jnz	ge1
;keep record length less than 256
	dcr	c
	jmp	ge1
;>

;<test for EOR chr at HL
test_eor:
	mvi	b,1	;eor chr length
tcrlf	lda	eorchr
	rar
	jnc	tspc
	inr	b	;CR,LF pair
	mov	a,m
	cpi	13
	rz
	dcr	b
tspc	lda	eorchr
	ani	2
	jz	ttab
	mov	a,m
	cpi	32
	rz
ttab	lda	eorchr
	ani	4
	jz	tcomma
	mov	a,m
	cpi	9
	rz
tcomma	lda	eorchr
	ani	8
	jz	tper
	mov	a,m
	cpi	','
	rz
tper	lda	eorchr
	ani	16
	mov	a,m
	jz	teof
	cpi	'.'
	rz
;test for EOF
teof	dcr	b
	cpi	26
	stc
	rz
	cmc
	ret
;>


;first call from BASIC
call1:	sta	call1_flag
	shld	varptr
	mov	a,m
	sta	string_len
	inx	h
	xchg
	lhlx
	shld	string_loc
	mov	c,a
	inr	c
chkic:	dcr	c
	rz
	mov	a,m
	cpi	127
	jz	eferr
	cpi	26
	jz	eferr
	inx	h
	jmp	chkic


file	dw	0
varptr	dw	0
string_len db	0
string_loc dw	0
call1_flag db	0
eorchr	db	0
eors	db	13,10,32,9,',','.'
;SPACE$()
spaces	db	fbh,'(000)',0
