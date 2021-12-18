;==============================================
;ZIPDIR.ASM    (c)1991 Wilson Van Alst        ;
;v1.0            All rights reserved.         ;
;                                             ;
;AltLCD utility to sort the file directory    ;
;==============================================

;ROM calls

;for M100
nxtfil  equ     8405    ;HL^next valid file
compar  equ     23149   ;chr(HL)-chr(DE) for C
usrfil  equ     63930   ;first user dir file
linbuf  equ     63109   ;lineinput buffer
menu    equ     22423   ;MENU
movhdb  equ     9538    ;(HL)->(DE) for B

;for T200
;menu	equ	26532
;LINBUF	EQU	61296
;compar equ     28177
;dirtop	equ	62133
;nxtfil  equ 	11250
;movhdb	equ	12967

;assigned values
r1      equ     lodh+1  ; ** runtime mod
flag    equ     passok+1 ; ** runtime mod
TEMP    equ     linbuf  ;for temporary storage
dirtop  equ     usrfil  ;just a different name
; ** addresses are modified within the program at runtime

;==============================================

        lxi h,menu      ;HL^exit adrs
	push h		;set for RET
mopass:	xra a		;A=0
	sta flag 	;set flag=0
        lxi h,dirtop-11 ;HL^below 1st file
        call nxtfil     ;HL^first valid ufile
        RZ              ;if none:MENU
mofile	shld r1		;store in R1
	mov d,h		;DE^R1
	mov e,l
        call nxtfil     ;HL^R2
        jz passok       ;if R2=end of dir
	push h		;save R2
        lxi b,3         ;BC=name offset
        dad b           ;HL^R2name
        xchg            ;HL^R1,DE^R2name
        dad b           ;H^R1name,D^R2name
	mvi c,8		;B=count
        call compar     ;chr(R1)-chr(R2)
        pop h           ;HL^R2
        jnc mofile      ;don't swap if
                        ; R2>=R1

swap    lxi d,TEMP      ;DE^ TEMP storage
        push d          ;TEMP for later
        push h          ;R2 for later
        call mov11      ;mov R2->TEMP
	pop d		;DE^R2
lodh    lxi h,00        ;HL^R1 **
        push h          ;R1 for later
        call mov11      ;mov R1->R2
	pop d		;DE^R1
        pop h           ;HL^TEMP
        call mov11      ;mov TEMP->R1
	xra a		;A=0
	dcr a		;A=ffh
	sta flag	;set flag=ffh

passok  mvi a,0         ;A=flag **
	ana a		;is it 0?
	jnz mopass	;no:go again
        ret             ;yes:MENU

mov11	mvi b,11	;B=count
        jmp movhdb      ;ROM routine

        end
;==============================================

