      Tandy Portable Disk Drive Cable Revealed

  (c) Marty Goodman MD, Sept. 1989


  I recently picked up a Tandy Portable Disk Drive (TPDD) at a Ham Swap Meet
for $10.  It came WITHOUT the usual black 8 pin dual-in-line to DB25 cable
needed to connect the drive to a Model 100 / 102 / 200 / NEC 8201.  I
figured... what the heck... it's worth a gamble...  I own such a drive
already... if I am lucky and this works, I will have a spare   I went home
and, using the cable that came with my original TPDD I ascertained that the
drive I had bought was in perfect working order.  

    Fine.  Now... all I needed was a CABLE for the damn thing.  I called Tandy
National Parts, and after considerable difficulty, ascertained that the
catalog number for the needed cable was AW-1028 and they would gladly sell it
to me for $25.09 plus shipping.  


   TWENTY FIVE DOLLARS for a durn CABLE!!??  And here I had no more than ten
dollars invested in that spare drive, anyway!  I dedcided to make up a cable
for myself.


     The first difficulty was that the 8 pin dual in line connector used to
hook the cable to the drive is very non-standard, and I had not a prayer of
finding a source of those.  But, 15 minutes spent with a hacksaw, a 10 pin
dual in line, and a soldering iron (to melt and weld the plastic of my hacked
up former 10 pin dual in line connector and its strain relief) sufficed to
adequately clone that connector and attach it to a length of 8 conductor
ribbon cable.   


    The real problem came when I tried to "buzz out" the connections for the
wires of the cable using an ohmmeter.  I kept getting weird results... strange
resistances, and some lines behaved as if they had DIODES in them!  DRAT!  The
buggers must have put some CIRCUITRY into that cable!


    I then looked in the manual for my Tandy Portable Disk Drive.  Like so
many other Tandy product manuals, they had very conscientiously and
thoughtfully included a schematic diagram for the drive.  BUT, there was NO
diagram for the required (and normally included) conneting cable!  Drat! 
Foiled again! 


     So...  I teased apart the hood and the DB 25 connector the hood to (which
seemed like the only logical place they'd try to hide any circuitry.  and,
sure enough, there was a blob of what appeared to be hot glue all around a
little CIRCUIT BOARD inside that hood!


    About an hour spent destroying the hood to free up the whole mess and
carefully, tediously removing the hot glue using soldering irons and awls and
screwdrivers and exacto knives finally resulted in my having the circuit board
totally revealed.   There were three odd little surface mount components in
the circuitry for the DTR, TXD, and RTS lines going FROM  the TPDD  TO the
DSR, RD, and CTS pins of the DB25.  All other lines were wired straight thru. 
The three odd devices looked like litte resistors or capacitors, and had the
designation "14" on them.  Curiously, they had THREE leads, two on one long
side and one in the middle of the other long side of each of these tiny
rectangular components.  


    Some probing with an ohmmeter revealed that these things behaved like
diodes across some leads, and like a resistor across others.  I never DID
exactly identify WHAT the components were, but using a diode and a resistor I
was able to get a circuit to replace each of them that resulted in a WORKING
cable.  


    After a total of about five hours on this project (meaing I was getting
virttually minimum wage, even if you assumed all components were free) I had
my spare cable.  But I ALSO had the knowledge of HOW the cable was made, and
so the ability to make more or repair the ones I had.  And here is that
information:    


    Note that while this is a serial cable, all signal levels are TTL level,
NOT normal RS232 level!  This has to do with the way the signals are generated
inside the Tandy Portable Disk Drive.  


   (By the way, to deal with these TTL signal levels, the folks at Lap Dos had
to provide a special cable that has inside it a CMOS level converter to
convert in both directions the signal levels to RS232 level, so it can be
hooked to a normal PC type RS232 port.  The folks at Lapdos cleverly used some
diodes and capacitors, by the way, to POWER that level converter off the
voltages found ON the pins of the RS232 port.  Very smart!  Very sneaky!)  


     TPDD
  8 pin Dual In Line                         DB 25 RS232
  connector  wires                            connector   signal direction
  -------------------                         ----------  ----------------


  gnd   1 ------------------------------------- 7  gnd   

  CTS   2 ------------------------------------- 4  RTS    to TPDD 

  DTR   3 --------o--->l----------------------- 6  DSR    from TPDD 
                  l
              22K resistor  
                  l
                 gnd
 

 RTS   4 ---------o--->l----------------------- 5 CTS     from TPDD 
                  l
              22K resistor  
                  l
                 gnd    


 DSR   5 ------------------------------------- 20 DTR     to TPDD 


 *TXD  6 ---------o--->l----------------------- 3  RD     from TPDD 
                  l
              22K resistor  
                  l
                 gnd    

 *RXD  7 -------------------------------------- 2  TD     to TPDD 



       8  not connected                       1, 8-19, 21-25 all 
                                              (inclusive) not connected


    Note that for the DTR, RTS, and *TXD lines from the TPDD, there is a 22K
resistor going to ground (pin 1 of the TPDD and pin 7 of the DB25), then a
DIODE pointing its anode TOWARD the DB25 side of the circuit.  (The little "o"
is used to signify a 3 way connection point in this ASCII graphic).  I used
Radio Shack  Schotty diodes (cat no. 276-1165)  because Schotty's have ultra
low voltage drop across the diode in the forward direction.  Tho I SUSPECT any
durn diode would do in this circuit.


     This cable / circuit worked perfectly between the TPDD and my IBM PC
clone using LAP DOS, and between the TPDD and my NEC 8021 lap computer (a
"sister machine" to the Model 100  / 102).



   Happy Hacking!

     ---marty
