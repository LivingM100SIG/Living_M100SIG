0 'ADSM.CO and ADMINS.CO in one file.
1 'Load & install ADSM.CO in LOMEM.
2 'Run this file from drive or serial:
3 'RUN"0:ADSMLO.DO" / RUN"COM:98N1ENN"
4 'To uninstall, use ADMINS.CO.
5 IF PEEK(1)<>171 THEN PRINT"Tandy 200 Only": END
10 CLEAR 256, 56601
20 DEFINT A-Z
30 TP=-8935: LN=4499: EX=-8935:NM$="ADSM.CO"
40 GOSUB 13000
50 PRINT:PRINT "Saving to ADSM.CO"
60 SAVEM "ADSM.CO", TP, TP+LN, EX
100 'Now load ADMINS which moves ADSM.CO     to low memory (before BASIC).
130 TP=-5213: LN=777: EX=-5213:NM$="ADMINS.CO"
135 RESTORE 15000
140 GOSUB 13000
150 PRINT:PRINT
160 SAVEM "ADMINS.CO", TP, TP+LN, EX
200 PRINT "After installing ADSM.CO to LOMEM,": 
205 PRINT"Free up RAM using 'KILL ADSM.CO'"
207 PRINT"and 'CLEAR 256, MAXRAM'."
210 'Clear this program so ADMINS has sufficient space
220 KB=-738:K$="NEW"+CHR$(13)+"CALL -5213"+CHR$(13)
230 FORL=1TOLEN(K$):POKEKB+L*2-1,ASC(MID$(K$,L,1)):NEXT
240 POKE KB,L-1
250 'Keyboard Buffer saves our epitaph. 
900 END
13000 'Decode ML
13010 CLS:Q=0:E=0:H$=CHR$(13)
13020 ?"      /"LN-1"Loading "NM$" at"TP+65536;
13030 READP$:FORX=1TOLEN(P$):a$=MID$(P$,X,1)
13040 if a$="!" then if e=1 then 13090: else e=1: goto 13070
13050 v=asc(a$): if e=1 then v=v-128: e=0
13060 ?H$q;:POKEQ+TP,v:Q=Q+1
13070 NEXT:GOTO13030
13090 RETURN
14000 'ADSM.CO
14010 DATA">!Íá›ÍJL!¡tã!¢4ï!¡!‹îÍ n*eö~·ÊpÝ!Ž!ƒ‘G#~ÍqäÒgÝ!…Â9Ý	Ã0ÝÕÍEßÑÍýæ>!šÍ!¢ç*Jî!0ú!ˆ}Ä;çÍO Íb,Íæ\ÍUq*göÍ!‚ä!¡4î!†!†ÍÁ]=!†!„ÍÂ]!gÝÅ*QîÍ!ÞÍ¡á>ÿÍ
14020 DATA"Àç6:Í¶åÍwZ!¡!!Í›OÍNÞÍöT×ëÊ$ÞÖ+ÊÕÝ=ÊàÝ=ÊÕÝ!¡Vî!“Ö!ÊWÞ=ëÊ!ˆßë=ÊIÝÍ3à*AîÃ ÞÍ!“âDMÍnàÃ ÞëÍC-!–!ÕÍ!‡ÞÍ!”çÑ!•ÂæÝ!ÂãÝÉæ!2‹îo&!€)!‘Œî!™ëíÉÍB
14030 DATA"ÞÍhà:‹îåÍ÷ÝÁ!ˆÅÊ!žÞ<Í÷ÝáÙ!¢QîÉ!¡!!Í›O:!ýæ!ƒÊ!‡Þ!Ÿ:‹î<Ò<ÞÖ!‚Í÷Ý!¢Qî*QîÍ¡á!ÿÿÍ}ç!¡pïÍwZÃÌ!‘<ÍGßÍ!œàþ!šÊaÝÍ0PÍ!”çÃ[Þ!¡½íÍúÞ!¡Ëí!‘|îÍ!ƒß!¡Vø!¢ûô
14040 DATA"!¢ÿôÍÿã2:î!¡4î!†!„ÍÁ]<w!¡mîÍGß*ûô!¢?îÍ!”ç!‘pïÍ!‡à!’!“Â¦ÞÍ3à:8î·Â Þ!¡:î¾ÂaÝ4W_Íæ\*ûôDM*?î!ˆ!¢ýôÍ!3!¡{î×ÚaÝÍ!˜ßÍ¦+Ä,+Íb,Íf0Í¦+!¡!†!€!™!¢;î!¢AîÃŠ
14050 DATA"Þ>!ŒçÍ**!‘mîÕÍ!ßÑ!†!Ã§2ÍQÞÍðT×ÀÃgÝ>ÿ2jßåÍ!“!þRÂ>ß×Ö1þ!ƒÒ>ßO#~þ:Â>ßy!‡!‡2jß#ãáÍC-ÃÊZ>!‚õ>!Í÷[Í!˜ßÂUß!–øñ_=ÊcßzþùÒcß!ž!ˆ!¡0ú!¢Jî>!€·òwß!¡!‡
14060 DATA"!€>!ÃÑ[ÕóÍÝ!ÛØæ!ŒÓõ:jßÓ‘õ!¡F÷T]!!†!€ÍÅ/!‘±ß!¡0ûÍºA!†!‚!ˆÍÓ!ñáÁÍ0ûûÚ=LÀÃ!Ž_ÓØ8!€¼|Ê¾ß*PöùÕõÍMûá|áÓØùë!¢ÜßÉ!ÂWûÍb,Ã½+òmû!¡!€!€!!€!€Í¨‚Ø!‘0úë
14070 DATA"ÍU<²É*iö8!€!•ß?Ø¯2L÷!¡F÷Ís-Íh‚ë²ÉÍ!œàþ!ŠÊ!‡àÖ!ÈÆ!þ!šÀ¯28îÉ:jß·ú6]*ÜßGóÕÍ±›ûzÑ#ÃÊß!¡Iî!¢SîÍzà:HîO!†!€<ÂKà*JîDM::î·Ênàx±ÈÍnà!ˆë*Sî:Hî<
14080 DATA"Â!–ƒëÃGw:HîO!†!€!‘?îí	Ù!“!“í	ÙÉ!‘pï¯2Hî:4î·Ê·àÍ<áþIÂšà!“!šæßþFÊøê!›!¡,ë!Ž!…!šæß¾À!“#!ÂŸà!¡5î¯¾Êw!„5À+wÉÍ@äøÚÔàÍpäÒíà::î·Êz!„Í!“âÍ¡áÃðàÕÍ<áþ
14090 DATA"EÂæà!“!šæßþQÊšã*?îÑÍ¡ãÍ<áø!¡!„ë~·Êq!„Õþ Â!„á#N#F#!šÍ!”!¾#!“Ê!„á+ÍqäÚ!›á~þ!…Ú3á~#þ!…Ò!›á#~þ ÑÚ/áþ`Úôà#ÃôàÑÅ#N#Fg.!€Í@äøÊGá!“Ã<á!“Í@äÊGáÉ::
14100 DATA"î·|Â\áþ!ƒÒ!™!‘!ŸÅÚ!“âÉÍåé!ˆ!¢Sîy2HîÉ>ÿÃjá!¢Iî>!‚Ãjáë!¢SîÍC-KÃiá!¢?î!¢ûôå*;î!¢Aî!¡7î~·ÂªW4á!¢ÿôÉ!¢?îÃöæÍ<áõÍlã!“ñþHÊþá!Ž8ÃþáÖ0æ!‡õÍ<áô¬!ñÃýá
14110 DATA"ÍîáõÍ<á!!€!$ÍîáÁ€2IîÉõÍ<áñå!¡ýíÃòáõÍ<áñå!¡ãí#¾Úq!„#Âòá~áo|2Hîy€-ò!„â2Iî%È::î·ÈÍ@äúƒ!„!¡!€!€!¢LîÍ@äøÊ<á!šþ(ÊIâþ)ÂCâ!“å!¡Pî~6!€*Nî!¢LîáÃ
14120 DATA"QâÍqäÔ‡UõÍ§âñÚ!œâÕÍ\â!¢JîÑÃ!œâDMë*LîÖ!¡Ê›â=ÊŸâÖ!ˆÊâ	=È!ˆ!ˆÖ!‚È	=Ê£â=ëÀëx±Êt!„!‘ÿÿ!ˆ!“Ò‰âëÉëgox±È!‹!™Ã“â}«oÉ}³oÉ}£oÉ!¡!€!€!¢JîÍ@äøþ'ÊÎâþ(Â
14130 DATA"Øâ!“áñ7õå2Pî*Lî!¢Nî!¡!€!€É!“!šo!¢Jî!“ÃlãgÕÍlã!›!Ž!!šæßþHÊ!„ã|þ$Ê!…ã!Ž!ŠÍ@äÒ!…ã!¡õíN!úSã#¾#Âùâ!›yõÖ!Ê!Žã>72*ã!!!€*JîÍpä!›Òjãþ$ÊjãÖ0þ!ŠÚ:ã!€ÚRãÖ!‡þ
14140 DATA"!ŠÚRãþ!ÒRã	=ò:ã!ˆ!¢Jî!¡!€!€ñõ	=ÂHãDMÃ!”ãñÑÍ!ŒäÚfã:6îg::î´!šÂx	*Jî!ñÑ!“ÍpäÚlãÉÕkÍæ\}þ4Â…ã!¡mîÍQÞÄNÞÍEO!¡µíÍQÞá&!€Í!‹GÃgÝÍ<áÍ!“âÑåÍ!ŒäÁÒ´ã
14150 DATA"::î·ÊªWq#pÉÕåÅÕ8!€!•ßÒ=LÑ!Ž!ƒ#ÍpäÒÐãw#!“!ŒÃÃãÑs#r#Í!‚äáqÑÉ!šþ*ÊÿãÍ!ŒäÊx	##PYDMå*iö!ˆDMá!ƒÍ!–ƒë+Ã!‚ä*eö!¢gö¯w#!¢iöÉ*eö~·ÈÕåNA#!šÍ!”!¾!“#Â8ä
14160 DATA"!…xþ!„Ò!—äÍpäÚ8äëí!¢JîëÁÑ7Éá!†!€	ÑÃ!ä!š·ÊJäþ;ÂMäö€Éþ	Èþ,Èþ Èþ=ÈþaÚeäþ{Òeäæßþ??Òmäþ`<=É!šÍYäØþ$7Èþ'7Èþ0?Ðþ:ÉÍ½åGþvÊQåæÇþ!†ÂœäÍÍä6,
14170 DATA"Ã¶åþÇÂÃäÍQåx!!!æ!‡Æ0w#!5îOÜ! !Š2Hî=Ê·å6,Ã¶åþ!…ÊÍäþ!„Â×äÍQåx!!!ÃKåxæÏþÁÊääþÅÂòäÍ›å6P#6S#6WÃ¶åþ!ŠÊüäþ!‚Â!åOxæ ÂPåyÍQåxæ!ÃÑäþ!Ê•
14180 DATA"åþ!ƒÊ‡åþ!‹Ê‡åþ	Ê‡åþ!ˆÂ1å¸Ê‡åxî(¸ÚPåxæÀþ@Â?åÍ”äÃJåþ€ÂPåxæøÍQåxæ!‡Ã¨åxO!‘®ë!šþ Â^å!“!“!“*Fî6	!š#w!“þ!„Òcå2Hî6	!š¹7Ê¶å!“!šþ Úƒåþ`ÚUå!“ÃUåÍQ
14190 DATA"åÍžå6S#6PÃ¶åÍ‡åÃ—äÍQåx!!!æ!†þ!†ÈÑ!‘âí<æ!‡!“!“=ò®å!šw#!¢Fî6!€Éå!¡pïÍ·åáÉ!¡ÊíÍúÞ!¡pïåëÍ<áúèåÑ!¡!€!€åÍ!“âååÍ!“âÑÃ!æáÍ!˜ßÍ¦+Ê!Ž_*eöåëÍ¡A##åbk	+
14200 DATA"!¢;îë!¢=î!¢?î!¡ØíÍ!ßÍEßá!¢Aîëá!¢SîÍßæë*=îDM*;î:Cî·Âfæå!ˆ!™åÕ!šÍ„äÑ!“:Hîþ!ƒÂ\æíDM*=î+!ˆÒ[æ*;î!ˆÚ[æÕÍCçzÑ!“=Ä‡UáßÒ3æáåÍßæåå~Í‡ä:Hîþ!ƒOGÑÚ
14210 DATA"‡æ!“íÅÍXçÁ>LÚ‰æ>ÿõ*?îå:Cî·Â¨æ!Ê¨æ#åÅÍXçÁáÒ•æx28îáÍXç!¡9î!†L!Ž!‡Ú¿æ!†I5ú¿æ!†!€NqñOáÍ}ç:8î=ô!˜àÍúæÍhà*?îëáßÒfæÃQÝ*SîDM$%Êòæ*eö!¢Sî!ˆD
14220 DATA"M*Aî	!¢AîÉ!‘pï!š!“·ÕõÄ!¢çñÑÂýæ>!Í!¢ç>!ŠÍ!¢ç:!ýæ!ƒÈþ!‚Ú!”çÃaÝ*jß,Ê!…Zþ!šÈ*Jîw#!¢Jî!0ú!ˆ},À2ßß!ž!€ÃcßÍZçØ8!€!•ßÒ=L6!ƒ#q#p#Ã!…äDM*eö~·ÈÖ!‚_!–!€!™ëí!ˆ
14230 DATA"ë7È##Ã]ç> &!€õÍ!èñÃµåÅåx*?îÍÀç>:Äµå*Fî:8î·ÑÂÐè:Cî·ÁÂÜèÅ!šÕÍ‡äÑ:Hîþ!ÁÊÜèõÕ!“íÖ!ƒ/¤gyÍÃçÑñÃÜèÍ½å·ÈåõÍXçë*FîëÚéçñëôµåáõÍ!èñø+~þ
14240 DATA"HÄ!!›<Ã·åO!†!€!ˆ~þ!ƒÊÒç!!‡!€Í©êwñÁÉ}2!‚èÛ!€o&!€!NÞÅÍ½å!¢Lî:Eîþ!‚Ò!è>!‚2EîO!†!€W!¡!€!€z	Ú2è=Â%èDMÃ!¡è!¡¶åå¯õ>ÿ*Lî<!ˆÒ=è	!¢Lî_ñgƒÆÿ|õ{þ!ŠÚVèÆ!‡Æ0*
14250 DATA"Fîw#ñÜY$õÜ·åy=°Ê~è`iJ!†!€!‘ÿÿ!“!ˆÒsèBQKÃ8èÁzþ!Š+È#6Qþ!ˆÈ6Bþ!‚È6#þ!À!…!…ò è+~60#w#6HÉÕ!“Í@äÂ¤è¯!’25î<28îáÃGßëÍ½åíå>,ÍsçáålÍqçáÍ!èÃNÞÁ
14260 DATA"6	#6D#6B#>!å*?îDM*;î!ˆ$%Âòè=½Úñè}<2HîGá:8îO·:UîõÂ!ˆé!Ÿ!ŸÒ5éÕÅ6	#6;Ü!!›!¢FîÅÕíÍqçÑÁ:EîÖ!Â*é+¹Ìo!!“!…Â!’é·Äo!ÁÑñ!ŸÒ·å6	#6;!ŸÒHéy·ÊIé#
14270 DATA":Cî·!šÂSéæ!ÿþ!ÿ!Ž.Êeéþ Òdé6^#Æ@Oq!“!…ÂHéÃ¶å}2EîÉ}2CîÉåÍ!“âÑ}!’|·È!“!’É}2ŽéÍ!“â}Ó!€Éò£é}þ ÒŸé>^ç}Æ@çÃwZåÍ!“â}!¡EîNwáÅÍ!†èáÃnéÍåé+!‘nðAÍ^<
14280 DATA"H*QîÅÕå!“!š¾ÂÛé#!ÂÈéáåÍ!†èÍ!”çáÑÁ#|µÂÅéÉ!¡pïÍñé!Œ!ÀÃƒ!„!!€!€!›Í<áø!šþ'Â	ê!“!“!š!›þ'Â ê!›ÅåÍ!“âDMáq#pÁ!Œ45Êôé#!ŒÃôé!š!“w·Èþ'Êôé#!ŒÃ êåÍ!“âÁåÅ!ˆ#å
14290 DATA"õÍ!“âñÑÁÚ€!„!ˆÚQê	!™+BKëáÃ!¡ƒ	ëÅDMáñÃ!–ƒë!‘|îÍ!ˆß!¡×íÍ!ßÍEß*eö!¢Sî~·ÊQÝå!‘pï!|îÍ©êÂê6	#6E#6Q#6U#6	#!¢Fî!“íÍ!èÍúæÍßæá	N!†!€	Ãqê~Ö!ƒ#õ!Š·Ê
14300 DATA"»ê!ƒÍ!”!¾Âûç~!’!“ñ=Â¬êëÉ}2UîÉ!eî}æ!‡o&!€	åÍ!“â}áwÉåô!“â\UÕT]DMñÉ>!26îÍ!“âåÍ!“âÁ!ˆë!¡6î6!€z³+4+wÉ OáDB!‚báDW!sáDM!‚{áDS!náORG!†áENT!áIF
14310 DATA"!‚éêENDIF!‚ªàFIX!ÊêDD!ÅêMENU!‚¤gSMB!„[êDEL!‚ÜãMOVE!/êFIND!„¶éGET!ƒ!†èCNV!ƒéGO!ÜêRE!ƒ¸èWR!xéMD!néCD!séASM!„lÞDSM!„ÆåOP!…éIP!ƒýçSET!¡á
14320 DATA"LINK!‚£èEND!‚!—à ÉáMOV!@!ˆ éáMVI!‚!†!ˆ îáORA!°!INR!!„!ˆDCR!!…!ˆXRA!¨!CMP!¸!ADD!€!ADC!ˆ!SUB!!SBB!˜!ANA! ! ÝáLXI!ƒ!! âáPUSH!Å!POP!Á!L
14330 DATA"DAX!!Š!STAX!!‚!DAD!	!INX!!ƒ!DCX!!‹! ºáRST!Ç!ˆ þáJNZ!ƒÂJZ!ƒÊJMP!ƒÃRET!ÉCALL!ƒÍLHLD!ƒ*SHLD!ƒ!¢XCHG!ëDSUB!!ˆLHLX!íSHLX!ÙJNC!ƒÒJC!ƒÚRNZ!ÀRZ
14340 DATA"!ÈRNC!ÐRC!ØLDA!ƒ:STA!ƒ2CNZ!ƒÄCZ!ƒÌJP!ƒòJM!ƒúCNC!ƒÔCC!ƒÜCPI!‚þANI!‚æRLC!!‡RRC!!RAL!!—RAR!!ŸADI!‚ÆACI!‚ÎSUI!‚ÖSBI!‚ÞXRI!‚îORI!‚öDESP!‚8DEHL!‚(C
14350 DATA"MC!?STC!7LHLI!íSHLI!ÙHLMBC!!ˆCMA!/PCHL!éCP!ƒôCM!ƒüRP!ðRM!øOUT!‚ÓIN!‚ÛDI!óEI!ûXTHL!ãSPHL!ùNOP!!€RIM! SIM!0RHR!!RDL!!˜JPO!ƒâJPE!ƒêC
14360 DATA"PO!ƒäCPE!ƒìRPO!àRPE!èJND!ƒÝJD!ƒýDAA!'HLT!v???!Ë §áDMOV!‚(	ERROR !€!ŠSource File!€!ŠObject File!€!ŠOutput File!€A!‡B!€C!D!‚E!ƒH!„L!…M!†ÿ!‹D	O
14370 DATA"	Q!ƒB!€A!ƒB!€D!H!‚P!ƒS!ƒÿ Find  Asm Dsm DD  Get  Cnv  Set  Menu!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!!€!€!€!€!€!€!€!€!€!€!€Vø!€!€!NOTES!€!€!€!€!€!€!€!€!€!€!!‚!!!!!!‚!€!€!€!€
14380 DATA"!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!€!!
15000 'ADMINS.CO
15010 DATA"!‘!Ÿ!AD*îô!”ßÚþëåí!ˆáÂ¬ë!“!“!šG‚”!¡£íÂñìÍ!ƒí!‘sò!¡Mƒ!†!ƒÅåÕ!Ž!†!¡áí!“!“!“Í!‘nÑáÊòë!!‹!€	ë	ëÁ!…ÂÐëÃøëÁ!†!‹Í§2!¡›íÃÔìÕÍâì!¡áíÊñìÕ!¡üíÍžg!!‹!€ÄEOÍ÷!’çÖ1
15020 DATA"!¡sòÊ5ì	=Ê5ì	=Ê5ì=Â!’ì!¡ôíÃÔì!¢ÇìáÍ¡A##!¢xîáÅÕÅåë!¢ûô	+!¢ýô!¡!„!	.!€|åÍ!ƒíÁÑ!¡ADÙ!“!“x!’!“*xî	ÁÕÍ!–ƒáÁ!ˆ!¢vî	T]Á	Õå!šÕÍ4íÑ!“þ!ƒÚžìíDM*ûô!ˆÒì*ý
15030 DATA"ô!ˆÚì*vî	Ù!“þ!‚Ô‡UáßÒzì*vîDM!‘zîí|µÊÂì	Õëí	ÙÑ!“!“Ã°ìá!¢ßí!‘sò!¡Þí!†	Í§2!¡‘íÍžgÍO >!Í!”bÃ¤g!¡áí!‘F÷Í¥2Íb,Ã¦+ÍžgÍEOÍ÷!’Ã¤g!¡~íÃñì*îô„W”G!Ž
15040 DATA"!€iÒ!œíÅ|’GbÍÚ‚ÁÃ#íÍ¨‚Úýì	:bö€2bö|2ïôÖ 2!€ Éþ@ÚCíÖÀÒAí>!ÉÆ@_æ!ƒG{¨!Ÿ!Ÿ!¡^í_!–!€!™~!‡!‡!!!…òUíæ!ƒÉ]eUe]eUe}eve}eveõguoµgµougugµguoInsuf
15050 DATA"fient memory !€Installed!€Removed!€Cannot remove - The LOMEM configuration has changed.!€ADMINS°!€!€ADSM  .CO missing !€Aborted
15060 DATA"!€Choose in place of which one of these   ADSM is to be installed.!!Š1) ADDRSS!!Š2) SCHEDL!!Š3) MSPLAN!!Š4) I change my mind!
15070 DATA"!Š?!€!€!€!€!€!…ë!Šë!”ë*ë2ëJëPë^ëdëjëtë‰ëë™ë¦ë¬ë¯ë¸ëÁë!€ì	ì9ìBì­í!€!€!!

