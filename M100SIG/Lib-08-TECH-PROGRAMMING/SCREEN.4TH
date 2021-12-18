 3 
******** fig-FORTH Model ********
 
   Through the courtesy of
 
   FORTH Interest Group
   P. O. Box 1105
   San Carlos, CA  94070
 
Release 1 with Compiler Security & Variable Length Names
 
 
TRS-80 Model 100 version by
   Michael Weiblen  CIS: 72506,2072
   Version 1.1D   20 Feb 1986
 
Further distribution must include the above credit notice
 4 
( Error Messages )
Stack is empty
Dictionary is full
has incorrect address mode
isn't unique
 
Sector out of range
Stack is full
Disc Error!
 
 
 
 
 
 
Model 100 fig-FORTH v1.1D
 5 
( More Error Messages )
Compilation Only; Use in definition
Execution Only
Conditionals not paired
Definition not finished
in protected dictionary
Use only when loading
Off current editing screen
Declare vocabulary
 
 
 
 
 
 
 
 6 
( More FORTH words: TEXT 2SWAP WHERE CLS )
 
: TEXT   ( Accept following text into PAD )
     HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
 
: 2SWAP    ( Put second double number on top of stack )
      ROT >R ROT R> ;
 
: WHERE  ( Print screen# & image of a LOAD error )
     DUP B/SCR / DUP SCR ! ." Scr #" DECIMAL .
     SWAP C/L /MOD C/L * ROT BLOCK + CR C/L TYPE
     CR HERE C@ - SPACES 94 EMIT QUIT ;
 
: CLS    ( Clear screen )
     12 EMIT ;
 
 7 
( More FORTH words: DEPTH .S )
 
: DEPTH  ( Return the # of items on stack )
    S0 @ SP@ - 2 / 1 - ;
 
: .S     ( Non-destructive stack display )
       DEPTH IF SP@ 2 - S0 @ 2 - DO I @ . -2 +LOOP
       ELSE ." Stack empty" THEN CR ;
 
 
 
 
 
 
 
 
