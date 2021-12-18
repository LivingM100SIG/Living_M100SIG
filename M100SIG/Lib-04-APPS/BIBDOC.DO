    BIBLIO:  A Disk and Cassette file management system for the M100 and TDD
    ========================================================================


	BIBLIO is an automatic, easy to use file reference system which will:
store, update and cross-reference the names of your Disk AND Tape files; keep 
track of update dates; find individual file/subject references anywhere in your
library; print labels and two different directories; one alphabetically cross 
referenced, and one alphabetically source by source. It doesn't require 
any separate DOS to run and, best of all, is only limited by available RAM as 
to number of files you can keep track of. BIBLIO also stores file sizes.
	PLEASE read all these instructions completely before running BIBLIO. 
They're not complicated but they ARE necessary.

                                 INITIAL SET-UP

	Download BIBLIO.BA, BIBLDR.BA, BIBPRT.BA and BIBDOC.DO (this file).
Edit out the garbage and checksum them as .DO files; BIBLIO.BA = 396323,
BIBLDR.BA = 101878, BIBPRT.BA = 343021. Print out a copy of BIBDOC for future
use. Save all the program files as .BA's. RUN BIBLDR.BA It will create three
files: BIBSRT.CO is a modified version of the Perry/Wheeler SORTHI.CO which
runs in the Alt/LCD buffer; BIBFYL.DO will be the data file:(Line 1 MUST start
with # and line 2 with *.); END<!>.DO will be used in the cassette update
routine. The dummy file named END<!>.DO MUST be saved as the LAST file on each
cassette; either at the end of each side if you'll index each side separately
or at the end of side 2 if you prefer to treat the whole tape as one source.
(also a handy way to find the end of current programs on a side).
	BIBPRT.BA will create "fancy" directories and LABELS for your tapes and
disks. Although BIBLIO.BA has a built-in X-Ref print function for creating an
all-inclusive and very useful printed cross reference, BIBPRT is comprehensive
and prints a variety of formated file documents in 80/96/132 column format.


                                   OPERATION

	Cursor selection of BIBLIO from the M100 main menu displays BIBLIO's
main menu. Make your selection by pressing the corresponding letter. The menus 
all require Upper Case letters.

<D>isk & <C>ass update:
	Before you use BIBLIO for the first time you should plan a method for
identifying your disks and tapes. You can use any combination of letters and 
numbers with a maximum of THREE. Try to enter your sources in the order you
want them in the directory. Disks and tapes will be combined in the cross
directory but will print out separately for the directory. Although you
can change the order of source I.D.'s later, it requires some VERY careful 
editing so doing it right now is worth the time.
	Load your tape (press play) or disk & press <C> or <D>. The whole
disk process is automatic but <C> requires you to turn over the tape if you
chose to put END<!> on one side only. (The tape process tries to LOAD each tape
file, stops, reads the screen, ID's the files, saves the names and repeats 
until it finds END<!>.) Tape files will have a "c" as the last ext. character.
	BIBLIO starts the update process by sorting all commented files with
the same source I.D. into a small array. As new files are input BIBLIO saves
"old" comments to the "new" record. Keep an eye on free RAM, displayed in the
center of the main menu bottom line.  If you receive the message "Need RAM..."
clear some; or start a new  BIBFYL; then re-run BIBLIO.
	 If you fill up one BIBFYL just save it to your medium as BIB-1 etc.
and continue. (Remember: ALWAYS title the current data file as BIBFYL and put
 # as the first character in line 1 and * as the first character in line 2.)
	 (A "?" in the size field means size was divisible by 26 and couldn't
be read by the very simple Disk routine; you can edit BIBFYL to correct it
after using another DOS to find the size or live with the slight inaccuracy.)




<A>nnotate
	This will take you to BIBFYL via TEXT; use F1 to search. (Remember that
Ctrl -> will take you to the end of a line.) You can use 20 characters for your
comments if you don't leave a space after the file size. The array is sized 
to let you use ONLY 40 BYTES PER FILE! You can change the CLEAR1600 (40x40)
statement in line 2 if you need more comment room but be VERY careful when
adding over 20 characters. ONLY ONE CR PER FILE RECORD! I suggest you use only
upper case letters for comments because of the simple search routine used. When
you're finished "annotating" return to BIBLIO via F8 and the main menu.

<S>earch
	Choose a string to search for in BIBFYL. Display will show 6 files
pausing when screen is full; Print will ask you if your printer is ready then
Lprint all matches. "Searching..." will show at top of screen while BIBLIO
looks for your string. 

<X>-ref:
	This will Lprint a semi-formatted standard pitch 80 column alphabetical
cross reference listing. All annotated file records will display a "<" next to 
the file description.

<R>ecords
	In this section you will find which ID's are currently filed and when
each source was last updated: "d" means a disk source and "c" means tape.

<P>urge:
	This routine lets you remove ALL file records of a chosen source,
INCLUDING annotated files. Use carefully!!  Press P at the Menu; follow 
instructions.

<E>xit:
	ALWAYS END A BIBLIO SESSION BY RETURNING TO THE M100 MENU USING <E>XIT.
	You should save BYBFYL.DO, BIBSRT.CO, BIBLIO.BA, and BIBPRT.BA for your
next session. (Keep BIBLDR.BA someplace too, in case you lose BIBSRT.CO.)
	BIBLIO will reset your TELCOM parameters to M7E1E on the way out. If 
this is not your favorite you can edit the pokes in line 146. The two digit set
after the comma at each POKE command is the ASCII Decimal value of each of the 
characters of the TELCOM Stat. (M=77 etc.) They're in left>right sequence so if
you wanted Ignore parity just change POKE63069,69 (E) to POKE63069,73 (I) etc.
(Change MENU in LINE146 to call your DOS if that's more convenient.)
	




Points to remember:
	The size of BIBFYL (file records + comments) is really only limited
by available RAM. 5000 bytes will store about 175 uncommented file records.
	BIBLIO needs 6600 bytes plus TWICE the size of BIBFYL.DO to run:(for
example: with BIBLIO.BA and a 5K BIBFYL.DO in RAM you should have at least 6600
bytes free to do anything; more if you want to add more files.)
	The info stored in BIBFYL.DO is not explosive but it IS rigidly 
formatted for BIBLIO. Please be very careful when you add or delete BIBFYL
info. You can change the sequence of sources in the first line if you PERFECTLY
follow the syntax shown. (Any mistakes here will totally foul up BIBLIO's sort
and update routines: and you MUST also locate the appropriate date sets and 
change THEIR sequence; 1st source goes with first date etc.)
	Only the most rudimentary error trapping was used to save space. Be
sure that the disk drive and cassette recorder are on, loaded, and ready to go.
(Be sure you've CSAVEd END<!> as the last prog on your tape: otherwise BIBLIO 
will run the tape update forever!) If you forgot END<!> just SHIFT/BREAK out,
add END<!>, and rerun BIBLIO and that tape.




	BIBLIO makes and then kills TTEMP & COMTMP for interim sorting storage.
	Although BIBFYL is the file BIBLIO uses when running, you can of course
keep library files in your storage medium under any name. Just be sure that you
name the file to be processed as BIBFYL when you load it into RAM.
	As BIBLIO fills up, the sort routines do take a while to, well... sort.
Be patient; as you can see, it's working as fast as it can. (60sec/ 7K BIBFYL)
	You can leave any "input" prompt in BIBLIO by pressing <ENTER>. If you 
should "Need RAM" during any routine DON'T PANIC! Go to the main menu and look
for BIBFYL.DO and TTEMP.DO. If you find both just clear more RAM and rerun
BIBLIO. If you find only TTEMP rename it as BIBFYL, clear RAM and run BIBLIO.
	BIBLIO keeps the last two digits of the DATE$ at "88" in line 174.
	BIBLIO can't correctly record more than 6 .CO files in a row on a tape.
Please put a dummy file spacer at least every 6 .CO files on your tapes.

	Although BIBLIO uses a TDD-1 specific access routine, when the TDD-2
routine is publicized I'll do a version for that drive. I'm also working on a
version for the T200 soon to play at your local SIG.

-------------------------------------------------------------------------------

I hope you enjoy BIBLIO. If I've missed something in the program or DOC please
let me know. Feel free to send me E-MAIL or phone me at: 800-228-3309.
Many people worked hard to develop some of the routines I used. Thank you all!

CREDITS
	Disk Access Routines: Richard Haw
               Cassette idea: Stig Hammond
            SORTHI/BIBSRT.CO: Rick Perry & Phil Wheeler
      Misc. Programming help: Jim Howard


1/2/88
Randy Hess
73267,552
Omaha, Ne (402) 556-4211
