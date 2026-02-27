10 MAXFILES=0: CLEAR 10, 60323: NM$="ADMINS.CO"
20 DEFINT A-Z
30 TP=-5213: LN=777: EX=-5213
40 GOSUB 13000
50 IF PEEK(1)<>148 THEN CALL EX ELSE EXEC EX
90 END
13000 'Decode ML
13010 CLS:Q=0:E=0:H$=CHR$(13)
13020 ?"     /"LN-1"Loading "NM$" at"TP+65536;
13030 READP$:FORX=1TOLEN(P$):a$=MID$(P$,X,1)
13040 if a$="!" then if e=1 then 13090: else e=1: goto 13070
13050 v=asc(a$): if e=1 then v=v-128: e=0
13060 ?H$q;:POKEQ+TP,v:Q=Q+1
13070 NEXT:GOTO13030
13090 ?:RETURN
14000 'ADMINS.CO
14010 DATA"!‘!Ÿ!AD*îô!”ßÚşëåí!ˆáÂ¬ë!“!“!šG‚”!¡£íÂñìÍ!ƒí!‘sò!¡Mƒ!†!ƒÅåÕ!!†!¡áí!“!“!“Í!‘nÑáÊòë!!‹!€	ë	ëÁ!…ÂĞëÃøëÁ!†!‹Í§2!¡›íÃÔìÕÍâì!¡áíÊñìÕ!¡üíÍg!!‹!€ÄEOÍ÷!’çÖ1
14020 DATA"!¡sòÊ5ì	=Ê5ì	=Ê5ì=Â!’ì!¡ôíÃÔì!¢ÇìáÍ¡A##!¢xîáÅÕÅåë!¢ûô	+!¢ıô!¡!„!	.!€|åÍ!ƒíÁÑ!¡ADÙ!“!“x!’!“*xî	ÁÕÍ!–ƒáÁ!ˆ!¢vî	T]Á	Õå!šÕÍ4íÑ!“ş!ƒÚìíDM*ûô!ˆÒì*ı
14030 DATA"ô!ˆÚì*vî	Ù!“ş!‚Ô‡UáßÒzì*vîDM!‘zîí|µÊÂì	Õëí	ÙÑ!“!“Ã°ìá!¢ßí!‘sò!¡Şí!†	Í§2!¡‘íÍgÍO >!Í!”bÃ¤g!¡áí!‘F÷Í¥2Íb,Ã¦+ÍgÍEOÍ÷!’Ã¤g!¡~íÃñì*îô„W”G!
14040 DATA"!€iÒ!œíÅ|’GbÍÚ‚ÁÃ#íÍ¨‚Úıì	:bö€2bö|2ïôÖ 2!€ Éş@ÚCíÖÀÒAí>!ÉÆ@_æ!ƒG{¨!Ÿ!Ÿ!¡^í_!–!€!™~!‡!‡!!!…òUíæ!ƒÉ]eUe]eUe}eve}eveõguoµgµougugµguoInsuf
14050 DATA"fient memory !€Installed!€Removed!€Cannot remove - The LOMEM configuration has changed.!€ADMINS°!€!€ADSM  .CO missing !€Aborted
14060 DATA"!€Choose in place of which one of these   ADSM is to be installed.!!Š1) ADDRSS!!Š2) SCHEDL!!Š3) MSPLAN!!Š4) I change my mind!
14070 DATA"!Š?!€!€!€!€!€!…ë!Šë!”ë*ë2ëJëPë^ëdëjëtë‰ëë™ë¦ë¬ë¯ë¸ëÁë!€ì	ì9ìBì­í!€!€!!
