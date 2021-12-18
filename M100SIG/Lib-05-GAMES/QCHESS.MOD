A MOD TO QCHESS
---------------

QCHESS is one of the most ambitious games written for the Model 100.
Since it was written to be compiled with TCOMP, it is also one of the
fastest.

In playing QCHESS, I find the board a bit difficult to read.  The
following small code modifications create lines between the files,
making it easier (for me) to read the board quickly and accurately.

1) Add the code

   PRINT@40*(7-Y)+20,CHR$(124);

to line 5000 as shown here:

5000 FORY=7TO0STEP-1:PRINT@40*(7-Y),Y+1;:PRINT@40*(7-Y)+20,CHR$(124);:FORX=0TO7:GOSUB5500:NEXTX,Y:RETURN

2) Replace "" by CHR$(124) in line 5520 as shown here:

5520
PRINT@40*(7-Y)+X*2+4,CHR$(124);:G6=A(X*8+Y):IFG6*I>0THENPRINTCHR$(27);"p";

Before you do any of this, save a copy of your current versions of
QCHESS.BA and QCHESS.CO -- in case you don't like this change, or have
trouble creating the new version.

Please let me know of any difficulties or comments.

Phil Wheeler [71266,125]
Torrance, CA -- 12/27/86
