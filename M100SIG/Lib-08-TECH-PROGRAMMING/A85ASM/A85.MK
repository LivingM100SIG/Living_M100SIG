
MODEL  = L

COMPSW = /A$(MODEL) /Ox /Gs /FPa /Zd /B1 C1L.EXE
LINKSW = /MAP /LI /ST:8192

#COMPSW = /A$(MODEL) /Od /Gs /FPa /Zi /B1 C1L.EXE
#LINKSW = /MAP /LI /CO /ST:8192

ASOBJS = a85.obj a85util.obj a85eval.obj

.c.obj	     :
	       cl /c $(COMPSW) $*.c

a85.exe      : $(ASOBJS)
	       link $(LINKSW) <@<
$(ASOBJS)
$@
$*
;
<

$(ASOBJS)    : a85.h
