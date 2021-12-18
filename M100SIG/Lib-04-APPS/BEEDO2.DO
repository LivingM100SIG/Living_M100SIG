CHAPTER 8. DATABEE SCREEN FORMAT:

DATAbee, like dBase, uses one standard screen. The last line of this 
screen is the status bar. It shows the operation being performed, the 
database in use, the current record number and the total number of 
records. A database is manipulated by entering text commands at the 
"dot prompt" on the line above the status bar or by using the command 
menu (ASSIST).

In DATAbee, almost all commands consist of one word. You do not enter 
the command parameters on the command line as in dBase. Instead, 
prompts guide you through parameter options somewhat like the dBase 
III+ "Assistant" pull-down menus.

Like dBase, pressing the up and down cursor keys allows you to recall 
past commands which can save a lot of time when doing repetitive 
operations. DATAbee stores the past 10 commands.

DATAbee does not predefine the M100/102 function keys but any 
definitions already stored will be entered at the dot prompt when the 
function key is pressed. You may want to define some or all of the 
function keys, using BASIC, to the DATAbee commands you use 
frequently.


CHAPTER 9. ACTIVATING A DATABASE FILE:

When you first run DATAbee, there is no database file in use so the 
first operation is to activate a file. Do this with the USE command. 
Enter this command at the dot prompt followed by the database file 
name (i.e., USE <file>). The .DO extension is optional. When the dot 
prompt returns you're ready to work on the file.

Only one database can be active at a time. To switch to another 
database, reenter the USE command with a new file name.


CHAPTER 10. ADDING NEW RECORDS AND EDITING EXISTING RECORDS:

When you USE a database for the first time there are no records, so 
you must APPEND records. Enter APPEND at the dot prompt and the APPEND
/EDIT format will be displayed. For each record field, the field name 
and type are shown followed by a highlighted area for your data. Enter
or change the data for that field and press ENTER or the down cursor 
key. After all fields for the record have been added, a prompt asks if
you want to update the record in the file. PRESS ENTER TO WRITE TO THE
FILE. PRESS ESC TO ABANDON THE ENTRY AND RETURN THE DOT PROMPT.

To EDIT existing records, enter EDIT <record number> such as EDIT 2 or
EDIT 5. The EDIT format which is then displayed is the same as used 
with APPEND except the existing data on file is shown for you to 
change.

TO ABORT EITHER THE APPEND OR EDIT FUNCTION, PRESS ESC. Any entries 
for the record up to that point are discarded and the dot prompt 
reappears.


CHAPTER 11. DELETING RECORDS:

To delete an unwanted record, leave DATAbee with the QUIT or MENU 
command, go into the .DO data file in TEXT and delete the FULL line(s)
for the record. Make sure you remove the entire line INCLUDING the CR/
LF symbol at the end. Because of the amount of code necessary to 
include this function in the program, it is not supported from within 
DATAbee.


CHAPTER 12. VIEWING RECORDS:

There are three ways to view records. a)Use the EDIT command with the 
appropriate record number and scroll through the fields with the 
cursor or ENTER keys. b)Set the record pointer to the desired record 
number and enter the command, DISPLAY. Then press ENTER at the "Output
device" prompt to display to the screen. The last way, c)use the LIST 
command.

LIST is one of the most powerful commands. With it you can display to 
screen, printer or any M100/102 device, all records whose fields match
your specified criteria. Prompts guide you through the process.

You can list fields in any order by first specifying the field numbers
separated by commas at the prompt. Note that you will get a "??" 
prompt if you enter less than 15 fields. Simply press ENTER to accept 
your entry as is. Next, specify a match criteria, For instructions on 
how to do this see the chapter below on finding records. Then, specify
any standard m100/102 device name (LCD:,LPT:,COM:xxxxx) at the "Output
device" prompt or press ENTER for LCD, the default.

CHAPTER 13. FINDING RECORDS:

You find records in the database which match a specified criteria with
the LOCATE command. Enter LOCATE and you will be asked for a search 
condition. LOCATE will then move the record pointer to the first 
record which matches the criteria. You can look at the record as 
described in the last chapter. Find the next matching record by 
issuing the command, CONT. When the search reaches the end of the 
database, with or without stopping at matching records, the message, 
"End of locate scope", is displayed.

A search condition statement consists of a field number, an operator 
symbol (<,>,=,<>) and the data to be matched. For example, the 
following condition statement would locate all records where the data 
in field 2 was "MANAGER".

       2='MANAGER'

Following are other valid sample condition statements:

       1<>'CITY'
       5=Clerk
       3<122.11

IMPORTANT CONSIDERATIONS when building condition statements.

- Character matches are made from the left of the field not from a 
sequence within the middle of a field.
- Character matches are CASE SENSITIVE. You can enter data to 
character fields with any combination of upper or lower case 
characters but it's easy to forget when you used upper case and when 
you didn't. To insure that your searches always find all matches, it's
safest to always enter data in upper case only.
- There must be NO spaces surrounding the logic operator symbol.
- For character fields, the single quotes are optional unlike in 
dBase.


CHAPTER 14. PRINTING RECORDS AND REPORTS:

Output from the following commands can be directed to the printer by 
specifying "LPT:" at the "Output device" prompt.

       LIST
       DISPLAY
       DISPLAY STRUCTURE
       AVERAGE
       COUNT
       SUM

In addition, to provide some very basic formatting capability for your
printouts, entering ? at the dot prompt will output a blank line to 
the printer. If you use this in conjunction with the above commands 
and their output options, you can create reasonable printed reports.

You can also direct output to a non-RAM device, such as tape or disk (
with a resident DOS), and then load the file back into the M100 to 
edit and enhance it with TEXT.


CHAPTER 15. SUM, COUNT AND AVERAGE:

In DATAB.BA, the commands SUM and AVERAGE add or average the numeric 
data in a single numeric field for all records which meet a specified 
condition. At the prompts, enter the field number and then a condition
statement (in the format described in Chapter 13) and enter the output
device, if any. COUNT counts the number of records where the data in a
specified field matches your search condition and prints the result to
the output device you specify. The default device is LCD:.


CHAPTER 16. SORTING:

Sorting of the records in a database is handled by BEESRT.BA. Run this
program, enter the name of the database file to USE and, at the 
prompt, enter the number of the field to sort on. BEESRT.BA will 
generate a new file, sorted in ascending order, to the output device 
you specify. It cannot generate the output file to RAM. Your original 
file is not changed.

The dBase INDEX function is not support by DATAbee due to memory 
limitations. Sorting the file actually accomplishes the same thing and
the concept is more logical to many people.


CHAPTER 17. PRINTING LABELS:

Printing labels is done with BEELBL.BA. This auxiliary program prompts
you for the file name, the order of the fields and a search condition.
These are entered in the same formats used with other DATAbee 
commands.


CHAPTER 18. MOVING BETWEEN DATABEE AND DBASE:

DATAbee's BEEAPP.BA program provides the capability to read and write 
comma-delimited files. This gives you the ability to create a database
on your M100/102 and move it to dBase on a PC. Or, you can move part 
of a dBase database from a PC to the 100/102, append additional 
records and then move them back to the PC.

BEEAPP.BA first prompts for the DATAbee database file to USE. A second
prompt asks if you want to 1) COPY TO (write) or 2) APPEND FROM (read)
a comma-delimited file. In either case you can enter a RAM file name 
or a M100/102 device name. If you select COPY TO you are prompted for 
the list of field numbers and a search condition. These are entered in
the same manner as for the DATAB.BA list command. This allows you to 
move selected records or fields if you wish.

In using the DATAbee COPY TO function, it is important to understand 
how dates are handled. In date fields, you must use the format "01/01/
88" or "01/01/1988" or leave the field completely blank, otherwise 
BEEAPP.BA cannot convert it properly when creating a comma-delimited 
file.

Comma-delimited text files from DATAbee or dBase can be moved between 
the 100/102 and the PC with any standard PC communications program. On
the PC side, in dBase, use the COPY TO DELIMITED and APPEND FROM 
DELIMITED commands.

In order to insure compatibility between a DATAbee file on the M100 
and a dBase file on the PC, the structure of each database must be 
identical!


CHAPTER 19. ERROR CHECKING

In order to keep program size down, DATAB.BA includes simple error 
trapping on some key commands and a general error routine. On errors 
with these key commands, a simple explanation of the error is 
presented. In all other cases, the general error routine traps the 
error, displays the BASIC error number and program line number and 
returns to the dot prompt. For example, if you try to USE a file which
is not in memory you will get the message, "Error 52 Line 546".


CHAPTER 20. SOME BASIC TECHNICAL INFORMATION:

The DATAB.BA program is provided without any comment lines in order to
keep its size reasonable. If you are interested in the structure of 
the program, the file, BEEREM.DO contains a set of comment lines which
can be merged with DATAB.BA. Download this .DO file and store it in 
your M100/102 as BEEREM.DO. Remove any extraneous lines and data from 
the download process with TEXT. Then, with DATAB.BA also in memory, go
into BASIC and enter LOAD "DATAB". Then enter MERGE "BEEREM". When the
"Wait" message stops flashing you will have a commented version of 
DATAB.BA.

The other DATAbee programs are not as large, so the comment lines are 
included in them. These lines can be deleted if you want to reduce the
size of these programs.

DATAB.BA itself is broken into modules which are all called with GOSUB
statements beginning at the dot prompt command input routine (line 48)
. Except for a couple of instances necessary to save a few bytes of 
code, GOTO statements used in DATAB.BA, operate within the modules and
do not branch outside them.

A standard line input routine beginning at line 81 is called by many 
of the modules. This routine allows the calling module to set a flag 
for reverse video and to establish the screen position and length of 
the input field.

The random access read and write modules are at lines 36 and 42. When 
reading, the program sets a variable pointer (VARPTR) to the position 
and length of the data field within the .DO file. Reads, therefore, 
are almost instantaneous. You cannot write data to memory with this 
VARPTR technique so DATAB.BA pokes data into the proper positions in 
the .DO file. This is why writes are slower than reads although this 
really isn't noticeable except with long field lengths.

The other DATAbee programs all use the same basic modules which have 
been taken directly from DATAB.BA. Line numbers in all the programs 
are structured in such a way that, with minor modifications, they all 
could be merged into a single large program, appropriate commands 
added, and the complete system put on a ROM chip as a single program 
or maybe work something out with a Gold Card.

There are a lot of possibilities for expanding this system. A full 
report generator and a dBase-like programming language would be neat. 
Disk-based systems are possible but each would have to be specific to 
the type of DOS used. In fact, my original test versions of DATAbee 
were based on random reads and writes using full sectors under Powr-
DOS. I decided on the RAM version on the belief that it would appeal 
to a broader audience.

I hope I've gotten all of the major bugs out of this system but, with 
anything this large, there's always something you miss. Please let me 
know of any bugs or inconveniences so that I can issue updates as 
necessary and as my time permits.


Howard Sprow
73625-365

