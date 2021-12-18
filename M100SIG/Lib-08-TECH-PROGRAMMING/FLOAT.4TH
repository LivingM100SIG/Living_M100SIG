
    Floating Point Math for fig-Forth


        Thanks to the Model 100's ROM, it's relatively painless to 
    implement floating point operations in fig-Forth. The basic scheme
    is to store variables in floating point format and to convert them
    to and from ASCII text format as necessary. Here's the method:

    1.  For each floating point variable, allot eight bytes of
        memory for the variable to be stored in double-precision
        floating point format. For example: 0 VARIABLE VARNAME 6 ALLOT

    2.  You also need at least one buffer for conversion of floating
        point to ASCII and ASCII to floating point. This buffer requires
        18 bytes -- 14 digits, a sign, a decimal point, and a few null 
        bytes. For example: 0 VARIABLE BUFFER 16 ALLOT

    3.  Input numbers as text or as integers and convert them to
        floating point.

    4.  Perform the floating point operations.

    5.  Convert the desired results back to text for output.

        Here are the floating point operators and conversion words
    you'll need to use, along with stack diagrams:

    ASC->FP  ( var/addr buff/addr --- )  convert ASCII text at buff/addr
             to floating point format stored at var/addr.

    INT->FP  ( var/addr int --- )  convert integer value on top of stack
             into floating point format stored at var/addr.

    FP->INT  ( var/addr --- int )  convert floating point format number
             stored at var/addr into an integer left on the stack.

    FP->ASC  ( var/addr buff/addr --- buff/addr count )  convert
             floating point format number at var/addr into ASCII text
             stored at buff/addr, and leave the buffer address and
             character count on the stack suitable for TYPE.

    FP+      ( var1/addr var2/addr var3/addr -- )  add var2 and var3
             and leave the sum in var1.

    FP-      ( var1/addr var2/addr var3/addr --- )  subtract var3 from
             var2 and leave the difference in var1.

    FP*      ( var1/addr var2/addr var3/addr --- )  multiply var2 and
             var3 and leave the product in var1.

    FP/      ( var1/addr var2/addr var3/addr --- )  divide var2 by var3
             and leave the quotient in var1.

    FPSQR    ( var1/addr var2/addr --- )  find the square root of var2
             and leave it in var1.

    FP<=>    ( var1/addr var2/addr --- fl )  compare var1 and var2 and
             leave a flag on the stack as follows:
                 if fl = -1 then var1 > var2
                 if fl =  0 then var1 = var2
                 if fl = +1 then var1 < var2

        Another definition that may come in handy is 0BUFF ( buff/addr
    --- ) which clears an 18 byte wide buffer. I suggest clearing your
    buffer prior to entering text into it.

        Cut and paste screens 50-56 and install on your Forth disk with
    HELPER.BA, and to test the floating point words, cut and paste screens
    60-62 and install. Type 50 LOAD 60 LOAD and the demo will run.

        A couple things to know: FPSQR and FP->INT do no bounds checking,
    so they will crash on a negative number and a number over 65535,
    respectively. To test other numbers you may want to excise these
    two from the test source code and re-compile. Also, for some reason
    I haven't yet discovered, numbers smaller than .01 are printed in E
    notation. If someone knows a way around this, please let me know.
    Finally, whole numbers need to be entered with a decimal point
    (e.g. 1000. or 1000.0). A little definition to insert a decimal
    in your "number" string will fix that. I can't guarantee there
    aren't any bugs in here, but other than the above qualifications,
    the system seems to work pretty well. Please let me know if you
    encounter a problem and what you suggest to fix it.

        These proposals are just the bare minimum for a floating point
    system. Using the same techniques and the M-100 ROM routines, you
    should be able to extend this to cover trigonometric functions
    and/or change it to single precision, if you desire. What we could
    also use is a volunteer who would like to try his/her hand at some
    formatting definitions for FP number display.

    Tim Ekdom 72575,1473
    April, 1986

    PS: you might also find the definition for the stack operator PICK
    to come in handy in other applications.


 50 
( Floating Point Math )
FORTH DEFINITIONS HEX
 
: PICK    ( copy nth stack item )
          ( n --- )
    2 * SP@ + @ ;
 
: HLSET   ( set up registers for call )
          ( hl --- 0 0 0 hl )
    0 0 ROT 0 SWAP ;
 
: 4DROP   ( drops all registers )
          ( n n n n --- )
    DROP DROP DROP DROP ;
-->
( 4/6/86 #2 )
 51 
( Floating Point Math )
: 0BUFF   ( fill buffer with nulls )
          ( buff/addr --- )
    12 ERASE ;
 
: 0FPA1   ( fill FP accum #1 with nulls )
          ( --- )
    FC18 8 ERASE ;
 
: 0FPA2   ( fill FP accum #2 with nulls )
          ( --- )
    FC69 8 ERASE ;
 
: 0VAR    ( fill variable with nulls )
          ( var/addr --- )
    8 ERASE ; --> ( 4/7/86 #2 )
 52 
( Floating Point Math )
 
: ->FPA1  ( move var to FP accum #1 )
          ( var/addr --- )
    0FPA1 HLSET 31C4 CALL 4DROP ;
 
: ->FPA2  ( move var to FP accum #2 )
          ( var/addr --- )
    0FPA2 HLSET 31B8 CALL 4DROP ;
 
: FPA1->  ( move FP accum #1 to var )
          ( var/addr --- )
    DUP 0VAR HLSET 31CA CALL 4DROP ;
 
-->
( 4/7/86 #1 )
 53 
( Floating Point Math )
: ASC->FP  ( convert ASCII to FP format )
           ( var/addr buff/addr --- )
    0FPA1 HLSET 3840 CALL 4DROP
    DUP 0VAR FPA1-> 8 FB65 ! ;
 
: INT->FP  ( convert integer to FP format )
           ( var/addr int --- )
    0FPA1 HLSET 3543 CALL 4DROP
    DUP 0VAR FPA1-> 8 FB65 ! ;
 
: FP->INT  ( convert FP to integer )
           ( var/addr --- int )
    0FPA1 ->FPA1 0 HLSET 3501 CALL >R DROP DROP DROP R> ;
-->
( 4/7/86 #1 )
 54 
( Floating Point Math )
 
: FP->ASC  ( convert FP to ASCII )
           ( var/addr buff/addr --- buff/addr count )
    8 FB65 ! 0FPA1 DUP 0BUFF SWAP ->FPA1
    DUP HLSET 39EC CALL 4DROP
    DUP C@ 0= IF DUP 20 SWAP C! ENDIF
    13 1 DO
      DUP I + C@ 0= IF I LEAVE ENDIF
    LOOP ;
 
: FP+  ( FP addition )
       ( var1/addr var2/addr var3/addr --- )
    ->FPA2 ->FPA1 0 HLSET 2B78 CALL 4DROP FPA1-> ;
-->
( 4/7/86 #2 )
 55 
( Floating Point Math )
 
: FP-  ( FP subtraction )
       ( var1/addr var2/addr var3/addr --- )
    ->FPA2 ->FPA1 0 HLSET 2B69 CALL 4DROP FPA1-> ;
 
: FP*  ( FP multiply )
       ( var1/addr var2/addr var3/addr --- )
    ->FPA2 ->FPA1 0 HLSET 2CFF CALL 4DROP FPA1-> ;
 
: FP/  ( FP divide )
       ( var1/addr var2/addr var3/addr --- )
    ->FPA2 ->FPA1 0 HLSET 2DC7 CALL 4DROP FPA1-> ;
-->
 
( 4/6/86 #3 )
 56 
( Floating Point Math )
 
: FPSQR  ( FP square root )
         ( var1/addr var2/addr --- )
    ->FPA1 0 HLSET 305A CALL 4DROP FPA1-> ;
 
: FP<=>  ( Compare two FP numbers )
         ( var1/addr var2/addr --- fl )
    ->FPA2 ->FPA1 0 HLSET 34FA CALL DROP DROP DROP
    FF00 AND 100 / ;
 
DECIMAL  ;S
 
 
 
( 4/6/86 #3 )
 60 
( Test of Floating Point Math )
 
0 VARIABLE NUM1 6 ALLOT   0 VARIABLE NUM2 6 ALLOT
0 VARIABLE NUM3 6 ALLOT   0 VARIABLE BUFF 16 ALLOT
 
: RUN 12 EMIT
   BEGIN
     BUFF 0BUFF  ( Clear out text buffer )
     CR ." Enter first number:  " BUFF 15 EXPECT
     ( Input the number in ASCII )
     NUM1 BUFF ASC->FP  ( Convert it to floating point )
     BUFF 0BUFF
     CR ." Enter second number: " BUFF 15 EXPECT
     NUM2 BUFF ASC->FP
-->
( 4/6/86 #2 )
 61 
( Test of Floating Point Math )
 
     CR ." Adding            = " NUM3 NUM1 NUM2 FP+  ( Add )
     NUM3 BUFF FP->ASC TYPE  ( Convert result to ASCII & type )
     CR ." Subtracting       = " NUM3 NUM1 NUM2 FP-
     NUM3 BUFF FP->ASC TYPE
     CR ." Multiplying       = " NUM3 NUM1 NUM2 FP*
     NUM3 BUFF FP->ASC TYPE
     CR ." Dividing          = " NUM3 NUM1 NUM2
     FP/ NUM3 BUFF FP->ASC TYPE
     CR ." Square root  (#1) = " NUM3 NUM1 FPSQR
     NUM3 BUFF FP->ASC TYPE
     CR ." Integer part (#1) =  " NUM1 FP->INT .
-->
 
( 4/6/86 #3 )
 62 
( Test of Floating Point Math )
 
     CR ." Comparing:           " NUM1 NUM2 FP<=>
     DUP 0 < IF ." #1 > #2"
       ELSE DUP 0= IF ." #1 = #2"
         ELSE DUP 0 > IF ." #1 < #2 " ENDIF ENDIF ENDIF DROP
     CR ." Again? " KEY 89 =
   WHILE REPEAT ;
 
DECIMAL RUN ;S
 
 
 
 
 
( 4/7/86 #1 )
