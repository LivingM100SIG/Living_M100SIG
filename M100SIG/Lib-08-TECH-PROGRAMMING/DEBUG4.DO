( Highlights are VIEWMEM and DECOMPILE; see comments below )
BASE @ >R  ( Save base while compiling)
HEX
 CR ." Menu"
: Menu MENU ;
 CR ." CURPOS"
: CURPOS ( -- b )
 ( Returns cursor position 0..39 )
 0F788 C@
;
 CR ." CURON"
: CURON ( -- )
 ( Turn on cursor )
 73D9 CALLX
;
 CR ." CUROFF"
: CUROFF ( -- )
 ( Turn off cursor )
 73C5 CALLX
;
 CR ." INVON"
: INVON ( -- )
 ( Turns on inverse video display )
 AF F648 C!
;
 CR ." INVOFF"
: INVOFF ( -- )
 ( Turns off inverse video display )
 0 F648 C!
;
 CR ." CURHOME"
: CURHOME ( -- )
 ( Homes cursor )
 101 F639 !
 0 F788 C!
;
 CR ." ROOM"
: ROOM ( -- n )
 ( Returns number of free bytes )
 SP@ HERE - 180 -
;
 CR ." B."
: B. ( b -- )
 ( Types value b as 2-char hex number )
 BASE @ >R ( Save old value of BASE )
 HEX       ( Change base to HEX )
 0 <# # # #> TYPE SPACE ( Type value )
 R> BASE ! ( Restore value of base )
;
 CR ." ADR."
: ADR. ( adr -- )
 ( Types value of adr in 4-char hex )
 BASE @ >R ( Save old value of BASE )
 HEX
 0 <# # # # # #> TYPE SPACE SPACE
 R> BASE ! ( Restore value of BASE )
;
 CR ." C."
: C. ( c -- )
 ( Print character represented by c )
 DUP A0 >  ( control char with bit7 )
 OVER FF < ( DELETE with bit 7 )
 AND
 IF
  INVON    ( show this set inverse )
 THEN
 7F AND    ( mask bit 7 )
 DUP 20 <  ( Check for control chars )
 OVER 7F = ( Check for DELETE )
 OR
 IF        ( if control char or delete)
  DROP 2E  ( replace with '.' )
 THEN
 EMIT      ( print character )
 INVOFF
;
 CR ." DUMPLINE"
: DUMPLINE ( addr -- addr )
 ( display contents of 8 bytes of mem )
 DUP ADR.  ( display address value )
 DUP 8 +   ( final value + 1 )
 OVER      ( initial value )
 DO
  I C@ B.  ( display byte at loc )
 LOOP
 SPACE
 DUP 8 +   ( final value + 1 )
 OVER      ( initial value )
 DO
  I C@ C.  ( display byte in ASCII )
 LOOP
 CR
;
 CR ." CLS"
: CLS      ( -- )
 ( clears screen )
 0C EMIT 
;
 CR ." VIEWMEM"
: VIEWMEM  ( addr -- addr )
 ( display screenful of mem contents )
 CLS
 BEGIN
  CURHOME
  DUP 38 + ( last addr + 1 )
  OVER
  DO       ( once per line )
   I       ( dump info for this line )
   DUMPLINE
   DROP
  8 +LOOP
  KEY      ( get next keystroke )
  [ ." ." ] ( Reassure )
  DUP 1E = ( if up-arrow )
  IF
   DROP
   8 -     ( move back one line )
   0       ( don't exit )
  ELSE     ( not up-arrow )
  DUP 1F = ( if down-arrow )
  IF
   DROP
   8 +     ( move ahead 1 line )
   0       ( no exit )
  ELSE     ( not up or down )
  DUP 1D = ( left-arrow )
  OVER
  1 = OR   ( shift left-arrow )
  OVER
  11 = OR  ( ctl left-arrow )
  IF
   DROP
   1 -     ( back up one location )
   0       ( continue )
  ELSE     ( not up, down, left )
  [ ." ." ] ( Reassure )
  DUP 1C = ( right-arrow )
  OVER
  6 = OR   ( shift right arrow )
  OVER
  12 = OR  ( ctl right arrow )
  IF
   DROP
   1+      ( ahead one location )
   0       ( continue )
  ELSE     ( not up, down, right, left)
  DUP 14 = ( shift up )
  IF
   DROP
   38 -    ( back 1 screenful )
   0       ( continue )
  ELSE
  DUP 2 =  ( shift down )
  IF
   DROP
   38 +    ( ahead one screenful )
   0       ( continue
  ELSE
  [ ." ." ] ( Reassure )
  DUP 17 = ( ctl up )
  IF
   DROP
   DROP 0  ( go to addr 0 )
   0       ( continue )
  ELSE
  DUP 1A = ( ctl down )
  IF
   DROP
   DROP
   FFC8    ( go to end of mem )
   0
  ELSE
   DROP 1  ( exit )
  THEN
  THEN
  THEN
  THEN
  THEN
  THEN
  THEN
  THEN
 UNTIL     ( as long as get known key )
;
 CR ." NEWCOLD"
: NEWCOLD ( -- )
 ( Adjusts initialization for new )
 ( words in dictionary )
 FORTH
 LATEST 0C +ORIGIN !
 HERE 1E +ORIGIN !
;
 CR ." COLONLOC"
0 VARIABLE COLONLOC
 CR ." FINDCOLON"
: FINDCOLON ( pfa_of_;CODE pfa_of_: -- )
 ( Fill in COLONLOC )
 SWAP 2 - SWAP
 LATEST SWAP DO
  I @ OVER = IF
   I 2 + COLONLOC ! LEAVE
  ENDIF
 2 +LOOP
 DROP
;
 -FIND (;CODE) DROP DROP
 -FIND : DROP DROP FINDCOLON
 FORGET FINDCOLON
 CR ." BADADR"
: BADADR ( adr -- )
 @ COLONLOC @ = IF
  ." :"
 ELSE
  ." not recognized"
 ENDIF
;
 CR ." DECOMPILE"
: DECOMPILE ( -- )
 ( used in form DECOMPILE <word> )
 -FIND 0= 0 ?ERROR
 DROP CFA CLS
 BEGIN ( cfa )
  DUP ADR. ( print loc in definition )
  DUP @ DUP ADR. ( print value there )
  3 - ( cfa adr2 )
  DUP 0 +ORIGIN U<
  OVER LATEST SWAP U< OR IF
   DROP DUP BADADR
  ELSE ( adr in proper range )
   DUP C@ 80 < IF
    DROP DUP BADADR
   ELSE ( proper range, high bit set )
    DUP -1 TRAVERSE ( cfa adr2 adr3 )
    DUP C@ 1F AND 3 PICK 3 PICK - - IF
     DROP DROP DUP BADADR
    ELSE
     SWAP DROP COUNT 1F AND TYPE
    ENDIF
   ENDIF
  ENDIF
  CR
  2+
 KEY 0D = UNTIL
;
 CR ." 4DROP"
: 4DROP ( n1 n2 n3 n4 -- )
 DROP DROP DROP DROP
;
 CR ." PLOT"
: PLOT ( x y -- )
 SWAP 8 SHL + >R 0 0 R> 0 744C CALL
 4DROP
;
 CR ." UNPLOT"
: UNPLOT ( x y -- )
 SWAP 8 SHL + >R 0 0 R> 0 744D CALL
 4DROP
;
 CR ." .S"
: .S
 ( Print contents of stack, unsigned )
 SP@ S0 @
 SWAP DO
  I @ U.
 2 +LOOP
;
 CR
R> BASE !  ( restore original base ) CR
