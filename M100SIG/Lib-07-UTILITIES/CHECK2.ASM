;*******************************************************************
;       MODEL 100 SIG CHECKSUM CALCULATOR FOR USE WITH THE CP/M
;       OPERATING SYSTEM - JIM MOORE - 5/26/85
;
;       Modified for use with 8-bit extended ascii files
;                             Phil Wheeler -- 5/9/87
;*******************************************************************
BDOS    EQU 5
FCB     EQU 5CH
BUFFER  EQU 80H
;
;
        ORG 100H
        LDA BUFFER      ;CHECK FOR ENTRY OF A FILENAME
        ORA A           ;CHECK BUFFER BYTE COUNT
        LXI D,CMDMSG    ;POINT TO ERROR MSG JUST IN CASE
        JZ EXIT
        MVI C,15        ;OPEN FILE
        LXI D,FCB
        CALL BDOS
        INR A           ;FF TO ZERO?
        LXI D,FNFMSG    ;PT TO ERRMSG
        JZ EXIT
        LXI D,SIGNON    ;PRT SIGNON MSG
        CALL PRMSG
        XRA A           ;ZERO BINARY CNTR
        MOV L,A
        MOV H,A
        MOV B,A
READ    MVI C,20        ;READ SECTOR
        LXI D,FCB
        PUSH H
        PUSH B
        CALL BDOS
        POP B
        POP H
        ORA A           ;CHECK FOR EOF
        JNZ EOF
        MVI C,81H       ;SET BUFFER CNTR
        LXI D,BUFFER    ;POINT TO BUFFER
AGAIN   DCR C
        JZ READ         ;READ ANOTHER SECTOR
        LDAX D          ;READ A FILE CHR
        INX D           ;PT TO NEXT CHR
        CPI 0DH
        JZ AGAIN        ;IGNORE CR
        CPI 0AH
        JZ AGAIN        ;IGNORE LF
        CPI 1AH
        JZ EOF          ;^Z=EOF
        PUSH D          ;SAVE BUFFER PTR
        MOV E,A         ;SET UP 24BIT ADD
        XRA A
        MOV D,A
        DAD D
        ADC B
        MOV B,A
        POP D
        JMP AGAIN
EOF     LXI D,BICS      ;PT TO BINARY CHKSUM
        XCHG            ;PUT BI CKSM IN BICS
        MOV M,E
        INX H
        MOV M,D
        INX H
        MOV M,B
        MVI C,11        ;FILENAME LENGTH
        LXI D,FCB+1     ;PT TO START OF FILENAME
        LXI H,FNAME     ;PT TO PRT BUFFER
LPFNAM  LDAX D          ;GET CHR
        MOV M,A         ;MOV TO PRT BUF
        INX D
        INX H
        MVI A,4         ;SET UP TO SKIP PERIOD POSITION
        CMP C
        JNZ PERIOD
        INX H
PERIOD  DCR C
        JNZ LPFNAM
        LXI B,CHKSUM    ;PT TO ASCII CS BUFFER
        LXI H,TABLE     ;POWERS OF TEN TABLE
NXTDIG  MVI A,30H       ;PUT ZERO IN DIGIT
        STAX B
REPEAT  PUSH H          ;SAVE TABLE PTR
        LXI D,BICS      ;PT TO BINARY VALUE
        LDAX D          ;SUB PWR 10 FROM BINARY VALUE
        SUB M
        STAX D
        INX D
        INX H
        LDAX D
        SBB M
        STAX D
        INX D
        INX H
        LDAX D
        SBB M
        STAX D
        POP H
        LDAX B
        INR A
        STAX B
        JNC REPEAT      ;STILL >0
        DCR A           ;TOO FAR ADD BACK
        STAX B
        LXI D,BICS
        LDAX D
        ADD M
        STAX D
        INX D
        INX H
        LDAX D
        ADC M
        STAX D
        INX D
        INX H
        LDAX D
        ADC M
        STAX D
        INX B           ;PT TO NEXT DIGIT
        INX H           ;PT TO NEXT 10
        XRA A
        CMP M           ;IF TABLE VALUE ZERO QUIT
        JNZ NXTDIG
        MVI D,4         ;KILL LEADING 0
        MVI A,48
        LXI H,CHKSUM
SPACES  CMP M
        JNZ PRTCSM
        MVI M,32
        INX H
        DCR D
        JNZ SPACES
PRTCSM  LXI D,FNAME     ;PRINT CHECKSUM
EXIT    CALL PRMSG
        RET
PRMSG   MVI C,9
        JMP BDOS
BICS    DS 3
TABLE   DB 80H,96H,98H,40H,42H,0FH,0A0H,86H,1H,10H,27H,0,0E8H,3,0
        DB 64H,0,0,0AH,0,0,1,0,0,0
FNAME   DS 8
        DB '.'
        DS 3
        DB ' Checksum = '
CHKSUM  DS 8
        DB 10,10,'$'
CMDMSG  DB 10,10,'COMMAND ERROR: type CHECK d:filename.type$'
FNFMSG  DB 10,10,'FILE NOT FOUND.$'
SIGNON  DB 10,10,'Model 100 SIG Checksum Calculator',13,10,10,'$'
        END
