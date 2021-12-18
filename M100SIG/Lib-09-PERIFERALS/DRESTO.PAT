This one line patch will allow you to load files automatically with 
DRESTO.TDD without halting program execution should you encounter a file 
which has been deleted since it was saved.  Also, the program would halt 
upon end-of-file when nothing but basic files had been saved as a set.  This 
patch fixes that also.  Delete this paragraph and save as .DO file, then 
merge with DRESTO.TDD


506 IFERR=52ANDERL=115THENCLOSE1:V=V+1:RESUME100ELSEIFERR=52ANDERL=165THENRESUME170
