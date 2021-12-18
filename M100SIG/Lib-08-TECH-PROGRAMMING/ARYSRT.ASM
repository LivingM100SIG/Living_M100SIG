;ARYSRT.ASM  (c)1991 Wilson Van Alst
;v1.0          All rights reserved.
;
;An asm bubble-sort routine for fixed-
; length elements that are contiguous
; in memory.  On entry, the A register
; has the number of elements to be
; sorted, and HL points to the first
; element.

;Can be used to sort numeric arrays
; in BASIC, as shown in the example
; programs below.

len     equ 8       ;element length
el1     equ lod1+1  ;runtime pointer
el2     equ lod2+1  ;runtime pointer
dummy   equ 0ffffh  ;dummy value,
                    ; modified at
                    ; runtime

CALL    org 64800   ;M100/102
                    ;CALL address
;CALL   org         ;T200 CALL adrs

        inr a           ;A=#of elements
;[above instruction is for the BASIC
; array sort only, where an array of
; dim(n) has (n+1) elements]

	mov c,a		;set lup1 count

;outer loop sets pointer to "element 1"

lup1    dcr c           ;do c-1 times
	rz
	shld el1	;store ^elmnt1
	mov b,c		;set lup2 count

;inner loop looks for any element
; smaller than "element 1" and, if
; found, makes a swap:

lup2    lxi d,len       ;set HL...
	dad d		;...^next elmnt
	shld el2	;store ^elmnt2
	push b		;save count
	call compar	;elmnt2<elmnt1?
	cc swap		;yes:swap
	pop b		;B,C=lup count
	lhld el2	;HL^elmnt2
	dcr b		;inner lup
	jnz lup2	; for b


;now set outer-loop pointer to the
; next "element 1" and execute again:

        lhld el1        ;HL^elmnt1
        lxi d,len       ;set HL...
	dad d		; ^next element
	jmp lup1


;compare two elements of size c
; return with CY flag set if element
; 2 is smaller than element 1:

compar  mvi c,len       ;check 8 bytes
lod1	lxi h,dummy	;HL^elmnt1
lod2	lxi d,dummy	;DE^elmnt2
mocomp	ldax d		;A=(elmnt2)
	cmp m		;(el2)-(el1)
	rnz		;if different
	inx h		;else bump...
	inx d		; pointers and
	dcr c		;  check more
	jnz mocomp
	ret

;swap two memory blocks of size c:

swap    mvi c,len       ;swap 8 bytes
	lhld el2	;set ...
	xchg		; ..DE^elmnt2
	lhld el1	;HL^elmnt1
moswap	ldax d		;perform...
	mov b,a		; ...
	mov a,m		;  ...
	mov m,b		;   ...
	stax d		;    ...swap
	inx h		;bump...
	inx d		; pointers
	dcr c		;loop for...
	jnz moswap	;  8 bytes
	ret



The following two programs poke the above ASM code to addresses in the
AltLCD buffer and use the routine to sort a double-precision BASIC
array.  Note that the array elements must be double precision positive
numbers (i.e., >=0).  Negative numbers, if present, will sort "higher"
than positive numbers.

0 'ARYSRT.100  (c)1991 W. Van Alst
1 'v1.0        All rights reserved.
2 '
9 'Poke the sort routine to AltLCD:
10 forr=64800to64878:ready:poker,y:next
11 data 60,79,13,200,34,75,253,65
12 data 17,8,0,25,34,78,253,197
13 data 205,72,253,220,90,253,193,42
14 data 78,253,5,194,40,253,42,75
15 data 253,17,8,0,25,195,34,253
16 data 14,8,33,255,255,17,255,255
17 data 26,190,192,35,19,13,194,80
18 data 253,201,14,8,42,78,253,235
19 data 42,75,253,26,71,126,112,18
20 data 35,19,13,194,99,253,201
21 '
99 'Give it something to sort:
100 n=20:dimx(n)
110 fori=0ton:x(i)=100*rnd(1):next
111 '
119 'Sort it:
120 call64800,n,varptr(x(0))
121 '
129 'Display sorted data:
130 fori=0ton:printx(i):next



0 'ARYSRT.200  (c)1991 W. Van Alst
1 'v1.1         All rights reserved.
2 '
8 'Poke the sort routine to AltLCD:
9 forr=63574to63652:ready:poker,y:next
10 data 60,79,13,200,34,132,248
11 data 65,17,8,0,25,34,129
12 data 248,197,205,126,248,220,144
13 data 248,193,42,129,248,5,194
14 data 94,248,42,132,248,17,8
15 data 0,25,195,88,248,14,8
16 data 17,0,0,33,0,0,26
17 data 190,192,35,19,13,194,134
18 data 248,201,14,8,42,129,248
19 data 235,42,132,248,26,71,126
20 data 18,112,35,19,13,194,153
21 data 248,201
99 'Give it something to sort:
100 n=20
110 fori=0ton:x(i)=100*rnd(1):next
120 'Sort it:
130 call63574,n,varptr(x(0))
140 'Display:
150 fori=0ton:printx(i):next


