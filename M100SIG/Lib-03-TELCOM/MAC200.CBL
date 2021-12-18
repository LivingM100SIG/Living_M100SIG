

By Simon Tortike
CIS: 73717,647
NetNorth/Bitnet/EARN: STORTIKE@UALTAVM
Dept of Min-Met-Pet Engg
Edmonton, Alberta
Canada T6G 2G6
March 1987

Copyright 1987 The University of Alberta and Simon Tortike.
All rights reserved.

The author accepts no responsibility for anything arising from the 
information contained in this document.

COMMUNICATIONS BETWEEN A MAC PLUS AND A TANDY MODEL 200 LAPTOP COMPUTER.

I have recently been using a Mac Plus to store M200 files, 
transferring them back and forth.  However, at first there was 
considerable difficulty in establishing two-way communication between 
the M200 and the Mac.  The cable needed is different from that needed 
between a Mac and an M100.  This point was made in articles in MacUser
magazine: "You can take it with you", by M.D. Wesley and G. Rankin, 
MacUser, August 1986 and "Desktop Productivity: Hints & Tips", 
MacUser, January 1987. Instructions for making a Mac-M200 cable were 
provided in the second article.  I had one made up according to these 
instructions and found that it only worked one way: Tandy to Mac. 
Another article appeared in the March 1987 issue of Macazine 
discussing connection of an M100 to a Mac.  As pointed out in the 
MacUser articles, an Apple ImageWriter I cable would suffice for the M100. 

Next, I turned to CIS for information in the M100SIG, MACUS and MACDEV
(MAUG) forums.  The M100SIG forum was particularly helpful, as one 
might expect, but the only proven information was again for linking 
together the M100 with the Mac.  Finally, I got our terminal repair 
department on campus to use a breakout box to establish the 
connections, which they duly did.  This cable permitted two-way 
communication at 9600 baud with Xon-Xoff control.  The diagram follows:

        Tandy end       Mac end        Mac end
        (DB25P)        (mini-DIN8)    (DB9)
        
        |->4
        |->5
        
        |->6
        |  3............3    ...........5
        |->8            4<-|            3<-|
        |  2............5  | ...........9  |
        |->20...........6  | ...........4  |
                           |               |
        |->1               |               |
        |->7............8<-| ...........8<-|
                        shell,1,2,7
                        are not used

where the weird |-> signs indicate a shorted pin. Therefore pins
6,8,20 and pins 1,7 are (separately) shorted on the DB25.  Pins 4,8
and 3,8 respectively are shorted on the mini-DIN8 and the DB9.  The
dots indicate the suggested connection between the two plugs, i.e.,
3-3, 2-5, 20-6, 7-8 for DB25-mini-DIN8 connection and 3-5, 2-9, 20-4,
7-8 on the DB25-DB9 connection. NB the isolated pins 4,5 on the DB25
are shorted for a reason! Acknowledgements for drawing the diagram
must go to our departmental electronics technician: Rob Stefaniuk.

Just plug the cable into your Mac and your M200 and away you go! Note 
that I have given the mini-DIN8 connection for the Mac Plus as this 
was how the connection was determined at first.  We later decided to 
use the Apple-supplied DB9-mini-DIN8 connector cable as the
mini-DIN8 plugs were too fragile.  They were terrible to solder and 
the wires broke off with very little handling.  I don't recommend them 
unless you have a way to make them into integral connectors.

I have since found out that the interface cable supplied by Hewlett-
Packard to connect my Mac to an HP ColorPro plotter also works 
perfectly.  So if you don't wish to  make up a cable from scratch you 
can buy one off the shelf from an HP dealer for around C$50 (the last
time I looked it was HP part number 92219M: a 1.5 m DB9-DB25 male to
male cable)

To transfer files I use Telcom as described in the aforementioned 
magazine articles and in the M100SIG file MAC100.DOC.  I use 9600 
baud, 7-bit with 1 stop bit; the STAT setting is 87I1ENI,O,T.  On the 
Mac I use Red Ryder v9.4 by Scott Watson (famous on GEnie) available 
from Mac users' groups and most BBSs.  Here I use the VT100 emulation 
with wraparound and newline modes on.  Ensure that the "send linefeed 
after carriage return" option under the terminal preferences is 
turned OFF. The communication parameters should be set to 
9600-N-7-1-FULL.  Use full duplex on both machines unless you want to 
monitor transfers on both screens. Transfer files as text, or XMODEM 
if you have the utility on the M200.  I found that no problems arose 
using text transfers, so error checking should not be necessary unless 
you live next to an electrical substation's high voltage transformers. 
Convert .CO (compiled) files on the M200 to .DO using a BINHEX program
first.  There are some available in the M100SIG DLs.  This is a very 
convenient way to move binary (or is it hexadecimal?) code between 
machines. 

I hope this document saves someone else time and effort.
Good luck!  WST.

