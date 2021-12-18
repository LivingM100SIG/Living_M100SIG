DATAbee DATABASE SYSTEM FOR THE MODEL 100/102

Reference Manual

9/7/88

Copyright Howard H. Sprow 1988


TABLE OF CONTENTS:

Chapter   Subject

  1       GENERAL OVERVIEW
  2       DATABEE FEATURES
  3       CREATING A DATABASE FILE STRUCTURE
  4       CHANGING THE STRUCTURE OF A DATABASE FILE
  5       SUMMARY OF DATAB.BA COMMANDS
  6       COMMAND MENU
  7       FILE STRUCTURE AND RANDOM ACCESS
  8       DATABEE SCREEN FORMAT
  9       ACTIVATING A DATABASE FILE
  10      ADDING NEW RECORDS AND EDITING EXISTING RECORDS
  11      DELETING RECORDS
  12      VIEWING RECORDS
  13      FINDING RECORDS
  14      PRINTING RECORDS AND REPORTS
  15      SUM, COUNT AND AVERAGE
  16      SORTING
  17      PRINTING LABELS
  18      MOVING BETWEEN DATABEE AND DBASE
  19      ERROR CHECKING
  20      SOME BASIC TECHNICAL INFORMATION


CHAPTER 1. SUMMARY OF DATAB.BA COMMANDS

APPEND - adds record to end of database (See Ch. 10)

ASSIST - activates command menu (See Ch. 6)

AVERAGE - computes average of numeric field for all records which 
match specified criteria (See Ch. 14,15)

CONT - used in conjunction with LOCATE command to find next record 
which matches criteria (See Ch. 13)

COUNT - counts number of records which match specified criteria (See 
Ch. 14,15)

DIR - displays M100/102 RAM files

DISPLAY - displays current record data (See Ch. 12,14)

DISPLAY STRUCTURE - displays structure of database fields (See Ch. 14)


FILES - displays M100/102 RAM files

EDIT <record number> - changes record data (See Ch. 10)

GO <record number> - moves record pointer. The word, GO, is optional. 
(See Ch. 6,12)

LIST - displays data for records which match specified criteria in 
column format (See Ch. 12,14)

LOCATE - finds record(s) which match specified criteria (See Ch. 13)

MENU - returns to M100/102 main menu

QUIT - returns to M100/102 main menu

SUM - computes total of numeric field for all records which match 
specified criteria (See Ch. 14,15)

USE - opens database file (Note: File must be first created with 
BEEFIL.BA) (See Ch. 9)

? - outputs blank line to printer (See Ch. 14)


CHAPTER 2. GENERAL OVERVIEW:

DATAbee is a complete database system which is a work-alike version of
dBase III+ For the Model 100/102. It uses a simple dBase III+ Command 
set and a similar screen format to create and manipulate single file 
databases. DATAbee files are maintained in RAM as standard .DO files 
and are read and written in a random access manner. DATAbee files can 
be converted to dBase III+ Files on a PC and vice versa.

DATAbee consists of the following BASIC programs and text files:

  DATAB.BA  -  the main program module which provides record
               appending, editing, searching and output
               capabilities

  BEEFIL.BA  -  creates and changes the structure of
                database files

  BEEAPP.BA  -  reads and writes comma-delimited ASCII files
                to/from DATAbee files which allows you to
                move records and whole database files
                directly between DATAbee and dBase on a PC

  BEESRT.BA  -  sorts a DATAbee file on any key field

  BEELBL.BA  -  prints labels from a DATAbee database

  BEEREM.DO  -  comment lines for DATAB.BA

  BEEDO1.DO -  part 1 of reference manual

  BEEDO2.DO -  part 2 of reference manual

DATAbee operates from commands entered on a command line like dBase or
from a pull-down menu of commands. After you enter a basic command, a 
series of prompts are provided in DATAbee to guide you through the 
options.

Each of the 6 DATAbee program modules is a stand alone program so you 
only have to keep in memory the modules you will need to work with. 
The largest module is DATAB.BA at about 7000 bytes. With a 32K system 
and some type of DOS in memory this will leave you about 20K for a 
database file which actually can handle a surprising amount of data.


CHAPTER 3. DATABEE FEATURES:

- Command structure similar to dBase III+
- Read and write comma-delimited ASCII files to move data
   to/from dBase on a PC.
- Single file database system
- Fast random access reading and writing of records.
- Number of records limited only by available RAM.
- Up to 15 fields per record.
- Character, numeric and date field types supported.
- Pull-down menu of commands
- Locate, list and printout records based on data
   in a key field. <,>,=,<> criteria are supported.
- Sum/count/average based on key field criteria.
- Sorting on one key field.
- Print labels based on key field criteria.
- Structure of database can be changed at any time after it
   is created. Records are updated automatically to
   fit new structure.
- Output of operations can be directed to any device.
- Automatic right justification in numeric fields.
- Cursor key recall of past commands entered.


CHAPTER 4. CREATING A DATABASE FILE STRUCTURE:

As in dBase, before you can enter records to a database you must first
define the structure of that database. In DATAbee this is done by 
running BEEFIL.BA which operates much like dBase's CREATE DATABASE 
command.

The program prompts you for the name of a database file stored in RAM.
It is not necessary to enter the .DO extension. Upper or lower case 
characters may be used. If no file by that name exists, DATAbee 
assumes you want to create a new file. The CREATE STRUCTURE screen is 
then presented. This works basically the same as dBase except that you
must manually move the cursor from one field to the next. Again, 
memory limitations made this necessary.

A database consists of records which are comprised of fields of data. 
DATAbee supports 3 types of fields - character fields, numeric fields 
and date fields. dBase logic and memo field types are not supported.

For each field you create, you must define its name, type and length. 
Do this by entering the appropriate data under the column headings. 
You should manually insure that no two field names are the same. For 
the type column, you need only enter "C","N", or "D" as the first 
letter. When you move to the next field, DATAbee automatically fills 
in the rest of the full type description. Field lengths can be no 
greater that 78 positions. For numeric field lengths, be sure to leave
room for a decimal point and any required decimal places. Unlike 
dBase, in DATAbee you must manually deal with decimal positions within
a field. For date fields, DATAbee automatically sets the field length 
to 10 which allows dates to be entered as "01/01/1988" or "01/01/88". 
For compatibility with dBase III+, you must use one of these formats 
or leave the field blank.

After you have defined the field, press ENTER. The entry will be 
checked and you will get a beep if something is wrong. Once the entry 
is accepted, the cursor will move down to the line for the next field.
Note that unlike dBase if you press an up or down cursor key, the 
current field entry will be abandoned. Only ENTER will accept an 
entry. You can, of course, use the cursor keys to move back to 
previous lines to make changes.

When you have entered data for all fields (up to 15), press CTRL (with
the CAPS LOCK key up!) to create a new database file and return to the
M100/102 main menu. If you look at the file you will see that, at this
point, it contains no records, only the field definitions. See the 
section below on file structure.


CHAPTER 5. CHANGING THE STRUCTURE OF A DATABASE FILE:

It is inevitable that, after you begin working with a database, you 
will want to change its structure in some way. DATAbee can handle the 
following types of changes to a database by using the BEEFIL.BA 
program.

      - change field name
      - change field length
      - add new field(s)
      - delete field(s)

You cannot change a field type or move the position of a field in the 
sequence of fields.

Run BEEFIL.BA and enter the name of the database file in RAM to be 
changed. Then enter any desired changes to field names or lengths. To 
add a field, just include it at the end of the list of fields. To 
delete a field, change the name for that field to "DELETE". Press CTRL
and DATAbee will create a new file with your new structure. All of 
your old records will be automatically updated to fit the new 
structure.

SOME IMPORTANT CONSIDERATIONS. BEEFIL.BA must output the new file to a
device, not RAM. A RAM file name will not be accepted for the output 
file. If you reduce the size of a field, BEEFIL.BA will truncate 
characters in that field from the right for character fields and from 
the left for numeric fields. Be careful, but if you do goof, you're 
still safe since the original file is left unchanged.


CHAPTER 6. COMMAND MENU:

dBase III+ Has a pull-down menu system called the "Assistant" which is
especially helpful to new users in navigating the system. DATAbee 
includes a simple version of this feature which has two types of 
menus.

1) Entering ASSIST at the dot prompt calls the main command menu. Move
the cursor to the desired command and press ENTER. For the commands, 
USE, EDIT and GO, the command is displayed at the dot and the cursor 
is positioned for you to enter the file name (for USE) or a record 
number (for EDIT and GO). For all other commands, you are taken 
directly to the prompts for the required parameters.

2) A menu of field numbers and names is displayed whenever a command 
asks you to select a field (by number). This makes it easy to identify
fields by number. In dBase III+, you would enter the full field name. 
Using field numbers, not names, in DATAbee saved program space.


CHAPTER 7. FILE STRUCTURE AND RANDOM ACCESS:

If you look at a DATAbee file after you have added some records you 
will see that it is a standard .DO file made up of two sections 
separated by CHR$(255), the checkerboard symbol, on a line by itself. 
The first section consists of the definitions of the fields. These are
the same lines you created with BEEFIL.BA. In fact you can create a 
new database file in TEXT without BEEFIL.BA if you maintain the 
correct structure for each line. You cannot change records in a live 
database this way, though, unless you want to manually try to adjust 
the structure of every record line.

The second section holds the record data. The data for each record is 
terminated by a carriage return/line feed. Even though it adds 2 bytes
per record, it was decided to use this method rather than running all 
records together with no separator, because only in this way can you 
work easily, directly on the .DO file in TEXT if you have to. See the 
chapter on deleting records.

DATAbee actually reads and writes records to the .DO file in random 
access so it is very quick for you to move the record pointer to any 
record and then view or rewrite it. To do this, DATAbee first 
calculates the position of the file in RAM and then determines the 
offset of each record from the start of the file. It is thus critical 
that the RAM position of the file, or directory pointers to it, not 
change as a result of any DATAbee operation. This is why some 
operations require that an output be to a device other than RAM.

