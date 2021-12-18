This one line patch for DBAKUP.TDD corrects a minor oversight on my part.
All but the M/L programs were written to the directory file upon saving to disk
This adds the .CO files saved to the end of that directory file like it should.
Download and save as .DO file then delete this paragraph and merge the 
one line with DBAKUP.TDD.

48 KILL":"+D$+".DO":SAVEM":"+D$+".DO":POKE65450,0:GOSUB11:IFK$="n"ORK$="N"THEN49:ELSEKILLD$+".DO"
