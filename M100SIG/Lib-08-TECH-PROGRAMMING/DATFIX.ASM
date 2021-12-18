;DATFIX.ASM  Model 100/102 DATE$ bug handler
;   Copyright 1990 Tri-Mike Network East
;              by Mike Nugent

;For noncommercial use by private individuals.
;All other rights reserved.

;Designed for minimum CPU cycles/bytes, DATFIX is spliced
;into the background task via the TP timing pulse (TP) hook
;at F5FF, executing every 4 milliseconds. The code at DATFIX
;duplicates ROM code at 1B35 (where the hook would normally
;return) except that XTHL replaces the ROM's PUSH H, thus
;pushing HL onto the stack and doing away with the return
;address of 1B35.

;Then DATE calls CHKYR to see if it's time to roll over to a
;new year. CHKYR first checks whether the PEND flag is set.

;When PEND is not set, the code falls through to NOPEND,
;which checks to see if it's December 31 yet. If so, it sets
;the PEND flag before returning; otherwise it simply
;returns.

;When PEND is set (meaning it's December 31) CHKYR causes a
;jump to ISPEND. ISPEND simply looks to see when midnight
;has passed (i.e., the date has become January 1). Once it
;has become January 1, our own stored year digit (at YRFIX)
;is incremented, and the PEND flag is reset.

;Upon returning from either subroutine, FIXYR plugs our own
;year-one's digit into F92D, where the computer stores it,
;thus keeping the year correct. Then it jumps to 1B3D in the
;system ROM to continue the background task. Voila!

;Note that FIXYR is the operand byte (n) of the MVI A,n
;instruction. Whatever program is used to install this code
;should poke the desired value (0-9) of the year-one's
;digit into FIXYR. Thereafter, the code will update the year
;automatically.

;RST 7.5 does DI:JMP 1B32
;1B32: CALL F5FF
;F5FF: JMP DATFIX

        org ea60h       ;arbitrary--for development only

datfix: xthl            ;push hl, waste RET to 1b35
        push d          ;save all regs
        push b
        push psw
        mvi a,0dh       ;allow only
        sim             ;UART intrpt
        ei
date:   call chkyr      ;chk rollover
fixyr:  mvi a,0         ;a<-correct yr
yrfix:  equ $-1         ;from here
        sta f92dh       ;plug it in
        jmp 1b3dh       ;continue w/ROM

;--- datfix s/r's ---

chkyr:  lxi d,pend      ;de^12/31 flag
        ldax d          ;a<-flag
        ora a           ;new yr pending?
        lda f92ch       ;a<-mth (1-12), regardless
        jnz ispend      ;nw yr pending
nopend: sui 0ch         ;december?
        rnz             ;no
        lhld f939h      ;hl<-day bytes
        dcr h           ;is 3x?
        dcr h
        dcr h
        rnz             ;no
        dcr l           ;is 31st?
        rnz             ;no
        inr a           ;a<-1
        stax d          ;set pend flag
        ret
ispend: dcr a           ;january yet?
        rnz             ;no
        stax d          ;yes, reset flg
        lxi h,yrfix     ;and update our
        inr m           ;year fix val
        ret

pend:   db 0            ;pending rollover flag

pgmsiz: equ $-datfix
        end

