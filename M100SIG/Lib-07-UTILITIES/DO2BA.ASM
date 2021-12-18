;DO2BA.SRC by James Yi 73327,1653  June 28, 1988
;Utility that loads a Basic program from text file without the space needed to make the .BA copy.

;Model 100 version: Phil Wheeler -- 71266,125 [6/29/88]

;		M100	 T200
;		-----	-----
	org	62457	;ALT LCD in M200

curbas	equ	$f67c	;$ef67
saveba	equ	$1f1b	;10763 [2a0b]
inxh	equ	$199e	;16808
ommsg	equ	$60B1	;7492h
tick	equ	30326	;36809
cls	equ	16945	;20301
bkgff	equ	$FFA2	;64790
inpbfr	equ	$F681	;61292
buffer	equ	$F681	;61292
basic	equ	$6C49	;33679---
getnum	equ	2283	;2326
fnkmac	equ	$F62C	;$eef9
basdir	equ	63898	;62101
;ramdir	equ	63919	;62122
files	equ	7994	;10794
inpa	equ	17982	;21744
getlen	equ	8698	;11587
getfnm	equ	19467	;23242
finddo	equ	8352	;11197
geteof	equ	$6B2D	;$8268
insert	equ	27501	;33448
mvhci	equ	11997	;15445
mvhbci	equ	27611	;33558
mvhbcd	equ	27622	;33569
beep	equ	16937	;20293
printc	equ	22417	;26526
uptdir	equ	8518	;11362
tokenz	equ	$0646	;1649
;inschr	equ	$6B61	;33436
;pekdir	equ	8396	;11241
;nxtdir	equ	$20D5	;11250
doarea	equ	64430	;63073
frespc	equ	64438	;63081
tdelay	equ	$5316	;6214h
ldbfnk	equ	27804	;33756
Killc0	equ	$1FBF
Kill80	equ	$2017
Kill00	equ	$1FD9

;test memory
	lhld	frespc
	desp	0
	dcr	d	;256 bytes ok?
	rst	3
	jc	memok
	lxi	h,ommsg
	call	printc
	mvi	a,1
	jmp	tdelay

memok:	lxi	h,greet
	call	printc
	call	files
	call	uptdir
filinp:	lxi	h,inpmsg
	call	printc
	call	inpa
	rst	2
	rz
	call	getlen
	call	getfnm
	call	finddo
	jz	filinp
	push	h
	xchg
	shld	filadr

;move file to lowest postion

;get file length
	push	h
	call	geteof
	pop	b
	dsub	b
	inx	h
	push	h
	push	b
	mov	b,h
	mov	c,l
	lhld	doarea
	push	h
	dcx	h
	inx	d
	shlx		;put in lowest position
	dad	b
	shld	filend
	pop	b
	pop	h
	dsub	b
	shld	movlen
	pop	h
	push	b
	jz	convrt	;already lowest
;move in chunks
mvblck:	mov	a,h
	ora	l
	jz	convrt
	inr	h
	dcr	h
	mov	b,h
	mov	c,l
	jz	less256
	lxi	b,256
less256	dsub	b
	push	h
	lhld	filadr
	lxi	d,buffer
	push	b
	push	d
	push	h
	call	mvhci
	shld	filadr
	xchg
	dcx	d
	lhld	movlen
	mov	b,h
	mov	c,l
	pop	h
	dcx	h
	call	mvhbcd
	inx	h
	xchg
	pop	h
	pop	b
	call	mvhci
	pop	h
	jmp	mvblck

;convert to Basic
convrt:	lhld	basdir
	shld	baptr
	pop	h
cnvlin	call	tick
	push	h
pntend	mov	a,m
	sui	26
	jz	endlin
	inx	h
	cpi	13-26
	jnz	pntend
	dcx	h
	mvi	m,0
	inx	h
endlin	sta	endchr
	ora	a
	mvi	m,0
	cnz	inxh
	xthl		;filptr
	push	h
	dcx	h
	rst	2	;Number?
	pop	h
	jc	lineok
;DO error
	jz	noerr
	call	printc
	call	beep
	lda	bkgff
	ani	2	;break?
	jz	noerr
	call	wrbend
	rst	0

noerr	pop	d
	jmp	nxtlin

lineok:	call	getnum
	xchg
	shld	linenm+2	;line #
	xchg
	call	tokenz	;stores tokens at INPBFR

	pop	d	;end of space to store basic tokens
	lhld	baptr	;start of
;store line # and line pointer

	lxi	b,linenm
	mvi	a,4
mvhead	push	psw
	call	makroom
	ldax	b
	mov	m,a
	inx	h
	inx	b
	pop	psw
	dcr	a
	jnz	mvhead

	lxi	b,inpbfr
mvtokn	call	makroom
	ldax	b
	mov	m,a
	inx	h
	inx	b
	ora	a
	jnz	mvtokn
	shld	baptr
;DE=next text line
nxtlin:	xchg
	lda	endchr
	ora	a
	jnz	cnvlin
;write two zero's for BA end marker
	call	wrbend

done:	call	uptdir
	pop	h
	call	kill
	call	ldbfnk
	lhld	basdir
	shld	curbas
	lxi	h,exit
	shld	fnkmac	;activate Fkey
	jmp	saveba

;HL=filend - write two zero's 
wrbend:	lhld	filend
	xchg
	lhld	baptr
	call	makroom
	mvi	m,0
	inx	h
	call	makroom
	mvi	m,0
	inx	h
	shld	doarea
;restore CR,LF,EOF chrs
restore
	rst	3
	jz	wreof
	mov	a,m
	cpi	26
	jz	eraeof
	ora	a
	jnz	noteol
noteof:	mvi	m,13
	inx	h
eraeof	mvi	m,10
noteol:	inx	h
	jmp	restore
wreof:	mvi	m,26
	ret

makroom	rst	3
	rc
	push	d
	push	b
	lxi	b,1
	call	insert
	pop	b
	pop	d
	inx	d
	push	h
	lhld	filend
	inx	h
	shld	filend
	pop	h
	ret

Kill	mov	a,m
	inx	h
	mov	e,m
	inx	h
	mov	d,m
	dcx	h
	dcx	h
	cpi	$c0
	jz	killc0
	cpi	$80
	jz	kill80
	jmp	kill00

greet	db	'  ** Text to Basic Converter **' 13 10
endchr	db	0
inpmsg	db	'Press <CTRL> to break from error.'
	db	13 10 'Load from [<CR>=Exit]'
baptr	dw	0
movlen	dw	0
filadr	dw	0
filend	dw	0
exit	db	'Menu',13
	db	0
linenm	dw	$FF00
	dw	0

