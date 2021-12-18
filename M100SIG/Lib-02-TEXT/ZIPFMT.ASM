;ZIPFMT.ASM (c)1989 Wilson Van Alst			All rights reserved.
;-----------------------
;v1.7  9/6/89
;-----------------------
;	'In place' text formatter for
;	the T200.  Runs in AltLCD area
;	of system RAM.
;	-- use ZIPFIX.BA to modify
;	 this formatter or create new
;	 ones for different layouts.
;-----------------------
;ROM and System RAM addresses:
;
files    equ   10794
opendo   equ   11635
linin?   equ   21744
prnnxt   equ   28158
crlf?    equ   28797
omdump   equ   29832
inschr   equ   33436
makhol   equ   33448
tick     equ   36809
mspacc   equ   40795
linbuf   equ   61296
;-----------------------
;Assigned and derived values:
;	(more at bottom of listing)
left	equ	5
chars	equ	34
top	equ	3
bot	equ	4
space	equ	0
print	equ	59
spcadr	equ	linbuf+20 ;storage
;-----------------------
;*Open document:
	call	files	;show files
	call	prnnxt	;display prompt
	db	'Format',0 ;prompt
	call	linin?	;user input
	rst	2	;null?
	rz		;Y:return
	call	opendo	;N:HL->filetop
	rnc		;no prev. file
;*Start page: insert top margin
nupage	mvi	a,top	;A=top margin
	call	crlfs	;insert lines
;*Start line: insert left margin
nuline	mvi	a,space	;A=linespace
	call	crlfs	;insert CR's
	sta	spcadr+1 ;set flag to 0
lefref	mvi	c,left	;C=left margin
	call	stash	;make room
	inx	d	;adjust pointer
	rst	3	;cmp HL-DE
	cc	mspacc	;insert spaces
;-format line to width
linref	mvi	c,chars	;C=chrs/line
molin	xchg		;DE->chr
	call	crlf?	;CRLF found?
	xchg		;HL->new chr
	jz	tstlin	;if CRLF found
	cpi	26	;eof?
	rz		;Y:all done
	cpi	32	;space?
	jnz	nospac	;N:skip next
	shld	spcadr	;Y:store addrs
nospac	dcr	c	;chr count =0?
	jnz	molin	;N:get more
;-now at max width: word wrap
	lda	spcadr+1 ;Y:A=flag
	ana	a	;is it 0?
	jz	lnglin	;Y:skip next
	lhld	spcadr	;N:HL->last spc
lnglin	cz	inschr	;adjust file
	dcx	h	;adjust pointer
	mvi	m,13	;poke CR
	inx	h	;adjust pointer
	mvi	a,10	;A= LF
	call	inschr	;poke it
;*Check lines/page count:
tstlin	lxi	b,print	;C=max B=count
	inr	b	;adjust count
	mov	a,b	;A=nu count
	sta	lincnt	;store it
	sub	c	;count-max=0?
	jnz	nuline	;N:keep going
	sta	lincnt	;Y:poke count=0
;-insert bottom margin:
botref	mvi	a,bot	;Y:A=bot margin
	lxi	d,nupage ;DE=ret addrs
	push	d	;put on stack
;-general routine for adding CRLF's:
crlfs	add	a	;A=2*A
	rz		;if A=0,go back
	mov	c,a	;C=A
	call	stash	;make room
mocrlf	mvi	m,13	;insert CR
	inx	h	;adjust pointer
	mvi	m,10	;insert LF
	rst	3	;HL=DE?
	inx	h	;adjust pointer
	jnz	mocrlf	;if HL<>DE
	ret		;task done
;-general routine for opening space:
stash	call	tick	;make noise
	mvi	b,0	;BC = C
	call	makhol	;create space
	rnc		;no CY: ok
	jmp	omdump	;else OM error
;-----------------------
;More assigned addresses:
lincnt	equ	tstlin+2 ;lines/page
lefmar	equ	lefref+1 ;for zipfix
linlen	equ	linref+1 ;for zipfix
topmar	equ	nupage+1 ;for zipfix
botmar	equ	botref+1 ;for zipfix
linspa	equ	nuline+1 ;for zipfix
maxlin	equ	tstlin+1 ;for zipfix
;-----------------------
	end
