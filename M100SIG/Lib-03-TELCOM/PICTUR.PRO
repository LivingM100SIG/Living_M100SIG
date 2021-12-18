PICTUR.PRO

Application note for C.ITOH PROWRITER re: Jim Irwin's PICTUR.100
----------------------------------------------------------------------

To print .RLE graphics on the C.ITOH PROWRITER, lines 2 and 3
of 'PICTUR.BA' must read as follows:

2 Y$=CHR$(27)+"T16"   '(NOTE CAPITAL 'T')
3 Z$=CHR$(27)+CHR$(83)+"0480"+CHR$(0)


Also, as noted in PICTUR.DOC, some printers work 'backwards'
from others. The Prowriter is one of them. In addition to the above
line changes you must change the last 14 bytes of the machine language
routine as outlined in Irwin's four-line listing in PICTUR.DOC


With these modifications you can produce full-size printouts of
weather maps, etc., on the Prowriter at speeds considerably faster
than with the excellent BASIC program 'CITOH.BA' which is
also found in this Library.


Jim Travis 73575,65  December 28, 1988
