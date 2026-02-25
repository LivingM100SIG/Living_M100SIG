10 'Machine Language Oval Routine T200
12 'See Lib-06-GRAPHICS-MUSIC/OVAL.DOC
15 'James Yi  24-Sep-88
17 IF PEEK(1)<>171 THEN PRINT"Tandy 200 only.": END
20 DEFINT A-Z
30 TP=-1960: LN=378: EX=-1960
40 GOSUB 13000
50 PRINT "See OVAL.DOC for usage."
90 END
13000 'Decode ML
13010 CLS:Q=0:H$=CHR$(13)
13020 ?"     / 377 OVAL.CO at 63576";
13030 READP$:FORX=1TOLEN(P$):a$=MID$(P$,X,1)
13040 if a$="!" then if e=1 then 13090: else e=1: goto 13070
13050 v=asc(a$): if e=1 then v=v-128: e=0
13060 ?H$q;:POKEQ+TP,v:Q=Q+1
13070 NEXT:GOTO13030
13090 RETURN
14000 'OVAL.CO
14010 DATA"!¢Îùî!‚2Ðù*Vø!¢Ìù!¢Áù|2Àù½Òsø?}2Ñù2¿ù!Ÿ,!¢Êù$!¢Èùog2Åù!¢Ãù!¢Æù¯2Âùog!¢½ù<2Èù2Ëù*Èù:Ðù!:½ùOÚÕø•_:ÀùG”³`i!¢ÈùÄŽù*Êù:ÁùO•_:¾ùG”³`i!¢ÊùÄ
14020 DATA"ŽùÃòø½2Èù:ÀùGÄYù*Êù:ÁùO½2Êù:¾ùGÄYù*Ìùë!¡Âù!½ù4#~“wÒ!Œù:Ñù†w!Š<!‚#!ƒ~’wÒ!œù:Ñù†w!Š<!‚#:Âù–/<wÚø!ƒ!Š=!‚<†w#!ƒ~’wÒ>ù:Ñù†w!Š=!‚#!ƒ~“wÒNù:Ñ
14030 DATA"ù†w!Š=!‚:¿ù!¡Âù¾ÒøÉ*Îù|€WÚgùþðÚiù!–ï|bWÒrù!–!€}‘_Ô‚ù}Øþ€Ð_Ã‚ùÕÍ°ùz!”¼ÂƒùÑÉ*Îù}‘_Ô›ù}Ø_|WÔ¨ù|€WÒ¨ùÉzþðÐ{þ€Ð:Ðùæ!‚åÕÍxÑáÉ!€!€!€
14040 DATA"!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!!

