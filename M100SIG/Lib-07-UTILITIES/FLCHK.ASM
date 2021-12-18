;FLCHK.ASM
;Performs checksums on DO,CO and BA files
;The file length and checksum are both displayed on the screen and saved to a file named CHKSUM.DO
;James Yi 73327,1653 04/26/88
;
;This is the 100/102 version.  Runs in user RAM, NOT in Alt LCD buffer
;due to need to duplicate 200 ROM code not present in M100.
;   Phil Wheeler -- 71266,125
;        6/19/88
;

	org	62405	;NOT Prev buffer

;		M100	 T200
;		----	 ----
maxlen	equ	132	;DO line len
getend	equ	$6b2d	;$8268:point HL to chr$(26)
getlen	equ	$21fa	;11587
fmtfnm	equ	$4c0b	;23242
;sound	equ	36774	;[do in RAM] Sound E,D
insert	equ	$6b6d	;33448
printc	equ	$5791	;26526:print @ clm 1
opendo	equ	$2206	;11635
numstr	equ	$fbe8	;63131:number string stored here when 18187 is called
inpbuf	equ	63109	;61296
getval	equ	$08eb	;2326
;prnlen	equ	27281	;[do in RAM] prints 'xxxxx Bytes'
findfl	equ	$20af	;11212:find all type of file, with extension
resfpt	equ	$2146	;11362
mclear	equ	$6366	;30535:[HL]=0 x BC
print	equ	$11a2	;4556
inpa	equ	$463e	;21744
;len	equ	$6acc	;print 'Length='
om	equ	$60b1	;$7492:'Memory full' string
files	equ	$1f3a	;10794
mvdbi	equ	13417	;16826:[DE]->[HL]xB
;** added for M100
getadr	equ	$5ae3	;get start adr of file
rom1	equ	$05f4
prnhl	equ	$39d4
wrbyt	equ	$4b44
ram1	equ	$f63a
rom2	equ	$765c
rom3	equ	$7676
rom4	equ	$7657

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

;****Added Model 100 code
prnlen:	mov	a,m
	call	getadr
	cpi	$a0
	jz	prn1
	cpi	$b0
	jz	prn2
	cpi	$f0
	jz	prn2
	cpi	$c0
	jz	prn3
	push	h
	xchg
	call	rom1
	pop	d
	mov	a,l
	sub	e
	mov	e,a
	mov	a,h
	sbb	d
	mov	d,a
	dcx	d
	jmp	len

prn3:	mvi	a,$1a
	lxi	d,$ffff
prn4:	cmp	m
	inx	h
	inx	d
	jnz	prn4
	jmp	len

prn1:	inx	h
	inx	h
	mov	e,m
	inx	h
	mov	d,m
len:	xchg
	push	h
	call	prn5
	db	'Length: ',0
	call	prnhl
	call	prn5
	db	' Byte',0
	pop	h
	mov	a,l
	dcr	a
	ora	h
	mvi	a,$73
	cnz	wrbyt
prn2:	lda	ram1
	cpi	$17
	rnc
	mvi	a,$20
	rst	4
	jmp	prn2

prn5:	xthl
	call	prn6
	xthl
	ret

prn6:	mov	a,m
	inx	h
	ora	a
	rz
	rst	4
	jmp	prn6

sound:	push	psw
	push	d
	call	rom2
	mov	b,d
snd2:	call	rom3
	mov	c,e
	call	rom4
	dcr	b
	jnz	snd2
	pop	d
	call	snd3
	pop	psw
	jmp	snd4

snd3:	in	$ba
	ori	$20
	out	$ba
	ret

snd4:	mvi	a,$09
	sim
	ret
;*****

inpmsg:	db	13,10,'File to check' 0
chkmsg:	db	'ChkSum = ' 0
num	ds	8
	db	255
ckfil	db	'CHKSUM',0
fltype	db	0
llen	db	0
