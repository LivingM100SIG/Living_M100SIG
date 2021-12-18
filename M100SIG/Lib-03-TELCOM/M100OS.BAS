Model 100 <-> OS/2 Interface
by
Arthur Tyde
(C)opyright 1990

Registration fee is $20.00, which entitles you to updates and additional
software features.  Support shareware by sending me two sawbucks.

1020 Raleigh #2006
Carrollton, TX 75007

*---------------------------*     *-----------------------*

Users,

I hope you find the OS/2 to Model 100 interface useful.  This version 
supports .DO files only.  The full version that supports all filetypes
AND allows you to hook the Tandy Disk Drive up to a PC serial port is
availalable to all users who register their copy of this software.

A new version is also in the works that will support remote attach sessions
via the Model 100 built in modem.



The commands are simple.  Here are some examples.

      Model 100    Full PC filename
      |            |
SEND TEXT.DO TO A:TEXT.TXT
Sends the TEXT.DO file to the PC's drive A: as TEXT.TXT

MOVE TEXT.DO TO C:/MODEL100/TEXT.TXT
Moves the TEXT.DO file to the PC's C: hard disk's MODEL100 subdirectory
as TEXT.TXT

RECEIVE LETTER.DO FROM A:LETTER.TXT
Receives the LETTER.DO file from the PC file on drive A: called LETTER.TXT.

PRINT LETTER.DO
Send's the LETTER.DO file on the Model 100 to the PC's LPT1: attached
printer.

FILES
Shows the files on the Model 100.

DIR A:
Sends a file containing the PC A: disk directory to the Model 100 as
PCDIR.DO.

BYE
Terminates the PS100.BA and M100.CMD programs.


Here's the REXX code for OS/2 Extended Edition.  Cut this out of this
document and save it as M100.CMD

---------------------------------------------------------------------------

/*
PS/2<->Model 100 OS/2 System Interface
(C)opyright 1990 by A, Tyde
This program is shareware, if you find it useful please send
a $20.00 fee to Art Tyde, 1020 Raleigh #2006, Carrollton TX 75007.
This will entitle you to full documentation, licence, and updates.
*/

parse upper arg option

call task_setup
call communications
exit

task_setup:
rc=0
cr=d2c(13)
crlf=d2c(13)||d2c(10)
return

communications:
comcommand='@MODE COM2:9600,E,8,1,TO=OFF,XON=OFF,IDSR=OFF,ODSR=OFF,OCTS=ON,DTR=ON,RTS=ON'
comcommand
port=substr(comcommand,7,4)
call lineout port,'+'||cr
reply=strip(linein(port),'B','00'x)
if reply='-' & option='SEE' then say '-> Connected...'

do forever
   parse upper value strip(linein(port),'B','00'x) with reply
   if reply='' then call lineout port,'>OK:' /* cycle input port on Mod 100 */
   if left(reply,3)='BYE' then do
      if option='SEE'then say '-> BYE command processed.'
      exit
   end
   if left(reply,4)='SEND' | left(reply,4)='MOVE' then do
      parse upper value reply with var1' 'var2 ' TO ' var3
      var3=translate(var3,'\','/')
      cmdd=1
      if var1='MOVE' then cmdd=2
      if option='SEE' then say '-> 'var1' command processing.'
      call receive
   end
   if left(reply,5)='PRINT' then do
      parse upper value reply with var1' 'var2
      var3='PRNFILE.TXT'
      cmdd=1
      if option='SEE' then say '-> 'var1' command processing.'
      call receive
      'DETACH PRINT 'VAR3
      if option='SEE' then say '-> Print job 'var3' detached.'
   end
   if left(reply,7)='RECEIVE' then do
      parse upper value reply with var1' 'var2 ' FROM ' var3
      var3=translate(var3,'\','/')
      cmdd=3
      if option='SEE' then say '-> RECEIVE command processing.'
      call send
   end
   if left(reply,3)='DIR' then do
      dirm=''
      parse upper value reply with var1 dirm
      dirm=translate(dirm,'\','/')
      var3='PCDIR.DO'
      var2=var3
      cmdd=3
      '@DIR 'dirm' >'var3
      if option='SEE' then say '-> DIR command processing.'
      call send
   end
   if left(reply,5)='FILES' then do
      cmdd=4
      call lineout port,cmdd||cr
      if option='SEE' then say '-> FILES command processed.'
   end
end
return

receive: /* Mod 100 command is send, lets receive */
rc=lineout(port,cmdd||cr||var2||cr)  /* issue command to M100 */
if option='SEE' then say '-> Receiving: 'var2
reply=''
line=''
do until line='FF'x
     line=translate(strip(linein(port),'B','00'x),'0D0A'x,'FEFD'x)
     reply=reply||line
end
call lineout var3,reply /* write the file */
call lineout var3,'' /* close the file */
var1=''
if option='SEE' then say '-> Saved as: 'var3
return

send: /* Mod 100 command is receive, lets send */
line=charin(var3,1,32768) /* load the file into memory (32K Max) */
temp=var2||','length(line)
if option='SEE' then say '-> Transmitting: 'var2', length ('length(line)').'
call lineout port,cmdd||cr||temp||cr /* issue command to M100 */
do i=1 to length(line)
     call charout port,substr(line,i,1)
     if pos('.',(i/10))=0 then do
        temp=strip(linein(port),'B','00'x)
        if temp\='FF'x then leave
     end
end
return


----------------------------------------------------------------------------
Following is the program you need to download to the Model 100 using the
TELCOM program, load it into BASIC and save it as PS100.BA.


----------------------------------------------------------------------------


10 CLEAR1024:MAXFILES=3:CLS:DEFSTRA-C:B="COM:88E1E":PRINT"<->":PRINT:DEFINTI-K
40 GOSUB400:INPUT#1,A:IFA="+"THENPRINT#2,"-":BEEP:CLS:PRINT"<+>":ELSEMENU
50 GOSUB400:J=0:I=J:LINEINPUT":";A:PRINT#2,A:IFA="BYE"ORA="bye"THENMENU
55 LINEINPUT#1,A:IF A=""THEN55ELSEONVAL(A)GOSUB100,100,300,70
60 GOTO50
70 FILES:RETURN
100 IFA="2"THENJ=1
104 INPUT#1,A:IFA=""THEN100ELSEPRINT">PC:";A:OPENAFORINPUTAS3
110 GOSUB412
220 RETURN
300 INPUT#1,A,K:IFA=""THEN300ELSEPRINT"<PC:";A;K:OPENAFOROUTPUTAS3
310 IFI>=KTHEN320ELSEI=I+1:C=INPUT$(1,1):PRINT#3,C;
315 IF(I/10)=INT(I/10)THENKEY7,MID$(STR$(I),2,LEN(STR$(I))-1):PRINT#2,CHR$(255)
316 GOTO310
320 PRINT">OK:";I:GOSUB400:PRINT#2,CHR$(255)CHR$(13):I=0:RETURN
400 CLOSE:OPENBFORINPUTAS1:OPENBFOROUTPUTAS2:RETURN
412 IFEOF(3)THEN419ELSEC=INPUT$(1,3)
416 IFC=CHR$(13)THENC=CHR$(254)ELSEIFC=CHR$(10)THENC=CHR$(253)
417 PRINT#2,C:GOTO412
419 PRINT#2,CHR$(255):PRINT">OK";:C="":IFJ=1THENKILLA:PRINT"!":GOSUB400:ELSEPRINT"."
420 CLOSE#3:RETURN

-------------------------------------------------------------------------------

For updates and new software, when available, send $20.00 to Art Tyde, 
1020 Raleigh #2006, Carrollton TX 75007.  I'd also like to hear from Model
100 and OS/2 users.  Give me a call at 214-394-6486.

Use a null modem cable to connect your PC directly to the Model 100.

To operate the system, run the PS100.BA program on your Model 100.  You
will see a <-> in the upper left had corner on the screen.  Then execute
the M100 exec on the PS/2.  You can use the option see, ie. M100 SEE to
view the program processing.  If you wish to detach M100 as a background 
task so you can file transfer in the PS/2 background execute the
command DETACH M100.  The SEE option is not compatible with the DETACH
command unless you enter DETACH M100 >OUTPUT.TXT, which will write the
screen messages from the background M100 task to the OUTPUT.TXT file.

When the PC connects with the Model 100, the <-> will change to a <+>
and you can enter any of the commands listed above.  
                                                                   