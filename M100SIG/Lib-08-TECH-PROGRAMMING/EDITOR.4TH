
The fig-Forth Editor


When you're writing several screens of fresh Forth code you're better off
typing the code in TEXT and using HELPER.BA to convert it into screens on
your Forth disk. However, if you just want to make a few minor changes to
your code it's a bit of a nuisance to have to switch back and forth between
Forth and TEXT. These screens contain the fig-Forth editor, which is handy
for making small changes to your Forth code from within Forth. The commands
are as follows:

Line editing:

n P text     Put "text" on line n. If you use P immediately following a T
             command you may omit the line number.
n D          Delete line n. Lines n+1 and following move up. Line n is held
             in PAD.
n T          Type line n and save it in pad. The cursor position is shown and
             the line number displayed before the Ok prompt.
n R          Replace line n with the text in PAD.
n I          Insert the text in PAD at line n, moving the old lines down.
n E          Erase line n.
n S          Spread at line n. Subsequent lines are moved down and line
             n becomes blank.
n DELETE     Deletes n characters before the cursor position.

Cursor positioning:

TOP          Position cursor at the start of the screen.
n M          Move cursor by amount n. Cursor line is printed and position
             shown.

String editing:

F text       Search forward from current position until string "text" is
             found. Cursor is positioned at end of string.
B            Back up: use after F to back up cursor by length of most
             recent text.
N            Find the next occurrence of string found by F.
X text       Find and delete the string "text".
C text       Copy in "text" at the current cursor position. (Note: don't
             use C without any text to avoid copying a null into the screen.)
TILL text    Delete on current line from current cursor position to the end
             of the string "text".

Other:

n TEXT text  The "text" up to the delimiter character n is moved to PAD.
n LIST       List screen n and select it for editing.
L            Re-list the current screen and re-type the current cursor line.
             Use a command that sets or resets the cursor position (like T or
             TOP) before using L to avoid the "off editing screen" error.
n CLEAR      Clear screen n and select it for editing.
n1 n2 COPY   Copy screen n1 to screen n2.
FLUSH        Transfer all changes to disk.


17 LOAD compiles the editor into the dictionary. You'll get a couple
"already defined" error messages. That's OK. The last words in the loaded
screens reset the current and context vocabularies to Forth. So when you want
to use the editor, type EDITOR. (Be sure to set OFFSET as appropriate for
your disk before doing any operations that will write to disk.)


Tim Ekdom 72575,1473 March, 1986
The Forth code is in the public domain, courtesy of the Forth Interest Group.


 17 
( TEXT, LINE )
FORTH DEFINITIONS HEX
: TEXT      ( ACCEPT FOLLOWING TEXT INTO PAD )
     HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
 
: LINE      ( RELATIVE TO SCR, LEAVE ADDRESS OF LINE )
      DUP FFF0 AND 17 ?ERROR   ( KEEP ON THIS SCREEN )
      SCR @ (LINE) DROP ;
 -->
 
 
 
 
 
 
 
 18 
( LINE EDITOR )
VOCABULARY EDITOR IMMEDIATE HEX
: WHERE         ( PRINT SCREEN # & IMAGE OF ERROR )
    DUP B/SCR / DUP SCR ! ." SCR # " DECIMAL .
    SWAP C/L /MOD C/L * ROT BLOCK + CR C/L TYPE
    CR HERE C@ - SPACES 5E EMIT [COMPILE] EDITOR QUIT ;
 
EDITOR DEFINITIONS
: #LOCATE       ( LEAVE CURSOR OFFSET -2, LINE-1 )
       R# @ C/L /MOD ;
: #LEAD        ( LINE ADDRESS-2, OFFSET-1 TO CURSOR )
      #LOCATE LINE SWAP ;
: #LAG         ( CURSOR ADDRESS-2, COUNT-1 AFTER CURSOR )
      #LEAD DUP >R + C/L R> - ;
: -MOVE   ( MOVE IN BLOCK BUFFER ADDR FROM-2, LINE TO-1 )
      LINE C/L CMOVE UPDATE ;  -->
 19 
( LINE EDITING COMMANDS )
: H             ( HOLD NUMBERED LINE AT PAD )
     LINE PAD 1+ C/L DUP PAD C! CMOVE ;
 
: E             ( ERASE LINE-1 WITH BLANKS )
     LINE C/L BLANKS UPDATE ;
 
: S             ( SPREAD MAKING LINE # BLANK )
     DUP 1 - ( LIMIT ) 0E ( FIRST TO MOVE )
     DO I LINE I 1+ -MOVE -1 +LOOP E ;
 
: D            ( DELETE LINE-1, BUT HOLD IN PAD )
    DUP H 0F DUP ROT
    DO I 1+ LINE I -MOVE LOOP E ;
 
 -->
 20 
( LINE EDITING COMMANDS )
 
: M  ( MOVE CURSOR BY SIGNED AMOUNT-1, PRINT ITS LINE )
    R# +! CR SPACE #LEAD TYPE 5F EMIT
                   #LAG  TYPE #LOCATE . DROP ;
 
: T  ( TYPE LINE BY #-1, SAVE ALSO IN PAD )
    DUP C/L * R# ! DUP H 0 M ;
 
: L  ( RE-LIST SCREEN )
   SCR @ LIST 0 M ;
 -->
 
 
 
 
 21 
( LINE EDITING COMMANDS )
: R        ( REPLACE ON LINE #-1, FROM PAD )
     PAD 1+ SWAP -MOVE ;
 
: P        ( PUT FOLLOWING TEXT ON LINE -1 )
     1 TEXT R ;
 
: I        ( INSERT TEXT FROM PAD ONTO LINE # )
     DUP S R ;
 
: TOP     ( HOME CURSOR TO TOP LEFT OF SCREEN )
    0 R# ! ;
 -->
 
 
 
 22 
( SCREEN EDITING COMMANDS )
: CLEAR         ( CLEAR SCREEN BY NUMBER-1 )
      SCR ! 10 0 DO FORTH I EDITOR E LOOP ;
: COPY          ( DUPLICATE SCREEN-2 ONTO SCREEN-1 )
   B/SCR * OFFSET @ + SWAP B/SCR * B/SCR OVER + SWAP
  DO DUP FORTH I BLOCK 2 - ! 1+ UPDATE LOOP
  DROP FLUSH ;
 
 -->
 
 
 
 
 
 
 
 23 
( DOUBLE NUMBER SUPPORT )
( OPERATES ON 32 BIT DOUBLE NUMBERS OR TWO 16 BIT INTEGERS )
FORTH DEFINITIONS
: 2DROP DROP DROP ;
: 2SWAP ROT >R ROT R> ;
EDITOR DEFINITIONS
 
 -->
 
 
 
 
 
 
 
 
 24 
( STRING MATCH FOR EDITOR )
: -TEXT
 SWAP -DUP IF
           OVER + SWAP
      DO DUP C@ FORTH I C@ -
           IF 0= LEAVE ELSE 1+ THEN LOOP
      ELSE DROP 0= THEN ;
: MATCH
  >R >R 2DUP R> R> 2SWAP OVER + SWAP
  DO 2DUP FORTH I -TEXT
     IF >R 2DROP R> - I SWAP - 0 SWAP 0 0 LEAVE
        THEN LOOP 2DROP SWAP 0= SWAP ;
 -->
 
 
 
 25 
( STRING EDITING COMMANDS )
: 1LINE #LAG PAD COUNT MATCH R# +! ;
: FIND
    BEGIN 3FF R# @ <
        IF TOP PAD HERE C/L 1+ CMOVE 0 ERROR ENDIF
        1LINE UNTIL ;
: DELETE
    >R #LAG + FORTH R -
    #LAG R MINUS R# +!
    #LEAD + SWAP CMOVE
    R> BLANKS UPDATE ;
 -->
 
 
 
 
 26 
( STRING EDITOR COMMANDS )
: N  FIND 0 M ;
: F  1 TEXT N ;
: B  PAD C@ MINUS M ;
: X  1 TEXT FIND PAD C@ DELETE 0 M ;
: TILL
     #LEAD + 1 TEXT 1LINE 0= 0 ?ERROR
     #LEAD + SWAP - DELETE 0 M ;
 -->
 
 
 
 
 
 
 
 27 
( STRING EDITOR COMMANDS )
: C
    1 TEXT PAD COUNT
    #LAG ROT OVER MIN >R
    FORTH R R# +!
    R - >R
    DUP HERE R CMOVE
    HERE #LEAD + R> CMOVE
    R> CMOVE UPDATE
    0 M ;
FORTH DEFINITIONS DECIMAL
 
 ;S
 
 
 
