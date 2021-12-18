        ' M100COM.BAS  M100 DISK DRIVE EMULATION ON AN IBM   VER 880322.03
        'Copr. 1988 Len Tucker

10 CM$ = COMMAND$
   CP$ = "COM1:"
   BAUD = 19200
   IF CM$ <> "" THEN
        IF INSTR(CM$, "COM2") THEN CP$ = "COM2:"
        IF INSTR(CM$, "9600") THEN BAUD = 9600
   END IF
   CLS
11 SHELL "DIR " + DRV$ + DIR$ + "??????.* > " + DRV$ + DIR$ + "PDD_DIR.BAK"
   CLOSE
   OPEN DRV$ + DIR$ + "PDD_DIR.BAK" FOR INPUT AS 1
   OPEN DRV$ + DIR$ + "PDD_DIR.DAT" FOR OUTPUT AS 2
   N1 = 0
14 DO WHILE NOT EOF(1)
        LINE INPUT #1, T$
        IF T$ <> "" THEN
                IF ASC(T$) >= 48 AND MID$(T$, 15, 3) <> "DIR" THEN
                        PRINT #2, LEFT$(T$, 6) + "." + MID$(T$, 10, 12)
                        N1 = N1 + 1
                ELSEIF MID$(T$, 2, 3) = "Dir" THEN
                        I% = INSTR(2, T$, ":")
                        IF I% THEN
                                DRV$ = MID$(T$, I% - 1, 2)
                                DIR$ = MID$(T$, I% + 1)
                                IF RIGHT$(DIR$, 1) <> "\" THEN
                                        DIR$ = DIR$ + "\"
                                END IF
                        END IF
                ELSEIF MID$(T$, 11, 4) = "File" THEN
                        BF = VAL(MID$(T$, 19, 9)) / 1280 'bytes free is
                END IF                                   'updated only at
        END IF                                           'the start
   LOOP
   CLOSE

90 GOSUB 900
   GOSUB 100
   GOSUB 910
   GOSUB 920
   GOTO 500

100 CLOSE : PDD = 0: FO = 0
    OPEN CP$ + "9600,N,8,1,DS,CD,CS,RS" FOR RANDOM AS 1 LEN = 256
    COMPORT% = &H3F8
    IF CP$ = "COM2:" THEN COMPORT% = &H2F8
    IF BAUD = 19200 THEN
        I% = INP(COMPORT% OR 3)
        OUT (COMPORT% OR 3), I% OR &H80
        OUT COMPORT%, 6                  'CHANGE BAUD RATE DIVISOR FOR 19200
        OUT (COMPORT% OR 3), I%
    END IF
    RETURN

104 IF (LOC(1) = 0) AND (RTS = 0) THEN
        I% = INP(COMPORT% OR 4)
        OUT (COMPORT% OR 4), (I% OR 2)   ' RTS ON
        RTS = 1
    END IF
    RETURN

105 IF (LOC(1) = 0) AND RTS THEN
        I% = INP(COMPORT% OR 4)
        OUT (COMPORT% OR 4), (I% AND 253)   ' RTS OFF
        RTS = 0
    END IF
    RETURN

106 I% = 16                                ' CTS MONITOR DISABLED IN
    'IF LOC(1) = 0 THEN                    ' THIS VERSION
        'I% = INP(COMPORT% OR 6) AND 16
    'END IF
    RETURN

                        'CHECKSUM
110 CK% = 0
    FOR C1% = 1 TO LEN(S$)
        CK% = 255 AND (CK% + ASC(MID$(S$, C1%)))
    NEXT C1%
    CK% = (CK% MOD 256) XOR 255
    RETURN
                        'SEND DATA
120 RP$ = CHR$(RP%)
122 S$ = CHR$(RS%) + CHR$(LEN(RP$)) + RP$
    GOSUB 110
    S$ = S$ + CHR$(CK%)
123 GOSUB 106
    GOSUB 930
    IF I% THEN PUT #1, , S$ ELSE IF INKEY$ = "" THEN 123
124 RETURN

128 FOR I% = 1 TO LEN(S$)               'DEBUG ROUTINE
        T$ = MID$(S$, I%, 1)
        IF ASC(T$) < 32 OR ASC(T$) > 126 THEN
                T$ = "<" + STR$(ASC(T$)) + ">"
        END IF
        PRINT T$;
    NEXT I%
    PRINT
    RETURN
                        'FILENAME
130 I% = INSTR(1, QF$, ".")
    IF I% < 2 OR I% > 7 THEN
        QF$ = ""
    ELSE
        QF$ = LEFT$(QF$, I% - 1) + SPACE$(7 - I%) + MID$(QF$, I%, 4)
    END IF
    RETURN
132 QF$ = RTRIM$(MID$(QP$, 1, 6)) + "." + RTRIM$(MID$(QP$, 8, 3))
    RETURN

                        'SEND FILENAME
135 IF SZ > 65535 THEN SZ = 65535
    BF1 = BF
    IF BF1 > 80 THEN BF1 = 80
    T$ = "F": IF ASC(QF$) = 0 THEN T$ = CHR$(0)
    RP$ = QF$ + SPACE$(24 - LEN(QF$)) + T$ + CHR$(SZ \ 256) + CHR$(SZ MOD 256) + CHR$(BF1): RS% = 17: RETURN

                        'DRIVE OK
150 RS% = 18: RP% = 0: RETURN: ' DISK OK
151 RS% = 18: RP% = 16: RETURN: 'FILE NOT FOUND
152 RS% = 18: RP% = 48: RETURN: 'END OF FILE
153 RS% = 18: RP% = 64: RETURN: 'I/O ERROR
154 RS% = 18: RP% = 80: RETURN: 'WRITE PROTECTED
155 RS% = 18: RP% = 96: RETURN: 'NO SPACE

                       
                        'KEYBOARD COMMAND
400 IF ASC(T$) = 0 THEN
        T$ = RIGHT$(T$, 1)
        IF T$ = CHR$(68) THEN
                CLS
                END
        ELSEIF T$ = CHR$(67) THEN
                CLS : PRINT "Enter the New Drive & Directory Path ";
                INPUT T$
                IF T$ <> "" THEN
                        I% = INSTR(T$, ":")
                        IF I% = 2 THEN
                                DRV$ = MID$(T$, 1, 1) + ":"
                        END IF
                        DIR$ = RTRIM$(MID$(T$, I% + 1))
                        IF DIR$ <> "" THEN
                                IF LEFT$(DIR$, 1) <> "\" THEN
                                        DIR$ = "\" + DIR$
                                END IF
                        END IF
                        IF RIGHT$(DIR$, 1) <> "\" THEN DIR$ = DIR$ + "\"
                        IF BAUD = 19200 THEN
                                I% = INP(COMPORT% OR 3)
                                OUT (COMPORT% OR 3), I% OR &H80
                                OUT COMPORT%, 12
                                OUT (COMPORT% OR 3), I%
                        END IF
                        GOTO 11
                ELSE
                        GOTO 90
                END IF
        ELSEIF T$ = CHR$(66) THEN
                IF BAUD = 9600 THEN
                        BAUD = 19200
                ELSE
                        BAUD = 9600
                END IF
                GOTO 90
        END IF
    END IF
                       
                        'RECEIVE DATA
500 ON ERROR GOTO 590
502 GOSUB 104: IF LOC(1) = 0 THEN T$ = INKEY$: IF T$ = "" THEN 502 ELSE 400
    CH% = 1: GOSUB 550: IF RD$ <> "Z" THEN 502
    CH% = 1: GOSUB 550: IF RD$ <> "Z" THEN 502
    CH% = 1: GOSUB 550: IF CH% THEN 502
    QU% = ASC(RD$)
    IF QU% > 8 THEN 502
    CH% = 1: GOSUB 550: IF CH% THEN 595
    QL% = ASC(RD$)
    CH% = QL%: GOSUB 550: IF CH% THEN 595
    QP$ = RD$
    QP% = 0: IF LEN(QP$) > 0 THEN QP% = ASC(RIGHT$(QP$, 1))
    CH% = 1: GOSUB 550: IF CH% THEN 595
    CK$ = RD$
    S$ = CHR$(QU%) + CHR$(QL%) + QP$
    GOSUB 110
    IF CK% = ASC(CK$) THEN
        IF QU% = 8 THEN
                FOR I% = 1 TO 30000
                        IF LOC(1) > 1 THEN RD$ = "  ": GET #1, , RD$: EXIT FOR
                NEXT I%
        END IF
    ELSE
        ER$ = "checksum error " + STR$(CK%) + " " + STR$(ASC(CK$))
        GOSUB 945
        GOSUB 153
        GOSUB 120
        GOTO 595
    END IF
    GOTO 600
550 RD$ = ""
    IF CH% THEN
        FOR I% = 1 TO 10000
                IF CH% <= LOC(1) THEN
                        RD$ = STRING$(CH%, " ")
                        GET #1, , RD$: CH% = 0
                        EXIT FOR
                END IF
        NEXT I%
    END IF
    RETURN

590 SELECT CASE ERR
        CASE 57
                IF BAUD = 9600 THEN
                        RESUME 500
                ELSE
                        GOSUB 100
                        GOSUB 153
                        GOSUB 120
                        ER$ = "Communication Error"
                        GOSUB 940
                        RESUME 500
                        END IF
        CASE 69
                GOSUB 100
                GOSUB 153
                GOSUB 120
                BEEP
                RESUME 500
        CASE 75, 76
                CLS
                PRINT "PATH ERROR"
                DRV$ = ""
                DIR$ = ""
                END
        CASE 68
                BEEP
                IF CP$ = "COM2:" THEN
                        CP$ = "COM1:"
                        RESUME 90
                ELSE
                        CLS
                        PRINT "COM1 Malfunction"
                        END
                END IF
        CASE ELSE
                ON ERROR GOTO 0
    END SELECT

595 QU% = 9: QL% = 0: QP% = 0: QP$ = "": GOTO 500
                        
                         'drive comm request
600 GOSUB 105: IF QU% > 8 THEN 695
601 ON QU% + 1 GOSUB 610, 620, 750, 720, 730, 740, 670, 680, 690
605 GOTO 695

610 IF QP% > 2 THEN 698 ELSE ON QP% + 1 GOTO 700, 701, 702: 'FIND FILE

620 IF QP% > 3 THEN 698 ELSE IQP% = QP%: ON QP% GOTO 710, 712, 714: 'OPEN FILE

670 GOSUB 153: GOTO 120: 'FORMAT DISK

680 GOSUB 150: GOTO 120: 'STATUS OK

690 S$ = "C1000000": GOTO 123

695 'PRINT QU%, QP%, QL%        'DEBUG ROUTINE
696 GOTO 500

698 GOSUB 153: GOTO 120

699 STOP: GOSUB 153: GOSUB 120: GOTO 500

700 GOSUB 132: IQF$ = QF$: GOSUB 780: GOSUB 788: GOSUB 135: GOTO 122
701 FI% = 0: DS$ = "LFILES": BYTES = 0: IQF$ = "": GOSUB 920: GOSUB 945
702 GOSUB 815: GOSUB 135: GOTO 122

710 GOSUB 153            'WRITE
    IF FO = 0 THEN
        GOSUB 782
        SZ1 = SZ
        DS$ = "OPEN/WRITE"
    END IF
    GOTO 120

712 GOSUB 153            'APPEND
    IF FO = 0 THEN
        GOSUB 784
        SZ1 = SZ
        DS$ = "OPEN/APP"
        END IF
    GOTO 120

714 GOSUB 153            'READ
    IF FO = 0 THEN
        GOSUB 782
        SZ1 = SZ
        DS$ = "OPEN/READ"
    END IF
    GOTO 120
                       
                        'READ FROM FILE
720 GOSUB 152
    RP$ = CHR$(RP%)
    IF FO THEN
        SZ2 = 128
        IF SZ1 < 129 THEN SZ2 = SZ1
        IF SZ2 THEN
                RP$ = STRING$(SZ2, " "): GET #2, , RP$
                SZ1 = SZ1 - SZ2
                BYTES = BYTES + SZ2
                RS% = 16
                DS$ = "READ"
        END IF
    END IF
    GOSUB 122
    IF SZ1 = 0 THEN 788 ELSE RETURN
                       
                        'WRITE TO FILE
730 GOSUB 153
    IF FO THEN
        SZ2 = LEN(QP$)
        IF SZ2 THEN
                PUT #2, , QP$
                SZ = SZ + SZ2
                BYTES = BYTES + SZ2
                DS$ = "WRITE"
                GOSUB 150
        END IF
    END IF
    GOTO 120

                        'DELETE FILE
740 GOSUB 787
    GOSUB 153
    SZ = 0
    IF IQF$ <> "" THEN
        QF$ = IQF$
        GOSUB 130
        GOSUB 830
        KILL DRV$ + DIR$ + IQF$
        IQF$ = ""
        FO = 0
        GOSUB 150
        DS$ = "DELETE"
    END IF
    ON ERROR GOTO 590
    GOTO 120
                       
                        'CLOSE FILE
750 GOSUB 788
    IF (IQP% = 1) OR (IQP% = 2) THEN
        QF$ = IQF$
        GOSUB 130
        GOSUB 820
        IQP% = 0
        DS$ = "CLOSE"
        GOSUB 945
    END IF
    GOSUB 150
    GOTO 120
                       
                        'TEST FOR FILE
780 GOSUB 787
    SZ = 0
    BYTES = 0
    IF IQF$ <> "" THEN
        OPEN DRV$ + DIR$ + IQF$ FOR INPUT AS 2
        SZ = LOF(2)
        FO = 1
        GOSUB 130
    END IF
    GOTO 785
                       
                        'OPEN FILE TO READ/WRITE
782 GOSUB 787
    SZ = 0
    BYTES = 0
    IF IQF$ <> "" THEN
        OPEN DRV$ + DIR$ + IQF$ FOR BINARY AS 2
        SZ = LOF(2)
        FO = 1
        GOSUB 150
    END IF
    GOTO 785
                       
                        'OPEN FILE TO APPEND
784 GOSUB 787
    SZ = 0
    BYTES = 0
    IF IQF$ <> "" THEN
        OPEN DRV$ + DIR$ + IQF$ FOR BINARY AS 2
        SZ = LOF(2)
        SEEK #2, SZ + 1
        FO = 1
        GOSUB 150
    END IF
785 ON ERROR GOTO 590
    GOTO 920
                       
                        'CLOSE
787 ON ERROR GOTO 790
788 IF FO THEN CLOSE #2: FO = 0
789 RETURN
                         'ERROR ROUTINE
790 SELECT CASE ERR
        CASE 53
                QF$ = STRING$(24, CHR$(0))
                SZ = 0
                GOSUB 151
                DS$ = "NOT FOUND"
                RESUME 799
        CASE 61
                GOSUB 155
                RESUME 799
        CASE 62
                GOSUB 152
                RESUME 799
        CASE 63, 70
                GOSUB 154
                RESUME 799
        CASE ELSE
                ON ERROR GOTO 0
    END SELECT

799 RETURN
                         'FIND FILE IN PDD_DIR
810 GOSUB 890
    FOR FI% = 1 TO N1
        GET #3, FI%
        IF RTRIM$(FILENAME$) = RTRIM$(LEFT$(QF$, 10)) THEN RETURN
    NEXT FI%
    FI% = 0
    RETURN

                        'FIND BLANK RECORD IN PDD_DIR
813 GOSUB 890
    FOR FI% = 1 TO N1
        GET #3, FI%
        IF FILENAME$ = SPACE$(10) THEN RETURN
    NEXT FI%
    FI% = 0
    RETURN
                        'FIND NEXT FILE IN PDD_DIR
815 GOSUB 890
    FI% = FI% + 1
    QF$ = STRING$(24, CHR$(0))
    SZ = 0
    IF FI% > N1 THEN FI% = 0: RETURN
    GET #3, FI%
    QF$ = LEFT$(FILENAME$, 10) + SPACE$(14)
    SZ = VAL(SZ$)
    IF ASC(QF$) = 32 THEN 815 ELSE RETURN
                       
                        'ADD FILE TO PDD_DIR
820 IF QF$ = "" THEN RETURN
    GOSUB 810
    IF FI% = 0 THEN
        GOSUB 813
        IF FI% = 0 THEN
                FI% = N1 + 1
                N1 = N1 + 1
        END IF
    END IF
    LSET FILENAME$ = LEFT$(QF$ + "        ", 10)
    LSET SZ$ = STR$(SZ)
    PUT #3, FI%
    RETURN
                       
                        'DELETE FILE IN PDD_DIR
830 GOSUB 810
    IF FI% THEN
        LSET FILENAME$ = SPACE$(10)
        LSET SZ$ = SPACE$(9)
        PUT #3, FI%
    END IF
    RETURN
                       
                        'OPEN PDD_DIR
890 IF PDD = 0 THEN
        OPEN DRV$ + DIR$ + "PDD_DIR.DAT" FOR RANDOM AS 3 LEN = 21
        FIELD #3, 10 AS FILENAME$, 9 AS SZ$, 2 AS ZZ$
        PDD = 1
    END IF
    RETURN
                       
                        'CLOSE PDD_DIR
895 IF PDD THEN CLOSE #3: PDD = 0
896 RETURN

900 LOCATE 24, 8, 0
    PRINT "<F8> Baud Rate  <F9> Directory Select   <F10> End Program";
    RETURN

910 LOCATE 1, 1, 0: PRINT "Drive "; DRV$; "      "
    LOCATE 1, 11: PRINT "Directory "; LEFT$(DIR$, LEN(DIR$) - 1); SPACE$(40)
    LOCATE 1, 63: PRINT "Port "; CP$; BAUD
    RETURN

920 LOCATE 2, 1, 0: PRINT "File  "; LEFT$(IQF$ + SPACE$(10), 10)

930 LOCATE 2, 20, 0: PRINT "Status "; LEFT$(DS$ + SPACE$(10), 10)
    LOCATE 2, 40: PRINT "Bytes        ";
    LOCATE 2, 46: PRINT BYTES
    RETURN

940 LOCATE 3, 1: PRINT ER$
    BEEP
    RETURN

945 LOCATE 3, 1: PRINT SPACE$(40)
    RETURN
END

                                                                                                           