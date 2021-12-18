10
( COPY-SCREENS )

( Declarations )

0 VARIABLE BUFFER-START  0 VARIABLE BUFFER-POINTER
0 VARIABLE #SCREENS      0 VARIABLE SRC-START
0 VARIABLE SRC-END       0 VARIABLE SRC-OFFSET
0 VARIABLE DEST-START    0 VARIABLE DEST-END
0 VARIABLE DEST-OFFSET

0 CONSTANT WRITE         1 CONSTANT READ

-->



11
( COPY-SCREENS )

( Word definitions )

: GET-INPUT  ( Input a value for a variable )
             ( var addr -> )
   QUERY 13 WORD HERE NUMBER DROP SWAP ! ;


: FLIP-FLAG  ( invert truth flag )
             ( f -> f )
   IF 0 ELSE 1 ENDIF ;

-->


12
( COPY-SCREENS )

: INIT-BUFFER  ( Set up RAM buffer )
               ( -> f )
   CR 64438 @ 2 + DUP BUFFER-START !  ( find free RAM )
   40950 SWAP -                       ( size )
   1024 / DUP DUP #SCREENS !          ( # screens room for )
   ." Buffer has room for " . ." screens"
   FLIP-FLAG ;                        ( make 1 if 0 screens )

: GET-SRC-DATA  ( Input source range )
                ( -> )
   CR ." Source disk start screen? " SRC-START GET-INPUT
   CR ." Source disk end screen? " SRC-END GET-INPUT
   CR ." Source disk offset? " SRC-OFFSET GET-INPUT
   1 SRC-END +! ;   ( incr for loop )  -->
13
( COPY-SCREENS )

: GET-DEST-DATA  ( Input dest disk data )
                 ( -> )
   CR ." Destination disk start screen? "
   DEST-START GET-INPUT
   CR ." Destination disk offset? "
   DEST-OFFSET GET-INPUT
   DEST-START @ #SCREENS @ + DEST-END ! ;  ( calc end )

: CONV->BLOCKS  ( convert screen # to absolute blocks )
                ( offset, screen# -> end blk+1, start blk )
   4 * + DUP 4 + SWAP ;

-->

14
( COPY SCREENS )

: MOVE-BLOCKS  ( move blocks <-> RAM )
               ( r/w cmnd, end blk+1, start blk -> )
   DO
     DUP                         ( copy r/w cmnd )
     BUFFER-POINTER @ I ROT R/W  ( set up for R/W & do it )
     DISK-ERROR @ DUP            ( check for disk error )
     IF CR ." Disk error " .     ( yes )
        ." - aborted " QUIT
     ELSE DROP ENDIF             ( no )
     BUFFER-POINTER @ 256 + BUFFER-POINTER !  ( incr buff )
   LOOP
   DROP ;                        ( drop r/w cmnd )

-->
15
( COPY-SCREENS )

: MOVE-SCREENS  ( moves screens <-> RAM )
                ( r/w cmnd, offset, start, end -> )
   BUFFER-START @ BUFFER-POINTER !  ( init buffer pointer )
   CR SWAP                       ( set up loop indexes )
   DO
     DUP ROT DUP ROT                ( copies for next loop )
     I CONV->BLOCKS MOVE-BLOCKS     ( move four blocks )
     I 4 .R                         ( print screen # )
     SWAP                           ( order for next loop )
   LOOP
   DROP DROP ;                      ( get rid of extras )

-->

16
( COPY-SCREENS )

: COPY-SCREENS  ( application word )
                ( -> )
   DECIMAL INIT-BUFFER IF CR ." Aborted " QUIT ENDIF
   GET-SRC-DATA
   SRC-END @ SRC-START @ - DUP #SCREENS @ >  ( range check )
   IF CR ." Too many screens - aborted" QUIT
   ELSE #SCREENS ! ENDIF                     ( save # screens )
   GET-DEST-DATA
   CR ." Insert source disk, hit a key " KEY DROP
   READ SRC-OFFSET @ SRC-START @ SRC-END @ MOVE-SCREENS
   CR ." Insert destination disk, hit a key" KEY DROP
   WRITE DEST-OFFSET @ DEST-START @ DEST-END @ MOVE-SCREENS
   CR ." Finished" CR ;
;S
