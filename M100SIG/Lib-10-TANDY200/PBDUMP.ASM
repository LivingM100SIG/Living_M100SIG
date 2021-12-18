;PBDUMP - paste buffer dumper
;By James Yi [73327,1653]
;9-14-90

v	equ	2	;1=100,2=200 version
	field	2-v	;select right EQU value for the 100/200
ALTLCD	Equ	F7B0H	FCC0H
	org	altlcd
	top	60000	;to loadm at safe location below system ram
			; while making the loader.

;System ref	200	100
;		---	---
POPH	Equ	1607H	14F0H
UPTDIR	Equ	2C62H	2146H
PRMLCD	Equ	FA30H	FE00H
MVHBCI	Equ	8316H	6BDBH
PASDIR	Equ	F29FH	F9A4H
PRNSTRN	Equ	679EH	5791H
GETLEN	Equ	2D43H	21FAH
FMTFNM	Equ	5ACAH	4C0BH
OPENDO	Equ	2D73H	2206H
LINPUT	Equ	54F0H	463EH
prmlcdsiz equ	640	320

start:	call	uptdir ;be sure file pointers are ok
;get dump file name
	lxi	h,dumpto
	call	prnstrn
	call	linput
	rst	2
	rz
	call	getlen
	call	fmtfnm
;open dump file, get dump location
	call	opendo
	call	geteof
	push	h
;get paste buffer location,length
	lhld	pasdir+1
	call	geteof
	dsub	b
	xchg
	mov	h,b
	mov	l,c
;move PB to file -
; move in chunks, out of paste buffer, to a scratch space, then into file.
l3	mov	a,h
	ora	l
	jz	poph	;done
;get chunk size =< screen buffer size
	lxi	b,prmlcdsiz
	dsub	b
	jnc	l2
	dad	b
	mov	b,h
	mov	c,l
	lxi	h,0
l2	xthl
	push	h
	xchg
;move chunk to scratch space
	lxi	d,prmlcd
	push	b
	call	mvhbci
	pop	b
	pop	d
	push	h
	push	b
;delete out of paste buffer, make space in file
	push	h
	dsub	b
	pop	b
l4	dcx	b
	dcx	h
	mov	a,m
	stax	b
	rst	3
	jnz	l4
;move into file
	pop	b
	lxi	h,prmlcd
	call	mvhbci
	pop	h
	xchg
	xthl
	jmp	l3

;get end of file location, file length
geteof:	lxi	b,ffffh
	mvi	a,26
l1	inx	b
	cmp	m
	inx	h
	jnz	l1
	dcx	h
	ret


dumpto	db	'Dump to',0

