This file can be correctly printed using the following BASIC program.
10 OPEN "M10ROM" FOR INPUT AS 1
20 IF NOT EOF(1) THEN 30 ELSE 50
30 LINE INPUT #1,Z$
40 LPRINT SPACE$(10);Z$:GOTO 20
50 CLOSE 1:END




                    OLIVETTI M-10 ROM/RAM                 [1]

     This represents  the best  information I can offer as to
the contents of the M10  ROM.    All  the  routines presented
herein have been exercised, and have been found to perform in
a way that is similar or identical to the same routines in an
Model  100.    Note  however that in many cases, particularly
those  routines  that  manipulate  the  ports,  the  M10 code
differs considerably from its Model 100 counterpart.

     The most  significant differences  are in the serial I/O
routines, and  translating software  from the  Model 100 that
makes use  of these  routines can  prove to  be a frustrating
exercise.  Note also that the  Model 100  Serial I/O routines
ignore the  CTS line,  but the OLIVETTI routines do not.  Any
serial routines that attempt to use  the RS-232  port via the
ROM MUST take this into account.

     The  address  references  in  parentheses  refer  to the
Model 100 ROM equivalent routines.

LCD FUNCTIONS
-------------------------------------------------------------
CRLF      423F    Send newline to display.
(4222)
                  Entry: None
                  Exit:  None
                  Registers Used: A

HOME      424A    Move cursor to 1,1
(422D)
                  Entry: None
                  Exit:  None
                  Registers Used: A

CLS       424E    Clear display.
(4231)
                  Entry: None
                  Exit:  None
                  Registers Used: A

SETSYS    4252    Set (Lock) system label line. Equivalent to
                  ESC T.
(4235)
                  Entry: None
                  Exit:  None
                  Registers Used: A

RSTSYS    4257    Reset    (Unlock)    system   label   line.
                  Equivalent to ESC U.
(423A)
                  Entry: None
                  Exit:  None
                  Registers Used: A




                    OLIVETTI M-10 ROM/RAM                 [2]

LOCK      425C    Inhibit screen scroll. Equivalent to ESC Y.
(423F)
                  Entry: None
                  Exit:  None
                  Registers Used: A

UNLOCK    4261    Enable screen scroll. Equivalent to ESC W.
(4244)
                  Entry: None
                  Exit:  None
                  Registers Used: A

CURSON    4266    Enable screen cursor. Equivalent to ESC P
(4249)
                  Entry: None
                  Exit:  None
                  Registers Used: A

CUROFF    426B    Inhibit screen cursor Equivalent to ESC Q
(424E)
                  Entry: None
                  Exit:  None
                  Registers Used: A

DELLIN    4270    Delete  line  at  current  cursor location.
                  Equivalent to ESC M.
(4253)
                  Entry: None
                  Exit:  None
                  Registers Used: A

INSLIN    4275    Insert  a  blank  line  at  current  cursor
                  location. Equivalent to ESC L.
(4258)
                  Entry: None
                  Exit:  None
                  Registers Used: A

ERAEOL    427A    Erase  from   cursor   to   end   of  line.
                  Equivalent to ESC K.
(425D)
                  Entry: None
                  Exit:  None
                  Registers Used: A

ENTREV    4286    Enable reverse video. Equivalent to ESC p.
(4269)
                  Entry: None
                  Exit:  None
                  Registers Used: A




                    OLIVETTI M-10 ROM/RAM                 [3]

EXTREV    428B    Disable reverse video. Equivalent to ESC q.
(426E)
                  Entry: None
                  Exit:  None
                  Registers Used: A

ESCA      428D    Send specified escape code sequence.
(4270)
                  Entry: [A] = code
                  Exit:  None
                  Registers Used: A,F

POSIT     4299    Set cursor position.
(427C)
                  Entry: [H] = column (1-40)
                         [L] = row    (1-8)
                  Exit:  None
                  Registers Used: A,F,H,L

LCD       4B53    Displays a  character on LCD at the current
                  cursor  location  and  updates  the  cursor
                  position. (Also RST 4)
(4B44)
                  Entry: [A] character to be displayed
                  Exit:  None
                  Registers Used: All registers preserved

SETCUR    7483    Move cursor to specified location
(7440)
                  Entry: [D] = column (1-40)
                         [E] = row    (1-8)
                  Exit : None
                  Registers Used: A,F,D,E,H,L

PLOT      748F    Turn pixel ON at specified location.
(744C)
                  Entry: [D] = x location (0-239)
                         [E] = y location (0-63)
                  Exit:  None
                  Registers Used: All

UNPLOT    7490    Turn pixel OFF at specified location.
(744D)
                  Entry: [D] = x location (0-239)
                         [E] = y location (0-63)
                  Exit:  None
                  Registers Used: All




                    OLIVETTI M-10 ROM/RAM                 [4]

KEYBOARD FUNCTIONS
-------------------------------------------------------------
CHGET     12D0    Wait and get a character from keyboard.
(12CB)
                  Entry: None
                  Exit:  [A]  contains  ASCII  character,  or
                         code if  special character. Function
                         keys   F1-F8  return  pre-programmed
                         strings.
                         C  flag  set  if  special character,
                         otherwise reset.
                  Registers Used: A,F

CHSNS     13E0    Check keyboard queue for characters.
(13DB)
                  Entry: None
                  Exit:  Z  flag  set  if  queue  was  empty,
                         otherwise   reset    if   keystrokes
                         pending.
                  Registers Used: A,F

GETLN     4633    Get line  from keyboard  with a '?' prompt.
                  Line is terminated with the ENTER  key, and
                  is placed in the buffer at F688 (F685).
(463E)
                  Entry: None
                  Exit:  ASCII  characters  in INBUF at F688,
                         [DE] points to $0D terminator byte.
                  Registers Used: All

INLIN     4639    Get line from  keyboard  without  a prompt.
                  Line is  terminated with  the ENTER key and
                  placed in the buffer at F688 (F685).
(4644)
                  Entry: None
                  Exit:  ASCII characters in  INBUF  at F688,
                         [DE] points to $0D terminator byte.
                  Registers Used: All

WAITSPC   5F34    Wait for a SPACE from keyboard
(5F2F)
                  Entry: None
                  Exit:  [A] = SPC
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                 [5]

KYREAD    7275    Scan keyboard for a key.  No wait.
(7242)
                  Entry: None
                  Exit:  [A] register contains character.
                         Z flag set if no key waiting
                         Z reset if key was waiting
                         C reset if normal character
                         C set if special character

                  If Carry set, [A] will contain a code.
                         0        F1
                         1        F2
                         2        F3
                         3        F4
                         4        F5
                         5        F6
                         6        F7
                         7        F8
                         8        LABEL
                         9        PRINT
                         0A       SHIFT-PRINT
                         0B       PASTE
                  Registers Used: A,F,C,D,E,H,L

                  NB.   There is  a minor bug in the OLIVETTI
                  version.  If the  F1 key  was pressed, then
                  the  function   returns  with  the  C  flag
                  correctly set, but in  addition the  Z flag
                  is also set, and [A] contains 0.  Thus code
                  that  simply  checks  the  Z  flag  for the
                  presence of  a character  will fail on this
                  machine.

KEYX      72A7    Check  keyboard  queue  for  characters  or
                  BREAK condition.
(7270)
                  Entry: None
                  Extit: Z  flag  set  if  queue  was  empty,
                         otherwise reset if keys pending.
                         C  flag  set   if   BREAK  detected,
                         otherwise reset.
                  Registers Used: A,F

BRKCHK    72BA    Check for BREAK/PAUSE characters only.
(7283)
                  Entry: None
                  Exit:  C  flag  set  if  BREAK  (CTRL-C) or
                         PAUSE  (CTRL-S)  detected, otherwise
                         reset.
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                 [6]

FUNCTION KEY ROUTINES
-------------------------------------------------------------
ERAFNK    42A7    Erase function key display.
(428A)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

STDSPF    42C2    Set & Display function keys.
(42A5)
                  Entry: [HL] points to function key table.
                  Exit:  None
                  Registers Used: All

DSPFNK    42C5    Display function keys.
(42A8)
                  Entry: None
                  Exit:  None
                  Registers Used: All

CLRFNK    5A81    Clear  function  key  definitions.    Fills
                  table with $80.
(5A79)
                  Entry: None
                  Exit:  None
                  Registers Used: All

SETFNK    5A84    Set function key definitions.
(5A7C)
                  Entry: [HL] points to function key table.
                  Exit:  None
                  Registers Used: All




                    OLIVETTI M-10 ROM/RAM                 [7]

FNKSB     5AA6    Display function key table.
(5A9E)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

PRINTING ROUTINES
-------------------------------------------------------------
PRTSTR    11A5    Print a NUL  terminated  string  to current
                  display device.  This routine is replicated
                  at 5A60 (5A58).  The routine at 27CB (27B1)
                  also  performs   the  same  function  in  a
                  roundabout way.
(11A2)
                  Entry: [HL] points to ASCIIZ string.
                  Exit:  [HL] points to NULL byte.
                  Registers Used: A,F,H,L

PNOTAB    1480    Print a character without expanding tabs to
                  spaces.  Code is not the same as TANDY 100.
(1470)
                  Entry: [A] = character to be printed.
                  Exit:  [C]  set   if  cancelled  by  BREAK,
                         otherwise reset.
                  Registers Used: A,F

PRTLCD    1E6A    Print contents of LCD screen.
(1E5E)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F,D,E

PRTTAB    4B64    Print a character expanding tabs to spaces.
(4B55)
                  Entry: [A] = character to be printed.
                  Exit:  [C]  set  if  cancelled   by  BREAK,
                         otherwise reset.
                  Registers Used: A,F

PRINTR    6D44    Send a character to printer.
(6D3F)
                  Entry: [A] = character to be printed.
                  Exit:  [C]  is  set  if cancelled by BREAK,
                         otherwise reset.
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                 [8]

RS-232-C/MODEM FUNCTIONS
-------------------------------------------------------------
SETSER    17F0    Set   serial   interface   parameters   and
                  activate RS-232/MODEM.
(17E6)
                  Entry: [HL]  =   start  address  of  ASCIIZ
                         string containing parameters. Syntax
                         is the same as TELCOM STAT command.
                         C  flag  set  for  RS-232, reset for
                         MODEM.  Error out to BASIC.
                  Exit:  None
                  Registers Used: All

DISC      52C3    Disconnect phone line.
(52BB)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

CONN      52D8    Connect phone line.
(52D0)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

DIAL      5332    Dial a specified phone number.
(532D)
                  Entry: [HL]  points  to  address  of  phone
                         number. (ASCIIZ string)
                  Exit:  None
                  Registers Used: All

RCVX      6D74    Check RS-232 queue for characters.
(6D6D)
                  Entry: None
                  Exit:  [A] = number of chars pending
                         Z  flag  set  if  no data, otherwise
                         reset.
                  Registers Used: A,F

RV232C    6D85    Get a character from RS-232 receive queue.
(6D7E)
                  Entry: None
                  Exit:  [A] = char
                         Z flag  set if  no errors, otherwise
                         reset   if   Parity,   Framing,   or
                         Overflow detected.
                         C  flag   set   if   BREAK  pressed,
                         otherwise reset.
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                 [9]

SENSCQ    6E12    Send XON resume character, CTRL-Q.
(6E0B)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

SENDCS    6E25    Send XOFF pause character, CTRL-S.
(6E1E)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

SD232C    6E39    Send  a  character  to  RS-232/MODEM  under
                  XON/XOFF control.
(6E32)
                  Entry: [A] = character
                  Exit:  None
                  Registers Used: A,F

SNDCOM    6E47    Send  character   to  RS-232/MODEM  without
                  XON/XOFF control.
(6E3A)
                  Entry: [C] = character
                  Exit:  None
                  Registers Used: A,F

BAUDST    6E97    Set BAUD rate for RS-232
(6E75)
                  Entry: [H] = BAUD rate, ASCII 1-9,M
                  Exit:  None
                  Registers Used: A,F,D,E,H,L

INZCOM    6EC8    Initialise RS-232/MODEM
(6EA6)
                  Entry: [H] = BAUD rate, ASCII 1-9,M
                         [L] = UART configuration code
                         C  flag  set  if  RS-232,  reset  if
                         MODEM.
                  Exit:  None
                  Registers Used: H,L

CARDET    6F06    Detect carrier.
(6EEF)
                  Entry: None
                  Exit:  [A] = 0 if carrier, else $FF
                         Z flag set if carrier, else reset.
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                [10]

CLSCOM    6F63    Deactivate RS-232/MODEM
(6ECB)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F

CASSETTE ROUTINES
-------------------------------------------------------------

CTON      14B0    Turn motor ON.
(14A8)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F,D,E

CTOFF     14B2    Turn motor OFF.
(14AA)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F,E

CASIN     14B8    Read   char   from   cassette   and  update
                  checksum.
(14B0)
                  Entry: [C] = current checksum
                  Exit:  [A] = character
                         [C] = updated checksum
                  Registers Used:

CSOUT     14C9    Send  character   to  cassette  and  update
                  checksum.
(14C1)
                  Entry: [A] = character
                         [C] = current checksum
                  Exit:  [C] = updated checksum
                  Registers Used: A,F,C

SYNCW     6F6E    Write cassette header and sync byte only.
(6F46)
                  Entry: None
                  Exit:  None
                  Registers Used: A,F,B,C,D

DATAW     6F83    Write  a  character  to   cassette  without
                  updating checksum.
(6F5B)
                  Entry: [A] = character
                  Exit:  None
                  Registers Used: A,F,B,E




                    OLIVETTI M-10 ROM/RAM                [11]

SYNCR     6FAD    Read cassette header and control byte only.
(6F85)
                  Entry: None
                  Exit:  None
                  Registers Used:

DATAR     7052    Read char from cassette, no checksum.
(702A)
                  Entry: None
                  Exit:  [D] = character
                  Registers Used:

RAM FILES ROUTINES
-------------------------------------------------------------
KILASC    1FD0    Delete a  text file.   (NB, Seems to return
                  to main menu.)
(1FBE)
                  Entry: [DE] = TOP address of file.
                         [HL] = directory address
                  Exit:  None
                  Registers Used:

MAKTXT    2228    Create a text (.DO) file.
(220F)
                  Entry: Filename must be in FILNM1 buffer at
                         FC99 (max 8 Bytes) .DO extention not
                         required.
                  Exit:  [HL] = TOP address of new file.
                         [DE] = Address of directory entry.
                         C flag  set if  file already exists,
                         otherwise reset.
                  Registers Used:

CHKDC     5AB3    Search for file in directory.
(5AAB)
                  Entry: [A] contains number of characters in
                         filename  plus  period  symbol  plus
                         extension.
                         [DE] Address  of U/C ASCIIZ filename
                         string.
                  Exit:  [HL] =  start  address  of directory
                         entry of the file.
                         Z  flag   set  if  file  not  found,
                         otherwise reset.
                  Registers Used: All

GTXTTB    5AEB    Get TOP address of file.
(5AE3)
                  Entry: [HL] = directory address
                  Exit:  [HL] = TOP address of file.
                  Registers Used: F,D,E,H,L




                    OLIVETTI M-10 ROM/RAM                [12]

INSCHR    6B66    Insert a character in a text file.
(6B61)
                  Entry: [A] = character to insert.
                         [HL] = address  at  which  to insert
                         character.
                  Exit:  [HL] = [HL] + 1
                         C flag set if out of memory.

MAKHOL    6B72    Insert specified  number of  spaces in text
                  file.

                  Entry: [BC] = number of spaces to insert.
                         [HL] = address  at  which  to insert
                         spaces.
                  Exit:  [HL] and [BC] preserved.
                         C flag set if out of memory.

MASDEL    6BA4    Delete specified number of characters.  NB,
                  [HL] MUST point to a valid text file!

                  Entry: [BC]  =  number  of   characters  to
                         delete.
                         [HL]  =  address  at  which to start
                         delete.
                  Exit:  [BC] and [HL] preserved.
                  Registers Used: A,F,D,E

MISCELLANEOUS ROUTINES
-------------------------------------------------------------
UCOMP     0018    Compare [DE] and [HL].  Also RST 3.
(0018)
                  Entry: [HL] & [DE] contain  16 bit unsigned
                         integers.
                  Exit:  [HL] < [DE] C set, and Z clear
                         [HL] = [DE] Z set
                         [HL] > [DE] C and Z clear

GETUPR    0FEB    Get character and convert to U/C.
(0FE8)
                  Entry: [HL] points to character.
                  Exit:  [A] Contains U/C character.
                  Registers Used: A,F

TOUPER    0FEC    Convert Character to U/C.
(0FE9)
                  Entry: [A] Contains character.
                  Exit:  [A] contains U/C character.
                  Registers Used: A,F




                    OLIVETTI M-10 ROM/RAM                [13]

TIME      1919    Read system time.
(190F)
                  Entry: [HL] =  address of 8 byte buffer for
                         time.
                  Exit:  [HL] points to  last  ASCII  byte of
                         time     hh:mm:ss.     String    not
                         terminated.
                  Registers Used: All

DATE      1939    Read System date.
(192F)
                  Entry: [HL] = address of 8 byte  buffer for
                         date.
                  Exit:  [HL]  points  to  last ASCII byte of
                         date   mm/dd/yy.        String   not
                         terminated.
                  Registers Used: All

DAY       196C    Read system day.
(1962)
                  Entry: [HL] =  address of 3 byte buffer for
                         day.
                  Exit:  None
                  Registers Used: All




                    OLIVETTI M-10 ROM/RAM                [14]

LENSTR    2213    Count   number   of   characters   in   NUL
                  terminated string.   NB. String length must
                  be less than 256 bytes.
(21FA)
                  Entry: [HL] points to start of string.
                  Exit:  [E] contains number of characters.
                         [HL] preserved.
                         [A] contains NUL byte.
                  Registers Used: A,F,E

BLKUP     3483    Move specified number of bytes in ascending
                  sequence.
(3469)
                  Entry: [B] = number of bytes to move
                         [DE] = source address
                         [HL] = target address
                  Exit:  None
                  Registers Used: A,F,B,D,E,H,L

BLKDN     348C    Move   specified   number   of   bytes   in
                  descending sequence.
(3472)
                  Entry: [B] = number of bytes to move
                         [DE] = source address
                         [HL] = target address
                  Exit:  None
                  Registers Used: A,F,B,D,E,H,L

SCOMP     34DC    Signed Integer Comparison.
(34C2)
                  Entry: [HL] & [DE] contain signed integers.
                  Exit:  [HL] < [DE] [A] = FF (-1)
                         [HL] = [DE] [A] = 0, & Z flag set
                         [HL] > [DE] [A] = 1

PRNTINT   39EE    Print ASCII decimal contents of [HL].
(39D4)
                  Entry: [HL] contains unsigned integer.
                  Exit:  None
                  Registers Used: All.




                    OLIVETTI M-10 ROM/RAM                [15]

CHKMUC    410E    Check if [HL] points to U/C character.
(40F1)
                  Entry: [HL] = address of character.
                  Exit:  C  flag   is  set   if  lower  case,
                         otherwise reset.
                  Registers Used: A,F,H,L

CHKAUC    410F    Check if [A] contains U/C character.
(40F2)
                  Entry: [A] = character to check.
                  Exit:  C  flag   is  set   if  lower  case,
                         otherwise reset.
                  Registers Used: A,F

NULFILL   4F12    Fill memory with NUL
(4F0A)
                  Entry: [HL] points to start of memory
                         [B] contains number of bytes to fill
                  Exit:  [HL] points to last byte + 1
                         [A] = 0
                         [B] = 0
                  Registers Used: A,F,B,H,L

CHRFILL   4F13    Fill memory with character.
(4F0B)
                  Entry: [HL] points to start of memory
                         [A] contains fill byte
                         [B] contains number of bytes to fill
                  Exit:  [HL] points to last byte + 1
                         [B] = 0
                  Registers Used: A,F,B,H,L

MENU      57A2    Go to main menu.
(5797)
                  No entry or exit conditions.

MOVUP     6BE0    Move specified number of bytes in ascending
                  sequence.
(6BDB)
                  Entry: [HL] = source address
                         [DE] = target address
                         [BC] = number of bytes
                  Exit:  None
                  Registers Used: All




                    OLIVETTI M-10 ROM/RAM                [16]

MOVDN     6BEB    Move   specified   number   of   bytes   in
                  descending sequence.
(6BE6)
                  Entry: [HL] = source address
                         [DE] = target address
                         [BC] = number of bytes
                  Exit:  None
                  Registers Used: All

INITIO    6CDB    Cold start reset.
(6CD6)
                  No Entry/Exit conditions.

IOINIT    6CE5    Warm start reset.
(6CE0)
                  No Entry/Exit conditions.

MUSIC     72FB    Make  tone  of   specified   frequency  and
                  duration.
(72C5)
                  Entry: [DE] = frequency
                         [B] = duration
                  Exit:  [DE] preserved.
                  Registers Used: A,F,B,C




                    OLIVETTI M-10 ROM/RAM                [17]

SYSTEM INFORMATION
-------------------------------------------------------------
RESERVED RAM LOCATIONS

HIMEM     F5F4  (F5F4) HIMEM Pointer
CURY      F63C  (F639) Cursor row location  (0-7)
CURX      F63D  (F63A) Cursor column location  (0-39)
ACTLIN    F63E  (F63B) Number of active lines  (0-7)
ACTCOL    F63D  (F63C) Number of active columns  (0-39)
LBLFLG    F640  (F63D) Label line flag. 0 = unused, 1 = used.
REVFLG    F64B  (F648) Reverse video flag.  0 = Normal
LFFLAG    F65D  (F65A) Linefeed switch. 0 = LF, Non-Zero = LF
STATBF    F65E  (F65B) Current STAT image, eg M7E1D
PRTPOS    F677  (F674) Line Printer head position
LCDFLG    F678  (F675) LCD flag.  0 = Screen, 1 = Printer.
INBUF     F688  (F685) 256 byte input buffer.
CURLOC    F78B  (F788) Current horizontal location of cursor
DIRTBL    F965  (F692) Start of directory table.
DOBAPT    FBB4  (FBAE) Pointer to start of DO/end of BA files
COPTR     FBB6  (FBB0) Pointer to start of CO files
VARTBL    FBB8  (FBB2) Pointer to start of variable table
ARYTBL    FBBA  (FBB4) Pointer to start of array table
FRERAM    FBBC  (FBB6) Pointer  to  start  of  system  unused
                       memory.
FILNM1    FC99  (FC93) Filename buffer #1
FILNM2    FCA2  (FC9C) Filename buffer #2
LCDMEM    FE00  (FE00) Start of LCD RAM.  Extends to FF40.
SNDFLG    FF44  (FF44) Sound flag.  0 = ON, $AF = OFF
NUMCHR    FF6D  (FFAA) Number of characters in KB buffer
KYBUFF    FF6E  (FFAB) 64 byte keyboard  buffer.    Odd bytes
                       contain ASCII,  an $FF in an even byte
                       indicates a function key.
CURIMG    FF8F  (FFEC) 5 bytes that contain  a  bit  image of
                       the  character  underneath the current
                       cursor location.

Address  references  in  parentheses   are   the   Model  100
equivalents.

UART CONFIGURATION CODE

Bit 0     Specifies number of stop bits. 0 = 1, 1 = 2
Bits 1/2  Parity.  00 = None, 01 = Even, 10 = Odd.
Bits 3/4  Word Length.  00 = 6, 01 = 7, 10 = 8.
          The configuration  code byte  is ANDed  with $1F to
          ignore bits  5-7.   The text  string containing the
          current  STAT  setting  is  located  in  the STATBF
          location  at  F65E,  in  the  order  Baud,  Length,
          Parity, Stop Bits, and XON/XOFF switch.




                    OLIVETTI M-10 ROM/RAM                [18]

DIRECTORY ORGANIZATION

Each file is managed by an 11 byte directory entry.

Byte 1    Directory Flag for file type and status.
Byte 2-3  Address of file in RAM.
Byte 4-11 8 Byte file name and extension.

Directory Flag is organised thus:-

Bit 7     1 if valid entry
Bit 6     1 if ASCII text file (.DO)
Bit 5     1 if machine language file (.CO)
Bit 4     1 if file is in ROM
Bit 3     1 if file is invisible
Bit 2     Reserved for future use
Bit 1     Reserved for future use
Bit 0     Internal use.

A. Ryan
P.O. Box 222,
Carp,
Ontario,
Canada, K0A-1L0
(613) 256-2487
CompuServe ID: 72007,1743