;Source code for insert/overwrite(ESC-2/ESC-1) option utility.
;Also supports 	DIsabled word wrapping
;To enable word wrapping, press SHIFT as you press ENTER after the file name
; Based on test version for T200 -- 11/20/87
;This is Model 100 test version





;Previous Nowrap code---------
	ORG	$FCC0
BEGIN	LXI	H,JY15
	ENT	BEGIN
	SHLD	$F652	;61236 <---T200, in decimal
	LXI	H,$5E22	;29140
	CALL	$5A7C	;28192
	XRA	A
JY15	CNZ	$4229	;20293
	CALL	$5D53	;29003
	call	$1f3a	;does 'files' at entry
	lxi	h,shmsg	;shift-enter msg
	call	$27b1
	LXI	H,$5E15	;29124
	CALL	$27B1	;13591
	CALL	$463E	;21744
	RST	2
	ANA	A
	JZ	$5797	;26532
	CALL	$2206	;11635
	PUSH	HL

;Add a mod here

	lhld	64222
	shld	hook1
	LXI	H,JY11
	SHLD	64222	;62731 Set Key hook
	lhld	64274	;save menu hook
	shld	hook2
	LXI	H,JY13
	SHLD	64274	;62781 Set Menu hook (above adrs+50)
	LXI	H,0
	SHLD	$F6E7	;61394
	LDA	$FF99	;64781
	ANI	1	;Nowrap switch
	JMP	$5F71	;29479

;--------------------

;Menu hook

JY13	PUSH	hl
	lhld	hook1
	SHLD	64222	;62731 Reset Key hook
	lhld	hook2
	SHLD	64274	;62781 Reset menu hook
	POP	hl
	jmp	$5797	;was RET

;	RST	7 hook from GetKey, 4855
;If in TEXT, make it goto patch, instead of RETurning 
;to 29609 upon RETurn from GetKey

JY11	DI
	PUSH	bc
	PUSH	de	;Save BC&DE
	LXI	H,0
	DAD	SP
	XCHG		;Save SP
	MVI	A,20	;Peel 10 layers to get to RETurn addr
JY1	INX	SP
	DCR	A
	JNZ	JY1	;Peel
	LXI	H,JY5	;RETurn to JY5 instead of 29609
	XTHL
	LXI	B,$5ff0	;29609
	DB	8	;Is it TEXT?
	JZ	JY9	;Yes
	DAD	B
	XTHL		;No, put it back

;Restore stack

JY9	XCHG
	SPHL
	POP	de
	POP	bc
	EI
	RET		;RETurn from hook

;-----------------------

;Patch - originally 29609

JY5	STA	$F6DF	;61386
	PUSH	af
	CALL	$65EC	;31188
	POP	af
	JC	$6501	;30943
	CPI	127
	JZ	$6118	;29945 DEL
	CPI	32
	JC	$6005	;29630 CTRL or FN

;--------Insert ascii chr

;FiRST	check for ESC sequence
	MOV	H,A
	LDA	$F6E0	;61387
	CPI	27	;ESC sequence?
	MOV	A,H
	JNZ	JY7	;No, continue


;An escape sequence

	CPI	'1'	;ESC-1?
	JZ	JY10	;Yes, OverWrite mode
	CPI	'2'	;ESC-2?
	JNZ	JY7	;No, continue TEXT
	XRA	a	;Yes, Insert mode
JY10	STA	JY6
	RET		;RETurn to TEXT main loop (29690)



;
;------part of rom routine at 29803(Insert ASCII)

JY7	PUSH	AF
	CALL	$628F	;30320
	CALL	$6A9B	;33238
	CALL	$6AF9	;33332
	POP	AF

;------

	CALL	JY8	;insert (30583)
	JC	$60A3	;29828 Memory full
	JMP	$609B	;29820	;Jump back to rom to continue

;Insert routine - moDIfied

JY8	XCHG		;Save HL in DE
	MOV	B,A
	LDA	JY6
	ORA	A	;Insert mode?
	MOV	A,B
	JZ	$6397	;30584 (30583+1) --Yes, insert
	LHLD	$FB62	;62997
	RST	3	;End of file?
	MOV	A,B
	JZ	$6397	;30584	;(30583+1) -- Yes, insert
	LDAX	D
	CPI	13	;CR?
	MOV	A,B
	JNZ	JY12	;No, overwrite
	INX	D
	LDAX	D
	DCX	D	;test if CR&LF
	CPI	10	;End of line?
	MOV	A,B
	JZ	$6397	;30584 (30583+1) -- Yes, insert

;Overwrite

JY12	XCHG
	MOV	M,A
	RST	4	;Overwrite and print new chr
	POP	AF
	RET		;Do not continue in rom - RET to TEXT main loop(29690)

JY6	DB	0	;InsertOverWrite switch
shmsg	dm	<SHIFT-ENTER for Word Wrap>
	db	13
	db	10
	db	0
hook1	ds	2
hook2	ds	2
	END
