     Date: Feb 16,1987, TYPE II.DO          Page 4



     This is the second section of the TYPE II documentation explaining the
     extra features and customization of the C-TYPE version of the program.
     The first three pages dealing with the standard features of both C-
     TYPE and X-TYPE is in DL2 as XTYPE2.DO.

     ====================
     The 'ESC' Selections
     ====================

     The extra features of C-TYPE are activated by pressing the 'ESC' key.
     This brings up an additional menu on the message line at the top of
     the screen. The display will be in inverse and will look like this...

     DEL He Qk Ti Up Vw XY0 (1-9)

     (DEL)ete

     Pressing the delete key allows you to select a number of characters to
     delete. You can select from 1-9 characters for deletion. This works
     like the TAB feature and deletes the characters immediately after the
     keypress.

     (He)ading

     Pressing 'H' will insert the heading defined in line 103 into the edit
     line. It may then be sent to the printer or edited as desired. As
     uploaded the program contains my own CIS header. Edit this program
     line for the heading that you desire.

     (Qk) Quick Calc

     Pressing 'Q' brings up the calculator. It is a reverse polish
     calculator with an X and Y register. The function keys display the
     various functions. F8 returns you to the line editor screen. The
     delete key works as usual. You may display up to 5 decimal places and
     the values will appear formatted with commas when necessary.

     The calculator retains its values in the X and Y registers after
     exiting back to the typewriter. To display the value of either
     register from the editor use the 'ESC' key followed by 'X' or 'Y'. The
     value of the selected register appears on the line under the edit
     line. This is the way I figure tax and extensions to produce invoices
     for my business and was a major reason for including the calculator.

     (Ti)me

     Sends the time/date line to the editor. It may then be printed or
     edited as desired. Hitting 'ESC' then 'DEL' then '9' will quickly kill
     the second portion of the display.

     (Up) Up page

     This selection allows you to send blank lines to the printer. Specify









     Date: Feb 16,1987, TYPE II.DO          Page 5



     the number of lines and press ENTER. Your last selection will become
     the default. ENTER a '0' to exit with no lines being sent to the
     output. The initial default is '4' lines.

     (Vw) View

     Sends the first 33 characters of the last typed entry to the line
     above the edit line. This is similar to the context line except the
     context line contains the last 33 characters of the same line. This
     simple feature allows you to easily align the first 33 cols of your
     new line with the previous line. It also supplies context for the
     descriptive format mode displayed at the end of this doc.

     (1-9)

     Selects automated formats. These selections can be edited to values of
     your choosing but I have already defined the first five selections for
     your use in formatting or as examples.

     To select your own formats for these keys you need only remember to
     create the line as follows:

     Define the desired left margin as 'Z'.
     Define the desired right margin as 'R'.
     Define the desired out/indent as 'O".
     Define any desired printer codes to be sent prior to the next line as
     'PR$'.
     Define a new line count (if needed) as 'L'.
     Define a prompt of up to 37 characters to be sent to the prompt line
     above the editor as 'FM$'.
     Branch back to line 19 with a GOTO.

     i.e. To set the elite type on an NEC printer, reset the margins for
     elite and prompt the user about the change the line would be:

     ### Z=12:R=84:PR$=E$+"E":FM$=" Elite/margins reset":GOTO19

     Where ### represents the line number. The 'E$' in the above example is
     globally defined in the program as the escape character - CHR$(27).
     Use this to advantage in building your print strings since they will
     frequently require the escape character.

     After defining this line you can press, in quick succession if you
     wish, 'ESC' then the number key you defined the macro to and all of
     the line parameters will adjust to the new format and you will be
     prompted about the change. This macro can be called at any time. Any
     line that you have in the editor will remain unchanged but will format
     to the new values.

     That's all there is to it!

     I have pre-defined the first five keys as follows:










     Date: Feb 16,1987, TYPE II.DO          Page 6



     1 - Resets the original default formats (5-75).
         Prompt = Default
     2 - Sets the margins for indent on each side (10-70).
         Prompt = Indents set
     3 - Outdents three from the default format. This is commonly used when
     numbering or lettering entries.
         Prompt = Default, outdent 3
     4 - A descriptive mode that has the left margin set at 30 and a 25
     character outdent. Used for creating the format shown at the end of
     this document. This format is commonly used in resumes and is almost
     impossible to produce with traditional text formatters. Use the View
     option to keep context for the text description on the left of the
     main paragraph.
         Prompt = Description
     5 - Rolodex card format. This is the format I use to type in my own
     rolodex cards. I include it as a display of setting all of the
     parameters, including the line count.
         Prompt = Rolodex card

     These and other lines that you might want to change to your own
     settings are located at 92 to 102. At the present time keys 5-9 simply
     return back to the editor. Using this method it will be easy to
     customize the program to your printer and to your particular
     formatting needs.

     ==========================
     Programming the Calculator
     ==========================

     Although the calculator displays only the X and Y registers it also
     has two memory registers. These are program values M1 and M2. The
     values in these registers are 'pushed' in by the X and Y registers. As
     an example entering consecutive values of 3, 12, .11, and 4,000 into
     the X register will result in the following contents of the four
     registers:

     M2=3, M1=12, Y=0.11, and X=4,000.

     Using this feature in combination with the macro feature allows you to
     'program' the calculator for frequent operations. I have defined the
     'ESC' then '0' combination to produce a mortgage payment calculation.
     Just enter the variables to the X register in the following order:

     1 - Years to pay
     2 - # of compounding periods
     3 - Interest rate (as a fraction)
     4 - Amount of mortgage

     Pressing ENTER after each entry will 'push' the values up from X to
     the succeeding registers. Do not press ENTER after the last entry
     since that will alter the entries. Simply exit to the line editor
     screen with F8 and press 'ESC' followed by '0'. The payment amount
     will appear on the prompt line. To see how this is done just examine









     Date: Feb 16,1987, TYPE II.DO          Page 7



     line 102. For your own formulas the variable 'T' may be safely used to
     hold the results since it is not used elsewhere in the program.

     I debated whether to include this feature in the SIG version due to
     the additional complication but I decided to leave it in since folks
     in some common personal businesses, such as real estate, may find it
     useful.

     One final note about customizing C-TYPE. The version name that appears
     in the line editor may be changed by editing 'VR$' in line 3. Use 8
     characters or less. This helps if you have versions for different
     printers. As uploaded 'VR$' = -ronnie-. You can also send the printer
     an initialization string, as in X-TYPE, by defining 'PR$' in line 3.
     It is uploaded as a null string.

     ==================
     About the programs
     ==================

     These programs have proved very useful to me in my business and
     personal correspondence. I have a fine commercial text formatter on
     ROM that is preferable for jobs such as this documentation but it was
     the desire for a simpler method of quick editing that caused me to
     write these programs in the first place. It soon became evident that
     for some tasks and formats these programs were superior to any form of
     text formatter that I have experienced.

     These programs are offered to the members of the M100 SIG on CIS in
     thanks for the many fine programs that I have gotten there. I have
     made every attempt to make these versions easy to use and to modify,
     and to trap out possible errors as much as possible. In this respect
     TYPE II is designed as much for what it won't do as for what it does.
     The user base I designed for was myself, for both business and
     personal needs, my wife, who is a fine typist with no computer
     experience, and my kids, ages 6 and down (letters to Santa etc). It is
     possible for a rank beginner and computer phobe using these programs
     to hunt and peck a literate letter without the need to know special
     editor commands and other computer trivia and terminology.

     The versions that I use most often include an automatic word wrap,
     expert user commands, RAM/disk merge for boilerplate, and a provision
     for imbedded commands such as underlining or italics. There is no
     simple way to do imbedded commands for all printers since it requires
     the individual command codes to be inserted before sending to the
     output. If you want a complete version customized to your printer send
     $15.00 and your printer specs to:

     Ronnie Riche
     1700 Aycock St.
     Arabi, LA  70032

     In addition to a complete customized version for your printer I will
     include the rest of the package, including versions for Epson and NEC









     Date: Feb 16,1987, TYPE II.DO          Page 8



     compatible printers and a more complete documentation.

     Whatever versions you decide to use I hope you get as much use from
     these programs as I have.

     Good luck...

     -ronnie-

     ps. This is the segment of descriptive mode text mentioned earlier in
     the doc. This format is next to impossible to produce using
     traditional text formatters.

     X-TYPE                   A simple version of TYPE II that includes
     ======                   the most needed features in an electronic
                              typewriter. This is the best version to use
     A simple                 for simple typing tasks, such as preparing
     typewriter program.      index or rolodex cards or the addressing of
                              envelopes.

     C-TYPE                   A far more powerful version of TYPE II that
     ======                   features an interactive calculator and the
                              use of 'macro' formatting commands. C-TYPE
     A powerful and           can be easily customized by just about any-
     flexible typewriter      one to use the special printer features.
     with calculator.         The calculator and the macros are also user
                              programmable.




































