		TITLE	"8085 Cross-Assembler Test Source File"
		PAGE	60
;
; The 8085 opcodes in opcode numerical order:
;
BYTE		EQU	012H
WORD		EQU	034H
PORT		EQU	056H
ADDRESS		EQU	07890H

                org     55h

; 000H - 00FH.

begin           equ     $
		NOP
		LXI	B, WORD
		STAX	B
		INX	B
		INR	B
		DCR	B
		MVI	B, BYTE
		RLC
					; 008H is undefined.
		DAD	B
		LDAX	B
		DCX	B
		INR	C
		DCR	C
		MVI	C, BYTE
		RRC

; 010H - 01FH.

					; 010H is undefined.
		LXI	D, WORD
		STAX	D
		INX	D
		INR	D
		DCR	D
		MVI	D, BYTE
		RAL
					; 018H is undefined.
		DAD	D
		LDAX	D
		DCX	D
		INR	E
		DCR	E
		MVI	E, BYTE
		RAR

; 020H - 02FH.

		RIM
		LXI	H, WORD
		SHLD	ADDRESS
		INX	H
		INR	H
		DCR	H
		MVI	H, BYTE
		DAA
					; 028H is undefined.
		DAD	H
		LHLD	ADDRESS
		DCX	H
		INR	L
		DCR	L
		MVI	L, BYTE
		CMA

; 030H - 03FH.

		SIM
		LXI	SP, WORD
		STA	ADDRESS
		INX	SP
		INR	M
		DCR	M
		MVI	M, BYTE
		STC
					; 038H is undefined.
		DAD	SP
		LDA	ADDRESS
		DCX	SP
		INR	A
		DCR	A
		MVI	A, BYTE
		CMC

; 040H - 04FH.

		MOV	B, B
		MOV	B, C
		MOV	B, D
		MOV	B, E
		MOV	B, H
		MOV	B, L
		MOV	B, M
		MOV	B, A
		MOV	C, B
		MOV	C, C
		MOV	C, D
		MOV	C, E
		MOV	C, H
		MOV	C, L
		MOV	C, M
		MOV	C, A

; 050H - 05FH.

		MOV	D, B
		MOV	D, C
		MOV	D, D
		MOV	D, E
		MOV	D, H
		MOV	D, L
		MOV	D, M
		MOV	D, A
		MOV	E, B
		MOV	E, C
		MOV	E, D
		MOV	E, E
		MOV	E, H
		MOV	E, L
		MOV	E, M
		MOV	E, A

; 060H - 06FH.

		MOV	H, B
		MOV	H, C
		MOV	H, D
		MOV	H, E
		MOV	H, H
		MOV	H, L
		MOV	H, M
		MOV	H, A
		MOV	L, B
		MOV	L, C
		MOV	L, D
		MOV	L, E
		MOV	L, H
		MOV	L, L
		MOV	L, M
		MOV	L, A

; 070H - 07FH.

		MOV	M, B
		MOV	M, C
		MOV	M, D
		MOV	M, E
		MOV	M, H
		MOV	M, L
		HLT
		MOV	M, A
		MOV	A, B
		MOV	A, C
		MOV	A, D
		MOV	A, E
		MOV	A, H
		MOV	A, L
		MOV	A, M
		MOV	A, A

; 080H - 08FH.

		ADD	B
		ADD	C
		ADD	D
		ADD	E
		ADD	H
		ADD	L
		ADD	M
		ADD	A
		ADC	B
		ADC	C
		ADC	D
		ADC	E
		ADC	H
		ADC	L
		ADC	M
		ADC	A

; 090H - 09FH.

		SUB	B
		SUB	C
		SUB	D
		SUB	E
		SUB	H
		SUB	L
		SUB	M
		SUB	A
		SBB	B
		SBB	C
		SBB	D
		SBB	E
		SBB	H
		SBB	L
		SBB	M
		SBB	A

; 0A0H - 0AFH.

		ANA	B
		ANA	C
		ANA	D
		ANA	E
		ANA	H
		ANA	L
		ANA	M
		ANA	A
		XRA	B
		XRA	C
		XRA	D
		XRA	E
		XRA	H
		XRA	L
		XRA	M
		XRA	A

; 0B0H - 0BFH.

		ORA	B
		ORA	C
		ORA	D
		ORA	E
		ORA	H
		ORA	L
		ORA	M
		ORA	A
		CMP	B
		CMP	C
		CMP	D
		CMP	E
		CMP	H
		CMP	L
		CMP	M
		CMP	A

; 0C0H - 0CFH.

		RNZ
		POP	B
		JNZ	ADDRESS
		JMP	ADDRESS
		CNZ	ADDRESS
		PUSH	B
		ADI	BYTE
		RST	0
		RZ
		RET
		JZ	ADDRESS
					; 0CBH is undefined.
		CZ	ADDRESS
		CALL	ADDRESS
		ACI	BYTE
		RST	1

; 0D0H - 0DFH.

		RNC
		POP	D
		JNC	ADDRESS
		OUT	PORT
		CNC	ADDRESS
		PUSH	D
		SUI	BYTE
		RST	2
		RC
					; 0D9H is undefined.
		JC	ADDRESS
		IN	PORT
		CC	ADDRESS
					; 0DDH is undefined.
		SBI	BYTE
		RST	3

; 0E0H - 0EFH.

		RPO
		POP	H
		JPO	ADDRESS
		XTHL
		CPO	ADDRESS
		PUSH	H
		ANI	BYTE
		RST	4
		RPE
		PCHL
		JPE	ADDRESS
		XCHG
		CPE	ADDRESS
					; 0EDH is undefined.
		XRI	BYTE
		RST	5

; 0F0H - 0FFH.

		RP
		POP	PSW
		JP	ADDRESS
		DI
		CP	ADDRESS
		PUSH	PSW
		ORI	BYTE
		RST	6
		RM
		SPHL
		JM	ADDRESS
		EI
		CM	ADDRESS
					; 0FDH is undefined.
		CPI	BYTE
		RST	7

;
; Let's test the rest of the pseudo-ops while we're at it:
;
VARIABLE	SET	-1

		IF	VARIABLE
		DB	-1, , +1
		ELSE
		DB	+1, , -1
		ENDIF

VARIABLE	SET	VARIABLE EQ 0

		IF	VARIABLE
		DW	, +1
		ELSE
		DW	, -1
		ENDIF

		DS	10H

		DB	"EXPLOSION", 0DH, 0AH, 0

                END     begin
