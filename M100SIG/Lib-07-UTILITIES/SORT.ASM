;SORT 6/7/84 by Rick Perry 75665,1045

; This is the source code for the sort routine
; contained in the programs: ALARMS.100 & SORT.LDR

; The algorithm is a 'bubble sort' designed to sort a RAM .DO file
; in place. File can have variable length lines, with line length
; up to 255 chars, including <CR><LF>.

; Calling syntax:   CALL ENTRY,0,VARPTR(Z)
;  where  Z  is an integer variable, which on return
;  will be set to  0  for success,
;		   1  for 'file not found',
;		   2  for 'line too long'.

; The .DO file name must be read in advance by a LINE INPUT

chkdc	equ	5AABH	; lookup file in RAM Dir
gtxttb	equ	5AE3H	; get pointer to start of file
cls	equ	4231H	; clear screen
upcase	equ	0FE8H	; convert (M) to uppercase
buf	equ	0F685H	; start of LINE INPUT buffer

; Info on the block move ROM routines, called by absolute
; hex address here, appears at the end of this file.

	rel		; produce relocatable object

dotyp	db	'.DO',0

entry	mvi	m,1	; assume 'file not found'
	shld	flag

	lxi	h,buf	;HL -> file name
	push	h
	dcx	h

lp1	inx	h	;make file name uppercase
	call	upcase
	mov	m,a
	cpi	'.'
	jz	do
	ora	a
	jnz	lp1

do	lxi	d,dotyp	;put in .DO extension
	mvi	b,4
	call	3469H

	pop	d	;try to lookup file in Dir
	mvi	a,10
	call	chkdc
	rz		;failure exit for 'file not found'

	call	gtxttb	;get pointer to start of file
	shld	start
	lhld	flag
	mvi	m,0	;set flag for 'success'

;during the main loop, DE will point to start of line with length C
;		       HL will point to following line with length B

mainlp	xra	a	;start a pass
	sta	done	; (done) will remain 0 if no swaps needed
	lhld	start
	push	h
	call	getnxt
	shld	next	;(next) holds start address of next line
	pop	h

lp2	xchg		;this loop advances through the file
	mov	c,b	;line by line.
	lhld	next
	push	h
	call	getnxt
	shld	next
	pop	h
	mov	a,b
	ora	a
	jz	endlp	;pass finished when next line is zero length
	push	b
	push	d
	push	h
	call	compare	;will set carry if lines out of order
	pop	h
	pop	d
	pop	b
	cc	switch	;swap the lines
	jmp	lp2

endlp	lda	done
	ora	a
	jnz	mainlp
	ret

;I find it difficult to properly comment the following switch routine.
;It not only swaps the two current lines, but also sets the current
;line pointer, HL, and length, B, to continue the flow of the main loop.
;See end of file for info on the block move ROM routines.

switch	push	b
	push	h
	lxi	d,buf
	call	2542H	;move one line to buffer
	pop	d
	xchg
	inr	c
	call	2EE8H	;replace one line...
	lxi	d,buf
	pop	b
	inr	b
	call	346CH	;then the other
	mov	b,c
	mvi	a,255	;set (done) nonzero to indicate
	sta	done	;swap was performed
	ret

compare	xchg		;on return, carry set if swap needed
comp1	ldax	d
	cmp	m
	rnz
	inx	d
	dcr	b
	rz
	inx	h
	dcr	c
	jnz	comp1
	ret

getnxt	mvi	b,0	;get pointer to next line (HL)
			;and length of current line (B)
nxt2	mov	a,m
	cpi	26	;^Z = EOF
	rz
	inx	h
	inr	b
	jz	toolong	; B>255
	cpi	13
	jnz	nxt2	;line ends with <CR>...
	mov	a,m
	cpi	10	;optionally followed by <LF>
	rnz
	inx	h
	inr	b
	rnz

toolong	call	cls
	pop	d	;unstack normal return address from getnxt.
	pop	h	;pointer to current line, was stacked
	mvi	b,100	;before call to getnxt.
t2	mov	a,m
	rst	4	;just display first 100 chars
	inx	h
	dcr	b
	jnz	t2
	lhld	flag
	mvi	m,2	;failure exit, 'line too long'
	ret

done	ds	1	;data storage areas
flag	ds	2
start	ds	2
next	ds	2

;*** END OF ASSEMBLY SOURCE ***

;BLOCK MOVE ROUTINES
;various entry points to the following ROM code are used in SORT:

2542  MOV   A,M
2543  STAX  D
2544  INX   H
2545  INX   D
2546  DCR   B
2547  JNZ   2542
254A  RET

2EE6  MOV   A,M
2EE7  STAX  D
2EE8  DCX   H
2EE9  DCX   D
2EEA  DCR   C
2EEB  JNZ   2EE6
2EEE  RET

3469  LDAX  D
346A  MOV   M,A
346B  INX   D
346C  INX   H
346D  DCR   B
346E  JNZ   3469
3471  RET
