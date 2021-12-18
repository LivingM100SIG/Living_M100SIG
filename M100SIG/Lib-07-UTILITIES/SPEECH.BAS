1'this is a driver for speech synthesizer(read SPEECH.SYN DL-4 for description)
2'If you enter demo, it lets you hear the letter of the key you press.
4'add your own words by entering groups of allophones(vowels and consonants) to data statements and change line 29 restore command to control which groups of words to be spoken.
5' at the end of each word, put a "0"  as a data item and to indicate a repeating point, put "res"(when this is read, it will go to the first word and repeat again and again.)
6' size of array variable A() at line 28 should equal the number total items in the data statements.
25input"Enter '1' to hear your own words created or '2' for a Demo. ";m:ifm<0orm>2then25
26LPRINTCHR$(64);
27CLS:PRINT"Wait..."
28DIMA(768),WF(63)
29RESTORE 800
30ONMGOTO200,390
200READW$:IFW$="res"THEN300ELSEIFW$="0"THENW$="pa3"
210L=-1:A$=RIGHT$(W$,1):ONASC(LEFT$(W$,1))-96GOSUB900,905,910,915,920,925,930,935,940,943,945,950,955,960,965,970,972,975,980,985,990,992,993,995,996,998:IFL=-1THEN220ELSEA(W)=L:W=W+1:GOTO200
220'the allophone is not in the vocabulary
230PRINTW$;" is not a recognizable allophone.":GOTO200
300FORL=0TOW:LPRINTCHR$(A(L));:NEXT
305LPRINTCHR$(4);
310GOTO300
390restore810
400READW$:IFW$="res"THEN490ELSEIFW$="0"THENWF(WD+1)=W:WD=WD+1:GOTO400
410L=-1:A$=RIGHT$(W$,1):ONASC(LEFT$(W$,1))-96GOSUB900,905,910,915,920,925,930,935,940,943,945,950,955,960,965,970,972,975,980,985,990,992,993,995,996,998:IFL=-1THEN440
420A(W)=L:W=W+1:GOTO400
440PRINTW$;" is not a recognizable allophone.":GOTO400
490WF(WD+1)=W
500PRINT@0,"Press a key with caps lock off.":K$=INKEY$:IF K$=""THEN500
505PRINTK$
510K=ASC(K$)-97
515IFK<0THEN500
520FORL=WF(K)TOWF(K+1)-1
530LPRINTCHR$(A(L));:NEXT
540LPRINTCHR$(64);:GOTO500
800datahh1,eh,ll,ax,ow,0
810DATAey,0
815DATAbb2,iy,0,ss,ss,iy,0,dd2,iy,0,iy,0,eh,eh,ff,ff,0,jh,iy,0,ey,pa2,pa3,ch,0,aa,ay,0,jh,eh,ey,0,kk1,eh,ey,0,eh,eh,el,0,eh,eh,mm,0,eh,eh,nn1,0,ow,0
820DATApp,iy,0,kk1,yy1,uw2,0,ar,0,eh,eh,ss,ss,0,tt2,iy,0,yy1,uw2,0,vv,iy,0,dd2,ax,pa2,bb2,yy1,uw2,0,eh,eh,pa3,kk2,ss,ss,0,ww,ay,0,zz,iy
900IFA$="a"THENL=24ELSEIFA$="e"THENL=26ELSEIFA$="o"THENL=23ELSEIFA$="r"THENL=59ELSEIFA$="w"THENL=32ELSEIFA$="x"THENL=15ELSEIFA$="y"THENL=6
902RETURN
905IFA$="1"THENL=28ELSEL=63
907RETURN
910L=50:RETURN
915IFA$="1"THEN917ELSEIFMID$(W$,2,1)="d"THENL=33ELSEL=54
916RETURN
917IFMID$(W$,2,1)="d"THENL=21ELSEL=18
918RETURN
920IFA$="h"THENL=7ELSEIFA$="l"THENL=62ELSEIFA$="1"THENL=51ELSEIFA$="2"THENL=52ELSEL=20
922RETURN
925L=40:RETURN
930IFA$="1"THENL=36ELSEIFA$="2"THENL=61ELSEL=34
932RETURN
935IFA$="1"THENL=27ELSEL=57
937RETURN
940IFA$="h"THENL=12ELSEL=19
942RETURN
943L=10:RETURN
945IFA$="1"THENL=42ELSEIFA$="2"THENL=41ELSEL=8
947RETURN
950L=45:RETURN
955L=16:RETURN
960IFA$="g"THENL=44ELSEIFA$="1"THENL=11ELSEL=56
962RETURN
965IFA$="r"THENL=58ELSEIFA$="w"THENL=53ELSEL=5
966RETURN
970IFA$="p"THENL=9ELSEL=VAL(A$)-1
972RETURN
975IFA$="1"THENL=14ELSEL=39
977RETURN
980IFA$="h"THENL=37ELSEL=55
983RETURN
985IFA$="h"THENL=29ELSEIFA$="1"THENL=17ELSEL=13
987RETURN
990IFA$="h"THENL=30ELSEIFA$="1"THENL=22ELSEL=31
991RETURN
992L=35:RETURN
993IFA$="h"THENL=48ELSEL=46
994RETURN
995L=47:RETURN
996IFA$="r"THENL=60ELSEIFA$="1"THENL=49ELSEL=25
997RETURN
998IFA$="h"THENL=38ELSEL=43
999RETURN
1000DATAres
