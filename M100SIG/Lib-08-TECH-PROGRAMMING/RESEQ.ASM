;RESEQ.ASM -- A source for a Model 100 version
;	      of James Yi's RESEQ.200
;
;Custom Software assembler format
;
;Phil Wheeler -- 71266,125
;
;Version 100.0 - 10/30/87
;
	org	60000	;arbitrary (will build relocating loader)
	ent	60000	;entry point to program
	shld	start	;store starting value
	mov	b,h
	mov	c,l
	ora	a
	rz		;quit if step=0
	mov	l,a
	mvi	h,0
	shld	step	;store stepping value
	xra	a
	sta	pass	;reset pass counter
	mov	l,a
	dcx	h
	shld	mem	;memory needed = 0
;
;check if line no. > 65529 might come up
;
	lhld	$f67c	;location of current BA pgm
	xchg
L2a	lxi	h,5
	dad	b
	jc	L18	;ln # >65529
	db	$ed	;hl=[de (load hl from ads in de)
	mov	a,h
	ora	l
	jz	L4	;checks out OK
	xchg		;point to next line #
	lhld	step
	dad	b
	mov	b,h
	mov	c,l
	jnc	L2a	;OK so far
;
L18	mvi	e,5	;line # out of range
	jmp	$45d	;exit with FC error msg
;
;Start of main loop
;
L4	lhld	$f67c	;go to beginning of file
	xchg
;
;see if first or second pass
;
	lda	pass
	inr	a
	sta	pass	;pass=pass+1
	cpi	3	;test second pass done
	jz	L11	;done -- exit
	lhld	mem	;pass 0 or 1; need more memory?
	inr	h
	dcr	h
	jm	L3	;<=0, so not needed
	inx	h	;memory needed, see if avail
	mov	b,h
	mov	c,l
	xchg
	call	$6b6d	;ins
	mvi	e,7
	jc	$045d	;not enuff memory
	call	$6b9f	;del, restore
	xchg
;
;Enter next pass
;
;go thru pgm, find token
L3	call	$7676	;buzzer
	db	$ed	;(hl=[de) all done?
	mov	a,h
	ora	l
	jz	L4	;end of file
	inx	de	;current line no.
	inx	de
	db	$ed	;(hl=[de)
	shld	$fb9f	;print line and err code
	inx	de
	inx	de	;pt to first char in line
;
;get char and test it
;
L6	ldax	d
	inx	d
	ora	a
	jz	L3	;end of line
	lxi	h,L19	;point to token list

L1a	cmp	m	;is token's arg a number?
	inx	h
	jz	L7	;yes
	inr	m
	dcr	m
	jnz	L1a	;none of these
	cpi	58
	jnz	L6
	ldax	d
	cpi	145
	jnz	L6	;no
	inx	d	;yes
;
;get value of ascii string, chk spacing and numerical
;
L7	dcx	d
L17	xchg
L1b	inx	h
	mov	a,m
	cpi	32
	jz	L1b
	dcx	h
	rst	2
	jc	L8	;numerical argument
	xchg
	jmp	L6	;arg not numeric
L8	shld	arg	;remember position of this argument
	dcx	h
	call	$08ec	;get val(arg(str$()))
	xchg
	shld	val	;save the val
;
;go through and find this line
;
	lhld	start
	mov	b,h
	mov	c,l	;reseq line # start
	lhld	$f67c	;start of file
	xchg
;
;find a line and check for eof
;
L9	db	$ed	;hl=[de
	mov	a,h
	ora	l
	mov	l,e
	mvi	e,8
	jz	$4cb	;eof reached, line not fnd, exit with UL err
	mov	e,l
	inx	d
	inx	d
	db	$ed	;look at this line
	push	d
	xchg
	lhld	val
	rst	3	;is this it?
	pop	d
	jz	L10	;found
	inx	d	;not found, look at next line
	inx	d
	call	L16	;point to next line
	lhld	step	;calc resequenced line #
	dad	b
	mov	b,h
	mov	c,l
	jmp	L9
;
;Calc how many bytes it will take to replace with new value
;
L10	mov	h,b	;get str of reseq line nos
	mov	l,c
	call	$39d4
	mvi	a,13
	rst	4
	lxi	b,6	;get string's length
	lxi	h,$fbe8	;first char of string
L1c	dcr	c
	inx	h
	mov	a,m
	cpi	32
	jz	L1c	;skip a space
	shld	char	;store 1st char adrs
	push	b	;remem length
;
;calc diff in length
;
	lhld	arg	;1st char of arg
L1d	dcr	c
	rst	2
	jc	L1d	;pt to last char
	lhld	mem
	dad	b	;add to memory needed
	mov	a,c
	ora	a	;test if diff + or -
	jp	L12	;if +, more mem needed
	db	$08	;-bc (sub bc from hl)
	dcr	b
	dad	b	;convrt to abs vallue
L12	shld	mem	;update memory needed
	pop	d
	lda	pass	;if 2nd pass, reseq lines
	dcr	a
	jz	L13	;1st pass
	lhld	$fbae
	dad	b
	shld	$fbae	;adjust .DO ptr
	lhld	arg	;1st char of arg str$
	push	d	;save str$ len
	jc	L14	;delete
	call	$6b6d	;insert
	jmp	L15
L14	mov	a,c
	xri	255
	mov	c,a
	inr	b
	inx	b
	call	$6b9f	;delete
L15	pop	b
	xchg
	lhld	char
	call	$2edd	;repl arg str$ with new str$
L13	lhld	arg	;check for ON goto ,,,,,,
L1e	rst	2
	jc	L1e	;look at a non-num char
	xchg
	cpi	','
	jz	L17	;if comma, more than one arg
	jmp	L6	not ON, go to next token
;
;If done, adjust line headers and exit
;
L11	lhld	$f67c	;adj line hdr from beginning
	xchg
	lhld	start
	mov	b,h
	mov	c,l
L2b	db	$ed	;hl=[de
	mov	a,h
	ora	l
	jz	$2146	;if done, reset file ptrs & exit
	push	d	;remember prev hdr adrs
	inx	d
	inx	d
	mov	a,c
	stax	d	;[de=a
	inx	d
	mov	a,b
	stax	d
	inx	d	;reseq each line
	lhld	step
	dad	b
	mov	b,h
	mov	c,l
	call	L16	;point to next line
	pop	h
	mov	m,e
	inx	h
	mov	m,d	;poke hdr with next line adrs
	jmp	L2b
L16	ldax	d	;point to end of line
	inx	d
	ora	a
	jnz	L16
	ret
;
;token list
;
L19	db	136
	db	140
	db	205
	db	149
	db	139
	db	137
	db	165
	db	166
	db	147
	db	0
;
;variable storage
;
start	dw	0	;first line number (65534) <-- RESEQ.200 adrs
step	dw	0	;line increment value (65532)
pass	db	0	;pass number (65529)
mem	dw	0	;memory needed (65530)
arg	dw	0	;argument (65525)
val	dw	0	;val of arg (str$) (65523)
char	dw	0	;first char address (65521)
;
	end
