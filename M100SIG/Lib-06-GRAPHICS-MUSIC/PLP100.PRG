0 'PLP100.CMZ                             
1 ' [P]resentaion       Designed by...      [L]evel                                 [P]rotocol          Camz 72757,3076   
2 '-------SUMMARY OF SHIFT CODES--------                                            -Code-  ------Function--------------  
3 '   ~*    Enter PLP Mode
4 '   ~!    Exit PLP Mode
5 '   ~A    Use ASCII Subset
6 '   ~D    Use Line Draw Mode
7 '   ~.    Use Point Mode
8 '   ~B    Use Box Mode
9 '   ~R    Use Box Fill Mode
10 '  ~C    Use Circle Mode
11 '  ~L    Locate Cursor (Note:This                command has two formats, one            for ASCII Mode and one for  
12 '        Line Draw Mode
13 '  ~W    Wait Command
14 '  ~#    Draw/Erase Select
15 '  ~%    Clear Screen
16 '  ~M    Musical Note Mode
17 '  ~I    Inverse Video Mode
18 '  ~N    Normal Video Mode
19 '
50 'Program Initialization
60 DEFDBL A-Z
70 X=0:Y=0:R=0:C=0:S=1:Q=2:QQ=Q
80 DIMX(89),Y(89):FORN=0TO89:READX(N),Y(N):NEXTN
90 GOTO 130
100 'Presentation Level
110 GOSUB 200:IF D=94 THEN 500
120 IF D<0 OR D>93 THEN 110
130 ON Q GOSUB 550,570,600,640,680,720,760,900,800,870,830,850,1020,1050,1070
140 GOTO 100
200 'Data Input (NOTE:Input as D$)
210 IF EOF(1) THEN D$=INPUT$(1):CLOSE:END ELSE D$=INPUT$(1,1)
220 D=ASC(D$)-32:RETURN
230 'Input (X,Y)
240 XX=D:GOSUB 200:XX=XX+93*D
250 GOSUB 200:YY=D:RETURN
500 'Code Translator
510 GOSUB 200:QQ=Q
520 D=INSTR("*!AD.BRCLW#%MIN",D$)
530 IF D THEN Q=D
540 ON Q GOTO 100,100,100,100,100,100,100,100,100,100,130,130,100,130,130
550 'Enter PLP
560 X=0:Y=0:R=0:C=0:S=1:Q=3:RETURN
570 'Exit PLP
580 GOSUB 200:IF D$<>"~" THEN PRINT D$;:GOTO 580
590 GOSUB 200:IF D$="*" THEN 550 ELSE PRINT "~"D$;:GOTO 580
600 'ASCII Mode
610 PRINT @R*40+C,CO$;D$;CF$;
620 C=POS(0):R=CSRLIN
630 RETURN
640 'Line Draw Mode
650 GOSUB 230:LINE (X,Y)-(XX,YY),S
670 X=XX:Y=YY:RETURN
680 'Point Mode
690 GOSUB 230:X=XX:Y=YY
700 IF S THEN PSET (X,Y) ELSE PRESET (X,Y)
710 RETURN
720 'Box Mode
730 GOSUB 230:X=XX:Y=YY
740 GOSUB 200:GOSUB 230:LINE (X,Y)-(XX,YY),S,B
750 RETURN
760 'Box Fill Mode
770 GOSUB 230:X=XX:Y=YY
780 GOSUB 200:GOSUB 230:LINE (X,Y)-(XX,YY),S,BF
790 RETURN
800 'Locate
810 IF QQ=3 THEN R=D:GOSUB 200:C=D:Q=QQ:RETURN
820 X=D:GOSUB 200:X=X+93*D:GOSUB 200:Y=D:Q=QQ:RETURN
830 'Draw/Erase Select
840 S=ABS(S-1):Q=QQ:RETURN
850 'Clear Screen
860 CLS:Q=QQ:RETURN
870 'Wait
880 T=D:GOSUB 200:T=T+93*D
890 FOR N=0 TO T:NEXT N:Q=QQ:RETURN
900 'Circle Mode
910 GOSUB 230:X=XX:Y=YY
920 GOSUB 200:RR=D:ST=1:IF R<36 THEN ST=36/RR
930 GOSUB 200:D1=D:GOSUB 200:D1=D1+93*D
940 GOSUB 200:D2=D:GOSUB 200:D2=D2+93*D
950 FOR N=D1 TO D2 STEP ST:DG=NMOD90:IF (N>90 AND N<180) OR (N>270 AND N<360) THEN DG=89-DG
960 SX=1:IF N>90 AND N<270 THEN SX=-1
970 SY=1:IF N>180 AND N<360 THEN SY=-1
980 XX=RR*X(DG)*SX+X:YY=RR*Y(DG)*SY+Y
990 IF XX>239 OR XX<0 OR YY>63 OR YY<0 THEN 1010
1000 IF S THEN PSET (XX,YY) ELSE PRESET (XX,YY)
1010 NEXT N:RETURN
1020 'Musical Note
1030 SN=D:GOSUB 200:SN=SN+93*D:GOSUB 200:SN=SN+D*8650:GOSUB 200:DD=D:GOSUB 200:DD=DD+93*D
1040 SOUND SN,DD:RETURN
1050 'Inverse Video
1060 PRINT CHR$(27);"p";:Q=QQ:RETURN
1070 'Normal Video
1080 PRINT CHR$(27);"q";:Q=QQ:RETURN
5000 DATA 1,0,.9998,.0174,.9993,.0348,.9986,.0523,.9975,.0697,.9961,.0871,.9945,.1045,.9925,.1218,.9902,.1391,.9876,.1564
5010 DATA .9848,.1736,.9816,.1908,.9781,.2079,.9743,.2249,.9702,.2419,.9659,.2588,.9612,.2756,.9563,.2923,.9510,.3090,.9455,.3255
5020 DATA .9396,.3420,.9335,.3583,.9271,.3746,.9205,.3907,.9135,.4067,.9063,.4226,.8987,.4383,.8910,.4539,.8829,.4694,.8746,.4848
5030 DATA .8660,.5000,.8571,.5150,.8480,.5299,.8386,.5446,.8290,.5591,.8191,.5735,.8090,.5877,.7986,.6018,.7880,.6156,.7771,.6293
5040 DATA .7660,.6427,.7547,.6560,.7431,.6691,.7313,.6819,.7193,.6946,.7071,.7071,.6946,.7193,.6819,.7313,.6691,.7431,.6560,.7547
5050 DATA .6427,.7660,.6293,.7771,.6156,.7880,.6018,.7986,.5877,.8090,.5735,.8191,.5591,.8290,.5446,.8386,.5299,.8480,.5150,.8571
5060 DATA .4999,.8660,.4848,.8746,.4694,.8829,.4539,.8910,.4383,.8987,.4226,.9063,.4067,.9135,.3907,.9205,.3746,.9271,.3583,.9335
5070 DATA .3420,.9396,.3255,.9455,.3090,.9510,.2923,.9563,.2756,.9612,.2588,.9659,.2419,.9702,.2249,.9743,.2079,.9781,.1908,.9816
5080 DATA .1736,.9848,.1564,.9876,.1391,.9902,.1218,.9925,.1045,.9945,.0871,.9961,.0697,.9975,.0523,.9986,.0348,.9993,.0174,.9998
