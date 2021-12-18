
Here's a "quick and dirty" way to send output to the printer only (information
courtesy of Bob Andersen): poke a 1 into address 63093 when you want output to
be directed to the printer; poke a 0 into address 63093 when you want output
re-directed to the screen.

I've defined several words that make use of this feature. They are on the
screens below. Cut the screens from this file and put them on your Forth disk
with HELPER.BA. (Of course, you may change the screen numbers if you want,
but if you do, don't forget to change the appropriate LOAD in screen #31.)
I didn't define any of the words using any of the others (eg: LSPACE could be
defined much easier using LEMIT) so that you can "pick and choose" which ones
you want to use. ONLINE? queries the 8155 port that monitors printer status
and returns a true flag if the printer is online and a false flag if not. The
others work just like their screen-output counterparts, except output goes
to the printer only. They also seem to work with number formatting (<#, #, #S,
#>, HOLD), although I haven't tested that thoroughly.

To try this out, type 31 LOAD and then TEST. You also might like to try
sending control codes to your printer with LEMIT. For example, with an Epson-
compatible printer, 27 LEMIT 15 LEMIT will toggle condensed mode on and
27 LEMIT 12 LEMIT will cause a form-feed. You can also try (assuming you're
using the same screen numbers) 116 BLOCK 256 TYPE which prints the first block
of screen 29.

Have fun!
Tim Ekdom  72575,1473
March, 1986

_______________________________________________________________________________
29
( ONLINE? and LTYPE )

FORTH DEFINITIONS DECIMAL

: ONLINE?  ( Check if printer online )
           ( -> f )
    187 P@ 6 AND ;

: LTYPE    ( Send text to the printer )
           ( addr n -> )
    1 63093 C!     ( direct output to printer )
    TYPE           ( print it )
    0 63093 C! ;   ( redirect it to screen )

-->

30
( LCR, LEMIT, and LSPACE )

: LCR     ( perform CR on printer )
          ( -> )
    1 63093 C! CR 0 63093 C! ;

: LEMIT   ( send one character to printer )
          ( c -> )
    1 63093 C! EMIT 0 63093 C! ;

: LSPACE  ( type a space )
          ( -> )
    1 63093 C! 32 EMIT 0 63093 C! ;

;S

31
( Test LTYPE & LCR )

29 LOAD

: TEST  CR ONLINE?
    IF ." Type some words: " CR
      QUERY 13 WORD HERE COUNT LTYPE LCR
    ELSE ." Printer not on line " CR
    ENDIF ;

;S





