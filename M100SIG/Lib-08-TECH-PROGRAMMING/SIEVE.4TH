FORTH/BASIC SPEED COMPARISON

The program "Eratosthenes Sieve", published in BYTE magazine in September
of 1981, has been widely used as a benchmark to compare various programming
languages. Here is the source code for a shortened version of the Sieve in
Basic and in fig-Forth. I have reduced the size of the array to 4K and also
do only one iteration, so as not to have to wait all day for Basic. I have two
versions in Forth: the first uses an integer array, as Basic does. So it is
the closest equivalent. The second version uses a byte array, which Basic
does not provide. This version really screams in Forth! The Basic code is
not compacted or optimized, so you can easily trace the algorithm. (The Forth
code is pretty obscure.) Even after the Basic code is optimized for speed the
Forth version #2 is still over 13 times faster and version #1 is over 2 1/2
times faster.

Cut and paste the source code. Use HELPER.BA to load the Forth code into
screens on your disk. 32 LOAD compiles version #1 and 35 LOAD compiles version
#2. Type MINI-SIEVE#1 to run version #1, MINI-SIEVE#2 for #2. Note the start
and stop times. You'll have to COLD (or FORGET TIME$) in between testing the
two Forth versions as there's not enough room in memory for both those arrays.

The Basic code presented here is based on the Basic code for the Sieve as
published in the Byte article mentioned above. The Forth code is original. I
coded it from scratch since the Forth code in the Byte article does not work.

Tim Ekdom 72575,1473
March, 1986


0 ' Mini-Sieve Benchmark
1 DEFINT A-Z:SZ=4095:DIM FL(SZ):CT=0
2 CLS:PRINT:PRINT"Mini-Sieve in Basic"
3 PRINT"Hit a key to start"
4 A$=INKEY$:IF A$="" THEN 4
5 PRINT "Started at ";TIME$
6 FOR I=0 TO SZ:FL(I)=1:NEXT I
7 FOR I=0 TO SZ
8 IF FL(I)=0 THEN 16
9 PR=I+I+3
10 K=I+PR
11 IF K>SZ THEN 15
12 FL(K)=0
13 K=K+PR
14 GOTO 11
15 CT=CT+1
16 NEXT I
17 BEEP:PRINT "Stopped at ";TIME$
18 PRINT USING "#### \    \";CT;"primes"


32
( MINI-SIEVE #1 )

FORTH DEFINITIONS DECIMAL

: TIME$  ( print system clock )
         ( -> )
    0 0 0 PAD 6415 CALL DROP DROP DROP DROP PAD 8 TYPE ;


( Mini-Sieve declarations )

4096 CONSTANT SIZE  0 VARIABLE PCOUNT
0 VARIABLE PRIME    0 VARIABLE FLAGS SIZE 1 - 2 * ALLOT

-->

33
( MINI-SIEVE #1 )

: MINI-SIEVE#1  ( with integer array )
                ( -> )
    12 EMIT CR
    ." Mini-Sieve in Forth #1" CR
    ." Hit a key to start" KEY DROP CR
    ." Started at " TIME$ CR

    SIZE 0 DO
      1 FLAGS I 2 * + !
    LOOP

-->


34
( MINI-SIEVE #1 )

    SIZE 0 DO
      FLAGS I 2 * + @ IF
        I DUP + 3 + DUP PRIME ! I +
        BEGIN DUP SIZE < WHILE
          DUP 2 * 0 FLAGS ROT + ! PRIME @ +
        REPEAT
        DROP 1 PCOUNT +!
      ENDIF
    LOOP

    7 EMIT ." Stopped at " TIME$ CR
    PCOUNT @ . ." primes" CR ;

;S      ( 3/23/86 #4 )
35
( MINI-SIEVE #2 )

FORTH DEFINITIONS DECIMAL

: TIME$  
    0 0 0 PAD 6415 CALL DROP DROP DROP DROP PAD 8 TYPE ;


4096 CONSTANT SIZE  0 VARIABLE PCOUNT
0 VARIABLE PRIME    0 VARIABLE FLAGS SIZE 2 - ALLOT

-->




36
( MINI-SIEVE #2 )

: MINI-SIEVE#2  ( using byte array )

    12 EMIT CR
    ." Mini-Sieve in Forth #2" CR
    ." Hit a key to start" KEY DROP CR
    ." Started at " TIME$ CR

    FLAGS SIZE 1 FILL

-->




37
( MINI-SIEVE #2 )

    SIZE 0 DO
      FLAGS I + C@ IF
        I DUP + 3 + DUP PRIME ! I +
        BEGIN DUP SIZE < WHILE
          DUP 0 FLAGS ROT + C! PRIME @ +
        REPEAT
        DROP 1 PCOUNT +!
      ENDIF
    LOOP

    7 EMIT ." Stopped at " TIME$ CR
    PCOUNT @ . ." primes" CR ;

;S      ( 3/23/86 #2 )
