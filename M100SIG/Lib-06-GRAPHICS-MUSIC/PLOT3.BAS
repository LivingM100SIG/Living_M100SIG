1 '    +------------------------------+
2 '    |	Plotting Program
3 '    | Sept. 1985- Version 2.1
4 '    |Four Color-Rev. Auto-Scaling SR
5 '    | JAN.  1987- Version 3.0
6 '    |   SINGLE KEY AND TITLES ADDED
7 '    |   24 KEY ENTRIES - 1 to 24
10 '   +------------------------------+
11 ' VS=3.0
10001 '+------------------------------+
10002 '|I. Takes unsorted data file
10003 '+------------------------------+
11001 '+------------------------------+
11002 '|	A. Get file
11003 '+------------------------------+
11010 CLS
11020 INPUT "What is the input file's name";FI$
11030 OPEN FI$ FOR INPUT AS #1:CLS
11040 NP=0
11050 XA=0:XZ=0:YA=0:YZ=0
11055 PRINT "Counting entries."
11060 IF EOF(1) THEN 13030
11070 INPUT #1,X,Y,K
11080 PRINT ".";
12001 '+------------------------------+
12002 '|	B. Get firsts and lasts
12003 '+------------------------------+
12005 IF NP<=0 THEN XA=X
12006 IF NP<=0 THEN YA=Y
12010 IF X<XA THEN XA=X ELSE                  IF X>XZ THEN XZ=X
12020 IF Y<YA THEN YA=Y ELSE                  IF Y>YZ THEN YZ=Y
13001 '+------------------------------+
13002 '|	C. Count entries
13003 '+------------------------------+
13010 NP=NP+1
13020 GOTO 11060
13030 CLOSE 1:CLS
14001 '+------------------------------+
14002 '|	D. Read in data
14003 '+------------------------------+
14010 OPEN FI$ FOR INPUT AS #1
14020 DIM XL(NP),YL(NP),PN(NP),SY(NP)
14030 FOR I=1 TO NP
14040 INPUT #1,XL(I),YL(I),KY
14042 PN(I)=INT((KY-1)/6)+1
14044 SY(I)=((KY-1)MOD6)
14050 NEXT I
14060 CLOSE 1
20001 '+------------------------------+
20002 '|II. Figures scales for X and Y
20003 '+------------------------------+
21001 '+------------------------------+
21002 '|	A. Take deltas
21003 '+------------------------------+
21010 XD=XZ-XA:YD=YZ-YA
22001 '+------------------------------+
22002 '|	B. Divide 7x9.5 plot up
22003 '+------------------------------+
22010 LX=9.5-2.5:LY=7-2
22020 XI=XD/LX  :YI=YD/LY
23001 '+------------------------------+
23002 '|	C. Choose closest
23003 '|	   preferred factors
23004 '+------------------------------+
23010 ZI=XI:GOSUB 60001:XI=ZI
23020 ZI=YI:GOSUB 60001:YI=ZI
23030 ZA=XA:GOSUB 50001:XA=ZA
23040 ZA=YA:GOSUB 50001:YA=ZA
30001 '+------------------------------+
30002 '|III. Writes plot file
30003 '+------------------------------+
31001 '+------------------------------+
31002 '|	A. Get filename
31003 '+------------------------------+
31010 'cls
31020 INPUT "What is the output file's name";FI$
31030 OPEN FI$ FOR OUTPUT AS #1
32001 '+------------------------------+
32002 '|	B. Write header
32003 '+------------------------------+
32010 PRINT #1,";:V1,EC5,A,H,P1"
32020 P=1
32030 S=1
33001 '+------------------------------+
33002 '|	C. Write X axis
33003 '+------------------------------+
33005 PRINT #1,"300,200,D,"
33010 FOR I=1 TO LX STEP 1
33020 XT=I*200+300
33030 PRINT #1,XT;",200,"; XT;",220,"; XT;",200,"
33040 NEXT I
33050 PRINT #1,"U,"
34001 '+------------------------------+
34002 '|	D. Write Y axis
34003 '+------------------------------+
34005 PRINT #1,"300,200,D,"
34010 FOR I=1 TO LY STEP 1
34020 YT=I*200+200
34030 PRINT #1, "300,";YT; ",320,";YT; ",300,";YT;","
34040 NEXT I
34050 PRINT #1,"U,"
35001 '+------------------------------+
35002 '|	E. Print X values
35003 '+------------------------------+
35010 YT=200-50
35020 FOR I=0 TO LX STEP 1
35030 XT=I*200+300-50
35040 PRINT #1,"U,";XT;",";YT;","
35050 PRINT #1,"S12 ";
35060 XV=XA+I*XI
35070 PRINT #1,XV;"_,"
35200 NEXT I
36001 '+------------------------------+
36002 '|	F. Print Y values
36003 '+------------------------------+
36010 XT=300-20
36020 FOR I=0 TO LY STEP 1
36030 YT=I*200+200-50
36040 PRINT #1,"U,";XT;",";YT;","
36050 PRINT #1,"S42 ";
36060 YV=YA+I*YI
36070 PRINT #1,YV;"_,"
36200 NEXT I
37001 '+------------------------------+
37002 '|	G. Plot x,y pairs
37003 '+------------------------------+
37010 FOR I=1 TO NP
37011 IF PN(I)=P THEN 37020
37012 P=PN(I)
37013 PRINT #1, USING "!#!";"P";P;","
37020 XL(I)=INT((XL(I)-XA)/XI/.005)+300
37030 YL(I)=INT((YL(I)-YA)/YI/.005)+200
37100 PRINT #1,XL(I);",";YL(I);","
37105 PRINT #1, USING "\ \#!";"M2+";SY(I);","
37110 NEXT I
38001 '+------------------------------+
38002 '|        TITLES AND LABELS
38003 '+------------------------------+
38100 CLS:PRINT:PRINT
38110 INPUT "Plot title  ";TI$
38120 INPUT "X-axis label";XL$
38130 INPUT "Y-axis label";YL$
38140 PRINT #1,"P1,500,1220,S12 ";TI$;"_,230,500,S42 ";YL$;"_,700,100,S12 ";XL$;"_,"
49001 '+------------------------------+
49002 '|	H. Write closing
49003 '+------------------------------+
49010 PRINT #1,"U,H,@,"
49020 CLOSE 1
49030 END
50001 '+------------------------------+
50002 '| Anchor point subroutine
50003 '+------------------------------+
50005 IF ZA=0 THEN GOTO 50060
50010 ZZ=LOG(ABS(ZA))/LOG(10)
50020 NZ=INT(ZZ)
50030 FZ=ZZ-NZ
50040 ZA=INT(SGN(ZA)*(10^FZ))
50050 ZA=ZA*(10^NZ)
50060 RETURN
60001 '+------------------------------+
60002 '| Auto-scaling subroutine
60003 '+------------------------------+
60010 ZZ=LOG(ZI)/LOG(10)
60020 NZ=INT(ZZ)
60030 FZ=ZZ-NZ
60040 ZI=1
60050 IF FZ=>(LOG(1)/LOG(10)) THEN ZI=2
60060 IF FZ=>(LOG(2)/LOG(10)) THEN ZI=4
60070 IF FZ=>(LOG(4)/LOG(10)) THEN ZI=5
60080 IF FZ<=(LOG(5)/LOG(10)) THEN 60100
60090 NZ=NZ+1:ZI=1
60100 '
60110 ZI=ZI*(10^NZ)
60120 RETURN

