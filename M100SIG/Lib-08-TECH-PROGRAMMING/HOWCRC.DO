This file describes how to do CRC(Cyclic Redundancy Check)
 in 8085 assembly language.
It does not tell everything there is to know about CRC, but just shows how it
 can be implemented.


Xmodem CRC-16:

Fact - CRC is more reliable than checksum.

The following are two different 8085 opcode implementations of the CRC checking
 algorithm used in Xmodem-CRC.

The first one is the bit-by-bit method.  For each byte, CRC is calculated one
 bit at a time.


;DE=begin of data block
;BC=length of data block
;HL=CRC ( 0000H initially )

crck:	lxi	h,0000h	;initialize CRC
;do CRC for the block
cr1:	ldax	d	;get byte
	push	d
;do CRC for one byte
	xra	h
	mov	h,a
	mvi	e,8	;bit counter
cr2:	dad	h
	jnc	cr3
	mov	a,h
	xri	$10
	mov	h,a
	mov	a,l
	xri	$21
	mov	l,a
cr3:	dcr	e
	jnz	cr2
;get next byte
	pop	d
	inx	d
;until done
	dcx	b
	mov	a,b
	ora	c
	jnz	cr1
;Return with CRC in HL register
	ret



The next one is the table lookup method.  It is faster than the first method,
 because it does CRC on a whole byte at a time, instead of bits.
For each byte, it looks up the table of CRC values that would have resulted if
 it were done bit-by-bit.


;DE=begin of data block
;BC=length of data block
;HL=CRC (0000H initially)

crck:	lxi	h,0000h	;initialize CRC
;do CRC on the block
cr1:	ldax	d	;get byte
	push	d
;do CRC on the byte
	xra	h
	mov	e,a
	mvi	d,0
	mov	a,l
	lxi	h,crctab ;See below
	dad	d
	dad	d
	xchg
	lhli
	xra	h
	mov	h,a
;get next byte
	pop	d
	inx	d
;until done
	dcx	b
	mov	a,b
	ora	c
	jnz	cr1
;Return with CRC in HL register
	ret

crctab:	ds	512

;CRC Table
;contains 2 byte CRC value for each of
; 256 different bytes

;  Each entry is the
; bit-by-bit CRC on bytes 0 to 255,
; with 0000h as initial CRC,
; initialized for each byte.
;  The following routine builds the table.

build_crct:
	lxi	d,crctab ;table location - table size is 512 bytes.
	mvi	b,0	;for 0 to 255
bt1:
;do CRC on each byte
	mov	h,b
	mvi	l,0
	mvi	c,8	;bit counter
bt2:	dad	h
	jnc	bt3
	mov	a,h
	xri	$10
	mov	h,a
	mov	a,l
	xri	$21
	mov	l,a
bt3:	dcr	c
	jnz	bt2
;put CRC into table
	shli
;do next CRC
	inx	d
	inx	d
;until done
	inr	b
	jnz	bt1
	ret



I did a CRC check on my 200's standard ROM, and it came out to be 18828, or
 498CH in hexadecimal.  Hope mine is ok.
It took 7.5 seconds using the bit-by-bitmethod, 2.16 seconds with the table
 lookup method, which is about 3 1/2 times faster.

LHLI and SHLI are undocumented opcodes.  LHLI loads HL with the two bytes at
 the address pointed to by DE.  SHLI stores instead of loading.

