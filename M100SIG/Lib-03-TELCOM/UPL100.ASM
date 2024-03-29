                   UPL100 ;********************************************************
 ;UPL100 by Morris Jones
 ;********************************************************
 ;
 ; Upload support for the Model 100 and other XON/XOFF
 ; terminals or terminal emulators.
 ;
 ; Copyright (C) 1983 Morris Jones
 ; Permission granted to copy for non-commercial use.
 ; Credit to the original author should remain in the
 ; program.  Please submit revised versions to the author.
 ;Morris Jones
 ;PO Box 641
 ;Forest Knolls, CA  94933
 ;
 VERSEQU'1'
 REVEQU'0'
 ;
 ; Jul 29 83File created
 ; Aug  1 83Initial release
 ;
 ;Equates
 TOPMEMEQU6FFFH;TOP MEMORY UNDER BASIC
 WRBYTEEQU001BH;WRITE BYTE TO FILE
 OPENWREQU4420H;OPEN FILE
 CMDLINEQU4318H;COMMAND LINE BUFFER
 BOOTEQU402DH;SYSTEM WARMBOOT
 CLOSEEQU4428H;CLOSE A FILE
 DOSTIMEQU4041H;LOW MEMORY TIME
 CNTLIMEQU1000;SHORT TIMEOUT
 ;
 ;ASCII Equates
 CREQU0DH;CARRIAGE RETURN
 LFEQU0AH;LINE FEED
 CTLDEQU04H;EOF CHARACTER
 XONEQU'Q'-40H;START XMSN
 XOFFEQU'S'-40H;STOP XMSN
 ;
 ;Modem Equates
 MODEMEQU0E8H;MODEM STATUS REGISTER
 STATUSEQU0EAH;UART STATUS
 DATAEQU0EBH;DATA IN/OUT
 CARDETEQU20H;CARRIER DETECT BIT
 THREQU40H;XMIT STATUS BIT
 DATRECEQU80H;BYTE REC'D BIT
 ;
 ORG5200H;START OF USER AREA
 JPMAIN;JUMP AROUND DATA AREA
 ;
 ;DATA AREA
 ;
 SIGNONDEFM'UPL100 by Morris Jones'
 DEFBCR
 DEFBLF
 DEFM'Version '
 DEFBVERS
 DEFB'.'
 DEFBREV
 DEFM'  Aug  1 1983'
 DEFBCR
 DEFBLF
 DEFBCR
 DEFBLF
 DEFB'$'
 READYDEFM'Ready for Upload -- '
 DEFBCR
 DEFBLF
 DEFM'Press control-D when finished'
 DEFBCR
 DEFBLF
 DEFB'$'
 NFERRDEFM'ABORT --  No File Specified'
 DEFBCR
 DEFBLF
 DEFB'$'
 FILERRDEFM'ABORT -- Disk File Error'
 DEFBCR
 DEFBLF
 DEFB'$'
 TIMERRDEFM'ABORT -- Timeout'
 DEFBCR
 DEFBLF
 DEFB'$'
 WATMSGDEFM'One moment . . .'
 DEFB'$'
 ENDMSGDEFBXON
 DEFBCR
 DEFBLF
 DEFM'File Upload Complete'
 DEFBCR
 DEFBLF
 DEFB'$'
 XOFSTRDEFBXOFF
 DEFW0
 DEFW0
 DEFW0
 DEFW0
 DEFW0
 DEFB'$'
 ;
 FCBDEFS32
 DSKBUFDEFS256
 ;
 ;Stack Space
 DEFS400
 STACKEQU$
 ;
 ;MAIN PROGRAM
 ;
 MAINLDSP,STACK;INIT STACK POINTER
 CALLRESTIM;RESET TIMEOUT
 LDHL,SIGNON;POINT TO SIGNON MSG
 CALLSERSTR;SEND TO VIDEO & SERIAL
 CALLINIT;GET FILENAME AND OPEN
 LDHL,READY;POINT TO READY MSG
 CALLSERSTR;SEND
 LOOPLDA,XON;START THINGS OFF
 CALLSEROUT;THE RIGHT WAY
 CALLBUFINI;SETUP THE RX BUFFER
 CALLGETBUF;READ A BUFFER FULL
 PUSHAF;SAVE RETURN STATE
 CALLSAVBUF;WRITE IT TO FILE
 POPAF;EOF RECEIVED?
 JRNC,LOOP;NOPE, GET ANOTHER BUFF
 LDDE,FCB;POINT TO FCB
 CALLCLOSE;CLOSE THE FILE
 JPNZ,WRERR;IF ERROR
 LDHL,ENDMSG;ELSE WE'RE DONE
 CALLSERSTR;SEND THE ENDING
 JPBOOT;THROUGH
 ;
 ;
 ; Initialize the write file
 INITLDHL,CMDLIN;POINT TO COMMAND LINE
 CALLADVLTR;MOVE TO END OF COMMAND
 CALLADVSP;MOVE TO NEXT TOKEN
 LDA,(HL);SEE IF TERMINATED EARLY
 CP' ';VALID CHARACTER?
 JRNC,INI1;YES, CONTINUE
 LDHL,NFERR;NO, ABORT MESSAGE
 CALLSERSTR;SEND OUT
 JPBOOT;AND QUIT
 INI1LDDE,FCB;POINT TO FCB
 CALLMOVFN;MOVE TOKEN TO FCB
 LDA,03H;FILENAME TERMINATOR
 LD(DE),A;INSTALL IT
 LDDE,FCB;POINT TO FCB
 LDHL,DSKBUF;AND BUFFER
 LDB,0;LRL SIZE
 CALLOPENWR;CALL DOS
 JPNZ,WRERR;ABORT ON ERROR
 RET;THROUGH
 ;
 ; DISK FILE ERROR ROUTINE
 WRERRLDHL,FILERR;POINT TO ERROR MSG
 CALLSERSTR;DISPLAY IT
 JPBOOT
 ;
 ;TOKEN GETTING SUBROUTINES
 ADVLTRLDA,(HL);ADVANCE BEYOND LETTERS
 CP' ';CHECK FOR VALID
 RETZ;NOT LETTER
 RETC;ALSO NOT LETTER
 CP',';USED TO SEPARATE TOKENS
 RETZ;ALSO TIME TO RETURN
 INCHL;POINT NEXT CHARACTER
 JRADVLTR;CONTINUE ADVANCING
 ;
 ADVSPLDA,(HL);ADVANCE BEYOND SPACES
 CP' ';CHECK FOR SPACE,
 JRZ,SP1;SET FOR RETURN
 RETC;CTRL CHAR, ABORT
 CP',';ALSO SEPARATOR
 RETNZ;OTHERWISE, NOT SEPARATOR
 SP1INCHL;MOVE TO NEXT SPACE
 JRADVSP;CONTINUE LOOPING
 ;
 MOVFNLDA,(HL);MOVE FILENAME TOKEN
 CP' ';FIND TERMINATOR
 RETZ;END OF NAME
 RETC;ALSO END OF NAME
 CP',';ALSO END OF NAME
 RETZ;
 LD(DE),A;MOVE TO DE
 INCHL;POINT NEXT CHAR
 INCDE;POINT NEXT DEST
 JRMOVFN;CONTINUE MOVING
 ;
 ;BUFFER ROUTINES
 ;INITIALIZE BUFFER FOR FILLING
 BUFINILDHL,TOPMEM;GET TOP OF MEM
 DECHL;COUNT DOWN
 DECHL;FOR PARANOIA
 LD(BEND),HL;SAVE IN VARIABLE
 LDHL,BSTART;POINT TO START OF BUFF
 LD(BPTR),HL;SAVE IN CURRENT POINTER
 RET;THROUGH
 ;
 ;CHECK FOR ALMOST FULL BUFFER
 CHKBUFLDHL,(BEND);GET TOP OF BUFF
 LDDE,(BPTR);AND CURRENT LOCATION
 ORA;CLEAR CARRY FLAG
 SBCHL,DE;GET THE DIFFERENCE
 LDDE,30;30 BYTE CUSHION
 CALLCPHLDE;COMPARE WITH DIFFERENCE
 RET;CY MEANS ALMOST FULL
 ;
 ;ADD BYTE TO THE BUFFER
 BUFBYTPUSHHL;PRESERVE CONTENTS
 LDHL,(BPTR);GET CURRENT PTR
 LD(HL),A;SAVE THE BYTE
 INCHL;POINT TO NEXT
 LD(BPTR),HL;SAVE NEW POINTER
 POPHL;RESTORE HL
 RET;
 ;
 ;SAVE BUFFER TO FILE
 SAVBUFLDDE,FCB;POINT TO FCB
 LDHL,BSTART;POINT TO START OF BUFF
 SBLOOPPUSHDE;SAVE FCB ADR
 LDDE,(BPTR);GET CURRENT LOCATION
 CALLCPHLDE;ARE WE THERE YET?
 POPDE;RESTORE FCB ADR
 RETZ;YES, WE'RE THROUGH
 RETNC;OR FOR PARANOIA
 LDA,(HL);GET A BYTE
 CALLWRBYTE;SAVE IT
 JPNZ,WRERR;ABORT ON ERROR
 INCHL;POINT NEXT BYTE
 JRSBLOOP;LOOP TIL DONE
 ;
 ;GET A BUFFER FULL FROM SERIAL LINE
 GETBUFCALLSERIN;GET FIRST BYTE
 CPCTLD;END OF FILE?
 JRZ,GTL3;HANDLE EOF
 GET1CALLBUFBYT;SAVE THE BYTE
 CALLCHKBRK;CHECK FOR ABORT
 CALLCHKBUF;CHECK FOR END OF BUFF
 JRNC,GETBUF;ALLS WELL
 ;HERE TO SEND XOFF AND A FEW NULLS
 LDHL,XOFSTR;POINT TO STRING
 GTLOOPLDA,(HL);CHECK NEXT STRING BYTE
 CP'$';TERMINATOR
 RETZ;WITH CY RESET
 CALLCHKBRK;CHECK FOR ABORT
 CALLOUTSTA;CHECK TRANSMIT READY
 JRNZ,GTL1;SKIP AROUND IF NOT READY
 LDA,(HL);GET THE BYTE BACK
 CALLSEROUT;SEND IT
 INCHL;POINT NEXT ONE
 GTL1CALLINSTAT;SEE IF BYTE RECD
 JRNZ,GTLOOP;NONE, LOOP BACK
 CALLSERIN;GET THE BYTE
 CPCTLD;CHECK FOR EOF
 JRZ,GTL3;HANDLE EOF
 GTL2CALLBUFBYT;SAVE BYTE
 JRGTLOOP;CONTINUE LOOP
 ;HERE IF CTLD RECEIVED, EOF
 GTL3LDHL,WATMSG;ONE MOMENT PLEASE
 CALLSERSTR;THANK YOU
 SCF;CY MEANS EOF
 RET;THROUGH
 ;
 ;I/O STATUS ROUTINES
 CHKBRKPUSHAF;TEST FOR ABNORMAL
 INA,(MODEM);ABORT CASE, DROPPED
 ANDCARDET;CARRIER, 
 JPNZ,BOOT;OR
 LDA,(3840H);HOST OPERATOR
 AND04H;PRESSING BREAK
 JPNZ,BOOT;
 POPAF;ONLY REG USED
 RET;
 ;
 INSTATPUSHBC;RET Z IF BYTE READY
 LDB,A;SAVE A REG
 INA,(STATUS);GET REG FROM UART
 ANDDATREC;LEAVE BYTE
 XORDATREC;SET Z IF READY
 JRZ,INRET;SKIP CHECKS IF READY
 PUSHAF;SAVE STATUS
 CALLCHKBRK;CHECK FOR ABORT
 CALLCHKCNT;CHECK SHORT TIMEOUT
 CALLNC,CHKTIM;IF NECESSARY, CHECK TIME
 POPAF;RESTORE STATUS
 INRETLDA,B;RESTORE A REG
 POPBC;AND BC REG
 RET;THROUGH
 ;
 OUTSTAPUSHBC;RET Z IF XMIT READY
 LDB,A;SAVE A REG
 INA,(STATUS);GET UART STATUS
 ANDTHR;XMIT BIT
 XORTHR;SET Z IF READY
 CALLCHKBRK;CHECK FOR ABORT
 LDA,B;RESTORE A REG
 POPBC;
 RET;THROUGH
 ;
 ;I/O ROUTINES
 SERINCALLINSTAT;CHECK IF READY
 JRNZ,SERIN;LOOP UNTIL
 CALLRESTIM;RESET THE TIMER
 INA,(DATA);GET BYTE
 RET;
 ;
 SEROUTCALLOUTSTA;CHECK IF READY
 JRNZ,SEROUT;LOOP UNTIL
 OUT(DATA),A;SEND BYTE
 RET;
 ;
 CONOUTPUSHAF;SAVE THE BYTE
 PUSHDE;AND DE
 CALL33H;SEND TO VIDEO
 POPDE;RESTORE REGS
 POPAF;
 RET;
 ;
 ;SEND STRING TO SERIAL
 SERSTRLDA,(HL);GET BYTE
 CP'$';TEST FOR TERMINATOR
 RETZ;THROUGH
 CALLSEROUT;ELSE DONE
 CALLCONOUT;DUPLICATE TO VIDEO
 CALLCHKBRK;JUST IN CASE
 INCHL;POINT NEXT
 JRSERSTR;LOOP TIL THROUGH
 ;
 CPHLDEPUSHBC;COMPARE DE TO HL
 LDB,A;SAVE REGS DATA
 LDA,H;GET HIGH BYTE
 CPD;COMPARE HIGH BYTES
 JRNZ,CPRET;VALUE DETERMINED
 LDA,L;ELSE CHECK LOW BYTES
 CPE;COMPARE
 CPRETLDA,B;RESTORE DATA IN A
 POPBC;DON'T DISTURB FLAGS
 RET
 ;
 ;START OF TIMER ROUTINES AND ARITHMETIC
 ;DATA AREA
 OLDTIMDEFB0;TIME OF DAY IN SECONDS
 DEFW0
 NEWTIMDEFB0;TIME OF DAY IN SECONDS
 DEFW0
 A120DEFB120;TIME LIMIT, TWO MINUTES
 DEFW0;
 AC1DEFS3;ACCUMULATOR 1
 AC2DEFS3;ACCUM 2
 AC3DEFS3;ACCUM 3
 SECSDEFB0;LOCAL STORAGE FOR
 MINSDEFB0;TIME OF DAY IN RAW
 HRSDEFB0;FORMAT, FOR CONVERSION
 OLDRAWDEFS3;TIME IN RAW FORMAT
 ;
 ;CHECK FOR TIME LIMIT EXPIRED
 CHKTIMPUSHHL;SAVE STATUS
 PUSHDE;
 PUSHBC;
 PUSHAF;AND AF TOO
 LDHL,OLDRAW;OLD TIMA
 LDDE,SECS;TEMP STORAGE
 LDBC,3;BYTE COUNT
 LDIR;MOVE FOR CONVERSION
 LDHL,OLDTIM;CONVERTED TIME STORAGE
 CALLCONTIM;CONVERT TO SECONDS
 LDHL,DOSTIM;POINT TO CURRENT TIME
 LDDE,SECS;LOCAL STORAGE
 LDBC,3;BYTE COUNT
 LDIR;MOVE THEM
 LDHL,NEWTIM;POINT TO SAVE AREA
 CALLCONTIM;CONVERT TO SECONDS
 LDDE,NEWTIM;POINT TO DATA
 LDHL,OLDTIM;AND OLD TIME
 CALLCP24;COMPARE THE TWO
 JRC,CH1;CHECK FOR MIDNIGHT WRAP
 CALLRESTIM;GIVE THE GUY A BREAK
 JRCHRET;JUMP TO RETURN CODE
 CH1LDHL,NEWTIM;POINT TO NEW TIME
 LDDE,OLDTIM;AND OLD TIME
 CALLDIFF24;GET THE DIFFERENCE
 LDDE,A120;ADDRESS OF LIMIT
 CALLCP24;COMPARE THE TWO
 JRC,CHRET;IF NOT YET, RETURN
 LDHL,TIMERR;ELSE REPORT TIMEOUT
 CALLSERSTR;TO ALL INVOLVED
 LDDE,FCB;AND FOR GOOD MEASURE,
 CALLCLOSE;CLOSE THE FILE
 JPBOOT;AND QUIT
 CHRETPOPAF;RESTORE STATE
 POPBC;NO RETURN VALUE
 POPDE;
 POPHL;
 RET;THROUGH
 ;
 ;RESET OLDTIME
 RESTIMPUSHHL;SAVE STATE
 PUSHDE;
 PUSHBC;
 PUSHAF;
 LDHL,DOSTIM;SOURCE
 LDDE,OLDRAW;DESTINATION LOCALLY
 LDBC,3;3 BYTE COUNT
 LDIR;RELOCATE FOR HOLDING
 CALLRESCNT;RESET THE SHORT COUNT
 POPAF;RESTORE STATE
 POPBC;
 POPDE;
 POPHL;THROUGH
 RET;DONE
 ;
 ;CONVERT CURRENT TIME OF DAY TO SECONDS IN (HL)
 CONTIMPUSHHL;SAVE DESTINATION
 LDA,(SECS);GET SECONDS COUNT
 LD(AC3),A;STARTING POINT
 LDHL,0;AND ZERO OUT
 LD(AC3+1),HL;OTHER THREE BYTES
 ;
 LDA,(MINS);GET MINUTES COUNT
 LD(AC1),A;SAVE IN FIRST BYTE
 LD(AC1+1),HL;AND INIT OTHER TWO BYTES
 LDHL,AC2;POINT TO DESTINATION
 LDDE,AC1;AND ONE MULTIPLICAND
 LDA,60;OTHER MULTIPLICAND
 CALLMULT24;CONVERT TO SECONDS
 LDDE,AC2;NOW ADD SECONDS
 LDHL,AC3;TO PREVIOUS TOTAL
 CALLADD24;DONE
 ;
 LDA,(HRS);NOW GET THE HOURS
 LDHL,0;GET TWO BYTES OF ZERO
 LD(AC1),A;SAVE THE HRS
 LD(AC1+1),HL;AND INIT REST OF NUMBER
 LDHL,AC2;DESTINATION
 LDDE,AC1;MULTIPLICAND
 LDA,60;MULTIPLICAND
 CALLMULT24;CONVERT HRS TO MINS
 LDHL,AC1;NEW DESTINATION
 LDDE,AC2;MULTIPLICAND
 LDA,60;MULTIPLICAND
 CALLMULT24;CONVERT MINS TO SECS
 LDDE,AC1;RESULT OF CONVERSION
 LDHL,AC3;PREVIOUS TOTAL
 CALLADD24;FINAL TIME OF DAY
 ;
 POPDE;RESTORE ULT DESTINATION
 LDHL,AC3;SOURCE
 LDBC,3;BYTE COUNT
 LDIR;MOVE THE VALUE
 RET;DONE
 ;
 ;MULTIPLY 24 BIT (DE) BY A, RESULT TO (HL)
 MULT24LDB,8;BIT COUNT OF MULTIPLIER
 ORA;CLEAR CARRY FLAG
 CALLCLRAC;CLEAR DESTINATION ACCUM
 MU1RRCA;ROTATE BIT 0 INTO CARRY
 JRNC,MU2;SKIP AROUND ADD
 PUSHAF;
 CALLADD24;ADD (DE) TO (HL)
 POPAF;
 MU2EXDE,HL;MOVE DE TO HL
 PUSHAF;
 CALLSL24;SHIFT IT LEFT
 POPAF;
 EXDE,HL;SWAP BACK
 DJNZMU1;UNTIL 8 BITS GONE
 RET;THROUGH
 ;
 ;CLEAR 24 BIT ACCUM AT (HL)
 CLRACPUSH HL;SAVE REGS USED
 PUSHAF;
 XORA;GET A ZERO
 LD(HL),A;SAVE ONE
 INCHL;POINT NEXT
 LD(HL),A;SAVE ANOTHER
 INCHL;POINT LAST
 LD(HL),A;THROUGH
 POPAF;RESTORE
 POPHL;REGISTERS
 RET;THROUGH
 ;
 ;SHIFT 24 BITS IN (HL) LEFT ONCE
 SL24PUSHHL;SAVE REGS USED
 SL1SLA(HL);START WITH A SHIFT
 INCHL;POINT TO NEXT BYTE
 RL(HL);ROTATE THE CARRY IN
 INCHL;POINT TO NEXT BYTE
 RL(HL);AND ROTATE THE LAST BYTE
 POPHL;RESTORE HL
 RET;THROUGH
 ;
 ;SUBTRACT (DE) FROM (HL), RESULT IN (HL)
 DIFF24PUSHHL;SAVE IMPORTANT REGS
 PUSHDE;
 PUSHBC;
 XORA;CLEAR CARRY, A
 LDB,3;BYTE COUNT
 EXDE,HL;MOVE SOURCE TO HL
 DI1LDA,(DE);GET ONE
 SBCA,(HL);SUBTRACT ONE
 LD(DE),A;RESTORE IT
 INCDE;POINT NEXT
 INCHL;POINT NEXT
 DJNZDI1;LOOP FOR THREE
 POPBC;RESTORE ORIGINAL STATE
 POPDE;
 POPHL;
 RET;THROUGH
 ;
 ;ADD (DE) TO (HL) -- 24 BITS
 ADD24PUSHHL;SAVE STATE
 PUSHDE;
 PUSHBC;
 XORA;CLEAR CY, GET ZERO
 LDB,3;BYTE COUNT
 EXDE,HL;MOVE SOURCE TO HL
 AD1LDA,(DE);GET ONE
 ADCA,(HL);ADD ONE
 LD(DE),A;SAVE IT
 INCDE;POINT NEXT
 INCHL;POINT NEXT
 DJNZAD1;LOOP FOR THREE
 POPBC;RESTORE STATE
 POPDE;
 POPHL;
 RET;THROUGH
 ;
 ;COMPARE 24 BITS IN (DE) TO (HL)
 CP24PUSHHL;SAVE STATE
 PUSHDE;
 PUSHBC;
 INCHL;ADVANCE TO MSB
 INCHL;
 INCDE;ADVANCE TO MSB
 INCDE;
 EXDE,HL;MOVE SOURCE TO HL
 LDA,(DE);GET HIGH ORDER BYTE
 CP(HL);COMPARE 
 JRNZ,CPQUIT;NOT EQUAL, THAT'S ALL
 DECHL;POINT MIDDLE BYTE
 DECDE;POINT MIDDLE BYTE
 LDA,(DE);GET MIDDLE BYTE
 CP(HL);COMPARE
 JRNZ,CPQUIT;NOT EQUAL, QUIT
 DECHL;POINT LOW ORDER
 DECDE;POINT LOW ORDER
 LDA,(DE);GET BYTE
 CP(HL);COMPARE, DONE
 CPQUITPOPBC;RESTORE REGS
 POPDE;FLAGS STILL SET
 POPHL;
 RET;THROUGH
 ;
 ;INCREMENT SHORT COUNT
 CHKCNTPUSHHL;RETURNS NC IF CHKTIM
 PUSHDE;REQUIRED TO BE SURE
 LDHL,(COUNT);GET COUNT
 INCHL;ADD ONE
 LD(COUNT),HL;RETURN TO STORAGE
 LDDE,CNTLIM;GET COMPARE LIMIT
 CALLCPHLDE;COMPARE THE TWO
 POPDE;RESTORE OLD DATA
 POPHL;IF NC, THEN CALL CHKTIM
 RET;TO SEE IF TIMEOUT
 ;
 RESCNTPUSHHL;BYTE REC'D
 LDHL,0;PUT ZERO IN SHORT COUNT
 LD(COUNT),HL;STORE IT
 POPHL;
 RET;THROUGH
 ;
 COUNTDEFW0;DATA FOR SHORT COUNT
 ;
 BENDDEFW0;STORE END POINTER
 BPTRDEFW0;CURRENT BUFF ADR
 BSTARTEQU$;BUFFER BEGINS HERE
 ;
 END5200H
