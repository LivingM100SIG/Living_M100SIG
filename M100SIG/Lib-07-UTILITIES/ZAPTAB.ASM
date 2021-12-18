;ZAPTAB.200	(c)1989	Wilson Van Alst	v1.0		  All rights reserved.
;-------------------------------
;Will substitute the correct number of
; spaces in .DO files containing TABs.
;-------------------------------
;ROM calls and SysRAM addresses:
FILES   equ 10794
opendo  equ 11635
omerr   equ 19517
linin?  equ 21744
prnnxt  equ 28158
CHKBYT  equ 28797
makhol  equ 33448
altbuf  equ 63574
;-------------------------------
	org	altbuf
;
;*Prompt for file & set HL to file top:
	CALL	FILES	;display files
	CALL	PRNNXT	;print this:
	db	'DeTAB',0
	CALL	LININ?	;user input
	RST	2	;check entry
	RZ		;if null
	CALL	OPENDO	;open .DO file
	RNC		;if not there
	PUSH	H	;save filetop
;
;*Find how much room will be added:
	LXI	B,0	;hole count =0
	XCHG		;DE=filetop
nulina	LXI	H,0	;chrcount=0
nuchr	CALL	CHKBYT	;test character
	JZ	nulina	;if CR/LF
	CPI	26	;eof?
	JZ	expand	;yes:task done
	INX	H	;count chars
	CPI	9	;TAB?
	JNZ	nuchr	;no:skip next
tablup	MOV	A,L	;test chrcount
	ANI	7	; mod 8?
	JZ	nuchr	;  Y:skip next
	INX	H	;  incr chrcnt
	INX	B	;  incr holecnt
	JMP	tablup	;loop till mod8
;
;*Make room for expanded file:
expand	POP	H	;HL->file top
	CALL	MAKHOL	;make room
	JC	OMERR	;if no room
	INX	D	;DE->above hole
;
;*Move characters into hole, changing
; TABS to proper number of spaces:
nulinb	LXI	B,0	;chr count =0
mochrs	LDAX	D	;A = chr
	CPI	26	;eof?
	RZ		;Y:all done
	MOV	M,A	;poke chr
	CPI	9	;was it TAB?
	INX	B	;adj chr count
	CZ	spacer	;if tab
	INX	H	;adj file pntr
	INX	D	;adj chr pntr
	CPI	10	;eof of record?
	JZ	nulinb	;Y:reset chrcnt
	JMP	mochrs	;N:keep going
;
spacer	MVI	M,32	;poke space
	MOV	A,C	;A=chr count
	ANI	7	;mod 8?
	RZ		;Y:return
	INX	H	;N:adj fil pntr
	INX	B	; adj chr count
	JMP	L63663	;loop till mod8
;
	end
;
