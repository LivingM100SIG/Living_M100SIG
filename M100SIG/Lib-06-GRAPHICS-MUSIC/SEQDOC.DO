			SEQUEN.100 Documentation







	Copyright (C) 1985 Mark Lutton.



	Version 1.0, 9/21/85



	You may distribute the program but you may not sell it.  Please

distribute this documentation along with the program.  I didn't put

instructions into the program itself because they are rather complex and

would take up a lot of room.  If you like the program, please send $10 to

Mark Lutton, 30 Rich St., Malden, MA 02148.  Ask for a copy of the latest

listing and documentation.  Add $5 if you want a copy of the program on

Chipmunk disk.



	With this program you can write Model 100 song programs as fast as you

can play them.  The keyboard layout is nearly the same as in my program ORGAN.

  The main difference is that the CTRL key doesn't play a note.  ESC is G

below middle C, TAB is A below middle C, and "a" is B flat (just to be

perverse).  The keys "Z" through "/" correspond to white keys from Middle C

to E.  The keys "S" through single-quote correspond to black keys, except

for "F" and "K" because there's no black keys between E and F or B and C

on the piano.  Those two keys do nothing.  You should have enough

proficiency with ORGAN.BA that you can pick out a tune and get most of the

notes right.



	As you play the notes, they are put into an array with whatever time

values you want.  At the end of the program, the array is written out as a

BASIC program which you can run to play the tune.  You can edit this BASIC

program to print lyrics, display graphics or whatever else you want to

do.



	When you run the program, the first 5 lines of the display will show

the notes of your piece as you play them.  "2C#" means C-sharp in the

second octave.  (Durations are not indicated in this version.)



	Line 7 shows the current metronome marking (for instance "Quarter

note = 120") and the current duration (a picture of a note).  Line 8 shows the

labels for the function keys.



	Starting from the bottom of the keyboard and working up, here is what

the keys do:



	GRPH, CODE and NUM do nothing.  The space bar inserts a rest with a

duration equal to the current duration.  If a quarter note is displayed, the

rest will be a quarter rest.



	The other four rows of keys are notes.  If you hit a key, you will hear

the note and a note of the current duration will be stored and displayed.

Some keys do nothing.  Ignore them.  "SHIFT" plays notes two octaves higher

(except for ESC and TAB).  "CAPS LOCK" does the same thing for the alphabetic

keys but not the other keys (unlike ORGAN.BA).  Stick with "SHIFT".  BKSP

doesn't backspace, it plays a very high G.



	On the top row:  "PASTE", "LABEL", "PRINT" and "BREAK" do nothing

useful.  Three of the arrow keys don't do anything.  The left-arrow key

backspaces one note.  This is the only way you can edit the piece or fix

mistakes.



	The eight function keys work like this:



	F1 (MM) changes the metronome marking.  After you change it, it is

changed for the entire piece (you can't switch tempos in the middle of the

piece).  This is so that after you have entered the piece you can experiment

and find the best tempo.



	F2 (PLAY) plays the entire piece.



	F3 (LAST) plays the last 8 notes of the piece.



	F4 (TEXT) is for inserting a REM statement into the output.  When you

hit F4, you see "REM?" and whatever you type in will be inserted as a remark at

that point.  If you want the song to clear the screen, print lyrics, or

anything like that, put a REM at whatever point you want.  Later you can

edit the program and replace the REM with whatever statements you want.

Note however that "PRINT" statements and other statements take time and may

throw off the rhythm of the song.



	F5 (DUR up) makes the current duration longer.



	F6 (DUR down) makes the current duration shorter.  The durations are

dotted whole note, whole note, dotted half, half, dotted quarter, quarter,

dotted eighth, eighth, dotted sixteenth, sixteenth, dotted thirty-second,

thirty-second.



	F7 (TUPL) is for doing triplets or other tuplets.  If you want eighth

note triplets, for instance, set duration to eight notes and hit F7.

How many?  3  In time of?  2.  You will then see "3:2" after the note icon.

When you hit F7 again, you will be back to normal notes.



	F8 (END) is what you hit when you are done with the piece.  The

program will ask you for a file name to write the output to.  If you just hit

ENTER, it will go back to the main part of the program.  If you really are

done, type a file name.  Then wait for the program to write the file.  It will

return you to the menu.  Then go to BASIC, load the output program, edit it

 if you wish, and run it.



	The program is set up to hold 400 notes and 50 REM's.  If you want to

make a longer song, change occurrences of "400" and "50" in line 90 to bigger

numbers.



	NOTES FOR TANDY 200



	There are only two things that I know of that should be changed to make

this work on a 200.  One of them is the constant value of SN.  Change it from

40 to 114 in line 5150.  The other is in line 1010.  "CALL 17618,4,1" scrolls

 the top five lines of the screen.  Change it to whatever the 200 call is

to scroll the top 13 lines.  I can't test this because I don't have a 200.



	NOTES FOR VERSION 1.1



	The new version of SEQUEN.BA uses a file called "SAFETY.DO" to avoid losing work.  Every keystroke is written to this file, and after the output file is successfully written, SAFETY.DO is deleted.  When SEQUEN.BA is started, it first looks for SAFETY.DO and if it exists it reads input from that file.



	This means that if you get an error such as OM, just exit from SEQUEN, fix the error, run SEQUEN again, and watch it go by itself.  When it stops, pick up where you left off.  (You can backspace with the left-arrow key if you need to.)



	END OF SEQUEN.100 DOCUMENTATION

