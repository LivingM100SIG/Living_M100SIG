    I own an A&J System 100 and am quite satisfied with it.  Until
recently, its major drawback as far as I was concerned was its inability
to function at the same time as TMPC, which I use constantly.

    I had been able to limp along by using TMPC's FUTIL utility to load
TMPC, work with it, then save TMPC, then load the System 100 Operating 
System to save and load files, then save the operating system, then load
TMPC, etc.  No more.

     A&J has set up a utility on their BBS to allow relocation of their
OS so that it may co-exist with other ML programs.  I now have both the 
microdrive and TMPC on-line and  available instantly.  It's great.

     If you would like to have them co-exist on your 100, do the following:

1)  Save all of your files to wafer.
2)  Type in or load A&J's BBS program.
3)  Disable your OS (RUN"X:D")
4)  Clear all files & memory except the A&J BBS program.
5)  CLEAR 200,47000
6)  Invoke TELCOM.
7)  Set M7I1E,10
8)  CALL 14087326464<=^C>
9)  Give your unit's serial number
10) Go to the <R>elocate section
11) Set 47000 when asked for location
12) Exit the BBS
13) Run the A&J BBS program
14) Save the new OS to RAM
    Note: I use the name "SYS2" to avoid confusion.
    (SAVEM"SYS2",47000,51096,47000)
15) CALL 47000 - your OS is operative
16) Save the new OS to cassette twice!
    (SAVEM"CAS:SYS2",47000,51096,47000)
17) Load the TMPC.BA call-up program & save in memory
18) Load TMPC main program
19) KILL the A&J BBS program
20) Return tp MENU 

     You're all set.  To enter TMPC,  just run the TMPC.BA program from MENU.

ENJOY!

Jerry
