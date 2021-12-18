;PRINTZ.ASM 1/29/85 by Rick Perry [75665,1045]

;Mask high-order bit of characters sent to LPT:
;Intercept <CR>, <LF>, & <FF> and perform page breaks,
;page numbering, line spacing, indentation, character wrapping,
;and optional <LF> patch, and pause between pages.

;Enabled by placing entry address into RST-7,0A vector @HFAE4.
;This RST is invoked at H1470.

;Returns with registers unaltered.  Carry set if Break entered.

;ROM routines:

poper	equ	@H14EE.	;pops b, d, h then returns
prthl	equ	@H39D4.	;print integer (HL)
lpos0	equ	@H4BA5.	;set LPOS=0
printr	equ	@H6D3F.	;send (A) directly to LPT:
			;sets carry on Break
kyread	equ	@H7242.	;scan keyboard
brkck	equ	@H729F.	;check for Break
beep	equ	@H7662.	;BEEP

;RAM addresses:

width	equ	@HF649.	;Width value from Text
lpos	equ	@HF674.	;LPOS value
prevch	equ	@HFAAC.	;previous char printed

	rel		;generate relocatable code

entry	ani	#127.	;zero MSB
	cpi	#13.
	jz	@doit	;<CR>
	cpi	#12.
	jz	@doit	;<FF>
	cpi	#10.
	mvi	a,#13.
	jz	@doit	;change <LF> to <CR>

	lda	@prevch	;restore A
	push	psw	;compare LPOS & Width
	push	h
	lda	@width
	lxi	h,@lpos
	cmp	m
	jnc	@pp	;lpos<=width

	mvi	a,#13.
	call	@doit	;do <CR> since lpos>width
	nop
	nop
	nop
	mvi	m,#1.	;doit returns here, reset lpos=1
	jnc	@pp	;no Break

	pop	h	;Break
	pop	psw
	stc
	xthl
	inx	h
	inx	h
	inx	h
	xthl
	ret		;return to H1475.

pp	pop	h
	pop	psw
	ani	#127.	;zero MSB again

doit	xthl		;replace return address
	inx	h
	inx	h
	inx	h
	xthl
	push	h
	push	d
	push	b
	lxi	h,@exit	;stack exit address
	push	h

	mvi	c,#13.	;C=13 throughout rest of code
	cmp	c
	jz	@c13	;<CR>

	cpi	#12.
	jnz	@printr	;if not <FF> or <CR> then just print it

;here for <FF>

	lda	@count
	ora	a
	rz		;just return if already new page

	mvi	b,#0.
	jmp	@sp	;space to bottom of page

;here for <CR>

c13	call	@cr
	mov	a,m	;count
	inx	h
	cmp	m	;page
	jnc	@newpg

	inx	h	;perform line spacing
	inx	h
	mov	b,m	;space
	inr	b
	dcr	b
	jz	@indent
sp	dcr	b
	jz	@indent
	call	@cr
	mov	a,m	;count
	inx	h
	cmp	m	;page
	jc	@sp

newpg	inx	h
	mov	b,m	;skip
	lda	@bot
	cmp	b	;no page numbering
	jnc	@lp0	;if bot>=skip

	inx	h
	inx	h
	mov	a,m	;num
	ora	a
	jz	@lp0	;no numbers if num=0

	inx	h
	mov	b,m	;bot
	inr	b
	dcr	b
	jz	@skp0
skp	call	@cr	;skip lines before page number
	dcr	b
	jnz	@skp

skp0	call	@indent
	rc
	lda	@width
	rar
	dcr	a
	mov	b,a	;B=(width/2)-1
	xra	a	;clear carry
	call	@lp2	;indent to center of page
	rc
	mvi	a,#'-'
	call	@printr
	rc
	lxi	h,@num	;current page number
	mov	a,m
	inr	m
	mov	l,a
	xra	a
	mov	h,a	;HL = page number

	lda	@prevch
	mov	b,a
	push	b	;save C=13, B=prevch
	call	@prthl
	pop	b
	mov	a,b
	sta	@prevch	;restore prevch

	mvi	a,#'-'
	call	@printr
	rc
	call	@cr
	inx	h
	inx	h
	mov	a,m	;skip
	lxi	h,@bot
	sub	m
	mov	b,a	;B=skip-bot
	jmp	@lp1

lp0	inr	b
lp1	xra	a
	sta	@count	;zero out line count
	dcr	b
	cz	@pause?	;check new page pause?
	rc		;exit on Break
	inr	b
	dcr	b	;fix Z flag
	jz	@indent
	call	@cr
	jmp	@lp1

indent	xra	a	;clear carry
	lda	@margin
	mov	b,a
	inr	b
lp2	dcr	b
	rz		;normal exit here
	mvi	a,#' '
	call	@printr
	rc
	jmp	@lp2


;CR routine -- sends optional <LF>, then <CR>,
;and increments line counter.  On exit HL->count & LPOS=0.
;pops normal return address before exit if Break pressed

cr	pop	d
	def	#H3E.	;mvi a,#
lf	def	#0.	;10 here to send <LF>
	ora	a
	cnz	@printr
	rc
	lxi	h,@count
	inr	m
	mov	a,c	;C=13
	call	@printr
	rc
	push	d
	jmp	@lpos0


;PAUSE? routine -- BEEP and wait for keyboard entry if pause flag set

pause?	lda	@pause
	ora	a
	rz

	push	b
	call	@beep
wait	call	@kyread
	jz	@wait
	pop	b
	jmp	@brkck


exit	lda	@prevch	;restore A
	jmp	@poper	;pops and return


;data area:

pause	def	#0.	;pause between pages flag
count	def	#0.	;line counter
page	def	#58.	;lines printed per page
skip	def	#8.	;lines skipped between pages
space	def	#1.	;line spacing
num	def	#0.	;page number
bot	def	#2.	;lines skipped before page number
margin	def	#4.	;indentation

;*** The End ***
