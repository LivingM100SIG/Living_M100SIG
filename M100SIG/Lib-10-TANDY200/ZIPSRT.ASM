;ZIPSRT (c)1989 Wilson Van Alst
;	   All rights reserved.
;--------------------------------------
;Rom Calls:
;	     T200	;M100
getval  equ 02326 ;02283
files   equ 10794 ;07994
opendo  equ 11635 ;08710
cls     equ 20301 ;16945
togvid  equ 21349 ;17786
linin?  equ 21744 ;17982
prtbuf  equ 28150 ;23128
prnnxt  equ 28158 ;no M100 equ
nexrec  equ 28790 ;23661
getend  equ 33384 ;27437
makhol  equ 33448 ;27501
masdel  equ 33498 ;27551
mvhdb  equ 33569 ;27622
memory  equ 63081 ;64438
altbuf  equ 63574 ;64704
;
;Assigned addresses
toprec	equ	movit+1
filtop	equ	toplod+1
movrec	equ	movlod+1
maxbuf	equ	maxlod+1
column	equ	compar+1
;--------------------------------------
	org	altbuf
;
	call	files	;display files
	call	prompt	;user input
	db	'sort',0 ;prompt string
	rz		;if null entry
	call	cls	;clear screen
	xra	a	;A=0
basic	;spot for BASIC entry
	push	psw	;save A
	call	opendo	;set HL->file
	pop	d	;D has former A
	rnc		;file no good
;
	shld	filtop	;store file adr
;----------------------
	mov	e,d	;E=former A
	mvi	d,0	;D=0
	jmp	eval	;check input
;
cycle	shld	filtop	;set sort top
mosho	mov	a,m	;A=chr
	cpi	26	;eof?
	rz		;yes:done
	rst	4	;print chr
	inx	h	;adjust pointr
	cpi	10	;eol?
	jnz	mosho	;no print more
;HL now points to start of =next= rec
	push	h	;save addrs
;
	mvi	b,8	;set counter
ruler	call	prnnxt	;print ruler
	db	197,197,197,197,168,0
	dcr	b	;decrease count
	jnz	ruler	;no 0: loop
;
	call	prompt	;get input
	db	'col',0	;prompt string
	call	getval	;DE=bin of(HL+)
;
	pop	h	;HL->next rec
eval	mov	a,e	;is DE
	ora	d	;    = 0?
	jz	cycle	;yes:set top
;
	dcx	d	;adjust DE
	xchg		;HL=DE
	shld	column	;store it
;
;put CRLF at end of file
	xchg		;HL->file
	call	getend	;set HL->eof
	lxi	b,2	;make 2 spaces
	call	makhol	;
	mvi	m,13	;insert CR
	inx	h	;    and
	mvi	m,10	;      LF
;
;calculate max buffer size
	lhld	memory	;HL->free mem
	push	h	;save addrs
	lxi	h,-50	;HL= -50
	dad	sp	;HL= stack-50
	pop	b	;BC->free mem
	dsub	b	;HL=stk-free-50
	shld	maxbuf	;store buf size
;
;test file
	lhld	filtop	;HL->file start
nutest	push	h	;save Rec1
	call	getrec	;set HL->Rec2
	pop	b	;BC->Rec1
	jz	testok	;eof=test end
	dsub	b	;HL=R1 size
	xchg		;DE=size
maxlod	lxi	h,00	;HL=buf size
	rst	3	;cmpar HL-DE
	rc		;if rec too big
	lhld	column	;HL=column size
	rst	3	;cmpar HL-DE
	rnc		;if col too big
	lhld	toprec	;HL->next rec
	jmp	nutest	;check more
;
testok	lhld	filtop	;HL->sort start
;-----------------------
scan	mov	e,l	;set DE
	mov	d,h	;     -> R1
	call	getrec	;HL->R2
	rz		;if eof
	call	compar	;(HL)-(DE)
	lhld	toprec	;HL->R2
	jnc	scan	;look again
;if it falls through, R2<R1, and we
; will move R2
	call	togvid
	shld	movrec	;store R2 adrs
	xchg		;DE->R2
	lhld	memory	;HL->buffer
	push	h	;store buf adr
	call	mov2lf	;mov DE to HL
	push	d	;save slot end
;
toplod	lxi	h,00	;>filtop<
	shld	toprec	;put in toprec
;
scan2	xchg		;DE->top rec
movlod	lxi	h,00	;>movrec<
	call	compar	;(HL)-(DE)
	cnc	getrec	;if smaller,
	jnc	scan2	;    loop
;
movit	lxi	b,00	;>toprec<
	lhld	movrec	;HL->blokend+1
	push	h	;save addrs
	dsub	b	;HL=block size
	mov	c,l	;move size
	mov	b,h	;  to BC
	pop	h	;HL->blokend+1
	dcx	h	;adjust
	pop	d	;DE->slot end
	call	mvhdb	;mv blk to slot
;
	pop	d	;DE->buffer
	lhld	toprec	;HL->open spot
	push	h	;save for scan
	call	mov2lf	;move DE to HL
	pop	h	;HL->scan start
	jmp	scan	;look again
;
compar	lxi	b,0	;>BC=column
	dad	b	;HL=R2+col
	xchg		;HL=R1,DE=R2+cl
	dad	b	;HL=R1+col
mocomp	ldax	d	;A=Chr2
	cmp	m	;Chr2-Chr1
	rnz		;if not equal
	cpi	13	;is it eol?
	rz		;yes:return
	inx	h	;no:adjust
	inx	d	; pointers
	jmp	mocomp	;  and loop
;----------------------
getrec	xchg		;DE=HL
	call	nexrec	;DE->next rec
	xchg		;HL->next rec
	shld	toprec	;store HL
monul?	mov	a,m	;A=nexrec chr
	cpi	26	;eof?
	rz		;yes:Zflag set
	cpi	13	;another CRLF?
	rnz		;no:return
	lxi	b,2	;yes:
	call	masdel	; delete it
	jmp	monul?	;  & chk again
;
mov2lf	ldax	d	;A=(DE)
	mov	m,a	;poke to (HL)
	cpi	10	;is it eol?
	rz		;yes:return
	inx	h	;no:adjust
	inx	d	; pointers
	jmp	mov2lf	;  and loop
;
prompt	xthl		;HL->string
	call	prtbuf	;print it
	xthl		;for return
	call	linin?	;user input
	rst	2	;adjHL,chk null
	ret		
;
	end
