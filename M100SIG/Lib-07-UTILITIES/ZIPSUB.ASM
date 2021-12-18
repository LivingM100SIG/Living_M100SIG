;ZIPSUB.ASM	(c)1989	Wilson Van Alst	v5.00		  All rights reserved.
;AltLCD Search/Replace program.  See
; ZIPSUB.DOC for full instructions,
; including use from within BASIC.
; ----------------------------
; >> ROM Addresses: <<
;Name		T200	;M100
PRINT0	equ	04556	;04514
FILES	equ	10794	;07994
FINDDO	equ	11197	;08352
MAKTXT	equ	11644	;08719
MOVDHB	equ	16826	;13417
CLS	equ	20301	;16945
LININ?	equ	21744	;17982
FNAME	equ	23242	;19467
SEARCH	equ	28738	;23615
OMDUMP	equ	29832	;24743
MVHD0	equ	31159	;26051
MAKHOL	equ	33448	;27501
MASDEL	equ	33498	;27551
TICK	equ	36809	;30326
UPKEY	equ	40729	;23908
; >> SysRAM addresses: <<
VIDFLG	equ	61205	;63048
ERRTRP	equ	61236	;63058
LINBUF	equ	61296	;63109
; >> Assigned addresses: <<
finlen	equ	lenset+1
replen	equ	finlen+1
finbuf	equ	linbuf+100
askflg	equ	askset+1
;   ---------------------------
; >> Input file to search: <<
top	call	cls	;clear screen
	call	files	;list files
	call	prompt	;user input
	db 'File',0 ;prompt string
	rz	;MENU if null
	xchg	;DE-input str
	lxi	h,top	;HL-this pgm
	shld	errtrp	;for ERRrtn
	push	h	;for pgm rtn
	xchg	;HL-input str
	mov	e,a	;E=len(input)
	call	fname	;store fname
	call	finddo	;file exist?
	rz	;if no file
; >> Input string to find: <<
BASIC	;this is BASIC entry point,
	;with file name stored at FILE1
again	call	prompt	;user input
	db	27,'jFind',0 ;prompt
	rnc	;if null or too long
		;above returns to
		;File? prompt when
		;run from the MENU,
		;or to BASIC pgm
		;if run from there
	lxi	d,again ;pgm ret adr
	push	d	;for pgm return
	sta	finlen	;store len(f)
; >> Store find string: <<
	LXI	D,finbuf ;DE-finbuf
	call	MVHD0	;mov it to buf
; >> Input replacement string: <<
	call	Prompt	;user input
	db ' Sub',0	;prompt line
	jc	notnul	;if short enuf
	rnz		;if not 0
; >> Verify null entry: <<
	call	ynpmpt	;Y/N/Q reply
	db 'Delete',7,0	;prompt line
	rz		;N/Q:new find
	xra	a	;else A=0
; >> Store replacement length: <<
notnul  STA	replen	;store len(r)
; >> Set Ask flag: <<
askinp	call	ynpmpt	;Y/N/Q response
	db	27,'MAsk',0	;prompt line
	cpi	'Q'	;bail out?
	rz		;back to Find?
	sta	askflg	;store answer
; >> Set HL-file top: <<
	call	maktxt	;HL-filtop
; >> Look for find string: <<
getit	xchg		;DE-file
	LXI	H,finbuf ;HL-finstr
	call	search	;search
	rnc	;if not found
	call	tick	;make noise
	mov	l,c	;setHL-
	mov	h,b	;  match string
askset	mvi	a,0	;A=ask flag
	ana	a	;is it 0?
	jz	lenset	;Y:skip next

; >> Display match string & ask OK? <<
showit	push	h	;save match adr
	call	cls	;blank lcd
mosho	rst	3	;DE-match?
	cz	hilite	;yes:rev video
	ldax	d	;A=char
	cpi	26	;eof?
	jz	moask	;Y:done
	rst	4	;print it
	inx	d	;adjust pointer
	cpi	10	;was it eol?
	jnz	mosho	;n:loop
moask	call	ynpmpt	;get Y/N reply
	db	'Sub',0	;prompt string
	pop	h	;HL-match
	jnz	lenset	;reply=Yes
	ana	a	;was reply=No?
	rnz		;reply=Q
	inx	h	;adjust pointer
	jmp	getit	;next string
; >> If Ask off, or reply was Yes: <<
lenset	lxi	b,0	;BC=lens(f,r)
	mov	a,b	;A=len(r)
	ANA	A	;is it 0?
	jz	delete	;Y:delete
; >> Replace string bit for bit: <<
	LXI	D,LINBUF ;DE-(r)
mochrs	LDAX	D	;A=char
	MOV	M,A	;poke to (f)
	DCR	B	;adj (r) count
	INX	H	;adj pointer
	INX	D	;adj pointer
	jz	rdone	;if (r)count=0
	DCR	C	;adj (f) count
	JNZ	mochrs	;loop if NZ
; >> Len(r)len(f):adj & move extra: <<
	MOV	C,B	;set BC =
	MVI	B,0	; len(r)-len(f)
	PUSH	D	;save pointer
	call	MAKHOL	;room for more
	POP	D	;restore pntr
	jc	omdump	;if no room
	MOV	B,C	;B=extra chrs
	call	MOVDHB	;put in hole
	jmp	getit	;loop for more
; >> Len(f)len(r):delete chrs: <<
rdone	DCR	C	;BC=len(f)-(r)
delete	call	MASDEL	;delete&loop
	jmp	getit	;loop for more
; >> Reverse video for match string: <<
hilite	lda	vidflg	;A=vid status
	cma		;reverse it
	sta	vidflg	;store it
	ana	a	;is it 0?
	rz		;yes:home
	lda	finlen	;no:A=len(f)
	mov	c,a	;set BC
	mvi	b,0	;   = len (f)
	dad	b	;adjust HL for
	ret		; next rst $3
; >> Yes/No input: <<
ynpmpt	xthl		;HL-prompt
	call	print0	;print it
	xthl		;set ret stack
notyn	lxi	h,ynstr	;HL-' Y/N?',0
	call	print0	;print it
	call	upkey	;A=response
	cpi	'Q'	;is it Quit?
	rz		;ret A=Q,Zset
	sui	'N'	;is it No?
	rz		;ret A=0,Zset
	cpi	'Y'-'N' ;is it Yes?
	jnz	notyn	;N:loop
	ana	a	;reset Z
	ret
; >> Prompt subroutine: <<
prompt	xthl		;HL-prompt str
	call	print0	;print it
	xthl		;STK1-ret adr
	call	linin?	;user input
	inx	h	;HL-input
	dcr	b	;B=chr count
	mov	a,b	;A=chr count
	rz		;Zset if null
	cpi	80	;Cset if len ok
	ret
ynstr	db	'? Y/N/Q',0
;
	end
