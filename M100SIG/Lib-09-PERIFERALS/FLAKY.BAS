1 'FLAKY.BA for CRC error recovery
2 'W. H. Calvin CIS: 71256,1353 1/31/85
3 'tested only on .DO files so far
10 MAXFILES=2
15 PRINT:PRINT:PRINT "FLAKY.BA file recovery program"
17 PRINT "If not in correct file folder,"
18 PRINT " exit and set up properly."
20 INPUT "Name of flaky file: ";A$
30 IF A$="" THEN 20
35 FILES:PRINT "Create RAM file named ";A$;"?":INPUT "ENTER if OK";B$:IF B$<>""THEN1
40 IF LEFT$(A$,2)<>"0:" THEN A$="0:"+A$
45 IF RIGHT$(A$,3)=".DO" OR RIGHT$(A$,3)=".do" THEN 50 ELSE A$=A$+".DO"
60 CLOSE:OPEN A$ FOR INPUT AS 1:OPEN MID$(A$,3) FOR OUTPUT AS 2
63 ON ERROR GOTO 110
65 PRINT "Starting disk file  ";A$
70 FOR X=1 TO 999999
75  IF EOF(1) THEN PRINT " TOTAL Bytes ";X:CLOSE:MENU
80  B$=INPUT$(1,1)
90  PRINT#2,B$;
100 NEXT
110 'error recovery
120 PRINT "        bytes at error: ";X
130 PRINT#2,"<<ERROR>>";:GOTO 75
199 '
200 'FLAKY.BA is similar to CRCERR.BA but uses single byte input rather than line input, and so saves much more of file.
210 '  Particularly handy for very long lines of .DO files created by TEXT.
220 'NOT TESTED on .BA or .CO files.
230 'creates RAM file of same name as diskfile; be careful not to clobber existing file that you want to keep.
240 'assumes .DO suffix, assumes drive 0:
300 'CAUTION:  In my experience, there is always one or more garbles in the 
301 ' several displayed lines following the single byte marked <<ERROR>>.
305 ' In documents, one can usually guess them from context, but be careful if your .DO file is really a program listing.
310 'Often this program will read a flaky file (giving CRC errors upon LOAD) without any errors; reading a byte at a time seems more
surefire than whatever LOAD uses.

