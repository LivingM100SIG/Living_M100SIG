			BIBCNT.DO * 2/14/88 R.W.HESS
	This file contains new lines for merging into BIBLIO.BA and BIBPRT.BA
that will enable them to include the tape counter location of cassette files in
both BIBFYL and the Directory listings.
	Save BIBLIO.BA & BIBPRT.BA to RAM as .DO files, then PASTE each of the 
following sets of new lines to their respective files.  LOAD each "new" program
and SAVE it as before. 
	BIBLIO will now prompt you for tape counter readings before each new 
tape file and store your input with a trailing # in the cassette directory in 
the field where the disk directory prints file size. All previous BIBFYL's are
totally compatible with the new adds.
--For BIBLIO.BA-----
0 'BIBLIO.100  1/2/88 R.W.HESS (See BIBDOC.100) rev.2/14/88 (cass. counter)
10 CLS:RN$="Cassette ":DV$="c":DS$="    0#":GOTO152
32 DV$="c":CLOSE:GOSUB176:GOSUB172:GOSUB202:DS$=INPUT$(6):OPENRF$FORAPPENDAS3:S=0:OPEN"COMTMP"FORINPUTAS1:N=0
38 IFLEFT$(I$,5)="Found"THENGOSUB58:DF$=RIGHT$(I$,6):GOSUB56:GOSUB54:GOSUB42:DF$=DF$+T$:GOSUB92:GOSUB210:GOTO48
48 CLS:GOSUB202:K$="LOAD"+Q$+"CAS:"+R$+"RUN"+Q$+"BIBLIO"+R$+CHR$(67)+DS$
210 CLS:GOSUB150:PRINT@126,"Tape counter reading";:LINEINPUT": ";DS$
212 IFDS$=""THENDS$="     #":RETURN
214 DS$=SPACE$(5-LEN(DS$))+DS$+"#":RETURN
--For BIBPRT.BA-----
0 ' BIBPRT.BA  2/88 (cass/ctr) R.W.Hess
66 LF$=MID$(PT$,15,5)+" "
74 LPRINTN$": "S$:FORI=1TON:LPRINTA$(I):NEXT:LPRINTC"files, updated ";DT$;
76 IFB$="c"THENLPRINT:GOTO62ELSELPRINT"; aprox.";100000-VL;"bytes free.":LPRINT:GOTO62
