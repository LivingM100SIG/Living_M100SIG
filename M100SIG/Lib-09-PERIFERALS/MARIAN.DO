MARIAN: a disk librarian for the Tandy Model 100

Overview
--------  MARIAN is a program for working with catalogs of files on disks.
          Each catalog file may hold names of files on any number of disks;
          the only limit is the number of filenames MARIAN is configured to
          handle. As distributed, MARIAN has been tested with a catalog of
          24 disks containing over 200 files.

Modes
-----     MARIAN has several basic modes. Switching from one mode to
          another is generally a single keystroke operation. The first of
          these modes, TOP, is active when MARIAN starts running. This mode
          is a switchyard, allowing you to select one of MARIAN's basic
          operations; a prompt listing these operations appears on the
          screen above the cursor. Press the key corresponding to the first
          letter of the operation to do it. Each operation is described
          separately here.

READ
----      The READ operation is used to read in a new catalog file. When
          this operation is selected, MARIAN will ask for the name of the
          catalog file to examine. This file may be any valid BASIC file
          name. If you press ENTER without typing a filename, MARIAN will
          return to TOP mode; otherwise, MARIAN will discard any old
          catalog information in memory and read the file. After reading
          the file, MARIAN returns to TOP mode.

FIND
----      The FIND operation is used to locate a file, by name, on the
          disks you have entered in the catalog. MARIAN will ask for a file
          name; type the name you wish to search for. MARIAN will print the
          File and Volume name for each file whose name starts with what
          you typed; if you typed an extension, it is ignored. MARIAN will
          continue asking for file names until you press only ENTER; this
          is called FIND mode.

UPDATE
------    The UPDATE operation is used to update MARIAN's image of the list
          of files on a disk. When this operation is selected, MARIAN will
          ask for the name of the Disk Volume you are updating. Put the
          disk that has changed into the drive, and type a short name for
          the disk. I generally use two digit numbers, and keep my disks in
          order; that way, I can always find a given disk; but the Volume
          Name may be any string. If you just press ENTER, then MARIAN will
          return to TOP; otherwise, MARIAN will read the disk and stash
          away the names of all the files found. MARIAN will keep asking
          for Volume Names until you press only ENTER to signify that you
          are finished updating volumes for now. This is known as UPDATE
          mode.

SAVE
----      The SAVE operation is used to save MARIAN's internal catalog in a
          file so it can be used later. When this operation is selected,
          MARIAN will ask for the name of the catalog file to create. This
          file may be any valid BASIC file name. If you press ENTER without
          typing a filename, MARIAN will return to TOP mode; otherwise,
          MARIAN will save the current catalog in the named file. After
          saving the file, MARIAN returns to TOP mode.

EXIT
----      The EXIT operation washes your dishes, does your laundrey, cleans
          your windows, and drinks your beer. Or does it return to the
          menu? I keep forgetting which.

POWR-DISK
--------- A NOTE FOR POWR-DISK USERS: You are in luck. This program was
          written with you in mind, since I use Powr-Disk myself. Put a
          colon (:) before the name of a catalog file to read from or write
          to the disk.

OTHER DOS
--------- A NOTE TO OTHER DOS USERS: This program may or may not work for
          you. It uses a "LFILES TO" statement to put a listing of the
          files on a disk into a file in ram. If your DOS does not provide
          this facility, let me know. Maybe we can work something out.

READ THIS
--------- MARIAN falls into the classification of Supported ShareWare. This
          means that you can get it for free, but it is generally expected
          that if you keep it and use it, you will treat it as purchased
          software and send some money to the author. I figure that I would
          pay about ten bucks for this program if I were purchasing it;
          please send whatever you think it is worth to me at the address
          below.

LETS TALK
--------- If you have any comments, suggestions, wish to register as a paid
          customer (hint hint), would like a list of other programs I have
          available, or just want to chat, I can be reached in several
          ways. On CompuServe, I can be reached on the Model 100 Forum (GO
          M100SIG) or by EasyPlex; my ID number is 76606,3202. If you are
          in the Santa Barbara area, I can be reached on the Goleta OxGate.
          For those of you who do not have access to either of these, my
          address is:

                  Greg Limes
                  1 B North San Marcos Road
                  Santa Barbara, CA 93111
