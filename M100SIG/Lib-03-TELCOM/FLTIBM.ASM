;FLTIBM.ASM  -- Phil Wheeler  [71266,125]
;
;Version 1.7 -- 9/25/86
;
;
;TRS-80 Model 100 <--> IBM-PC File Transfer Utility
;
;Transfers ASCII files to/from Model 100 at
;9600 baud.  Use setting 88N1E and Save & Load on Model 100
;Examples are:
;   In TEXT: Save to:com:88n1e
;   in BASIC: Save"com:88n1e"
;
;Requires RS-232 cable with "Null Modem Adapter"
;for computer interconnect.
;
;Based on FLTKP.100 written by Don Corbitt, Feb 1984
;as modified to FLTKP.UPD by Phil Wheeler, July 1984
;
;Adapted to IBM-PC and Compatibles, July 1985
;No BIOS functions used; generic MS-DOS code,
;but comm port set-up is for IBM/Compatibles
;
;Change COM1 equate to select COM: port -- TRUE for COM1:
;and FALSE for COM2:
;
;Modified to prompt for
;overwrite of existing files      pcw -- 7/22/85
;
;Modified for WS stripping        pcw -- 8/1/85
;
;Minor menu changes               pcw -- 8/4/85
;
;Send hang-up fixed; M100
;hardware issue                   pcw -- 8/6/85
;
;Time-out count increased to
;let Basic programs be sent       pcw -- 8/8/85
;
;Further changes in time-out
;code                             pcw -- 5/26/86
;
;Still more changes in timing.
;Change to two-stage counter
;to allow counts larger than
;FFFFh and user patch of
;timing using DEBUG.              pcw -- 6/8/86
;
;Version to do EOF on CHR$(206)
;embedded in transmitted file.
;See minor patch at 'rloop:'      pcw -- 9/22/86
;
;
CODE    SEGMENT
        ASSUME    CS:CODE,DS:CODE

        ORG     100H
M       EQU     Byte Ptr 0[BX]
FALSE   EQU     0
TRUE    EQU     NOT FALSE
COM1    EQU     TRUE                    ;TRUE = COM1:, FALSE = COM2:
BDOS    EQU     5
FCBL    EQU     5ch
dbuff   EQU     80h                     ;disk i/o buffer
conin   EQU     1                       ;get char from console - wait
printf  EQU     9                       ;print buffer function (DE) until '$'
inlinf  EQU     10                      ;read buffer from console
openf   EQU     15                      ;open file,
closef  EQU     16                      ;close file after write
search  EQU     17                      ;look for file - ff if not found
readf   EQU     20                      ;read block from file
writef  EQU     21                      ;write block to file
makef   EQU     22                      ;make a file entry
bell    EQU     7
cr      EQU     13
lf      EQU     10
nul     EQU     0
eof     EQU     1ah                     ;end of file signal
xoff    EQU     19                      ;stop transmission
xon     EQU     17                      ;start transmission
SPACE   EQU     20h                     ;space
COUNT   EQU     30000                   ;send time-out count
CNTSCL  EQU     2                       ;count loop multiplier

;Wordstar attributes optionally stripped

SCR     EQU     8Dh                     ;soft cr
SLF     EQU     8Ah                     ;soft lf
SHYPHE  EQU     1Fh                     ;eol soft hyphen
SHYPHM  EQU     1Eh                     ;mid-text soft hyphen
NBSPC   EQU     0Fh                     ;no-break space
CTLB    EQU     02h                     ;control-b
CTLD    EQU     04h                     ;control-d
CTLS    EQU     13h                     ;control-s
CTLT    EQU     14h                     ;control-t
CTLV    EQU     16h                     ;control-v
;
;
;Set up 8250 UART addresses for selected com port
;
        IF COM1                         ;PORT IS COM1
;
UARTD   EQU     3F8H                    ;DATA PORT
UARTS   EQU     3FDH                    ;STATUS PORT
URTSNDR EQU     20H                     ;SEND-READY TEST
URTRCVR EQU     01H                     ;RCV-READY TEST
LCREG   EQU     3FBH                    ;LINE CONTROL REG
BDLSB   EQU     3F8H                    ;BAUD DIVISOR LSB
BDMSB   EQU     3F9H                    ;BAUD DIVISOR MSB
INTREG  EQU     3F9H                    ;INTERRUPT ENABLE REG
MDMREG  EQU     3FCH                    ;MODEM CONTROL REG
;
        ELSE                            ;THEN IT'S COM2
;
UARTD   EQU     2F8H                    ;DATA PORT
UARTS   EQU     2FDH                    ;STATUS PORT
URTSNDR EQU     20H                     ;SEND-READY TEST
URTRCVR EQU     01H                     ;RCV-READY TEST
LCREG   EQU     2FBH                    ;LINE CONTROL REG
BDLSB   EQU     2F8H                    ;BAUD DIVISOR LSB
BDMSB   EQU     2F9H                    ;BAUD DIVISOR MSB
INTREG  EQU     2F9H                    ;INTERRUPT ENABLE REG
MDMREG  EQU     2FCH                    ;MODEM CONTROL REG
;
        ENDIF

START:  JMP     BEGIN

WFLAG   DB       0                      ;WS flag
fbuff   DB      18
        DB      18 DUP(?)
fexmsg  DB      bell,cr,lf,'File exists! Overwrite?  $'
wrtmsg  DB      '  Will Do! $'
recmsg  DB      cr,lf,'File to receive: $'
sndmsg  DB      cr,lf,'File to send: $'
nfmsg   DB      bell,cr,lf,'File does not exist!!',cr,lf,'$'
TRYMSG  DB      bell,cr,lf,'Send loop lock-up. Check M100 set-up '
        DB      'and try again! $'
PGMMSG  DB      cr,lf,lf
        DB      'FLTIBM ASCII File Transfer (COM1:) -- Version 1.7'
        DB      cr,lf,lf
        DB      'Use with COM:88N1E & Save or Load on Model 100'
        DB      cr,lf,'Works with TEXT or BASIC',cr,lf,'$'
MENMSG  DB      cr,lf,'Selections are:',cr,lf,lf
        DB      '  [Q] Return to DOS',cr,lf
        DB      '  [S] Send file to M100',cr,lf
        DB      '  [W] Send stripped WS file to M100',cr,lf
        DB      '  [R] Receive file from M100',cr,lf,lf
        DB      'Enter your selection: $'

BEGIN:
;
;Initialize 8250 UART for 9600 baud, 8 bits, 1 stop bit, no parity
;Use the ports for set-up (vs. ROMBIOS INT 14H), so that it will
;work on compatibles -- like my Z-150.


RTN1:   MOV     DX,LCREG                ;LINE CONTROL REGISTER
        MOV     AL,80H                  ;
        OUT     DX,AL                   ;TO ADDRESS BAUD RAT DIVISOR

RTN2:   MOV     DX,BDLSB                ;ADRS OF RATE DIV LSB
        MOV     AL,0CH                  ;9600 BAUD LSB
        OUT     DX,AL                   ;SET BAUD RATE -- LSB DIVISOR

RTN3:   MOV     DX,BDMSB                ;MSB ADRS
        MOV     AL,0                    ;MSB FOR 9600 BAUD
        OUT     DX,AL                   ;SET BAUD RATE -- MSB DIVISOR

RTN4:   MOV     DX,LCREG                ;LINE CONTROL REGISTER
        MOV     AL,013H                 ;NO PARITY, 1 STOP BIT, 8 BITS
        OUT     DX,AL                   ;SET PARAMS ABOVE

RTN5:   MOV     DX,MDMREG               ;ADRS OF MDM CONTROL REG
        MOV     AL,03H                  ;SET FOR DTR AND RTS
        OUT     DX,AL                   ;IT MAY NOT MATTER, BUT DO IT!

RTN6:   MOV     DX,INTREG               ;ADRS OF ENABLE INTERRUPT REG
        MOV     AL,0                    ;
        OUT     DX,AL                   ;DISABLE 8250 INTERRUPTS
INIT:
        MOV     DX,OFFSET PGMMSG
        MOV     AH,PRINTF
        INT     21H
loop1:
        MOV     DX,OFFSET MENMSG
        MOV     AH,printf
        INT     21H
        MOV     AH,conin
        INT     21H
        CALL    touppr                  ;get upper case letters
        CMP     AL,'Q'                  ;test for quit
        JNZ     L_1                     ;no
        INT     20H                     ;yes -- return to DOS
L_1:
        CMP     AL,'W'                  ;send stripped WS file to M100
        JZ      SETFL1                  ;go set WS flag on (=1)
        CMP     AL,'S'                  ;send normal file to M100
        JZ      SETFL0                  ;go set WS flag off (=0)
        CMP     AL,'R'                  ;receive file from M100
        JNZ     LOOP1                   ;try again
        JMP     receive
SETFL0:
        MOV     DI,OFFSET WFLAG         ;flag address in ah
        MOV     AH,0                    ;off value
        MOV     [DI],AH                 ;set WS flag
        JMP SHORT SEND
SETFL1:
        MOV     DI,OFFSET WFLAG         ;flag address in ah
        MOV     AH,1                    ;on value
        MOV     [DI],AH                 ;set WS flag
        JMP SHORT SEND
send:
        MOV     DX,(Offset sndmsg)      ;'Enter file to send'
        MOV     AH,printf
        INT     21H
        CALL    gfspec                  ;get the file name, and see if it exists
        JNZ     sendit                  ;it exists, so send it
        MOV     DX,(Offset nfmsg)       ;'File doesn't exist'
        MOV     AH,printf
        INT     21H
        JMP     loop1                   ;try again
sendit:
        MOV     BX,(Offset stbuff)      ;end of program - start of buffer
        PUSH    BX
        MOV     DX,fcbl
        MOV     AH,openf                ;open file and read contents
        INT     21H
sloop:  MOV     AH,readf
        MOV     DX,fcbl
        INT     21H
        POP     DI                      ;PT TO CURRENT END OF DATA
        MOV     SI,DBUFF                ;PT TO DMS BUFFER
        MOV     CX,80H                  ;BUFFER SIZE
        REP MOVSB                       ;MOVE BLOCK
        PUSH    DI                      ;NEW END OF DATA
        AND     AL,AL                   ;nz = EOF
        JNZ     sendfil
        JMP SHORT    sloop
sendfil:
        MOV     DX,FCBL
        MOV     AH,CLOSEF               ;CLOSE SEND FILE
        INT     21H
        POP     BX                      ;arrange stack - discard this value
        MOV     BX,(Offset stbuff)      ;buffer ended with EOF, OK?
sloop1: MOV     CL,M                    ;get char
        MOV     CH,WFLAG                ;get WS flag
        CMP     CH,0                    ;test the flag
        JZ      WSEND                   ;not WS -- bypass stripping
SOFTCR:
        CMP     CL,SCR                  ;is it a soft CR?
        JNZ     SOFTLF                  ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
SOFTLF:
        CMP     CL,SLF                  ;is it a soft lf?
        JNZ     HIBIT                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
HIBIT:
        CMP     CL,80H                  ;char > 80h?
        JNA     HDLF                    ;no. leave it as-is
        SUB     CL,80H                  ;yes. reduce it by 80h
HDLF:
        CMP     CL,LF                   ;is it a hard lf?
        JNZ     HDSPC                   ;no..bypass
        MOV     CL,NUL                  ;yes..replace by null
        JMP     WSEND                   ;send it!
HDSPC:
        CMP     CL,NBSPC                ;is it a non-break space?
        JNZ     HYPH1                   ;if not, bypass
        MOV     CL,SPACE                ;it is! replace with a space
        JMP     WSEND                   ;send it!
HYPH1:
        CMP     CL,SHYPHE               ;is it an eol soft hyphen?
        JNZ     HYPH2                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
HYPH2:
        CMP     CL,SHYPHM               ;is it a mid soft hyphen?
        JNZ     CONTB                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
CONTB:
        CMP     CL,CTLB                 ;is it a control-b
        JNZ     CONTD                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
CONTD:
        CMP     CL,CTLD                 ;is it a control-d
        JNZ     CONTS                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
CONTS:
        CMP     CL,CTLS                 ;is it a control-s
        JNZ     CONTT                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
CONTT:
        CMP     CL,CTLT                 ;is it a control-t
        JNZ     CONTV                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
CONTV:
        CMP     CL,CTLV                 ;is it a control-v
        JNZ     WSEND                   ;if not, bypass
        MOV     CL,NUL                  ;it is! replace with a null
        JMP     WSEND                   ;send it!
WSEND:
        LAHF
        INC     BX
        SAHF
        CALL    rsout                   ;send char
        CMP     AL,eof
        JNZ     NWCHAR
        JMP     send                    ;end of file - send new file??
NWCHAR:
        CALL    rsist                   ;char waiting??
        JNZ     SKSKIP
        JMP     SLOOP1
SKSKIP: CALL    RSINT                   ;get char
        CMP     AL,xoff                 ;if xoff, then wait.....
        JZ      SLOOP2
        JMP     sloop1                  ;else ignore it
sloop2:
        CALL    RSINT
        CMP     AL,xon
        JNZ     sloop2
        JMP     sloop1
;rs output status. Z if uart busy, NZ otherwise.  A modified.
rsost:
        PUSH    DX
        MOV     DX,uarts
        IN      AL,DX
        AND     AL,URTSNDR
        POP     DX
        RET
;RS character out, character in C
rsout:                                  ;send byte in C to uart
        CALL    rsost
        JZ      rsout
        PUSH    DX
        MOV     DX,uartd
        MOV     AL,CL
        OUT     DX,AL
        POP     DX
        RET
;rs input status.  Z if no char waiting, NZ if char ready.
rsist:
        PUSH    DX
        MOV     DX,uarts
        IN      AL,DX
        AND     AL,URTRCVR              ;char waiting?
        POP     DX
        RET

;get char from uart and return in A (TX loop)

RSINT:
        PUSH    BX
        MOV     BX,COUNT                 ;set up a COUNT loop counter
RSINX:
        CALL    CNTOUT
        CALL    RSIST                    ;char wait test
        JZ      RSINX                    ;loop if none
        PUSH    DX
        MOV     DX,uartd
        IN      AL,DX
        POP     DX
        POP     BX
        RET

;escape path if locked in Xoff due to M100 buffer full

CNTOUT:
        DEC     BX
        CMP     BX,0
        JZ      TMOUT                    ;too long in loop!
        PUSH    BX
        MOV     BX,CNTSCL                ;initialize scaling loop

SCALE:
        DEC     BX
        CMP     BX,0
        JNZ     SCALE                    ;cycle CNTSCL times
        POP     BX
        RET

TMOUT:
        POP     BX                       ;clean up
        MOV     DX, OFFSET TRYMSG        ;print message
        MOV     AH,PRINTF
        INT     21H
        JMP     SEND                     ;go to send loop

;get char from uart and return in A (RX loop)

RSINR:
        CALL    RSIST                    ;char wait test
        JZ      RSINR                    ;loop if none
        PUSH    DX
        MOV     DX,uartd
        IN      AL,DX
        POP     DX
        RET
RECEIVE:
        MOV     DX,(Offset recmsg)
        MOV     AH,printf
        INT     21H
        CALL    gfspec
        JZ      rcvit                   ;doesn't exist, so get it
EXTMSG: MOV     DX,(Offset fexmsg)      ;say it exists
        MOV     AH,printf               ;and ask about overwrite
        INT     21H                     ;of the existing file
        MOV     AH,CONIN                ;get a character
        INT     21H
        CALL    TOUPPR                  ;make it upper case
        CMP     AL,'Y'                  ;overwrite is yes?
        JZ      OVRMSG                  ;show a response! then do it
        CMP     AL,'N'                  ;overwrite is no?
        JZ      RECEIVE                 ;then get a new name
        JMP     EXTMSG                  ;not yes or no; ask again!
OVRMSG:
        MOV     DX,OFFSET WRTMSG        ;get the message
        MOV     AH,PRINTF
        INT     21H                     ;show it -- then do it!
RCVIT:
        MOV     DX,fcbl
        MOV     AH,makef
        INT     21H
        MOV     BX,(Offset stbuff)
rloop:  CALL    RSINR                   ;get a char
        CMP     AL,206                  ;see if it is a '206'
        JNZ     NOREPL
        MOV     AL,eof                  ;replace '206' by '26'
NOREPL: MOV     M,AL                    ;and put in buffer
        INC     BX
        CMP     AL,eof                  ;if not last
        JZ      ENDLOOP
        JMP     rloop                   ;then get another
ENDLOOP:
        MOV     BX,(Offset stbuff)
secloop:
        MOV     DX,dbuff
        MOV     CH,80h
byteloop:
        MOV     AL,M
        MOV     SI,DX
        MOV     [SI],AL
        CMP     AL,eof
        JZ      lastone
        LAHF
        INC     BX
        SAHF
        LAHF
        INC     DX
        SAHF
        DEC     CH
        JNZ     byteloop
        CALL    wsect
        JMP SHORT    secloop
        JMP     lastone
lastloop:
        MOV     SI,DX
        MOV     [SI],AL
lastone:
        LAHF
        INC     DX
        SAHF
        DEC     CH
        JNZ     lastloop
        CALL    wsect
        MOV     DX,fcbl
        MOV     AH,closef
        INT     21H
        JMP     receive                 ;end of file - get another one??
wsect:
        PUSH    BX                      ;save position in buffer
        MOV     DX,fcbl
        MOV     AH,writef
        INT     21H
        POP     BX
        RET
touppr:
        CMP     AL,'a'
        JNB     L_3
        RET
L_3:
        CMP     AL,'z'+1
        JNAE    L_4
        RET
L_4:
        AND     AL,5fh
        RET
gfspec:
        MOV     BX,fcbl
        MOV     CH,33                   ;33 bytes to erase
        XOR     AL,AL
erase:  MOV     M,AL
        INC     BX                      ;next byte in fcbl
        DEC     CH
        JNZ     erase
        MOV     BX,fcbl+1
        MOV     CH,11                   ;file name block - default spaces
        MOV     AL,32                   ;space
erase1: MOV     M,AL
        INC     BX
        DEC     CH
        JNZ     erase1
        MOV     DX,(Offset fbuff)       ;buffer to hold file name
        PUSH    DX                      ;save start of buffer
        MOV     AH,inlinf               ;read line from keyboard
        INT     21H                     ;get line
        POP     BX                      ;start of buffer (max count)
        INC     BX                      ;actual value returned
        MOV     AL,M
        AND     AL,AL                   ;no chars in queue??
        MOV     CH,AL                   ;count in b
        JNZ     congsp                  ;if chars, continue get file spec
        POP     BX                      ;remove one level of subroutines
        JMP     loop1                   ;start over with menu
congsp:
        INC     BX                      ;first char of fspec
        INC     BX                      ;second char of fspec
        MOV     AL,M                    ;get ':' if in fspec
        DEC     BX                      ;first char of fspec
        CMP     AL,':'
        MOV     AL,0                    ;zero (A) without affecting flags
        JNZ     noprefix
        DEC     CH
        DEC     CH                      ;skipping first two chars of buffer
        MOV     AL,M
        CALL    touppr
        SBB     AL,'@'                  ;get value from 1 to 17 (A to P)
        MOV     SI,fcbl
        MOV     [SI],AL
        INC     BX                      ;point to ':'
        INC     BX                      ;point to first char of name
noprefix:
        MOV     DX,fcbl+1               ;start of name section of fcbl
nprloop:
        MOV     AL,M
        CALL    touppr
        CMP     AL,'.'
        JZ      stext                   ;start extension
        MOV     SI,DX                   ;put in fcbl
        MOV     [SI],AL
        LAHF
        INC     BX
        SAHF
        LAHF
        INC     DX
        SAHF
        DEC     CH
        JNZ     nprloop
exist:
        MOV     AH,search
        MOV     DX,fcbl
        INT     21H
        INC     AL
        RET
stext:
        LAHF                            ;skip '.'
        INC     BX
        SAHF
        MOV     DX,fcbl+9               ;start of extension
        DEC     CH
        JZ      exist                   ;done
extloop:
        MOV     AL,M
        CALL    touppr
        MOV     SI,DX
        MOV     [SI],AL
        LAHF
        INC     BX
        SAHF
        LAHF
        INC     DX
        SAHF
        DEC     CH
        JNZ     extloop
        JMP SHORT    exist

endbuff DW      0
stbuff  LABEL WORD              ;start of free space

CODE    ENDS
        END     start
