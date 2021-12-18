( CALC.4TH )
( Copyright 1988 Bill Boyd  75715,70 )

( This program may be distributed )
( freely, but may not be sold for )
( profit. )

( This file contains a group of words )
( to implement floating point math )
( operations for RAM4TH for the )
( Model 100. )

( Delete the comments [delineated by )
( parentheses] if memory space for )
( the source file is a problem. )

( This floating point implementation )
( has a 4-level floating point stack )
( like HP calculators.  Any number )
( typed into RAM4TH which contains a )
( decimal point will be interpreted )
( as a floating point number.  This )
( causes the stack to be lifted and )
( the number to be put into the X )
( register.  Floating point numbers )
( have the same representation and )
( range as BASIC's double precision )
( variables. )

( Display control:  There are three )
( types, only one of which is active )
( at a time. n FIX causes fixed-point )
( display with n digits to right of )
( decimal, n SCI displays a mantissa )
( with n+1 significant digits and an )
( exponent, and n ENG is like n SCI )
( except that the exponent is always )
( a multiple of 3. )

( Example of adding two numbers and )
( displaying the result: )
( 3 FIX 2.15 3.68 F+ F. )

( Other RAM4TH words for floating- )
( point operations: )
(  FENTER FVARIABLE )
( See RAM4TH.GLS for definitions )

 BASE @ ( save current base on stack )
 HEX
 CR ." STO"
: STO ( addr -- )
 ( copies X register to fvar at addr )
 X SWAP FMOVE
;
 CR ." RCL"
: RCL ( addr -- )
 ( lift stack and bring fvar at addr )
 ( into X register )
 FENTER
 X FMOVE
;
 ( Example of using fvariable: )
 ( FVARIABLE FVAR creates )
 ( FVAR STO puts value of X into it )
 ( FVAR RCL gets value back in
 CR ." RDN"
: RDN ( -- )
 ( roll floating point stack down )
 XU STO ( store X away temporarily )
 Y X FMOVE
 Z Y FMOVE
 T Z FMOVE
 XU T FMOVE
;
 CR ." RUP"
: RUP ( -- )
 ( Rotate floating point stack up )
 XU STO
 T X FMOVE
 Z T FMOVE
 Y Z FMOVE
 XU Y FMOVE
;
 CR ." FDROP"
: FDROP ( -- )
 ( drop floating point stack )
 RDN Z T FMOVE
;
 CR ." FPA1" ( floating point accum 1 )
 ( used by ROM math routines )
0FC18 CONSTANT FPA1
 CR ." FPA2" ( floating point accum 2 )
 ( used by ROM math routines )
0FC69 CONSTANT FPA2
 CR ." X->A1"
: X->A1 ( -- )
 ( copies X register into FPA1 )
 X FPA1 FMOVE
 8 0FB65 C! ( set double precision )
;
 CR ." Y->A1"
: Y->A1 ( -- )
 ( copies Y register into FPA1 )
 Y FPA1 FMOVE
 8 0FC65 C! ( set double precision )
;
 CR ." X->A2"
: X->A2 ( -- )
 ( copies X register into FPA2 )
 X FPA2 FMOVE
;
 CR ." A1->X"
: A1->X ( -- )
 ( copies FPA1 into X register )
 FPA1 X FMOVE
;
 CR ." 2PARM"
: 2PARM ( adr -- )
 ( Does operation of two operands )
 ( using ROM routine at adr )
 X->A2 Y->A1 CALLX FDROP A1->X
;
 CR ." F+"
: F+ ( -- )
 ( add numbers in X and Y register )
 2B78 2PARM
;
 CR ." F-"
: F- ( -- )
 ( subtract X from Y )
 2B69 2PARM
;
 CR ." F*"
: F* ( -- )
 ( multiply X by Y )
 2CFF 2PARM
;
 CR ." F/"
: F/ ( -- )
 ( divide Y by X )
 2DC7 2PARM
;
 CR ." Y^X"
: Y^X ( -- )
 ( Raise Y to the Xth power )
 ( Note that the ROM routine changes )
 ( the variable type sometimes, so )
 ( this restores the number to double )
 X->A2 Y->A1
 3D8E CALLX
 35BA CALLX ( convert result to double)
 FDROP A1->X
;
 CR ." DSPBOUND"
: DSPBOUND ( n1 -- n2 )
 ( Return n2, between 0 and 13 )
 ( Clips n1 to valid number of digits )
 0 MAX 0D MIN
;
 CR ." FMODE"
0 VARIABLE FMODE ( 0=FIX, 1=SCI, 2=ENG)
 CR ." NUMDIG"
0 VARIABLE NUMDIG
 CR ." FIX"
: FIX ( n -- )
 ( Set disp mode to n digits after )
 ( decimal )
 DSPBOUND NUMDIG !
 0 FMODE !
;
 CR ." SCI"
: SCI ( n -- )
 ( Scientific notation, n digits after)  ( decimal )
 DSPBOUND NUMDIG !
 1 FMODE !
;
 CR ." ENG"
: ENG ( n -- )
 ( Set mode to engineering, number of )
 ( digits to n+1 )
 DSPBOUND NUMDIG !
 2 FMODE !
;
 CR ." FSTR$"
: FSTR$ ( -- addr n )
 ( Puts string rep of number in X at )
 ( PAD )
 X->A1
 FMODE @ NUMDIG @ PAD F$CODE
;
 CR ." F."
: F. ( -- )
 ( print FP representation of X )
 FSTR$ TYPE SPACE
;
 CR ." 1PARM"
: 1PARM ( adr -- )
 ( copy X to A1, call routine at adr, )
 ( then copy A1 to X )
 X->A1 CALLX A1->X
;
 CR ." SQRT"
: SQRT 305A 1PARM ;
 CR ." LN"
: LN 2FCF 1PARM ;
 CR ." E^X"
: E^X 30A4 1PARM ;
 CR ." COS"
: COS 2EEF 1PARM ;
 CR ." SIN"
: SIN 2F09 1PARM ;
 CR ." TAN"
: TAN 2F58 1PARM ;
 CR ." ATAN"
: ATAN 2F71 1PARM ;
 CR ." FCOMP"
: FCOMP ( -- f )
 ( Compare two floating point numbers )
 ( in the fp accumulators. Returns -1 )
 ( if FPA2<FPA1, 0 if equal, and 1 if )
 ( FPA2>FPA1. )
 0 0 0 0 34FA CALL
 DROP DROP DROP
 DUP 0 < IF
  DROP -1
 ELSE ( not <0 )
  0100 < IF
   0
  ELSE ( >= 0100, so reg A has 01 )
   1
  THEN ( checked against 0100 )
 THEN ( sign of result checked )
;
 CR ." XYCOMP"
: XYCOMP ( -- f )
 ( Compares the fp numbers in X & Y )
 Y->A1 X->A2
 FCOMP
;
 CR ." REAL0"
FVARIABLE REAL0 ( -- adr )
0.0 REAL0 STO
 CR ." 0COMP"
: 0COMP ( -- f )
 ( Compares number in X to zero )
 REAL0 FPA1 FMOVE
 X->A2
 FCOMP
;
 CR ." X=0?"
: X=0? ( -- f )
 ( Returns f true if the X register )
 ( contains 0.0; f is 0 if X<>0.0 )
 0COMP
 0=
;
 CR ." X<>0?"
: X<>0? ( -- f )
 ( Returns 0 flag if the X register )
 ( contains 0.0; f is true otherwise )
 X=0?
 0=
;
 CR ." X>0?"
: X>0? ( -- f )
 ( Returns f true if X>0.0; else f=0 )
 0COMP
 1 =
;
 CR ." X<=0?"
: X<=0? ( -- f )
 ( Returns f true iff X is <= 0 )
 X>0? 0=
;
 CR ." X<0?"
: X<0? ( -- f )
 ( Returns f true iff X is negative )
 0COMP
 -1 =
;
 CR ." X>=0?"
: X>=0? ( -- f )
 ( Returns f true iff X is >=0 )
 X<0? 0=
;
 CR ." X=Y?"
: X=Y? ( -- f )
 ( Returns f true iff X and Y are same)
 XYCOMP
 0=
;
 CR ." X<>Y?"
: X<>Y? ( -- f )
 ( Returns f true iff X not equal to Y)
 X=Y? 0=
;
 CR ." X>Y?"
: X>Y? ( -- f )
 ( Returns f true iff X > Y )
 XYCOMP
 1 =
;
 CR ." X<Y?"
: X<Y? ( -- f )
 ( Returns f true iff X < Y )
 XYCOMP
 -1 =
;
 CR ." X>=Y?"
: X>=Y? ( -- f )
 ( Returns f true iff X >= Y )
 X<Y? 0=
;
 CR ." X<=Y?"
: X<=Y? ( -- f )
 ( Returns f true iff X <= Y )
 X>Y? 0=
;
 CR BASE ! ( restore original base )
