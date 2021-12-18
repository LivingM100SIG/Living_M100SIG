;**************************************
;* STIMES.ASM                         *
;* (c) 1990 by Tracy Allen 76670,326  *
;* creates 49 timers that operate in  *
;* in sync with the background task.  *
;* Each of the 49 clocks count time   *
;* elapsed from 0 to 65536            *
;* That's 18.2 hrs if seconds is unit *
;*                                    *
;* syntax for BASIC CALL:             *
;* CALL 62740,N%'E enables timer hook *
;*   and sets all timers to 0.        *
;*   use N% as count modulus          *
;*   value  N%=0 counts by seconds    *
;*          N%=128 counts by 1/2 secs *
;*          N%=64 counts by 1/4 secs  *
;*          N%=32 counts by 1/8 secs  *
;*          N%=16 by 1/16             *
;*          N%=8 by 1/32              *
;*          N%=4 by 1/64              *
;*          N%=2 by 1/128             *
;*          N%=1 by 1/256   seconds   *
;* POKE 62975,201  disables timer hook*
;* CALL 62740,N%,X%'S     sets N%th   *
;*                 timer to value X%  *
;* CALL 62740,N%,varptr(X%)'G    gets *
;*                 current time from  *
;*                 timer number N%, & *
;*                 returns value in X%*
;**************************************
;
	org 62740
timers:	mov b,a
	ldax d
	cpi ':'
	rnz
	inx d
	inx d
	ldax d
	cpi 255
	rnz
	inx d
	ldax d
	cpi 'G'
	jz wtget	;G, get timer N
	cpi 'S'
	jz wtrst	;S, set timer N
	cpi 'E'
	jz warm	;E enable timing hook
	ret
;
;
;E warm arms the timers, attches to
;background timer hook
;entry A  sets count modulus
;all timers zeroed
Warm:	mov a,b
	sta watch+10
	lxi h,watch
	shld thook+1
	mvi a,195
	sta thook
Wrst:	xra a	;zeros all watches
	mvi b,63h	;63h=99d length
	lxi h,Wttick	;watch buffer
wrst1:	mov m,a	
	inx h
	dcr b
	rz
	jmp wrst1
;
;
;G get Nth timer value
;  syntax CALL watchs,N,varptr(X%)'G
;  1<=N<=49 & X% is integer variable
Wtget:	mov a,b
	push h
	lxi d,wttick-1
	rlc	;multipy * 2
	add e	;to calculate address
	mov e,a
	xra a
	adc d
	mov d,a
	lhli	;get time
	pop d
	shli	;store in variable
	ret
;
;
;S set the Nth timer to value X%
;  call watchs,N,X%'S
Wtrst:	mov a,b
	cpi 50	;only allow 1-49
	rnc
	lxi d,wttick-1
	rlc	;multipy A * 2
	add e
	mov e,a
	xra a
	adc d
	mov d,a
	shli	;set watch
	ret
;
;
;
;watch subroutine is the business end 
;of the multiple watches.  It is 
;executed 256 times per second to keep
;all the watches current.
thook:	equ 62975	;time hook
;
;
wttick:	db 0
wt1:	ds 98
;WT1 to WT49, 2-byte timers
;
Watch:	push psw	;runs
	push h	;from CCK hook
	lxi h,wttick
	dcr m
	jnz watchx	;not time
	mvi a,0	
	sta wttick
	mvi a,31h	;31h=49d watchs
watcht:	inx h	;next watch low byte
	inr m	;tick
	inx h	;high byte
	jnz watcha	;no carry
	inr m	;carry tick hi byte
watcha:	dcr a	;more watchs?
	jnz watcht	;yes
watchx:	pop h	;exit to bkgrnd task
	pop psw
	ret	;to background task
