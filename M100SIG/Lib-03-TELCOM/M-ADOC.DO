	I have been successful in developing a procedure which allows me to 
create files on the M100 and upload them into my Apple II as text files for use 
with the Apple-Writer II word processor.  I have developed three programs which 
combine on one disc to make an auto-boot systems for the Apple.  Here's how it 
works.
	Program number one (HELLO.M-A) is used as the boot program on the disk. 
It instructs the user and also sets up the pointers to allow room for the 
machine language programa which converts the machine language ("B") files into 
text ("T") files.
	Program number two (M-A.BA) is the program which receives the uploaded 
file from the M100 and stores it on the disk as a "B" file. It also loads 
program number three (B-TCON.BIN) which is a machine language file which does 
the "B" to "T" conversion.  The converter program looks for a "B file called <
INPUT> and converts it into a "T" file called <OUTPUT>.  Program two then 
renames the <OUTPUT> file as defined by user.
	Note that program number two sets HIMEM:4095, to provide maximum file 
room.  This will permit a file length to be uploaded which just about fills the 
total memory of the M100.
	For details, program two is a variant of the the upload program 
contained in the November 83 issue of CALL -APPLE, page 56, while the machine 
language program is a variant of an example program contained in the appendix of
the book "Beneath Apple DOS".  These publications should be consulted for in 
depth information.
	I am using the CCS 7710A serial card at 600 baud. The RS232 cable is a 
straight, pin-for-pin cable with no transistions. (Pin one to pine one, etc.)
	Let me hear if all this works for you.
	David P. Allen [70310,355]

