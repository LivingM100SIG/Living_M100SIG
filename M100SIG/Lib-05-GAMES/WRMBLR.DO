     WORMY is a one-player version of Hustle, seen as a metaphor for greed.
You score points according to how long the worm gets before running into
itself or the wall.  You can't win, but then are there any arcade games you
CAN win (besides Dragon's Lair)?  Even if you somehow managed to fill the
screen with the ultimate worm, you'd be stuck.  Besides, can you imagine
anything as gross as a 1280-segment tapeworm?
     All this philosophy is irrelevant anyway as the ONLY things you can
do in this game are squinch around, eat the food and grow longer.  Enjoy it.

     These programs only run on a Model 100.

     Four files besides this one:

     WORMY.100:  Original BASIC version.

     WORMY.BA:  Same as WORMY.100 but with comments, for those of you who
would rather read games than play them.

     The next two programs require an empty 32K machine.  WORMY.CO, once
made, can run in 16K (maybe in 8K).  Borrow a 32K machine from someone.

     WORMY.TCM:  New improved version!  Runs slightly slower in BASIC but can
be compiled by TCOMP version 1.21.  The resulting program is rather big (6567
bytes) mainly because of a large array in it. 
      4655 bytes as .DO, 3862 as .BA.
      Checksum:  287,256
      To compile:  Clear a 32K machine.  Load TCOMP version 1.21 and this
program as WORMY.BA.  Start address: 56400.  End:  <ENTER>.
Source .BA file:  WORMY.  Object .CO file:  <ENTER>.  When done, type
NEW and then SAVEM "WORMY",56400,60288,56400.
Note that WORMY uses 56400 to 62960 to run.

     WORMKR.CO:  This BASIC program creates WORMY.CO directly.  Unfortunately
it just barely fits in 32K.  After downloading it, save it on tape or
disk.  Then clear out your machine and type "LOAD CAS:WORMKR" or
"LOAD 0:WORMKR.DO" or whatever.  "SAVE WORMKR". Then if using Chipmunk, remove
CDOS.  Then run WORMKR.
	16118 bytes as .DO.  Checksum: 791,441

            Mark Lutton (73106,1627)
