( File ETCH4.DO  Copyright 1988 by Bill Boyd )
( Provides sketchpad function written in Forth )
( Load by running RAM4TH and typing " ETCH4" LOADF )
( Run by typing ETCH )
( Space toggles crosshair on and off )
( Tab toggles plot and erase modes )
( Use arrow keys or WERSDZXC to move )
( Press ENTER to exit )
BASE @
DECIMAL
 CR ." ASCII"
: ASCII ( -- c )
 ( Determines code for next keystroke )
 ( Usage:  'ASCII A' returns hex 41 )
 BL WORD ( word goes to dictionary )
 HERE 1+ ( skip count byte )
 C@
 [COMPILE] LITERAL
; IMMEDIATE
 CR ." -1
: -1
 -1
;
 CR ." NOT"
: NOT ( n1 -- n2 )
 ( takes complement of number )
 -1 XOR
;
 CR ." BEEP"
: BEEP
 7 EMIT
;
 CR ." GARRAY"
: GARRAY ( -- )
 ( Storage type to hold screen bitmap )
 <BUILDS
  HERE
  1920 ALLOT ( 8 rows X 240 cols )
  1920 ERASE ( clears it when created )
 DOES>
;
 CR ." DSPMEM"
GARRAY DSPMEM ( DSPMEM holds bitmap )
 CR ." GCURXNUM"
240 CONSTANT GCURXNUM
 ( Number of X cursor positions )
 CR ." GCURYNUM
8 CONSTANT GCURYNUM
 ( Number of horizontal "stripes" )
 CR ." SHOWIT"
: SHOWIT ( -- )
 ( Display contents of screen memory )
 DSPMEM
 GCURYNUM 0 DO
  DUP GCURXNUM I 0 BPLOT
  GCURXNUM +
 LOOP
 DROP
;
 ( Cursor key definitions )
 CR ." LFTKEY"
29 CONSTANT LFTKEY
 CR ." RHTKEY"
28 CONSTANT RHTKEY
 CR ." UPKEY"
30 CONSTANT UPKEY
 CR ." DNKEY"
31 CONSTANT DNKEY
 CR ." TOGGLEROW"
: TOGGLEROW ( adr byte count -- )
 ( XOR count bytes with byte, )
 ( starting at address adr. )
 0 DO ( adr byte )
  2DUP TOGGLE
  SWAP 1+ SWAP
 LOOP
 DROP DROP
;
 CR ." GBYTE"
: GBYTE ( adr1 row col -- adr2 byte )
 ( determines the address and byte )
 ( mask for a given graphics location )
 ( adr1 is start of graphics mem )
 ROT + ( adr of col ) ( row adr )
 OVER 3 SHR GCURXNUM * +
 ( adr of byte )
 1 ROT 7 AND SHL ( adr byte )
;
 CR ." ALTCROSS"
: ALTCROSS ( adr row col )
 ( XOR all dots in row and all dots in)
 ( col of screen memory at adr )
 3 PICK ( adr row col adr )
 OVER + ( adr of first col )
 DUP [ GCURXNUM GCURYNUM * ] LITERAL +
 SWAP
 DO ( once per row ) ( adr row col )
  I 255 TOGGLE
 GCURXNUM +LOOP ( vertical col done )
 ( stack : adr row col )
 ROT ROT 0 ( col adr row 0 )
 GBYTE ( col adr byte )
 3 PICK 0 > IF ( if col > 0 )
  2DUP 5 PICK TOGGLEROW
 THEN ( col adr byte )
 >R OVER + 1+ R> ( col adr byte )
 ROT GCURXNUM SWAP 1+ -
 ( adr byte count )
 -DUP IF ( if count<>0 )
  TOGGLEROW
 ELSE
  DROP DROP
 THEN
;
 CR ." GXPOS"
0 VARIABLE GXPOS
 CR ." GYPOS"
0 VARIABLE GYPOS
 CR ." PCOLOR"
0 VARIABLE PCOLOR
 CR ." XFLAG"
0 VARIABLE XFLAG
 CR ." ETCH"
: ETCH ( -- )
 ( "Main program" for sketchpad )
 120 GXPOS ! ( start at center )
 32 GYPOS !
 -1 PCOLOR !
 -1 XFLAG !
 DSPMEM [ GCURXNUM GCURYNUM * ] LITERAL
 ERASE
 BEGIN
  DSPMEM GYPOS @ GXPOS @ GBYTE
  OVER C@ ( adr b1 b2 )
  PCOLOR @ IF
   OR
  ELSE ( PCOLOR = 0 )
   SWAP NOT AND
  THEN ( set or erased dot ) ( adr b )
  SWAP C!
  XFLAG @ IF ( display with cross )
   DSPMEM GYPOS @ GXPOS @ ALTCROSS
   SHOWIT
   DSPMEM GYPOS @ GXPOS @ ALTCROSS
  ELSE ( display without cross )
   SHOWIT
  THEN
  KEY ( c )
  DUP LFTKEY = OVER ASCII S = OR IF
   0 -1
  ELSE ( not LFT )
   DUP RHTKEY = OVER ASCII D = OR
  IF ( move right )
   0 1
  ELSE ( not LFT or RHT )
   DUP UPKEY = OVER ASCII E = OR
  IF ( move up )
   -1 0
  ELSE ( not LFT, RHT, or UP )
   DUP DNKEY = OVER ASCII X = OR
  IF ( move down )
   1 0
  ELSE ( not LFT, RHT, UP, or DN )
   DUP ASCII W =
  IF ( move up left )
   -1 -1
  ELSE ( not LFT, RHT, UP, DN, UpLf )
   DUP ASCII R =
  IF
   -1 1
  ELSE ( not LFT, RHT, UP, DN, UpLf, or UpRt )
   DUP ASCII Z =
  IF ( move down, left )
   1 -1
  ELSE ( not LFT, RHT, UP, DN, UpLf, UpRt, or DnLf )
   DUP ASCII C =
  IF ( move down, right )
   1 1
  ELSE ( not cursor movement )
   DUP 9 ( tab char ) =
  IF
   PCOLOR @ NOT PCOLOR !
  ELSE ( not cursor move, tab )
   DUP 32 ( space char ) =
  IF
   XFLAG @ NOT XFLAG !
  ELSE ( not cursor move, tab, space )
   DUP 13 XOR
  IF
   BEEP
  THEN ( beep if not LFT, RHT, UP, DN, or CR )
  THEN ( SPACE IF )
  THEN ( TAB IF )
  0 0
  THEN ( DNRHT IF )
  THEN ( DNLFT IF )
  THEN ( UPRHT IF )
  THEN ( UPLFT IF )
  THEN ( DNKEY IF )
  THEN ( UPKEY IF )
  THEN ( RHTKEY IF )
  THEN ( LFTKEY IF )
  GXPOS @ +
  DUP 0 < IF ( if colnum < 0 )
   DROP BEEP 0
  ELSE ( change to 0 if underflow )
   DUP GCURXNUM 1 - >
  IF
   DROP BEEP GCURXNUM 1 -
  THEN ( checked for overflow )
  THEN ( updated column number )
  GXPOS !
  GYPOS @ +
  DUP 0 < IF ( if colnum < 0 )
   DROP BEEP 0
  ELSE ( change to 0 if underflow )
   DUP 63 >
  IF
   DROP BEEP 63
  THEN ( checked for overflow )
  THEN ( updated row number )
  GYPOS !
 13 = UNTIL
;
 BASE !
 CR
