900    '
910    DIM A$(7)
1030   INTERRUPT%=fH59
1040   FOR I%=1 TO 26
:              SREG$=SREG$+CHR$(0)
:              NEXT I%
:      RREG$=SREG$+""
1500   PRINT "Loading Library";
1510   OPEN "A:UTILITY.LIB" AS 1 LEN=1024
1520   OPEN "UTILITY.LIB" AS 2 LEN=1024
1530   FIELD 1, 128 AS A$(0), 128 AS A$(1), 128 AS A$(2), 128 AS A$(3),
                128 AS A$(4), 128 AS A$(5), 128 AS A$(6), 128 AS A$(7)
1540   FIELD 2, 128 AS B$(0), 128 AS B$(1), 128 AS B$(2), 128 AS B$(3),
                128 AS B$(4), 128 AS B$(5), 128 AS B$(6), 128 AS B$(7)
1550   FOR I%=1 TO 3
:          GET 1, I%
1560       FOR J%=0 TO 7
:              LSET B$(J%)=A$(J%)
:              NEXT J%
1570       PUT 2, I%
:          NEXT I%
1580   CLOSE 1,2
1590   LIBRARY "UTILITY.LIB"
1600   PRINT
2000   '
2020   PRINT "Selecting"
:      MID$(SREG$,1,2)=CHR$(0)+CHR$(fHF)
:      GOSUB 10000
:      GOSUB 10100
:      GOSUB 10200                      ' select sio #0
2030   PRINT "Configuring"
:      MID$(SREG$,1,6)=CHR$(3)+CHR$(fH7)+CHR$(19)+CHR$(17)+CHR$(96)+CHR$(0)
:      GOSUB 10000
:      GOSUB 10200                     ' configure to 88n1i
2040   PRINT "Setting RTS f DTR"
:      MID$(SREG$,1,2)=CHR$(3)+CHR$(fHD)
:      GOSUB 10000
:      GOSUB 10200                     ' set RTS f DTR to mark
9999   GOTO 32700
10000  '
10010  CALL DBSYSINT(INTERRUPT%,SREG$,RREG$)
10099  RETURN
10100  '
10110  IF ASC(RREG$)>0 THEN
           PRINT "BIOS Error";ASC(RREG$)
10199  RETURN
10200  '
10210  MID$(SREG$,2,1)=CHR$(fHE)
:      GOSUB 10000
10220  PRINT "Status =";ASC(RREG$)
10299  RETURN
32700  '
32710  LIBRARY CLOSE
:      KILL "UTILITY.LIB"
32760  SYSTEM
32767  END
