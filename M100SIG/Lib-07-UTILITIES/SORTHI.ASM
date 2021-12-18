;SORT.LCD -- Rick Perry's SORT
;made free-standing (no BA driver)
;for use in the alt LCD buffer.
;          Phil Wheeler -- 71266,125
;          2 August 1987
;
;SORT 6/7/84 by Rick Perry 75665,1045

; This based on the source code for the sort routine
; contained in the programs: ALARMS.100 & SORT.LDR

; The algorithm is a 'bubble sort' designed to sort a RAM .DO file
; in place. File can have variable length lines, with line length
; up to 255 chars, including <CR><LF>.

;
chkdc	equ	$5AAB	; lookup file in RAM Dir
gtxttb	equ	$5AE3	; get pointer to start of file
cls	equ	$4231	; clear screen
upcase	equ	$0FE8	; convert (M) to uppercase
buf	equ	$F685	; start of LINE INPUT buffer
PRTMSG	EQU	$5791	;msg to lcd on new line
NTFND	EQU	$5CD6	;not found msg in ROM
WAITSP	EQU	$5F2F	;wait for press and rtn
LINEIN	EQU	$4644	;input line from kbd
MENU	EQU	$5797	;back to M100 menu
BEEP	EQU	$7662	;oops!
FILES	EQU	$1F3A	;display files
CRLF	EQU	$4222	;make a blank line
;
	ORG	64704	;put it alt lcd buffer
	ENT	64704
BEGIN	CALL	CLS	;clear screen
	CALL	FILES	;show user the files on menu
	CALL	CRLF	;make a blank line
	LXI	H,FILMS	;prompt for the file to sort
	CALL	PRTMSG
	CALL	LINEIN	;line input the file to sort
	RST	2	;see if there is one
	JZ	EXIT	;main menu if none
;
	lxi	h,buf	;HL -> file name
	push	h
	dcx	h
;
lp1	inx	h	;make file name uppercase
	call	upcase
	mov	m,a
	cpi	'.'
	jz	do
	ora	a
	jnz	lp1
;
do	lxi	d,dotyp	;put in .DO extension
	mvi	b,4
	call	$3469
;
	pop	d	;try to lookup file in Dir
	mvi	a,10
	call	chkdc
	JZ	EXITN	;failure exit for 'file not found'
;
	call	gtxttb	;get pointer to start of file
	shld	start
;
;during the main loop, DE will point to start of line with length C
;HL will point to following line with length B
;
mainlp	xra	a	;start a pass
	sta	done	; (done) will remain 0 if no swaps needed
	lhld	start
	push	h
	call	getnxt
	shld	next	;(next) holds start address of next line
	pop	h
;
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
	call	compar	;will set carry if lines out of order
	pop	h
	pop	d
	pop	b
	cc	switch	;swap the lines
	jmp	lp2
;
endlp	lda	done
	ora	a
	jnz	mainlp
	JMP	BEGIN	;done --> another
;
;I find it difficult to properly comment the following switch routine.
;It not only swaps the two current lines, but also sets the current
;line pointer, HL, and length, B, to continue the flow of the main loop.
;See end of file for info on the block move ROM routines.
;
switch	push	b
	push	h
	lxi	d,buf
	call	$2542	;move one line to buffer
	pop	d
	xchg
	inr	c
	call	$2EE8	;replace one line...
	lxi	d,buf
	pop	b
	inr	b
	call	$346C	;then the other
	mov	b,c
	mvi	a,255	;set (done) nonzero to indicate
	sta	done	;swap was performed
	ret
;
compar	xchg		;on return, carry set if swap needed
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
;
getnxt	mvi	b,0	;get pointer to next line (HL)
nxt2	mov	a,m	;and length of current line (B)
	cpi	26	;^Z = EOF
	rz
	inx	h
	inr	b
	jz	toolng	; B>255
	cpi	13
	jnz	nxt2	;line ends with <CR>...
	mov	a,m
	cpi	10	;optionally followed by <LF>
	rnz
	inx	h
	inr	b
	rnz
;
toolng	call	cls
	pop	d	;unstack normal return address from getnxt.
	pop	h	;pointer to current line, was stacked
	mvi	b,100	;before call to getnxt.
t2	mov	a,m
	rst	4	;just display first 100 chars
	inx	h
	dcr	b
	jnz	t2
	JMP	EXITL	;line too long exit
;Exit routines
;
EXITL	LXI	H,LNMSG	;point to msg
	CALL	PRTMSG
	JMP	ERROR
EXITN	LXI	H,NTFND
	CALL	PRTMSG
ERROR	CALL	BEEP
	LXI	H,PRESS
	CALL	PRTMSG
	CALL	WAITSP
EXIT	JMP	MENU
;
;messages
;
PRESS	DM	Press Space Bar
	DB	$00
DOTYP	DM	.DO
	DB	$00
FILMS	DM	File to sort? 
	DB	$00
LNMSG	DM	Long Line!
	DB	$00
;

;data storage
;
done	ds	1
start	ds	2
next	ds	2
	END
