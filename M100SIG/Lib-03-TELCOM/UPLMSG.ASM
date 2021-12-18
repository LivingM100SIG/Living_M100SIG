REM. ASCII Upload Routine for Model 100
REM. By Ron Bean 7/86	 395 bytes
REM. Assemble with ASM.BA
REM.	   This program is
REM.	"In The Public Domain"
REM.
	ORG	62560D	.
	LXI H	5751H	."File to upld"
	CALL	5791H	.dspl str
	CALL	463EH	.prompt,get ln
	LXI D	F685H	.line from kybd
	LXI H	FC93H	.dest
	MVI C	6D	.count
	LDAX D		.get chr
	ORA A		.is it 0?
	JNZ	$+6	.if so
	 MVI A	32D	. use space
	 DCX D		. hold back DE
	CALL	0FE9H	.conv to UC
	MOV M,A		.store
	INX H		.
	INX D		.
	DCR C		.count
	JNZ	$-15	.nxt chr
	MVI M	68D	.add 'DO'
	INX H		.
	MVI M	79D	.
	CALL	220FH	.create file
	PUSH H		.save file adrs
	JC	$+25	.if new
	 PUSH D		.
	 CALL	4229H	. BEEP
	 LXI H	5CD6H	. "Not Found"
	 CALL	5791H	. dspl str
	 CALL	4222H	. print CRLF
	 CALL	1F3AH	. FILES
	 POP H		.
	 POP D		. (swap data)
	 CALL	1FBEH	. kill file
	 RET		. Exit else:
	LXI H	670CH	."Width:"
	CALL	5791H	.dspl str
	CALL	4644H	.get line
	LXI H	F685H	.line from kybd
	CALL	112EH	.ASCII->integer
	MOV A,D		.returned in DE
	ORA A		.set flags
	JNZ 	$+9	.if WIDTH > 255
	MOV A,E		.
	CPI	FFH	.or
	JNZ	$+5	.if WIDTH=255
	 MVI A	FEH	. WIDTH=254
	CPI	20D	.
	JNC	$+5	.if WIDTH<20
	 MVI A	0D	. then WIDTH=0
	STA	WIDT	.store WIDTH
	LXI H	MSG1	."Wait echo"
	CALL	5791H	.dspl str
	CALL	463EH	.prompt,get ln
	LDA	F685H	.chr from kybd
	CALL	0FE9H	.conv to UC
	STA	WAIT	.set echo flag
	LXI H	MSG2	."Prompt:"
	CALL	5791H	.dspl str
	CALL	4644H	.get line
	LDA	F685H	.chr from kybd
	ORA A		.chk prompt
	JNZ 	$+5	.if none
	 MVI A  13D	. use CR
	STA	PROMPT	.store prompt
	CALL	CLR	.clr buffer
	POP H		.load file adrs
REM.
LINE	LDA	WIDT	.
	ORA A		.if WIDTH=0
	JZ	NEXT	.skip else:
	MOV E,A		.
	MVI D	0D	.
	PUSH H		.store adrs
	DAD D		.add WIDTH
	MOV A,M		.
	 CPI	32D	. SP?
	 JZ	S1	.
	 CPI 	13D	. CR?
	 JZ	S1	.
	 CPI	1AH	. EOF?
	 JZ	S1	. If not endln
	 DCX H		. back up
	 JMP	$-17	. try nxt chr
S1	MOV A,L		.line end adrs:
	STA	MARKER	.2nd byte
	POP H		.restore adrs
REM.
NEXT	LDA	MARKER	.
	CMP L		.
	JNZ	$+10	.IF width:
	 LDA	WIDT	.
	 ORA A		. and WIDTH<>0
	 JNZ	ENDLN	. end line
	MOV A,M		.elseif:
	CPI 	13D	.CR?
	JZ	ENDLN	.
	CPI	1AH	.EOF?
	RZ		.EXIT ELSE:
	CALL	6E32H	.send chr
	INX H		.point to nxt
	CALL	6D6DH	.check buffer
	JNZ	$+20	.IF no chrs:
	 LDA	WAIT	.
	 CPI	89D	.
	 JNZ	NEXT	. if WAIT="Y"
	 LDA	FFA2H	. chk kybd
	 CPI	80H	. if BREAK
	 RZ		. Exit else:
	 JMP	$-20	. try again
	CALL	6D7EH	.get chr
	RC		.EXIT if BREAK
	CALL	4B44H	.dspl chr
	MOV B,A		.store echo
	CPI	8D	.was echo a BS?
	JNZ	$+9	.if so
	 CALL	CLR	.clear buffer
	 JMP	NEXT	.nxt chr else:
	LDA	WAIT	.
	CPI	89D	.
	JNZ	NEXT	.if WAIT="Y"
	 DCX H		.point to last
	 MOV A,M	.get chr
	 INX H		.point to nxt
	 CMP B		.compare echo
	 JZ	NEXT	.if OK then nxt
	MVI A	8D	.
	CALL	6E32H	.else send BS
	DCX H		.adjust pointer
	CALL	CLR	.clear buffer
	JMP	NEXT	.nxt chr
REM.
ENDLN	MOV A,M		.
	CPI	1AH	.
	RZ		.Exit if EOF
	MVI A	13D	.
	CALL	6E32H	.send CR
L2	CALL	6D6DH	.check buffer
	JNZ	$+12	.if no chrs
	 LDA	FFA2H	. chk kybd
	 CPI	80H	. if BREAK
	 RZ		. Exit else:
	 JMP	L2	. try again
	CALL	6D7EH	.else get chr
	RC		.Exit if BREAK
	JNZ	$+14	.(UART err)
	 CALL	4B44H	. dspl chr
	 MOV B,A	.save chr
	 LDA	PROMPT	.
	 CMP B		.prompt?
	 JNZ 	L2	.if so
	CALL	CLR	.clr buffer
	INX H		.point to nxt
	MOV A,M		.load chr
	CPI	10D	.is it a LF?
	JNZ	LINE	.if so
	INX H		.point to
	JMP	LINE	.nxt chr
REM.
CLR	LXI D	04FFH	.timeout
L3	CALL	6D6DH	.check
	JZ	$+12	.if chrs
	 CALL	6D7EH	. clear buffer
	 CALL	4B44H	. dspl chr
	 JMP	CLR	. retry timeout
	MVI A	0D	.else:
	DCX D		.dec counter
	CMP E		.if not timeout
	JNZ	L3	.try again else
	CMP D		.check other
	JNZ	L3	.try again
	RET		.else return
REM.
WAIT	RES 1D	. wait for echo = "Y"
WIDT	RES 1D	. 1 byte binary
PROMPT	RES 1D	. 1 byte ASCII
MARKER	RES 1D	. 1 byte binary
MSG1	STR	Wait for Echo.
	DATA	0D		.
MSG2	STR	Prompt:.
	DATA	0D		.
	END
