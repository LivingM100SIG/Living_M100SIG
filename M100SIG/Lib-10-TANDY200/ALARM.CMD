     ALARM.CMD  operating instructions
     Copyright (c) 1989 by Paul Globman
     ==================================

ALARM.CO is designed to place a properly formatted entry into the Tandy 200's 
NOTE.DO file to facilitate the setting of the Tandy 200's alarm feature.

ALARM.CO will prompt you for DATE, TIME and MEMO.  The program will then place
that info into the NOTE.DO file.  This will only work in Bank #1 of the Tandy
200, since NOTE.DO cannot exist in Bank #2 or Bank #3.

Each new entry will be inserted at the TOP of the NOTE.DO file, rather than 
appended to the end of the file.  ALARM jumps to NOTE.DO after the entry is 
completed.  Upon exit from NOTE.DO the Tandy 200 alarm will be set.

DATE: You will be prompted to enter "mm/dd/yy" and you have several options.

  1) press ENTER for today's DATE.
  2) enter "mm/dd" (month/day) and current year will be inserted for you.
  3) enter "mm/dd/yy" for any month/day/year.
  4) press ^C  (control C) to abort and return to the calling program or menu.

TIME: You will be prompted to enter "hh:mm".  The "seconds" will be set to
":00" and will be inserted for you.  You can press ^C to abort at this prompt.

MEMO: You will be prompted to enter a memo, which the Tandy 200 will display
when the alarm is triggered.  The alarm feature will display up to 40 chrs.  If
you enter more characters than the LCD displays, the entire memo will be 
stored in NOTE.DO.  You can abort at the Memo prompt with ^C.

Once the memo is is entered you will go directly into NOTE.DO.  Press F8 to 
return to the menu.

ALARM.CO can be used as an XOS "command" module and will execute at the menu.
If stored in Bank #3 it can be executed in Bank #1 with the F3(Cmd) key and 
user input is taken on the bottom line of the menu (the input of the memo will
not scroll to display the full input if the memo exceeds the width of the LCD).

ALARM.CO will work equally as well without XOS by placing the cursor over
ALARM.CO, or by RUNM"ALARM" from a BASIC program.  If the input is aborted then
ALARM will return to the BASIC program (or menu).  If the alarm input is 
completed then the BASIC program will jump to NOTE.DO and not return to the 
calling program.

XOS-C users are reminded that the widebar cursor must NOT be over BASIC
to execute a CO file, and ALARM.CO can be renamed A.CO (or CMD>.CO is F3 with
CAPS LOCK is used for a dedicated function key).  Use ALARM.CMD in 
conjunction with MEMO.CMD for appointment and memo management.

Additional details about setting alarms is found in on page 22 of the Tandy 200
owners manual.

Use HXFER.200 to convert the following hex file to a CO file.

54F8F40054F8210CF9CD17353E073207EFCDF654D878FE01CCE9F8FE06CCDAF8FE00CA7BF8FE09C254F8CDE0F8211DF9CD17353E073207EFCDF654D878FE06C2
7BF82305113CF9EBCDBA41212BF9CD1735CDF654D878FE01CA99F823480C051147F9EBCDBA413E14814FC5360D23360ACD4F2DCDBA41CD7C2DC1CDA882DAD232
411133F9E5CDBA41E1C31B73CDE0F8C3FBF823051133F9EBC3BA412119F21137F9CD01F9211BF21134F9CD01F9211DF2113AF9CD06F9231B7EC63012AFC94461
74653A206D6D2F64642F79791B4B0054696D653A2068683A6D6D1B4B004D656D6F3A1B4B006D6D2F64642F79792C68683A6D6D3A30302C412C00

