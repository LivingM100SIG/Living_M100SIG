MEMO.CMD copyright (c)  1989
    by Paul Globman

Create MEMO.CO and load into bank #3.  Press F3 at the Menu for command input 
and type MEMO<CR>.  The bottom line of the menu will blank and you may enter 
notes which can later be retrieved from 2:MEMO.DO.  You can rename MEMO to M 
for minimum keystrokes, or rename it CMD> for dedicated F3 (Caps lock).

Use HXFER.200 to create MEMO.CO

52FF610052FFCDDBA03E082194FFCD70F83A76EFA7C2D232CD724FCDF654DA6068783DCA606832ABFF3E0221A2FFCD70F83E0421ABFFCD70F83E0421AEFFCD70
F8AFCD70F8C364FF0B97FF333A5842415349432E434F06A5FF323A4D454D4F0070EF02B1FF0D0A

;MEMO SOURCE
;
	ORG 65362	;telcom buffer
	ENTRY
;
;LOADM XBASIC IN M/L....
;
	CALL 41179	;load XBAS-2
	MVI A,8		;LOADM command
	LXI H,XB	;VARPTR(X$)
	CALL 63600	;execute
	LDA 61302	;look at RD
	ANA A		;test A for 0
	JNZ 32D2H	;beep and MENU
;
;GET MEMO INPUT
;
mm:	CALL 4F72H	;erase btm line
	CALL 54F6H	;GET MEMO
	JC 6860H	;abort if break
	MOV A,B
	DCR A		;test length
	JZ 6860H	;abrt if null
	STA DATA	;STORE LEN
;
;OPEN 2:MEMO.DO
;
	MVI A,2		;OPEN WRITE CMD
	LXI H,MEMO
	CALL 63600	;DO THE OPEN
;
;WRITE DATA
;
	MVI A,4		;WRITE CMD
	LXI H,DATA
	CALL 63600	;DO THE WRITE
;
;WRITE CRLF
;
	MVI A,4		;WRITE CMD
	LXI H,CRLF
	CALL 63600	;DO THE WRITE
;
;CLOSE MEMO
;
	XRA A		;CLOSE CMD
	CALL 63600
;
;NEXT MEMO
;
	JMP MM		;LOOP
;
;
XB:	DB 11		;VARPTR(X$)
	DW XB+3		;POINTER
	DB '3:XBASIC.CO'	;X$
;
MEMO:	DB 6		;VARPTR(MEMO$)
	DW MEMO+3
	DB '2:MEMO'	;MEMO$
;
DATA:	DB 0		;VARPTR(DATA$)
	DW EF70H	;INPUT BUFFER
;
CRLF:	DB 2		;VARPTR(CRLF$)
	DW CRLF+3
	DB 13,10	;CRLF$
