
#: 189731 S1/General/Help
    06-Nov-89  15:00:52
Sb: WP-2 to Mac Cable & Memory
Fm: Tim Celeski 74746,1145


Tandy WP-2 to the Mac

Finally solved the cable problem. Here are the pin-outs to connect the TANDY
WP-2 to the Macintosh.

        WP-2    MAC DB-9   MAC Plus
        -----   --------   --------

        5 Grd   1 Grd      4 Grd

        2 Rxd   5 Txd      3 Txd

        3 Txd   9 Rxd      5 Rxd

        7 Rts
       (     
        8 Cts

Loop back the RTS and the CTS lines on the WP-2 into each other with a jumper.
That should do it.



Memory Upgrade

The 32k internal memory upgrade used in the WP-2 consists of the following 28
pin chip.

Mitsubishi M5M5256BP-10L

I'm told that there are lots of other alternatives for this, and that this
speed of 100ms is not really necessary. Remember this is CMOS ram, handle
carefully!
