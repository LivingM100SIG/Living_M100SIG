40000 CA$ = STRING$(33, 0)                    ' CA$ will hold the code
40010 A0$ = " "                               ' A0$ will capture the value
40020 VC! = VARPTR(CA$)                       ' Locate the two primary
40025 VA! = VARPTR(A0$)                       '   strings in the routine.
40030 POKE VA! + 1, PEEK(VC! + 1)             ' Set A0$ to the first
40040 POKE VA! + 2, PEEK(VC! + 2)             '   position in CA$
40050 CZ! = PEEK(VC! + 1)+256 * PEEK(VC! + 2) ' CZ! will be the value to CALL
40060 RESTORE 40250                           ' RESTORE to the data location
40070 FOR     I = 1 TO 32                     ' Read in the machine code and
40080         READ A                          '   POKE it serially into the
40090         POKE CZ! + I, A                 '   string, byte by byte for all
40100 NEXT    I                               '   33 bytes.
40120 POKE CZ! +  4, PEEK(VC! + 1)            ' Now, POKE in the jump locations
40130 POKE CZ! +  5, PEEK(VC! + 2)            '   and the storage location in
40140 POKE CZ! + 11, PEEK(VC! + 1) + 15       '   the proper places.  This had
40150 POKE CZ! + 12, PEEK(VC! + 2)            '   to wait because we didn't know
40160 POKE CZ! + 16, PEEK(VC! + 1)            '   where in string space BASIC
40170 POKE CZ! + 17, PEEK(VC! + 2)            '   would put CA$.
40180 POKE CZ! + 21, PEEK(VC! + 1) + 6        '
40190 POKE CZ! + 22, PEEK(VC! + 2)            '
40200 CZ! = CZ! +  1                          ' Increment the CALLing location
40201                                         '   to the beginning of the actual
40202                                         '   routine.  Remember, the first
40203                                         '   byte is used for storage.
40250 DATA 62, 0, 50, 0, 0, 205, 66, 114, 200, 210, 0, 0, 198, 200, 50, 0
45021 DATA 0, 254, 3, 202, 0, 0, 22, 1, 30, 144, 6, 1, 205, 197, 114, 201
