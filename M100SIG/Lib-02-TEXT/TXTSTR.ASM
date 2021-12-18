;TextStar - Wordstar(tm) commands
;for the Model 100
; Version 1.0   11 October 1988
;
;Copyright (c) 1988 by Stanley Wong
;All Rights Reserved
;
;This file and related TextStar files
;may not be redistributed beyond CIS
;without my permission. CIS 70346,1267
;
;ADSM assembler syntax
;See Table 1 for commands supported.
;See Listing 2 for Basic loader
;
;Equates
;
MENU    EQU     22423D  ;go to main MENU
                        ;($5797)
TEXT    EQU     24046D  ;TEXT program
                        ;entry ($5DEE)
BEEP    EQU     7662H   ;beep routine
GETKEY  EQU     64222D  ;GHGET hook
                        ;($FADE)
;
;Other Rom Routine Addresses
;----------------------------
;$5FF0 - return to TEXT from GHGET
;$6005 - process control key
;$608A - process keystroke
;$6118 - DEL routine
;
        ORG     62500
WSTINI  LHLD    GETKEY  ;point to
                        ;GETKEY hook
        SHLD    GKHOOK  ;save original
                        ;value
        LXI     H,TS1   ;point to our
                        ;code to examine
                        ;keystrokes
        SHLD    GETKEY  ;GETKEY hook to
                        ;our code
        LHLD    $FB12   ;save original
                        ;menu hook
        SHLD    MHOOK
        LXI     H,F8    ;set Menu hook
                        ;to our code
        SHLD    $FB12
        LXI     H,0
        SHLD    F6E7H
        JMP     TEXT   ;enter TEXT
                       ;program
;
;Examine Key Press
; Code at TS1 inserts a RETurn to here
; if in TEXT
; TS1 is called from GETKEY RST 7 hook
;
WSTXT
;--------------------------------------
;This code is Copyright by Microsoft
        STA     F6DFH   ;Duplicate ROM
                        ;code here
        PUSH    PSW     ;until we detect
                        ; CTRL keystroke
        CALL    65ECH
        POP     PSW
        JC      6501H
        CPI     127
        JZ      6118H   ;DEL key
        CPI     32
;--------End of Microsoft code---------
        JC      CTRL    ;CTRL key
;A regular character received
        PUSH    PSW
        LDA     CQFLAG  ;check ctrl-Q
                        ;flag
        CPI     1
        JZ      CQON    ;^Q in effect
        LDA     CKFLAG  ;check ctrl-K
                        ;flag
        CPI     1
        JZ      CKON    ;^K in effect
        POP     PSW
        JMP     608AH   ;continue in rom
;
;control-K in effect
CKON    MVI     A,0     ;turn off flag
        STA     CKFLAG
        POP     PSW
        CALL    LW2UP   ;force to upper
                        ;case
        CPI     66      ;^KB?
        JZ      CTRLKB
        CPI     89      ;^KY?
        JZ      CTRLKY
        CPI     68      ;^KD?
        JZ      F8
        MVI     A,10    ;ignore
        JMP     $6005
;
;control-Q in effect
CQON    MVI     A,0     ;turn off flag
        STA     CQFLAG
        POP     PSW
        CALL    LW2UP
        CPI     67      ;^QC?
        JC      IGN2
        JZ      CTRLQC
        CPI     68      ;^QD?
        JZ      CTRLQD
        CPI     83      ;^QS?
        JZ      CTRLQS
        CPI     88      ;^QX?
        JZ      CTRLQX
        CPI     82      ;^QR?
        JZ      CTRLQR
        CPI     69      ;^QE?
        JZ      CTRLQE
        CPI     89      ;^QY?
        JZ      CTRLQY
IGN2    MVI     A,10    ;ignore
        JMP     $6005
;
;Look for our control characters
;
CTRL    CPI     7       ;ctrl-G ?
        JZ      $6118   ;yes-jump to
                        ;DEL routine
        CPI     20      ;ctrl-T ?
        JZ      CTRLT
        CPI     25      ;ctrl-Y ?
        JZ      CTRLY
        CPI     11      ;ctrl-K ?
        JZ      CTRLK
        CPI     17      ;ctrl-Q ?
        JZ      CTRLQ
        JMP     6005H   ;continue in ROM
;
CTRLK   PUSH    PSW     ;^K received,
                        ;wait for next
                        ;char.
        MVI     A,1     ;set ckflag
        STA     CKFLAG
        POP     PSW
        RET
;
CTRLQ   PUSH    PSW     ;^Q received,
                        ;wait for next
                        ;char.
        MVI     A,1     ;set cqflag
        STA     CQFLAG
        POP     PSW
        RET
;---------------------------------------
CTRLKB  MVI     A,12    ;^L - select
                        ;text mode
        JMP     $6005
CTRLKY  MVI     A,21    ;^U - cut(F6)
        JMP     $6005
;---------------------------------------
CTRLQC  MVI     A,26    ;move to eof
                        ;(^Z)
        JMP     $6005
CTRLQD  MVI     A,18    ;end of line
                        ;(^R)
        JMP     $6005
CTRLQE  MVI     A,20    ;top of screen
                        ;(^T)
        CALL    $6005
        LDA     F788H
        CPI     0
        JNZ     X1
        MVI     A,10
        JMP     $6005
X1      MVI     A,17
        JMP     $6005
CTRLQR  MVI     A,23    ;beginning of
                        ;file (^W)
        JMP     $6005
CTRLQS  MVI     A,17    ;beginning of
                        ;line (^Q)
        JMP     $6005
CTRLQX  MVI     A,2     ;bottom of
                        ;screen (^B)
        CALL    $6005
        MVI     A,18    ;right end of
                        ;last line
        JMP     $6005
CTRLQY  MVI     A,12    ;^L - select
                        ;text mode
        CALL    $6005
        MVI     A,18    ;^R - beginning
                        ;of line
        CALL    $6005
        MVI     A,21    ;^U - cut
        JMP     $6005
;---------------------------------------
CTRLT   MVI     A,12    ;^L - select
                        ;text mode
        CALL    $6005
        MVI     A,6     ;^F - move to
                       ; next word
        CALL    $6005
        MVI     A,21    ;^U - cut (F6)
        JMP     $6005
;
CTRLY   MVI     A,17    ;^Q - move to
                        ;left of line
        CALL    $6005
        MVI     A,12    ;^L - select
                        ;text mode
        CALL    $6005
        MVI     A,24    ;^X - move
                        ;down a line
        CALL    $6005
        MVI     A,21    ;^U - cut (F6)
        JMP     $6005
;
;
;RST 7 hook from GETKEY
;
;10 levels down in stack is the return
; address to the calling routine.  If it
; is 5FF0H then the call is from TEXT.
; Put a return to WSTXT. If not, then
; leave everything alone.
;
TS1     DI              ;don't bother
                        ;me, kid...
        PUSH    B       ;save registers
                        ;used
        PUSH    D
        LXI     H,0
        DAD     SP
        XCHG            ;save SP in D
;
	LXI	B,20	;get return
                        ;address 10
	LXI	H,0	;layers down in
                        ;stack
	DAD	SP	;HL<--SP
	DAD	B	;HL<--SP+20
	SPHL		;SP<--SP+20
;
        LXI     H,WSTXT ;RETurn to WSTXT
                        ;instead of
                        ;5FF0H
        XTHL
        LXI     B,$5FF0	;Was it called
                        ;from TEXT?
        DB	8       ; (hl<--hl-bc)
        JZ      TSX     ;Yes
        DAD     B
        XTHL            ;No
TSX     XCHG            ;Restore stack
        SPHL		;(old SP was
                        ;in DE)
        POP     D
        POP     B
        EI              ;allow
                        ;interrupts
        RET             ;RETurn from
                        ;hook
;
;Menu hook (F8 keypress to exit WS-TEXT)
;
F8      PUSH    H
        LHLD    GKHOOK  ;Restore
                        ;original GETKEY
                        ;hook
        SHLD    GETKEY
        LHLD    MHOOK   ;Restore
                        ;original Menu
                        ;hook
        SHLD    $FB12
        POP     H
        JMP     MENU    ;return to MENU
;
;Convert lower to upper case
; input/output in A-register
LW2UP   CPI     97      ;lower case is
        RC              ; in the range
        CPI     123     ; 97<=A<=122
        RNC
        SUI     32      ;convert
        RET
;
;Storage
;
GKHOOK  DW      0       ;GETKEY hook
MHOOK   DW      0       ;MENU hook
CKFLAG  DB      0       ;ctrl-K flag
CQFLAG  DB      0       ;ctrl-Q flag
;
        END             ;of TextStar
