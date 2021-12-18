;FLCHK.ASM
;Performs checksums on DO,CO and BA files
;The file length and checksum are both displayed on the screen and saved to a file named CHKSUM.DO
;James Yi 73327,1653 04/26/88
;
;
	org	$f856	;Prev buffer
maxlen	equ	132	;DO line len
getend	equ	$8268	;point HL to chr$(26)
getlen	equ	11587
fmtfnm	equ	23242
sound	equ	36774	;Sound E,D
insert	equ	33448
printc	equ	26526	;print @ clm 1
opendo	equ	11635
numstr	equ	63131	;number string stored here when 18187(print HL) is called
inpbuf	equ	61296
getval	equ	2326
prnlen	equ	27281	;prints 'xxxxx Bytes'
findfl	equ	11212	;find all type of file, with extension
resfpt	equ	11362
mclear	equ	30535	;[HL]=0 x BC
print	equ	4556
inpa	equ	21744
len	equ	$6acc	;print 'Length='
om	equ	$7492	;'Memory full' string
files	equ	10794
mvdbi	equ	16826	;[DE]->[HL] x B

;Begin program
beg:
	call	files	;display files
entfil:
	call	resfpt
;clear chksum counter
	lxi	h,num
	lxi	b,8
	call	mclear
;enter file name
	lxi	h,inpmsg
	call	print
	call 	inpa
	rst	2
	rz		;CR=exit
	jc	chkmem	;numbers instead of file name: checksum on memory
	call	getlen
	call	fmtfnm
	call	findfl
	jz	entfil
	mov	a,m
	push	a
	push 	d
	call	prnlen	;prints file length and returns the length in HL
	mov	b,h
	mov	c,l
	pop	d
	pop	a
	sta	fltype
;handle each type of file seperately
	cpi	192
	jz	DOfile
	cpi	160
	jz	cofile

;BAsic file
bafile:	lhlx
	mov	a,h	;end of BA?
	ora	l
	jz	dispcs	;then exit chk
	inx	d	;skip two byted
	inx	d	;line pointer
	inx	d	;and line num
	inx	d
;get rest of the line
l1	ldax	d
	inx	d
	ora	a	;end of line?
	jz	bafile	;get next line
	dcx	d
	call	addcs
	jmp	l1


cofile:	inx	d		;skip parameter
	inx	d		;bytes
	inx	d
	inx	d
	inx	d
	inx	d
	jmp	dofile


;Check memory area Top-End
chkmem:	push	h
comma:	rst	2
	jc	comma	;get comma
	xra	a
	sta	fltype
	mov	m,a
	xchg
	pop	h
	push	d
	call	getval	;convert Top to binary
	pop	h
	mvi	m,','
	push	d
	call	getval+1	;convert End to binary
	xchg
	pop	b
	push	b
	dsub	b
	inx	h
	push	h
	xchg
	call	len
	pop	b
	pop	d


dofile:	mvi	a,maxlen+1
	sta	llen
l2	mov	a,b
	ora	c
	jz	dispcs
	call	addcs
	jmp	l2

;add [DE] to checksum counter.
addcs:	dcx	b
	lda	fltype
	cpi	192
	ldax	d
	inx	d
	jnz	notdo
;check for line len and grph chrs on a dofile
	lxi	h,llen
	cpi	13
	jz	eol
	push	d
	push	b
	push	a
	ora	a
	cm	high	;grph chr=make high tone noise
	dcr	m
	cz	low	;line too long=make low tone noise
	pop	a
	pop	b
	pop	d


notdo:	push	b
	mov	b,a
dec:	lxi	h,num+7
	mov	a,b
	ora	a
	pop	b
	rz
	push	b
	mov	b,a
	mvi	c,1
	cpi	10
	jc	sub
	dcx	h
	mvi	c,10
	cpi	100
	jc	sub
	mvi	c,100
	dcx	h
sub	inr	m
	sub	c
	jnc	sub
	add	c
	mov	b,a
	dcr	m
ovf	mov	a,m
	cpi	10
	jc	dec
	sui	10
	mov	m,a
	dcx	h
	inr	m
	jmp	ovf
;CR - check for LF
eol:	ldax	d
	cpi	10
	rnz
	inx	d
	dcx	b
	mvi	m,maxlen+1
	ret

;display chksum and record it into CHKSUM.DO
dispcs:	lxi	h,inpbuf
	push	h
	call	getlen
	mvi	d,0
	dad	d
	mvi	m,':'
	inx	h
	lxi	d,numstr	;file len string
	mvi	b,6
	call	mvdbi
	mvi	m,'/'
	inx	h
	xchg
	lxi	h,chkmsg
	call	print
	lxi	h,num-1
l3:	inx	h
	mov	a,m
	ora	a
	mvi	a,48
	jm	endnum
	jz	l3
l4	mov	a,m
	inx	h
	adi	48
endnum:	rst	4
	stax	d
	inx	d
	mov	a,m
	inr	a
	jnz	l4
	xchg
	mvi	m,13
	inx	h
	mvi	m,10
	pop	b
	dsub	b
	push	b
	mov	b,h
	mov	c,l
	inx	b
	push	b
	lxi	h,ckfil
	call	opendo
	call	getend
	pop	b
	call	insert
	pop	d
	jnc	memok
;no room to put checksum
	lxi	h,om
	call	printc
	jmp	entfil
memok:	mov	b,c
	call	mvdbi
	jmp	entfil
;high tone beep
high:	lxi	d,256*30+30
	jmp	sound
;low tone beep
low:	lxi	d,256*30+200
	jmp	sound

inpmsg:	db	13 10 'File to check' 0
chkmsg:	db	'CheckSum = ' 0
num	ds	8
	db	255
ckfil	db	'CHKSUM' 0
fltype	db	0
llen	db	0
