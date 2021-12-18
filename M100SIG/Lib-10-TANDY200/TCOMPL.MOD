This line when added to TCOMPL.200 will allow the compilation of LINE command.


9209 'Line
9210 DATA 125,33,118,141,230,1,194,-9,4,46,119,34,73,239,193,225,209,197,195,191,39,999


The exact format to use in your Basic source code is the following :
    LINE(x1,y1)-(x2,y2),e

where: x1,y1,x2,y2 is any variable or constant as with the regular Basic
statement

and : "e" is either a 1 or 0 or any variable with the value of 1 or 0

NOTE: contrary to the Basic interpreter, where the 1/0 is optional, you MUST 
specify this value for the compiler to compile the statement properly.

Luc bouchard
73327,2320
Oct,24,1986
