*
*       PIXTEL.ASM: Wally Hubbard 70346,1716 10/16/85
*       This program attaches to the M100 TELCOM program
*       and displays CompuServe hi-res (GH) and medium-res
*       (GM) graphics live, on-line.
*       It is written to be assembled with ASM.COM under CP/M.
*       It is not necessary to download this program unless
*       you want to re-write this program.  Download PIXTEL.BAS
*       and RUN it to create the necessary file.  See PIXTEL.DOC
*       for more information.
*
;
;
;
mcenter equ     240-64          ;set centering for medium res pix
mleft   equ     mcenter-64
mright  equ     mcenter+64
length  equ     190h            ;approx. length of this program
maxram  equ     62960           ;highest usable RAM address + 1
bgoff   equ     765ch           ;turns background task off
enable  equ     753bh           ;use dtable to enable one LCD driver
bgon    equ     743ch           ;turns background task on again
dtable  equ     7643h           ;table for enable routine
wait    equ     7548h           ;wait for LCD ready signal
lcdaddr equ     0feh            ;LCD address port
lcddata equ     0ffh            ;LCD data port
hook    equ     0fadah          ;RST 7 hook table address
lcdhook equ     hook+8          ;address of LCD hook routine
escflag equ     0f646h          ;escflag<>0 if last char was escape
telcom  equ     5146h           ;entry point for TELCOM program
sd232c  equ     6e32h           ;send a character to the modem
cursoron equ    44afh           ;turn cursor on
cursoroff equ   44bah           ;turn cursor off
syslin  equ     4437h           ;turn off label line
clreos  equ     454eh           ;clear to end of screen
menuflag equ    0fac8h          ;used by menu
;
;
;
        org     maxram-length
;
;
;
;       This program examines each character going to the LCD
;       screen before it is printed.  If the last character was
;       an escape, then it looks for the next character to be
;       a G or an I.  If it's a G, it sets a flag and waits for
;       an H or an M.  If either is found, this program gobbles
;       all data going to the LCD and interprets it as graphics
;       until another escape is detected.  Then it resumes passing
;       unaltered characters to the LCD display routines.
;       If it detects an escape-I sequence, it sends CompuServe
;       a CIS ID string.  It also watches a byte that is set
;       to 0ffh by MENU and disconnects itself when it appears
;       TELCOM has been exited.  Any previous hook is preserved.
;
start:
        lhld    lcdhook         ;save existing hook
        shld    oldhook+1
        lxi     h,intercept     ;install intercept routine
        shld    lcdhook
        xra     a               ;zero gflag
        sta     gflag
        sta     menuflag        ;zero menuflag
        jmp     telcom          ;enter the TELCOM program
;
;
;
oldhook:
        jmp     7ff3h           ;dummy value replaced by start
;
;
;
unhook:
        lhld    oldhook+1
        shld    lcdhook
        pop     psw
        ret
;
;
;
intercept:
        push    psw             ;save register a and flags
        lda     gflag           ;jump if gflag is set
        ana     a
        jnz     int1b
;
        lda     escflag         ;check if escflag is set
        ana     a
        jnz     int1            ;jump if the flag is set
;
        lda     menuflag        ;menu sets this to ff
        inr     a
        jz      unhook          ;menu active, so goodbye
;
int0    pop     psw             ;restore register a and flags
        jmp     oldhook         ;let the standard routines work
;
int1    pop     psw             ;restore register a
        push    psw
        ani     7fh             ;mask the high bit to 0
        cpi     'G'             ;is it the letter G?
        jz      int1a           ;yes, so get graphics mode
;
        cpi     'I'             ;is it the letter I?
        jnz     int0            ;no, so we won't interpose ourselves
;
        lxi     h,cisid         ;send CompuServe an ID
        pop     psw             ;no longer needed on stack
        xra     a               ;zero the
        sta     escflag         ;escape flag
id      mov     a,m
        ana     a
        jz      int5
        push    h
        mov     c,a
        call    sd232c          ;send a char
        pop     h
        inx     h
        jmp     id              ;do next char until a null is found
;
int1a   pop     psw             ;no longer needed on stack
        mvi     a,0ffh          ;set graphics flag
        sta     gflag
        jmp     int5            ;wait for next char
;
int1b   xra     a               ;zero gflag
        sta     gflag
        pop     psw
        ani     7fh             ;mask the high bit to 0
        cpi     'H'             ;is it the letter H?
        jz      int2            ;yes so jump
;
        cpi     'M'             ;is it the letter M?
        jz      int3            ;yes so jump
;
        jmp     oldhook         ;no so return
;
int2    xra     a               ;set mode to 0
        sta     mode
        mvi     a,247           ;start in column 247
        sta     column
        jmp     int4
;
int3    mvi     a,80h           ;set mode to 80h
        sta     mode
        mvi     a,mleft         ;start in column mleft
        sta     column
int4    call    syslin          ;turn off label line
;       call    clreos          ;clear to end of screen
        call    cursoroff       ;turn off cursor
        xra     a               ;zero the escape flag
        sta     escflag
        lxi     h,draw          ;now make draw the intercept routine
        shld    lcdhook
        mvi     a,0ffh          ;initial color is 0ffh, black
        sta     color
int5    pop     psw             ;pop one return address then
        jmp     14edh           ;finish and return
;
;
draw:
        ani     7fh             ;mask the high bit to 0
        cpi     7               ;is it a bell, ^G?
        rz                      ;yes, so return
        cpi     27              ;is it an escape?
        jnz     draw0           ;no, so continue
        push    psw             ;yes, so bug out and
        lxi     h,intercept     ;point the hook back to intercept
        shld    lcdhook
        call    cursoron        ;turn on cursor
        pop     psw
        ret
draw0   sui     32              ;subtract 32 from the char value
        jz      draw3           ;if 0 results, don't draw
        jc      draw4           ;return if char < ' '
draw1   push    psw             ;save registers on stack
        push    h
        lda     column          ;if column > 240 then don't draw
        cpi     240
        jnc     draw2
        lda     color           ;put current color in e
        mov     e,a
        call    colscr          ;draw a dot
draw2   pop     h
        lda     column          ;increment the column count
        inr     a
        sta     column
        cpi     mright          ;check if doing column number mright
        jnz     draw2b          ;nope, so jump
        lda     mode            ;are we in GM mode?
        ral
        jnc     draw2b          ;nope, so jump
        mvi     a,mleft         ;yep, so go back to column mleft
        sta     column
draw2b  pop     psw
        dcr     a               ;decrement count
        jnz     draw1           ;draw another dot if a<>0
draw3   lda     color           ;switch colors (black/white)
        xri     0ffh
        sta     color
draw4   pop     psw             ;pop one return address then
        jmp     14edh           ;finish and return
;
;
;
colscr  lda     column          ;get current column
        lxi     h,dtable+10     ;point HL to enable table
colscr1 sui     50              ;calculate LCD driver table index
        jc      colscr2
        inx     h
        inx     h
        jmp     colscr1
colscr2 push    h
        push    psw
        call    bgoff           ;turn off background task
        di                      ;disable all interrupts
        call    enable
        pop     psw
        adi     50              ;recover quotient
        mov     d,a             ;save current LCD byte number
        call    dofour          ;rotate four bytes
        pop     h               ;recover old table index
        mov     a,l             ;subtract 10
        sui     10
        mov     l,a
        call    enable          ;enable the next LCD driver
        mov     a,d             ;get current LCD byte number
        call    dofour          ;rotate four bytes
        call    bgon            ;turn on background task
        ei                      ;enable all interrupts
        ret                     ;all done!
;
;
;       dofour
;
;       Each column of pixels is contained in eight bytes in the LCD
;       driver memories.  This routine rotates four bytes at a time, 
;       and is called twice, so that all eight bytes are rotated.
;       The effect is to push all pixels up by one pixel in one column.
;       The high bit in register e is inserted at the bottom.
;       dofour calculates the LCD memory addresses, then calls switch
;       to do the actual rotation.  The bit being rotated between
;       bytes is kept in register e as the high bit, bit 7.
;
dofour  ori     0c0h            ;generate LCD bank+byte address
        call    switch          ;do bottom-most byte
        mov     a,d
        ori     80h
        call    switch          ;do next byte
        mov     a,d
        ori     40h
        call    switch          ;do next byte
        mov     a,d
        jmp     switch          ;do top byte
;
;
;
switch  mov     b,a             ;save bank+byte address in b
        mov     a,e             ;put color bit into carry
        ral
        mov     a,b
        call    read            ;read a byte
        rar
        mov     c,a             ;save byte to write
        rar
        mov     e,a             ;save color bit
        mov     a,b             ;restore bank+byte info in a
        call    write           ;write a byte
        ret
;
;
;
read    call    wait            ;wait for LCD not busy
        out     lcdaddr         ;send LCD bank+byte address
        call    wait            ;wait for LCD not busy
        in      lcddata         ;read LCD data
        call    wait
        in      lcddata         ;read it again
        ret
;
;
;
write   call    wait            ;wait for LCD not busy
        out     lcdaddr         ;send LCD bank+byte address
        call    wait            ;wait for LCD not busy
        mov     a,c             ;get data to write
        out     lcddata         ;write LCD data
        ret
;
;
;
cisid   db      '#RS4,CC,GH,GM',0dh,0
;
;
;
color   ds      1               ;current color (ff=black,0=white)
column  ds      1               ;current column number
mode    ds      1               ;graphics mode (0=GH,80h=GM)
gflag   ds      1               ;set if esc-G has just been received
;
;
;
        end     maxram-length
