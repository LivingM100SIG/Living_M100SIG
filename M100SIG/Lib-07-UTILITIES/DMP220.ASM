	title	'DMP220 -- model 100 graphic dump to cgp-220'

	maclib	model100

	org	@maxram-0400h

debug	equ	false

dmp220:
	lxi	h,0		;set local stack
	dad	sp
	shld	stack
	lxi	sp,stack
	call	@posit		;get current cursor position
	shld	position	;save it

	sub	a
	lxi	h,workline	;clear work line
	mvi	b,240
clwloop:
	mov	m,a
	inx	h
	mov	m,a
	inx	h
	dcr	b
	jnz	clwloop

	mvi	a,ctl and 'R'	;go to graphics mode
	call	@printr	
	jc	quit

	sub	a		;initialize
	sta	shiftctr
	mvi	b,8		;count lines
prtline:			;print a line
	mvi	c,40
	lxi	d,workline
getbits:
	push	d
	push	b		;save counters
	mvi	a,'Y'
	call	@esca
	pop	b		;get counters
	push	b
	mvi	a,40		;32 + 8
	sub	b		;32 + line
	rst	4
	pop	b
	push	b
	mvi	a,72		;32 + 40
	sub	c		;32 + line
	rst	4

	call	@curson		;turn on cursor
	lxi	b,8*256
delay1:
	dcr	c
	jnz	delay1
	dcr	b
	jnz	delay1
	call	@curoff		;turn off cursor

	pop	b		;get counters
	pop	d		;get pointer to work line
	push	b		;save counters
	mvi	b,6		;6 columns per character
	lxi	h,0ffech	;image of character

getchloop:
	mov	a,m		;get a column

	inx	h
	push	h		;save pointer to image
	push	b		;save column counter
	mov	l,a
	mvi	h,0
	lda	shiftctr	;how much to shift
	ora	a		;zero?
	jz	noshift

shiftcol:
	dad	h
	dcr	a
	jnz	shiftcol

noshift:
	ldax	d		;get col
	mov	c,a
	inx	d
	ldax	d
	mov	b,a

	dad	b
	mov	a,h		;store col
	stax	d
	dcx	d
	mov	a,l
	stax	d
	inx	d		;advance to next col in work line
	inx	d

	pop	b		;get bit image counter
	pop	h
	dcr	b
	jnz	getchloop	

	pop	b		;get position counters
	dcr	c
	jnz	getbits

	push	b		;save position counter
	call	putline		;put out a graphics line
	lxi	h,shiftctr	;update shift counter
	mov	a,m
	inr	a
	ani	7		;mod 8
	mov	m,a
	cz	putline		;put another line if possible
	pop	b
	dcr	b
	jnz	prtline
	call	putline

	mvi	a,1eh		;get out of graphics mode
	call	@printr

quit:
	mvi	a,'Y'
	call	@esca
	lhld	position
	mvi	a,32
	add	l
	push	h
	rst	4
	pop	h
	mvi	a,32
	add	h
	rst	4

	lhld	stack		;reset stack
	sphl
	ret

putline:			;put graphics line to printer
	lxi	h,workline
	mvi	b,240
putline1:
	mov	a,m		;put a char
	push	h		;save line pointer
	push	b		;save line counter
	ori	80h
	call	@printr
	jc	quit
	pop	b		;get line counter
	pop	h		;get line pointer
	mov	e,m
	inx	h
	mov	d,m
	mvi	m,0
	xchg			;shift unused part to low order
	dad	h
	xchg
	dcx	h
	mov	m,d
	inx	h		;update line pointer
	inx	h
	dcr	b
	jnz	putline1
	mvi	a,cr		;put a return
	call	@printr
	ret

	if	debug
putaddr:
	push	d
	push	b
	push	psw
	push	h
	mov	a,h
	call	puthbyte
	pop	h
	push	h
	mov	a,l
	call	puthbyte
	mvi	a,' '
	rst	4
	pop	h
	pop	psw
	pop	b
	pop	d
	ret

puthex:
	push	h
	push	d
	push	b
	push	psw
	call	puthbyte
	mvi	a,' '
	rst	4
	pop	psw
	pop	b
	pop	d
	pop	h
	ret

puthbyte:
	push	psw
	rar
	rar
	rar
	rar
	call	hexdig
	pop	psw
hexdig:	ani	0fh
	adi	'0'
	cpi	'9'+1
	jc	@lcd
	adi	'A'-'9'-1
	rst	4
	ret

wbuff:	ds	8
	endif

shiftctr:
	ds	1
position:
	ds	2
workline:
	ds	2*240

	ds	256
stack:	ds	2

	end	dmp220
