 	;SAVLCD  87 03 16
	;Neil Wick [71056,613]
	ORG	60000	;Change as necessary
SAV$LCD	XRA	A	;A=0
	JP	INIT
LOD$LCD	MVI	A,1	;A=1
INIT	STA	LS$FLAG	;MVI D,0/D,1
	LXI	H,BUFFER	;Point to buffer start
	XRA	A	;Row = 0
NEXTROW	STA	-12	;Store current row #
	XRA	A	;Col = 0
NEXTCOL	STA	-11	;Save current character column #
	PUSH	H	;Save buffer address
	CALL	30300	;Disable interrupts
	MVI	D,0	;D=0: Read; D=1 Write
LS$FLAG	EQU	$-1	;Load/save flag
	CALL	29746	;Read 6 bytes to buffer starting at HL
	POP	H	;Get buffer pointer back
	LXI	B,6	;  then
	DAD	B	;  add 6
	LDA	-11	;Get prev. column
	INR	A	;  and increment for next
	CPI	40	;Row finished?
	JNZ	NEXTCOL	;  if not, do next column
	LDA	-12	;Retrieve row # just done
	CPI	7	;Last row?
	RZ		;Return if row 7 done
	INR	A	;Increment to next row #
	JMP	NEXTROW	;  and go for next row
BUFFER	DS	1920	;Buffer to save data to
	END
