1  '  COPYRIGHT JUNE,1984 by GORDON VICKERS, SUNNYVALE,CA.
2 ' Consent to use, and copy this program for free are extended to 
3 ' all Compuserve M100 SIG members.
5 DEFINT A - Z:SCREEN1,1
6 CLEAR1000,MAXRAM:KEY1,"1Cont"+CHR$(13):KEY2,"2Read"+CHR$(13):KEY3,"3Tokens"+CHR$(13):KEY4,"4Byte"+CHR$(13)
7 KEY5,"5String"+CHR$(13):KEY6,"6Find"+CHR$(13):KEY7,"7Dir"+CHR$(13):KEY8,"8End"+CHR$(13)
10 CLS:CALL17064:PRINT:GOSUB11:GOTO14
11 PRINT" Disk Doctor":PRINT:PRINT"WRITE PROTECT YOUR DISK, unless you're sure of what you are doing."
12 PRINT "Abbreviations used:":PRINT"  D - drive (0 or 1)":PRINT"  T - track (0 - 39)"
13 PRINT"  S - sector (1 - 18)":PRINT"  Sw - switch (0 or 1)":RETURN
14 PRINT:INPUT"Do you desire instructions? [ N,n / (any) ] ";K$:IFK$<>"N"ANDK$<>"n"THENGOSUB50000
15 PRINT:PRINT"Read Mode":INPUT"D,T,S,Sw";D,T,S,C:GOSUB 20:IFE=1THEN25ELSE100
20 IFD<>0ANDD<>1THENE=1
21 IFT<0ORT>39THENE=1
22 IFS<1ORS>18THENE=1
23 IFC<>0ANDC<>1THENE=1
24 RETURN
25 GOSUB26:E=0:GOTO15
26 PRINT:PRINT"Specification Error ":BEEP:GOSUB12:RETURN
50 K$="":FORY=0TO7:PRINTY*16":";:GOSUB55:NEXTY:RETURN
55 FORX=1TON:N$=STR$(ASC(MID$(B$,(Y*16)+X,1)))
60 IFLEN(N$)<4THEN65ELSE70
65 N$=CHR$(32)+N$:GOTO60
70 K$=K$+N$:NEXTX:PRINTK$:K$="":N$=""
75 PRINT"       ";
80 FORX=1TON:IFASC(MID$(B$,(Y*16)+X))<32THEN83ELSE85
83 PRINT"    ";:NEXTX:PRINT:RETURN
85 PRINTMID$(B$,(Y*16)+X,1);"   ";:NEXTX:PRINT:RETURN
90 PRINT:INPUT"T,S,Sw ";T,S,C
93 GOSUB20:IFE<>1THEN100ELSEGOSUB26
95 E=0:GOTO90
100 CLS:A$=DSKI$(D,T,S,C):N=16:B$=A$
105 PRINT"("T","S","C")":GOSUB50
130 PRINT"  *****  any function key to continue *****"
200 K$="":INPUTK$
201 K=VAL(K$):K$="":ONKGOTO500,90,300,205,400,700,1000,40000
205 INPUT"Position ";P:P=P+1:PRINTASC(MID$(A$,P,1)):INPUT "Is that the one [ Y,y / (any) ]";K$
210 IFK$="y"ORK$="Y"THEN220ELSE130
220 K$="":INPUT"replacement (decimal number)";N$:N=VAL(N$):IFN>0ORN$="0"THENMID$(A$,P,1)=CHR$(N)ELSE250
230 DSKO$ D,T,S,C,A$:GOTO100
300 CLS:B=127:K=0:FORX=128TO607:P=PEEK(X)
310 IFP<127THEN350
315 P=P-128:B=B+1
320 IFK/6<>INT(K/6)THEN330ELSEPRINT:K=0
330 PRINTTAB(K*12)B;:K=K+1
350 PRINTCHR$(P);: NEXTX:PRINT"  ";:GOTO130
400 INPUT"start pos.";B:B=B+1:INPUT"string ";K$:IFLEN(K$)=0THEN130ELSEMID$(A$,B,LEN(K$))=K$:GOTO230
500 IFC=1THEN505ELSE530
505 C=0:S=S+1
510 IFS>18THEN520ELSE525
520 S=1:T=T+1:IFT>40THENT=1
525 GOTO100
530 C=1:GOTO100
700 CLS:PRINT:PRINT:INPUT" String ";M$:Y=1
705 INPUT"start  T,S,Sw ";T,S,C
707 GOSUB20:IFE<>1THEN710ELSEGOSUB26
708 E=0:GOTO705
710 PRINT"("T;S;C")":A$=DSKI$(D,T,S,C)
715 IFASC(A$)=255ORASC(A$)=229THEN745
720 FORX=1TOLEN(A$):IFMID$(A$,X,1)=MID$(M$,Y,1)THENY=Y+1ELSEY=1
725 IFY=5THEN735ELSENEXTX
730 GOTO745
735 GOSUB50
738 PRINT" any key to continue /any function key to stop search"
740 K$="":INPUTK$:IFLEN(K$)=0THEN740
742 IFVAL(K$)>0THEN201
745 IFC=0THEN750ELSE755
750 C=1:GOTO710
755 S=S+1:C=0:IFS>18THEN760ELSE710
760 S=1:T=T+1:IFT>39THEN130ELSE710
900 N=ASC(MID$(A$,(Y*16)+X)):IFN=255THENE=E+1ELSEE=0
905 IFE=3THEN1080
910 IFX=1ANDN=0THENPRINTCHR$(8);"* ";
915 IFX<10THEN990
920 IFX=10ANDN=0THENPRINTTAB(15)"TEXT";
925 IFX=10ANDN=1THENPRINTTAB(15)"MACH.LANG.";
930 IFX=10ANDN=128THENPRINTTAB(15)"BASIC";
935 IFX=10ANDN<>0ANDN<>1ANDN<>128THENPRINTTAB(15)"("N")";
940 IFX=11THEN945ELSERETURN
945 PRINTTAB(30)N"   ("INT(N/2)",";
950 IFN/2=INT(N/2)THENPRINT"1,0)"ELSEPRINT"10,0)"
955 K=ASC(MID$(B$,N+1)):IFK>192THENRETURN
960 N=K:GOTO945
990 PRINTCHR$(N);:RETURN
1000 CLS:PRINT:PRINT"                 The Complete Directory":PRINT:PRINT" * denotes a killed file "
1003 PRINT:PRINT:PRINT"Filename"TAB(15)"Type"TAB(30)"HCA = (T,S,SW)":PRINT:S=1:C=0
1005 A$=DSKI$(D,20,S,C):B$=DSKI$(D,20,16,0)
1010 PRINT"(""20,"S","C")":PRINT"   ";:IFMID$(A$,1,1)=CHR$(255)THEN1080
1020 FORY=0TOLEN(A$)/16-1
1030 FORX=1TO11:GOSUB900:NEXTX
1040 PRINT:PRINT"   ";:NEXTY
1050 IFC=1THENS=S+1
1060 IFC=0THENC=1ELSEC=0
1070 IFS>18THEN1080ELSE1005
1080 PRINT:B$=A$:GOTO130
40000 CALL23164,0,23366:CALL27795:END
50000 CLS:PRINT" The function keys have been redefined and are used to select certain actions.":PRINT"Make a complete back-up";

50003 PRINT" disk prior to using this program. It is cheap ":PRINT"insurance against mistakes (man or machine).":PRINT
50005 PRINT"  1) Cont - continues read mode. Reads and displays next block.":PRINT"  2) Read - you specify track,";
50007 PRINT "sector, and switch. Disk is read and displayed."
50008 PRINT"  3) Tokens - prints table of BASIC tokens and reserved words."
50010 PRINT"  4) Byte - change a byte in the block read, writes block to disk.":PRINT"  5) String - write ascii to";
50012 PRINT" block read. Writes altered block to disk."
50013 PRINT"  6) Find - searches disk for specified string. Displays first occurance ,"
50015 PRINT"             prompts for continuation.":PRINT"  7) Dir - displays directory contents, shows file type, CHA,";
50017 PRINT" occupancy,":PRINT"           and indicates those that have been killed."
50020 PRINT"  8) End - restores function keys to default definitions and exits progam.":PRINT
50022 PRINT"        (any key to continue)"
50025 K$=INKEY$:IFLEN(K$)=0THEN50025
50030 CLS:PRINT:PRINT"    DOS resides on tracks 0 and 1. Do not write to these tracks.":PRINT"The directory goes from ";
50032 PRINT"track 20, sector 1 to sector 15.":PRINT "The File Allocation Table (FAT) is tripicated on the lower half"
50035 PRINT"(switch 0) of sectors 16,17,and 18.":PRINT"    Each directory entry contains a Head Cluster Address (HCA).";
50037 PRINT" The value of ":PRINT"the HCA refers to the start of a file and to a specific byte in the FAT."
50040 PRINT" HCA/2 = track. If HCA Mod 2 = 0 then the sector is sector 1 otherwise, file;"
50042 PRINT" begins on sector 10. In both cases, the switch is 0.":PRINT
50045 PRINT"    A file assigned an HCA of 39 would start on track 19, sector 10."
50050 PRINT"    The HCA also refers to a byte in FAT, it refers to the (HCA)th" 
50053 PRINT"byte (39th byte if using above example).":PRINT"The contens of this byte refers to :"
50054 PRINT"      1) if less than 190 then it refers to track/sector containing a "
50055 PRINT"          continuation of file and is treated exactly as a HCA."
50056 PRINT"      2) if greater than 190 then value of byte minus 190 = the last sector "
50057 PRINT"           used to store the file." 
50060 PRINT"    Use this program and it's Dir command to investigate this on your own."
50065 PRINT"It is an easy system but at first may seem confusing.":PRINT
50070 PRINT:PRINT"       ( any key to start )"
50075 K$=INKEY$:IFLEN(K$)=0THEN50075
50080 GOSUB12:PRINT:RETURN
60000 '
60005 '
60010 '    This program is available (free) to all SIG100 members.
60015 '    However,if you find it worth while, please send  70% of program's
60020 '    fair market value (use your own estimate) to:
60025 '
60030 '                Gordon Vickers
60035 '                871 San Juan Dr.
60040 '                Sunnyvale, Ca. 94086. 
60045 '
60050 '     Help a college student survive the raising cost of an education!
60055 '

