;DEFORM.200/100
;v2.1  (c)1988  Wilson Van Alst
;		  [76576,2735]
;
;	Removes formatting from RAM
;	.DO files 'in place.'  Will
;	strip format in layers, with
;	successive passes deleting
;	further layers of structure.
;
;	Runs in AltLCD buffer.
;
;
;	               ;M100 EQU's
finddo	equ	11197	;8352
file1	equ	63302	;64659
blnkf1	equ	13137	;9708
sho_hl	equ	18187	;14804
masdel	equ	82DAH	;6B9FH
FMTMSG	EQU	29125	;24084
UPCASM	EQU	4115	;4072
CLS	EQU	20301	;16945
FILES	EQU	10794	;7994
linin?	EQU	21744	;17982
PRINTC	EQU	26526	;22417     
tick	equ	36809	;30326
;
;==================================
;input file name and find top:
;
start	CALL	CLS
	CALL	FILES
	LXI	H,FMTMSG ;HL->prompt
	CALL	PRINTC	;dispay prompt
	CALL	LININ?	;input filename
	RST	2	;  or zilch
	RZ		;if zip,go home
	CALL	blnkf1	;clear file1
	LXI	D,file1	;DE->file1
namlup	CALL	UPCASM	;A=upcase <HL>
	ANA	A	;was it null?
	JZ	find	;yes?nextjob
	STAX	D	;<DE>=A
	INX	H	;HL=HL+1
	INX	D	;DE=DE+1
	JMP	namlup
find	CALL	finddo	;validate file
	JZ	start	;n/g?try again
;
;exits with DE= file top
;
;================================
;store file top in topsto:
;
	xchg		;HL=file top
	shld	topsto	;store it
	shld	tstore	;needs hi value
;
;exits with HL=file top
;==================================
;allow only two crlf's in a row:
;
delcrs	call	ficrl2	;get EOF/CRLF
	cpi	26	;EOF?
	jz	minent	;yes:nextjob
	mov	a,m	;A=next chr
	cpi	13	;another CR?
	jnz	delcrs	;no:check more
	inx	h	;yes:look next
	inx	h
mocr?	mov	a,m	;another CR?
	cpi	13	;
	jnz	delcrs	;no:resume chek
	lxi	b,2	;yes: delete
	call	masdel	;       it
	jmp	mocr?	;resume check
;
;==================================
;
;find minimum margin:
minent	lhld	topsto	;HL=file top
;
minmar	mov	a,m	;A=<HL>
	cpi	26	;EOF?
	jz	delmar	;yes:next job
	cpi	32	;space?
	jnz	morma2	;no?check more
;
	push	h	;STK1=line top
	rst	2	;jump past spcs
	pop	b	;BC=STK1=ltop
	push	h	;STK1=nextchr
	dsub	b	;HL=#spaces
	xchg		;DE=#spaces
	lhld	tstore	;HL=old marg
	rst	3	;cmpar HL-DE
	jc	mormar	;if old smaller
	xchg		;else HL=small
	shld	tstore	;store it
mormar	pop	h	;HL=STK1=nxtchr
morma2	call	ficrl2	;get next ltop
	jmp	minmar
;
;==================================
;
delmar	lhld	topsto	;HL->file top
;
lmar	mov	a,m	;A=<HL>
	cpi	32	;is it space?
	jnz	nodel	;no:leave it
	push	h	;STK1=line top
	lhld	tstore	;HL=margin
	mov	b,h	;BC = #spaces
	mov	c,l	;   to delete
	pop	h	;HL=STK1=ltop
	call	masdel	;delete margin
nodel	call	ficrl2	;get next ltop
	cpi	26	;EOF?
	jz	dermar	;yes:next job
	jmp	lmar
;
;================================
;
;DESTROY RIGHT MARGIN:
;=====================
;find biggest line:
;
dermar	LXI	H,0
	SHLD	TSTORE
	lhld	topsto	;HL->file top
;
linlup	push	h	;STK1=line top
	call	ficrl2	;HL->next line
	pop	b	;BC=STK1=oldlin
	cpi	26	;EOF?
	jz	decrlf	;yes:nextjob
	push	h	;STK1->nulin
	dsub	b	;HL=length
	xchg		;DE=length
	lhld	tstore	;HL=old max
	rst	3	;cmpar HL-DE
	jnc	molin	;smaller?skipit
	xchg		;HL=new max
	shld	tstore	;store it
molin	pop	h	;HL=STK1->nulin
	jmp	linlup
;
;==================================
;
decrlf	lhld	topsto	;HL->file top
;
crlup	push	h	;STK1=line top
	call	ficrl2	;find crlf
	pop	b	;BC=STK1=oldtop
	cpi	26	;eof?
	jz	start	;yes:nextfile
	mov	a,m	;A=next chr
	cpi	33	;is it chr?
	jc	crlup	;no:go again
	push	h	;STK1=line top
	dsub	b	;HL=length
	dmov	d,h+15	;DE=len+15
	lhld	tstore	;HL=maxline
	rst	3	;cmpar HL-DE
	pop	h	;HL=STK1=lintop
	jnc	crlup	;too small
	lxi	b,3	;get chr in 
	dsub	b	;  front of CR
	mov	a,m	;A=that chr
	dad	b	;restore HL
	cpi	'.'	;if '.'
	jz	crlup	;  do nothing
	cpi	'?'	;if '?'
	jz	crlup	;  do nothing
	cpi	'!'	;if '!'
	jz	crlup	;  do nothing
	cpi	':'	;if ':'
	jz	crlup	;  do nothing
;
;this is the actual delete:
	dcx	h	;HL->LF
	mvi	m,32	;space sted LF
	dcx	h	;HL->CR
	lxi	b,1	;set masdel
	call	masdel	;remove CR
	jmp	crlup	;next one
;
;====================================
;subroutine FICRL2:
;will search for EOF or CRLF and keep
;going until one or the other is found
;   ENTRY:	HL->place to begin
;   EXIT:	if EOF	HL->EOF
;			A=26
;		if CRLF	HL->next chr
;			A=10
ficrl2	call	tick	;make noise
	mov	a,m	;A=<HL>
	cpi	26	;EOF?
	rz		;yes:go back
	cpi	13	;CR?
	inx	h	;nuHL=HL+1
	jnz	ficrl2	;no?keeplooking
	mov	a,m	;A=<nuHL>
	cpi	10	;LF?
	jnz	ficrl2	;no?keeplooking
	inx	h	;nuHL=HL+1
	ret
;
;=================================
;pgm storage:
;
topsto	dw	FFFFH	;for file top
tstore	dw	FFFFH	;minmar,maxlin
;
	end
