TNDCOD.MOD: How to modify Tandycode for Epson printers or compatibles
 
   Tandycode is a great way to distribute programs.  (See TCODE.REV in DL13.)  

The only problem is that the printing program is made for Radio Shack printers 

only.  Here's how to modify the program for Epson printers and compatibles such

as Panasonic, Roland, Star Gemini, etc.:
 
Program as supplied:	Change to:
 
In lines 45 and 140:
CHR$(27);CHR$(19)	CHR$(18)
[Select 10 pitch]
 
In line 50:
CHR$(27);CHR$(20)	CHR$(15)
[Select condensed]
CHR$(18)		CHR$(27);"L";CHR$(29)
[Select graphics mode]
 
In line 55:
;CHR$(30)		[Delete this, including the ";"]
[End graphics mode]
 
In line 125:
STRING$(3,T)		STRING$(3,0)
STRING$(6,T)		STRING$(6,0)
 
Add line 127 as follows:
127 FORX=0TO3:H(X)=CHR$(27)+"L"+CHR$(LEN(H(X)))+CHR$(0)+H(X):NEXT
 
   You might like to try "*"+chr$(5) in place of "L" in lines 50 and 127 if you

have one the more recent printer models that includes this mode.  It will print

the bars slightly less condensed.  Try it both ways and see which is easier to 

read with the wand.  I really had no big problems reading either one.
 
   If your printer is not compatible with these codes, drop me a message and 
I'll help you with the proper patches.

   Neil Wick [71056,613]

