*PW.CO*               ;8085 assembly language mnemonics listing
                      ;
                      ;
CNTR   EQU  0F931H    ;power-down counter address
BUFFER EQU  0FF46H    ;address of serial buffer (used for input storage)
STATUS EQU  0F932H    ;power-down status byte
                      ;
IPL    EQU  1A78H     ;table of ROM routine addresses
CLS    EQU  4231H     ;
OFF    EQU  143FH     ;
PRSTR  EQU  27B1H     ;
CSRON  EQU  4249H     ;
KEYCHK EQU  7242H     ;
SETCSR EQU  427CH     ;
LDCNTR EQU  1BB1H     ;
BEEP   EQU  4229H     ;
MENU   EQU  5797H     ;
                      ;
                      ;string table
                      ;
PSWD   DS   11        ;password is here (followed by ASCII zeros)
FILNAM DB   22H       ;string literal marker (")
       DS   5         ;'PW.CO'
       DB   0         ;end-of-line marker
MSG1   DB   0AH       ;LF
       DS   17        ;' TRS-80/Model 100'
       DW   0A0DH     ;CR LF
       DS   17        ;' at your service.'
       DB   0DH       ;CR
       DW   0A0AH     ;LF LF
       DS   14        ;' Please log on'
       DB   0DH       ;CR
       DW   0A0AH     ;LF LF
       DS   3         ;' > '
       DB   0         ;end message
MSG2   DW   701BH     ;ESC 'p'
       DS   16        ;'>Invalid ID code'
       DW   711BH     ;ESC 'q'
       DB   0DH       ;CR
       DW   0A0AH     ;LF LF
       DS   14        ;' Try again    '
       DB   0DH       ;CR
       DW   0A0AH     ;LF LF
       DS   3         ;' > '
       DB   0         ;end message
                      ;
                      ;main routine
                      ;
ENTRY  LXI  H,FILNAM  ;filename address into HL
       CALL IPL       ;load filename into IPL buffer
RSTRT  MVI  A,0AH     ;timer count (10d) into A
       STA  CNTR      ;load power-down counter
       CALL CLS       ;clear screen
       CALL OFF       ;turn power off
       LXI  H,MSG1    ;string address into HL
       CALL PRSTR     ;call string print routine
       CALL INPUT     ;wait for input
       JZ   TEST      ;jump if input is correct or timer has expired
       LXI  H,0203H   ;screen column, row into HL
       CALL SETCSR    ;set cursor position
       LXI  H,MSG2    ;string address into HL
       CALL PRSTR     ;call string print routine
       CALL INPUT     ;wait for input
       JNZ  RSTRT     ;restart if input is incorrect
TEST   JNC  RSTRT     ;restart if power-down timer has expired
       STA  STATUS    ;renew power-down status byte
       CALL LDCNTR    ;restore counter to original value
       CALL BEEP      ;acknowledge
       JMP  MENU      ;and proceed to menu
                      ;
                      ;input routine
                      ;
INPUT  LXI  H,BUFFER  ;input buffer address into HL
       PUSH H         ;save address
       MVI  B,11      ;load loop counter
       SUB  A         ;zero accumulator
LOOP1  MOV  M,A       ;clear first 11 bytes of input buffer
       INX  H         ;
       DCR  B         ;
       JNZ  LOOP1     ;
       CALL CSRON     ;turn cursor on
LOOP2  CALL KEYCHK    ;check keyboard buffer
       POP  H         ;retrieve input pointer
       JZ   SKIP      ;jump if no character returned
       CPI  0DH       ;check for <ENTER>
       JZ   CHECK     ;jump if done with input
       MOV  M,A       ;load character into input buffer
       MOV  A,L       ;low byte of input pointer into A
       ANI  80H       ;check for 80h (prevent buffer overflow)
       RNZ            ;return with zero flag reset if too much input
       MVI  A,' '     ;blank code into A
       RST  4         ;call character print routine
       INX  H         ;increment input pointer
SKIP   LDA  CNTR      ;power-down timer count into A
       ORA  A         ;check for zero count
       RZ             ;return with carry flag reset if timer has expired
       PUSH H         ;save input pointer
       JMP  LOOP2     ;wait for next character
CHECK  LXI  D,PSWD    ;password address into DE
       LXI  H,BUFFER  ;input buffer address into HL
       MVI  B,11      ;load loop counter
LOOP3  LDAX D         ;password character into A
       CMP  M         ;compare to input character
       RNZ            ;return with zero reset if no match
       INX  D         ;increment password pointer
       INX  H         ;increment buffer pointer
       DCR  B         ;decrement loop counter
       JNZ  LOOP3     ;next character if not through password
       STC            ;set carry flag
       RET            ;return with zero and carry flags set if input is OK

