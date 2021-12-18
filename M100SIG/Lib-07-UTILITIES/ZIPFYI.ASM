;ZIPFYI.CO	(c)1989 Wilson Van Alst	v200/1.2	  All rights reserved.
;-----------------------------
;Name		T200	M100
; == ROM addresses: ==
UPCASA  EQU     04116	;04073
PRINT0  EQU     04556	;04514
FILES   EQU     10794	;07994
FINDDO  EQU     11197	;08352
GETLEN  EQU     11587	;08698
OPENDO  EQU     11635	;08710
MAKTXT  EQU     11644	;08719
SWAPNM  EQU     11711	;08780
CLS     EQU     20301	;16945
LININ?  EQU     21744	;17982
FNAME   EQU     23242	;19467
SEARCH  EQU     28738	;23615
MATCH0  EQU     31174	;26065
GETEND  EQU     33384	;27437
MAKHOL  EQU     33448	;27501
TICK    EQU     36809	;30326
; == SysRAM addresses: ==
ERRTRP  EQU     61236	;63058
FILEND  EQU     62997	;64354
FILE1   EQU     63302	;64659
; == Assigned addresses: ==
STASH   EQU     FILEND
SCHSTR  EQU     61510	;63220
SOURCE  EQU     61512	;63222
; == BASIC entry point: ==
;BASIC   EQU     63625	;
;------------------------------

; == Input file to search: ==
top	lxi	h,top
	shld	errtrp
	call	cls	;clear screen
	call	files	;list files
	call	prompt	;user input
	db	'File',0 ;prompt string
	rz		;MENU if null
	call	getlen	;DE=len(input)
	call	fname	;format & store
	call	finddo	;file exist?
	cnz	illegl  ;can't be MATCH
	jz	top	;if file n.g.

; == Input string to find: ==
again	call	prompt	;user input
	db	'Find',0 ;prompt
	jz	top	;if null
	lxi	d,again	;pgm ret adr
	push	d	;for pgm return
BASIC	;this is BASIC entry point,
	;with file name stored at FILE1
	;and 0-terminated string in HL
	shld	schstr	;store str adr

; == Set DE->start of search file: ==
	call	maktxt  ;set HL->filtop
	shld	source	;store it
	xchg		;DE->filtop

; == Total size of match records: ==
	lxi	b,0	;count=0
mosrch	push	b	;save count
	lhld	schstr	;HL->search str
	call	search	;DE->fnd rec
	pop	b	;BC=count
	jnc	schdon	;if not found
	call	tick
mochrs	ldax	d	;A=char
	cpi	26	;eof?
	jz	schdon	;next job
	inx	b	;incr count
	inx	d	;adj pointer
	cpi	10	;end of rec?
	jnz	mochrs	;N:count more
	jmp	mosrch	;Y:look again

; == Open FOUND.DO and create space: ==
schdon	mov	a,c	;is count=0?
	ora	b	;
	rz		;Y:more input
	push	b	;save count
	call	swapnm	;store sch name
	lxi	h,match0 ;HL->match,0
	call	opendo	;open MATCH.DO
	jnc	newfile	;if new file
	push	h	;else adjust
	lxi	h,source ; for existing
	dcr	m	;    eof marker
	pop	h
newfile	call	swapnm	;restor schname
	call	getend	;HL->MATCH end
	pop	b	;BC=hole count
	call	makhol	;make room
	rc		;if no RAM

; == Adjust for file movement: ==
	xchg		;DE->stash
	lhld	source	;HL->source
	inx	h	;adj pointer
	rst	3	;HL<DE? (C)
	jc	nofix	;N:no adjust
	dad	b	;Y:add offset
nofix	xchg		;DE->source

; == Find matching records & move: ==
mowrit	lhld	schstr	;HL->search str
	call	search	;find it
	rnc		;if not found
	lhld	stash	;HL->hole
	call	tick
mopoke	ldax	d	;A=char
	cpi	26	;is it eof?
	rz		;yes: done
	mov	m,a	;else poke it
	inx	d	;adjust
	inx	h	;  pointers
	cpi	10	;chr=LF?
	jnz	mopoke	;N:keep going
	shld	stash	;Y:store holead
	jmp	mowrit	;look for more

; == Prompt subroutine: ==
prompt	xthl		;HL->prompt str
	call	print0	;print it
	xthl		;STK1->ret adr
	call	linin?	;user input
	inx	h
	dcr	b
	ret		;go back

; == Illegal file subroutine: ==
illegl	lxi	h,file1	;HL->name slot
	lxi	d,match0 ;DE->'match',0
	mvi	b,5	;count=5
nmchek	ldax	d	;A=chr
	call	upcasa	;A=upper case A
	cmp	m	;same as slot?
	rnz		;N:ret Zoff
	inx	h	;Y:adjust
	inx	d	;    pointers
	dcr	b	;decr count
	jnz	nmchek	;check next
	ret		;ret Zset: n.g

	end
