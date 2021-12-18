Saving fig-Forth Dictionaries:

If you have defined new word definitions that you use frequently, or if you
have an application program that you want to save as a .CO file, you will
want to save a copy of your new Forth dictionary with your definitions or
application program already compiled into the dictionary, so that you don't
have to LOAD screens each time. Several user variables stored in the origin
area ("boot-up literals") will have to be modified so your new words will
be recognized the next time this dictionary is booted. Here's how to do it:

LOAD the screens containing your word definitions or application program so
they're compiled into the dictionalry. Then execute the following words:

FORTH DEFINITIONS DECIMAL

LATEST 12 +ORIGIN !  ( NFA of most recent addition to current vocabulary )
HERE 28 +ORIGIN !  ( resets FENCE )
HERE 30 +ORIGIN !  ( resets DP )
HERE FENCE !  ( resets current value of FENCE )

HERE U.  ( gives you the top of the dictionary )

Also, if you created a new vocabulary:

' vocabname 6 + 32 +ORIGIN !  ( resets VOC-LINK )

Be sure to remember the new value of HERE. Exit to the main RAM menu. Kill
the previous FORTH.CO file if it's in the RAM menu and/or other files to make
room. Now go to Basic and SAVEM"newfile.CO",40960,new top,40960 and you'll
have your new expanded FORTH!

Tim Ekdom
72575,1473
Feb, 1986

