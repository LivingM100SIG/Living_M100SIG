
; SIZE                  NEC PC-8201A RAM File Length Display
; ----
        SCR                     ;Output assembled listing to display
        ORG     62000           ;Program top address = 62000
SRCNAM  EQU     $229B           ;ROM routine to search directory for file
BEEP    EQU     $4258           ;ROM routine to make a beep
FILNAM  EQU     $FB78           ;Buffer in reserved RAM to hold filename
LNKFIL  EQU     $233A           ;ROM routine to fix up file structure
NTFND   CALL    BEEP            ;Make a BEEP
START   DISP    PROMPT          ;Display prompt message
        CALL    $47AA           ;ROM routine to get a line from the keyboard
        RC                      ;If carry is set, STOP was pressed, go to menu
        LXI     HL,$F5A1        ;Point HL to input buffer
        LXI     DE,FILNAM       ;Point DE to filename buffer
        MVI     B,6             ;Max number of chars in body of file name
LOOP1   MOV     A,M             ;Get a character from the input buffer
        CPI     '.'             ;Is it the filename terminator?
        JZ      PUTSPC          ;If so, go fill rest with spaces
        CPI     0               ;Is it the string terminator?
        JZ      EONAME          ;If so, jump to end of name routine
        STAX    DE              ;Store character in filename buffer
        INX     HL              ;Point to next character in input buffer
        INX     DE              ;Point to next spot in FILNAM buffer
        DCR     B               ;Decrement character counter
        JNZ     LOOP1           ;Loop till done
        JMP     PUTEXT          ;Go get extension
PUTSPC  MVI     A,$20           ;Put a space character into A
        STAX    DE              ;Store it in FILNAM buffer
        INX     DE              ;Point to next spot in buffer
        DCR     B               ;Decrement character counter
        JNZ     PUTSPC+2        ;Loop till done
PUTEXT  MVI     B,2             ;Put length of extension into B
        INX     HL              ;Point HL past the period
        MOV     A,M             ;Get a character from the input buffer
        ORA     A               ;Is it the zero terminator?
        JZ      EONAME          ;If so, end of filename has been reached
        STAX    DE              ;Store character in FILNAM buffer
        INX     DE              ;Point to next spot in buffer
        DCR     B               ;Decrement character counter
        JNZ     PUTEXT+2        ;Loop till done
        MVI     A,$20           ;Put a space character into A
        STAX    DE              ;Store in in buffer
EONAME  CALL    LNKFIL          ;Fix up directory links
        CALL    SRCNAM          ;Search for filename
        JZ      NTFND           ;If zero, then file was not found
        XCHG                    ;Get start address of file into HL
        CPI     $80             ;Check Att byte for a BASIC file
        JZ      BAFILE          ;If $80, go to BASIC routine
        CPI     $C0             ;Check Att byte for TEXT file
        JZ      DOFILE          ;If $C0, go to TEXT routine
        JMP     COFILE          ;Assume it is a .CO file
BAFILE  PUSH    HL              ;Store start address of file in DE
        POP     DE
LOOP2   MOV     A,M             ;Move LSB of address for next line # into A
        MOV     C,A             ;Store LSB in C
        ANA     A               ;Check to see if zero
        JZ      TEST            ;If so, test the MSB
        INX     HL              ;Point to MSB of address for next line #
        MOV     A,M             ;Move MSB into A
        MOV     B,A             ;Store MSB in B - BC now has next line address
KEEP    PUSH    BC              ;Store next line address on stack
        POP     HL              ;Load next address line into HL
        JMP     LOOP2           ;Go back and check for a zero address
TEST    INX     HL              ;Point to MSB of address for next line #
        MOV     A,M             ;Move MSB into A
        MOV     B,A             ;Store MSB in B
        ANA     A               ;Is MSB zero?
        JNZ     KEEP            ;If not, we need to look further, so go back
        MOV     A,L             ;It is, so subtract start address in DE from
        SUB     E               ; ending address in HL - LSB first
        MOV     C,A             ;Store LSB result in C
        MOV     A,H             ;Move MSB end address into A
        SBB     D               ;Subtract MSB of start address
        MOV     B,A             ;Store MSB result in B - BC now has difference
        INX     BC              ; between start address and end address
        INX     BC              ;Now add two for the end of file zero bytes
        JMP     PRTLEN          ;Go print message
DOFILE  LXI     BC,0            ;Zero out byte counter
LOOP3   INX     BC              ;Increment byte counter
        MOV     A,M             ;Get a character
        CPI     $1A             ;Is it the EOF character
        JZ      PRTLEN          ;If so, go print message
        INX     HL              ;Point to next character
        JMP     LOOP3           ;Loop till done
COFILE  INX     HL              ;Point to file length
        INX     HL              ;
        MOV     C,M             ;Move LSB to C
        INX     HL              ;Point to MSB
        MOV     B,M             ;Move MSB to B
        LXI     HL,6            ;Load up a 6
        DAD     BC              ;Add it to length
        PUSH    HL              ;Transfer it to BC
        POP     BC              ;
PRTLEN  DISP    MSG             ;Display the message
        PUSH    BC              ;Transfer length to HL
        POP     HL              ;
        CALL    $3898           ;Print numeric string
        CALL    $4251           ;Print CR/LF
        CHAR                    ;Wait for a character
        RET                     ;Return to caller
PROMPT  DM      Enter filename:
        DB      0
MSG     DM      File length =
        DB      0
        ENT     START           ;Program entry address
        END                     ;End of program
