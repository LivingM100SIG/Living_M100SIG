10 REM12345678901
15 REM type in line 10 only, and save as 'LPTLF.BA' - then load and run the program of lines 20-120
20 SA=32774:FORJ=SA TO SA+10
30 READ X:POKE J,X:NEXT
40 POKE 64228,6:POKE 64229,INT(SA/256)
50 DATA 254,13	    :';CPI   ODH
60 DATA 192	    :';RNZ
70 DATA 62,10	    :';MVI   A,0AH
80 DATA 205,63,109  :';CALL  6D3FH
90 DATA 62,13	    :';MVI   A,ODH
100 DATA 201	    :';RET
110 REM *** This is for 32K RAM, change the declaration of "SA" in line 20 for these RAM sizes:                                     8K RAM - SA=57350                      16K RAM - SA=49158                      24K RAM - SA=40966
120 REM *** permanent memory printer linefeed filter routine.                      by:  Clifford Knight                         P.O. Box 253                            Manomet, MA 02345                       I.D. #71106,1153
