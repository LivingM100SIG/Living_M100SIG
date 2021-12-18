GIMME A BREAK! (Part 2: Hardware)

This is for those of you who must send much longer breaks than are sent by the
program line in part 1. You will need, along with your tools, a single pole
double throw momentaty switch.

Cut the trace from M24 pin 3 to M31 pin 11.
Connect the center pole of the switch to M31 pin 11.
Connect the Normally Closed pole of the switch to M24 pin 3.
Connect the Normally Open pole of the switch to M31 pin 8.

HOW IT WORKS: When the switch is not being pressed, data coming from M24 is
passed on to M31 without change. This data is the TTL level serial data going
from the UART to the MODEM chip. When the switch is pressed, this connection is
broken and the input to the modem is held LOW, causing the modem to send a long
stream of zero bits. This is interpreted as a BREAK by any remote system; by
holding the switch, very long breaks may be generated.

If you get the Normally Open and Normally Closed poles swapped - easy to do -
your M100 will send a break except when you press the switch. Nothing should be
damaged inside the computer.

    Enjoy,
    Greg Limes
