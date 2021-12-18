LIST Glitch in fig-Forth

I've noticed that from time to time when I LISTed a screen, Forth would crash.
After a while, I noticed a pattern: this only happened when I LISTed blank
screens. Also, the crash always happened after a line number divisible by four
was displayed. This corresponds to the end of a block. With a little more
investigation, I discovered that the crashes were occurring when LISTing
blank screens that happened to correspond with the beginning of a track.
I still don't know why this happens. Perhaps it's a little timing discrepancy
between the Chipmunk and Forth. Or maybe Forth might expect blank screens to be
filled with spaces (ASCII 32) whereas when the Chipmunk formats a disk it fills
sectors with nulls (ASCII 0), although this doesn't explain why it seems to
occur only on screens that coincide with the beginning of a track. If anybody
knows for sure, I'm all ears. In any case, I have found a cure that, so far,
has always worked: fill the empty screen with spaces. So I've defined the word
shown below which takes the screen number to "fix" on the stack. This word
also is handy to erase a screen without having to load the editor.

Tim Ekdom 72575,1473
April, 1986


: BLANK-SCREEN  ( fill screen n with blanks )
                ( n --- )
    4 * 4 0 DO
      DUP I + BLOCK 256 32 FILL UPDATE FLUSH
    LOOP DROP ;

