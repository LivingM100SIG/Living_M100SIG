                          Documentation for ALARM.BA
                              by Andrew McDonald
                          --------------------------
     This is the documention file for ALARM.BA.  This is a very small program
that you can keep in your computer all the time, so it is perfect for people
on the road who don't want to carry an alarm clock and don't like hotel wake-
up calls.  The program takes up 352 bytes(287 with line 0 removed).  Please
do not distribute copies without line 0 in them.
     ALARM.BA features a controllable  snooze time as well as a "maximum time"
feature.  The maximum time disables the snooze to help you realize that it is
time to get up.  This is really great for those people who like to hit snooze
all day.
     To use, simply run ALARM.BA and answer the following prompt:
             A,M,S?
     This prompt is simple to save space.  A is alarm time in the form
HHMM where H is hours and M is minutes. Do not use a colon!  M is for maximum
time and is entered the in the same form.  S is snooze time in minutes.
Put commas between the numbers and press enter when done.
     The display will then clear and show the current time and the number of
seconds until the alarm goes off.  The number of seconds is mainly for novelty
and can be changed in line 3.  Change PRINT@173,TIME$,L to PRINT@176,TIME$.
This will also result in a 2 byte reduction in the size of the program.
     At the alarm time,  the computer will start beeping.  To turn off the
beep for the snooze time, hit any key.
     When the maximum time is reached, the alarm will go off again but the
snooze function will be disabled.  This will remind you it is absolutely time
to get up.
     To silence the computer for good, just hit control-C or SHIFT-BREAK.
     Also, unless you wish to replace the batteries very quickly, it is a
good idea to use the AC adapter. Running this program for 8 hours could
half kill a set of batteries.
     Hope you enjoy using this program. I welcome any suggestions or questions.
            Andrew McDonald
            Custom Software Systems
            CIS 76672,650
