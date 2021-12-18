REM. Non-buffered Cassette Load/Save
REM. for Model 100    by Ron Bean 8/86
REM. assemble with ASM.BA   528 bytes
REM.	   This program is
REM.	"In the Public Domain"
REM.
	ORG	60000D	.
	MVI A	FFH	.init data
	STA	DAT	.
	STA	LEN+2	.
	LXI H	MSG1	."Load or Save"
	CALL	5791H	.dspl str
	CALL	12CBH	.get chr
	CALL	0FE9H	.conv to UC
	CALL	4B44H	.dspl chr
	CPI	76D	."L"
	JZ	LODE	.
	CPI	83D	."S"
	JZ	SAVE	.
	JMP	5797H	.MENU
REM.
CREATE	LXI H	MSG2	."Filename:"
	CALL	5791H	.dspl str
	CALL	4644H	.get ln
	LXI D	F685H	.line from kybd
	LXI H	FC93H	.dest
	CALL	KNAME	.
	MVI M	68D	.add 'DO'
	INX H		.
	MVI M	79D	.
	INX H		.
	MVI M	0D	.
	CALL	220FH	.create file
	RET		.
REM.
KNAME	MVI C	6D	.count
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
	JNZ	KNAME+2	.nxt chr
	RET		.
REM.
LODE	CALL	CREATE	.create file
	JNC	CLODE	.if exists:
	PUSH H		.save adrs
	PUSH D		.and dir
	LXI H	MSG3	."Append"
	CALL	5791H	.dspl str
	CALL	12CBH	.get chr
	CALL	0FE9H	.conv to UC
	CALL	4B44H	.dspl chr
	POP D		.
	POP H		.
	CPI	89D	."Y"
	JZ	$+14	.if no
	 XCHG		. swap data
	 LXI B	$+7	. xtra ret adrs
	 PUSH B		. for CALL
	 CALL	1FBEH	. kill file
	 CALL	220FH	. create new
	MVI A	1AH	.
	CMP M		.EOF?
	JZ	CLODE	.
	 INX H		.
	 JMP	$-5	.
CLODE	PUSH H		.save adrs
	LXI H	67D4H	."Load from:"
	CALL	5791H	.dspl str
	CALL	4644H	.get line
	LXI D	F685H	.ln from kybd
	LXI H	FC93H	.dest
	LDAX D		.chk input
	ORA A		.if input
	JNZ	$+6	.use kybd else
	 LXI D	FC93H	. use filename
	CALL	KNAME	.
HEADER	CALL	14A8H	.motor on
	CALL	6F85H	.rd header
	LXI D	10D	.set count
	LXI H	DAT	.
	CALL	2413H	.rd data
	LDA	DAT	.
	CPI	FFH	.chk flag
	JZ	COMP	.
	CPI	9CH	.normal DO file
	JZ	SKIP	.
	CPI	D3H	.BA file
	JZ	SKIP	.
	CPI	D0H	.CO file
	JZ	SKIP	.
	JMP	HEADER	.(no flag)
COMP	CALL	14AAH	.motor off
	LXI H	CNAME	.
	LXI D	FC93H	.
	MVI C	6D	.counter
L1	LDAX D		.
	CMP M		.
	JZ	$+20	.
SKIP	 LXI H	2705H	. "skip"
	 CALL	5791H	.dspl str
	 LXI H	CNAME	.
	 MVI B	6D	. set count
	 CALL	1BE0H	. dspl B chrs
	 JMP	HEADER	. (wrong file)
	INX D		.
	INX H		.
	DCR C		.
	JNZ	L1	.if right file:
	LDA	LEN+2	.
	CPI	FFH	.chk flag
	JZ	$+12	.
	 LXI H	03EAH	. "Error"
	 CALL	5791H	. dspl str
	 JMP	CLODE	.
	LXI H	26FEH	."found"
	CALL	5791H	.dspl str
	LXI H	CNAME	.
	MVI B	6D	.set count
	CALL	1BE0H	.dspl B chrs
REM. make room
	LHLD	LEN	.get length
	MOV B,H		.
	MOV C,L		.
	POP H		.get adrs
	PUSH H		.save adrs
	CALL	6B6DH	.insert spaces
	JNC	$+9	.if out of mem:
	 CALL	4229H	. BEEP
	 JMP	5797H	. MENU
REM. adjust file directory
	POP B		.get file adrs
	PUSH B		.
	LXI H	F962H	.1st dir entry
L2	MOV A,M		.
	CPI	FFH	.(end of dir)
	JZ	FILE	.
	INX H		.
	MOV E,M		.
	INX H		.
	MOV D,M		.DE=adrs in dir
	PUSH H		.save dir ptr
	MOV H,B		.
	MOV L,C		.HL=file adrs
	RST 18		.cmp HL-DE
	JNC	S1	.if moved:
	LHLD	LEN	.
	DAD D		.
	XCHG		.DE=adrs to dir
	POP H		.get dir ptr
	PUSH H		.
	MOV M,D		.store new adrs
	DCX H		.
	MOV M,E		.
S1	POP H		.get dir ptr
	LXI D	9D	.
	DAD D		.nxt dir entry
	JMP	L2	.
REM. load file
FILE	CALL	14A8H	.motor on
	CALL	6F85H	.read header
	LHLD	LEN	.
	XCHG		.
	POP H		.adrs
	CALL	2413H	.read file
	CALL	14AAH	.motor off
	JMP	5797H	.MENU
REM.
SAVE	CALL	CREATE	.create file
	JC	$+17	.if new:
	 CALL	4229H	. BEEP
	 XCHG		. swap data
	 LXI B	$+7	. xtra ret adrs
	 PUSH B		. for CALL
	 CALL	1FBEH	. kill file
	 JMP	5797H	. MENU else:
	PUSH H		.save adrs
	LXI D	0D	.init counter
	MVI A	1AH	.
	CMP M		.chk EOF
	JZ	$+8	.if not EOF:
	 INX D		. count
	 INX H		. try nxt
	 JMP	$-6	. else:
	XCHG		.
	SHLD	LEN	.save length
	LXI H	6735H	."Save to:"
	CALL	5791H	.dspl str
	CALL	4644H	.get line
	LXI D	F685H	.line from kybd
	LXI H	CNAME	.dest
	LDAX D		.chk input
	ORA A		.if input
	JNZ	$+6	.use kybd else
	 LXI D	FC93H	. use filename
	CALL	KNAME	.
CSAVE	CALL	14A8H	.motor on
	CALL	6F46H	.wrt header
	LXI D	10D	.set count
	LXI H	DAT	.
	CALL	WRITE	.wrt data block
	CALL	531AH	.1/2 sec delay
	CALL	6F46H	.wrt header
	LHLD	LEN	.get length
	XCHG		.
	POP H		.and adrs
	CALL	WRITE	.wrt file
	CALL	14AAH	.motor off
	JMP	5797H	.MENU
REM.
WRITE	MVI C	0D	.Patch from
	MOV A,M		.ROM 22B9H
	CALL	14C1H	.write chr
	INX H		.
	DCX D		.
	MOV A,D		.
	ORA E		.
	JNZ	WRITE+2	.
	MOV A,C		.
	CALL	14C1H	.write cksm
	RET		.
REM.
DAT	DATA FFH .flag
CNAME	RES 6D	.filename
LEN	RES 2D	.file length
	DATA FFH .flag
MSG1	STR Cassette:<L>oad or <S>ave:.
	DATA 0D
MSG2	STR Filename:.
	DATA 0D
MSG3	STR Append?.
	DATA 0D
	END
