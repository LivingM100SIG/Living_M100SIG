/*
        HEADER:                CUG267;
        TITLE:                8085 Cross-Assembler (Portable);
        FILENAME:        A85UTIL.C;
        VERSION:        0.1;
        DATE:                08/27/1988;
        SEE-ALSO:        A85.H;
        AUTHORS:        William C. Colley III;
*/

/*
                      8085 Cross-Assembler in Portable C
  
                Copyright (c) 1985,1987 William C. Colley, III
  
Revision History:
  
Ver        Date                Description
  
0.0        AUG 1987        Derived from version 3.4 of my portable 6800/6801
                        cross-assembler.  WCC3.
  
0.1        AUG 1988        Fixed a bug in the command line parser that puts it
                        into a VERY long loop if the user types a command line
                        like "A85 FILE.ASM -L".  WCC3 per Alex Cameron.
  
This module contains the following utility packages:
  
        1)  symbol table building and searching
  
        2)  opcode and operator table searching
  
        3)  listing file output
  
        4)  hex file output
  
        5)  error flagging
*/

/*  Get global goodies:  */

#include "a85.h"

static OPCODE             *BinSearch(OPCODE *lo, OPCODE *hi, CHAR *nam);
static SHORT              ustrcmp(CHAR *s, CHAR *t);
static void              list_sym(SYMBOL *sp);
static void              check_page(void);
static void              record(USHORT typ);
static void		 IntelHex(USHORT typ);
static void		 M100Hex(USHORT typ);
static void		 M100Bin(USHORT typ);
static void              putb(USHORT b);


/*  The symbol table is a binary tree of variable-length blocks drawn	    */
/*  from the heap with the calloc() function.  The root pointer lives	    */
/*  here:								    */

static SYMBOL  *sroot = NULL;

/*  Add new symbol to symbol table.  Returns pointer to symbol even if	    */
/*  the symbol already exists.	If there's not enough memory to store       */
/*  the new symbol, a fatal error occurs.				    */

SYMBOL *new_symbol(CHAR *nam)
{
    SCRATCH int     i;
    SCRATCH SYMBOL **p, *q;

    for (p = &sroot; 
        (NULL != (q = *p)) && (0 != (i = strcmp(nam, q->sname)));)
        p = i < 0 ? &(q->left) : &(q->right);
    if (!q)
    {
        if (!(*p = q = (SYMBOL *) calloc(1, sizeof(SYMBOL) + strlen(nam))))
            fatal_error(SYMBOLS);
        strcpy(q->sname, nam);
    }
    return q;
}

/*  Look up symbol in symbol table.  Returns pointer to symbol or NULL	    */
/*  if symbol not found.						    */

SYMBOL *find_symbol(CHAR *nam)
{
    SCRATCH int     i;
    SCRATCH SYMBOL *p;

    for (p = sroot; p && (0 != (i = strcmp(nam, p->sname)));
         p = i < 0 ? p->left : p->right);
    return p;
}

/*  Opcode table search routine.  This routine pats down the opcode        */
/*  table for a given opcode and returns either a pointer to it or	   */
/*  NULL if the opcode doesn't exist.                                      */

OPCODE *find_code(CHAR *nam)
{
    static OPCODE   opctbl[] = {
                                {DATA_8 + 2, 0xce, "ACI"},
                                {SRC_REG + 1, 0x88, "ADC"},
                                {SRC_REG + 1, 0x80, "ADD"},
                                {DATA_8 + 2, 0xc6, "ADI"},
                                {SRC_REG + 1, 0xa0, "ANA"},
                                {DATA_8 + 2, 0xe6, "ANI"},
                                {DATA_16 + 3, 0xcd, "CALL"},
                                {DATA_16 + 3, 0xdc, "CC"},
                                {DATA_16 + 3, 0xfc, "CM"},
                                {NONE + 1, 0x2f, "CMA"},
                                {NONE + 1, 0x3f, "CMC"},
                                {SRC_REG + 1, 0xb8, "CMP"},
                                {DATA_16 + 3, 0xd4, "CNC"},
                                {DATA_16 + 3, 0xc4, "CNZ"},
                                {DATA_16 + 3, 0xf4, "CP"},
                                {DATA_16 + 3, 0xec, "CPE"},
                                {DATA_8 + 2, 0xfe, "CPI"},
                                {DATA_16 + 3, 0xe4, "CPO"},
                                {DATA_16 + 3, 0xcc, "CZ"},
                                {NONE + 1, 0x27, "DAA"},
                                {DAD_REG + 1, 0x09, "DAD"},
                                {PSEUDO, DB, "DB"},
                                {DST_REG + 1, 0x05, "DCR"},
                                {DAD_REG + 1, 0x0b, "DCX"},
                                {NONE + 1, 0xf3, "DI"},
                                {PSEUDO, DS, "DS"},
                                {PSEUDO, DW, "DW"},
                                {NONE + 1, 0xfb, "EI"},
                                {PSEUDO + ISIF, ELSE, "ELSE"},
                                {PSEUDO, END, "END"},
                                {PSEUDO + ISIF, ENDIF, "ENDIF"},
                                {PSEUDO, EQU, "EQU"},
                                {NONE + 1, 0x76, "HLT"},
                                {PSEUDO + ISIF, IF, "IF"},
                                {PORT + 2, 0xdb, "IN"},
                                {PSEUDO, INCL, "INCL"},
                                {DST_REG + 1, 0x04, "INR"},
                                {DAD_REG + 1, 0x03, "INX"},
                                {DATA_16 + 3, 0xda, "JC"},
                                {DATA_16 + 3, 0xfa, "JM"},
                                {DATA_16 + 3, 0xc3, "JMP"},
                                {DATA_16 + 3, 0xd2, "JNC"},
                                {DATA_16 + 3, 0xc2, "JNZ"},
                                {DATA_16 + 3, 0xf2, "JP"},
                                {DATA_16 + 3, 0xea, "JPE"},
                                {DATA_16 + 3, 0xe2, "JPO"},
                                {DATA_16 + 3, 0xca, "JZ"},
                                {DATA_16 + 3, 0x3a, "LDA"},
                                {LDAX_REG + 1, 0x0a, "LDAX"},
                                {DATA_16 + 3, 0x2a, "LHLD"},
                                {DAD_REG + (DATA_16 << 4) + 3, 0x01, "LXI"},
                                {DST_REG + (SRC_REG << 4) + 1, 0x40, "MOV"},
                                {DST_REG + (DATA_8 << 4) + 2, 0x06, "MVI"},
                                {NONE + 1, 0x00, "NOP"},
                                {SRC_REG + 1, 0xb0, "ORA"},
                                {PSEUDO, ORG, "ORG"},
                                {DATA_8 + 2, 0xf6, "ORI"},
                                {PORT + 2, 0xd3, "OUT"},
                                {PSEUDO, PAGE, "PAGE"},
                                {NONE + 1, 0xe9, "PCHL"},
                                {POP_REG + 1, 0xc1, "POP"},
                                {POP_REG + 1, 0xc5, "PUSH"},
                                {NONE + 1, 0x17, "RAL"},
                                {NONE + 1, 0x1f, "RAR"},
                                {NONE + 1, 0xd8, "RC"},
                                {NONE + 1, 0xc9, "RET"},
                                {NONE + 1, 0x20, "RIM"},
                                {NONE + 1, 0x07, "RLC"},
                                {NONE + 1, 0xf8, "RM"},
                                {NONE + 1, 0xd0, "RNC"},
                                {NONE + 1, 0xc0, "RNZ"},
                                {NONE + 1, 0xf0, "RP"},
                                {NONE + 1, 0xe8, "RPE"},
                                {NONE + 1, 0xe0, "RPO"},
                                {NONE + 1, 0x0f, "RRC"},
                                {RST_NUM + 1, 0xc7, "RST"},
                                {NONE + 1, 0xc8, "RZ"},
                                {SRC_REG + 1, 0x98, "SBB"},
                                {DATA_8 + 2, 0xde, "SBI"},
                                {PSEUDO, SET, "SET"},
                                {DATA_16 + 3, 0x22, "SHLD"},
                                {NONE + 1, 0x30, "SIM"},
                                {NONE + 1, 0xf9, "SPHL"},
                                {DATA_16 + 3, 0x32, "STA"},
                                {LDAX_REG + 1, 0x02, "STAX"},
                                {NONE + 1, 0x37, "STC"},
                                {SRC_REG + 1, 0x90, "SUB"},
                                {DATA_8 + 2, 0xd6, "SUI"},
                                {PSEUDO, TITLE, "TITLE"},
                                {NONE + 1, 0xeb, "XCHG"},
                                {SRC_REG + 1, 0xa8, "XRA"},
                                {DATA_8 + 2, 0xee, "XRI"},
                                {NONE + 1, 0xe3, "XTHL"}
    };

    return(BinSearch(opctbl, opctbl + MAXDIM(opctbl), nam));
}

/*  Operator table search routine.  This routine pats down the		    */
/*  operator table for a given operator and returns either a pointer        */
/*  to it or NULL if the opcode doesn't exist.                              */

OPCODE *find_operator(CHAR *nam)
{
    static OPCODE   oprtbl[] = {
                                {BCDEHLMA + REG, A, "A"},
                                {BINARY + LOG1 + OPR, AND, "AND"},
                             {BCDEHLMA + BDHPSW + BDHSP + BD + REG, B, "B"},
                                {BCDEHLMA + REG, C, "C"},
                             {BCDEHLMA + BDHPSW + BDHSP + BD + REG, D, "D"},
                                {BCDEHLMA + REG, E, "E"},
                                {BINARY + RELAT + OPR, '=', "EQ"},
                                {BINARY + RELAT + OPR, GE, "GE"},
                                {BINARY + RELAT + OPR, '>', "GT"},
                                {BCDEHLMA + BDHPSW + BDHSP + REG, H, "H"},
                                {UNARY + UOP3 + OPR, HIGH, "HIGH"},
                                {BCDEHLMA + REG, L, "L"},
                                {BINARY + RELAT + OPR, LE, "LE"},
                                {UNARY + UOP3 + OPR, LOW, "LOW"},
                                {BINARY + RELAT + OPR, '<', "LT"},
                                {BCDEHLMA + REG, M, "M"},
                                {BINARY + MULT + OPR, MOD, "MOD"},
                                {BINARY + RELAT + OPR, NE, "NE"},
                                {UNARY + UOP2 + OPR, NOT, "NOT"},
                                {BINARY + LOG2 + OPR, OR, "OR"},
                                {BDHPSW + REG, PSW, "PSW"},
                                {BINARY + MULT + OPR, SHL, "SHL"},
                                {BINARY + MULT + OPR, SHR, "SHR"},
                                {BDHSP + REG, SP, "SP"},
                                {BINARY + LOG2 + OPR, XOR, "XOR"}
    };

    return(BinSearch(oprtbl, oprtbl + MAXDIM(oprtbl), nam));
}

static OPCODE *BinSearch(OPCODE *lo, OPCODE *hi, CHAR *nam)
{
    SCRATCH int     i;
    SCRATCH OPCODE *chk;

    for (;;)
    {
        chk = lo + (hi - lo) / 2;
        if (!(i = ustrcmp(chk->oname, nam)))
            return chk;
        if (chk == lo)
            return NULL;
        if (i < 0)
            lo = chk;
        else
            hi = chk;
    }
}

static SHORT ustrcmp(CHAR *s, CHAR *t)
{
    SCRATCH int     i;

    while (!(i = toupper(*s++) - toupper(*t)) && *t++)
        ;
    return(i);
}

/*  Buffer storage for line listing routine.  This allows the listing	   */
/*  output routines to do all operations without the main routine	   */
/*  having to fool with it.                                                */

static FILE    *list = NULL;

/*  Listing file open routine.  If a listing file is already open, a        */
/*  warning occurs.  If the listing file doesn't open correctly, a          */
/*  fatal error occurs.  If no listing file is open, all calls to	    */
/*  lputs() and lclose() have no effect.				    */

void lopen(CHAR *nam)
{
    if (list)
        warning(TWOLST);
    else
    if (!(list = fopen(nam, "w")))
        fatal_error(LSTOPEN);

    fprintf(list, "\x0f");   // Compressed print mode
    return;
}

/*  Listing file line output routine.  This routine processes the	    */
/*  source line saved by popc() and the output of the line assembler in     */
/*  buffer obj into a line of the listing.  If the disk fills up, a	    */
/*  fatal error occurs. 						    */

void lputs(void)
{
    SCRATCH SHORT     i, j;
    SCRATCH USHORT   *o;

    if (list)
    {
        i = bytes;
        o = obj;
        do
        {
            fprintf(list, "%c  ", errcode);
            if (listhex)
            {
                fprintf(list, "%04x  ", address);
                for (j = 4; j; --j)
                {
                    if (i)
                    {
                        --i;
                        ++address;
                        fprintf(list, " %02x", *o++);
                    }
                    else
                        fprintf(list, "   ");
                }
            }
            else
                fprintf(list, "%18s", "");
            fprintf(list, "   %s", line);
            strcpy(line, "\n");
            check_page();
            if (ferror(list))
                fatal_error(DSKFULL);
        } while (listhex && i);
    }
    return;
}

/*  Listing file close routine.  The symbol table is appended to the        */
/*  listing in alphabetic order by symbol name, and the listing file is     */
/*  closed.  If the disk fills up, a fatal error occurs.		    */

static int      col = 0;

void lclose(void)
{
    void            fatal_error(), list_sym();

    if (list)
    {
        if (sroot)
        {
            list_sym(sroot);
            if (col)
                fprintf(list, "\n");
        }
	fprintf(list, "\f\x0e");
        if (ferror(list) || fclose(list) == EOF)
            fatal_error(DSKFULL);
    }
    return;
}

static void list_sym(SYMBOL *sp)
{
    if (sp)
    {
        list_sym(sp->left);
        fprintf(list, "%04x  %-10s", sp->valu, sp->sname);
        col = ++col % SYMCOLS;
        if (col)
            fprintf(list, "    ");
        else
        {
            fprintf(list, "\n");
            if (sp->right)
                check_page();
        }
        list_sym(sp->right);
    }
    return;
}

static void check_page(void)
{
    if (pagelen && !--listleft)
        eject = TRUE;

    if (eject)
    {
        eject = FALSE;
        listleft = pagelen;
        fprintf(list, "\f");
        if (title[0])
        {
            listleft -= 2;
            fprintf(list, "%s\n\n", title);
        }
    }
    return;
}

/*  Buffer storage for hex output file.  This allows the hex file        */
/*  output routines to do all of the required buffering and record	 */
/*  forming without the        main routine having to fool with it.	 */

static FILE    *hex = NULL;
static USHORT        cnt = 0;
static USHORT        addr = 0;
static USHORT        sum = 0;
static USHORT        buf[HEXSIZE];

/*  Hex file open routine.  If a hex file is already open, a warning        */
/*  occurs.  If the hex file doesn't open correctly, a fatal error          */
/*  occurs.  If no hex file is open, all calls to hputc(), hseek(), and     */
/*  hclose() have no effect.                                                */

void hopen(CHAR *nam)
{
    if (hex)
        warning(TWOHEX);
    else
    {
	if (!(hex = fopen(nam, "w+b")))
            fatal_error(HEXOPEN);
    }
    return;
}

/*  Hex file write routine.  The data byte is appended to the current        */
/*  record.  If the record fills up, it gets written to disk.  If the        */
/*  disk fills up, a fatal error occurs.				     */

void hputc(USHORT c)
{
    if (hex)
    {
        buf[cnt++] = c;
        if (cnt == HEXSIZE)
            record(0);
    }
    return;
}

/*  Hex file address set routine.  The specified address becomes the        */
/*  load address of the next record.  If a record is currently open,        */
/*  it gets written to disk.  If the disk fills up, a fatal error	    */
/*  occurs.                                                                */

void hseek(USHORT a)
{
    if (hex)
    {
        if (cnt)
            record(0);
        addr = a;
    }
    return;
}

/*  Hex file close routine.  Any open record is written to disk, the        */
/*  EOF record is added, and file is closed.  If the disk fills up, a	    */
/*  fatal error occurs. 						    */

void hclose(void)
{
    if (hex)
    {
        if (cnt)
            record(0);
        record(1);
        if (fclose(hex) == EOF)
            fatal_error(DSKFULL);
    }
    return;
}


static void record(USHORT typ)
{
    switch (sObjFmt)
    {
	case OBJFMT_INTELHEX:
	    IntelHex(typ);
	    break;

	case OBJFMT_M100HEX:
	    M100Hex(typ);
	    break;

	case OBJFMT_M100BIN:
	    M100Bin(typ);
	    break;
    }

    addr += cnt;
    cnt = 0;

    if (ferror(hex))
        fatal_error(DSKFULL);
    return;
}


static void IntelHex(USHORT typ)
{
    register SHORT	i;

    putc(':', hex);
    putb(cnt);
    putb(high(addr));
    putb(low(addr));
    putb(typ);
    for (i = 0; i < cnt; ++i)
        putb(buf[i]);
    putb(low(-sum));
    putc('\r', hex);
    putc('\n', hex);
}


static void M100Hex(USHORT typ)
{
    register SHORT	i;
    auto     USHORT usLen;
    static   BOOL	bFirstTime = TRUE;

    if (bFirstTime)
    {
	for (i = 0; i < 6; ++i)
	{
	    putc('0', hex);
	    putc('0', hex);
	}

	putc('\r', hex);
	putc('\n', hex);

	bFirstTime = FALSE;
    }

    if (0 == typ)
    {
	for (i = 0; i < cnt; ++i)
	    putb(buf[i]);

	putc('\r', hex);
	putc('\n', hex);
    }
    else
    {
	fflush(hex);
	fseek(hex, 0L, SEEK_SET);
	putb(low(usLoAddr));
	putb(high(usLoAddr));
    usLen = usHiAddr - usLoAddr + 1;
	putb(low(usLen));
	putb(high(usLen));
	if ((USHORT) -1 != usEntryAddr)
	{
	    putb(low(usEntryAddr));
	    putb(high(usEntryAddr));
	}
    }

    return;
}


static void M100Bin(USHORT typ)
{
    register SHORT	i;
    auto     USHORT usLen;
    static   BOOL	bFirstTime = TRUE;

    if (bFirstTime)
    {
	for (i = 0; i < 6; ++i)
	    putc(0, hex);

	bFirstTime = FALSE;
    }

    if (0 == typ)
    {
	for (i = 0; i < cnt; ++i)
	    putc(buf[i], hex);
    }
    else
    {
	fflush(hex);
	fseek(hex, 0L, SEEK_SET);
	putc(low(usLoAddr), hex);
	putc(high(usLoAddr), hex);
	usLen = usHiAddr - usLoAddr + 1;
	putc(low(usLen), hex);
	putc(high(usLen), hex);
	if ((USHORT) -1 != usEntryAddr)
	{
	    putc(low(usEntryAddr), hex);
	    putc(high(usEntryAddr), hex);
	}
    }

    return;
}


static void putb(USHORT b)
{
    static   CHAR     digit[] = "0123456789ABCDEF";

    putc(digit[b >> 4], hex);
    putc(digit[b & 0x0f], hex);
    sum += b;
    return;
}

/*  Error handler routine.  If the current error code is non-blank,	    */
/*  the error code is filled in and the        number of lines with errors  */
/*  is adjusted.							    */

void error(CHAR code)
{
    if (errcode == SPACE)
    {
        errcode = code;
        ++errors;
    }
    return;
}

/*  Fatal error handler routine.  A message gets printed on the stderr	   */
/*  device, and the program bombs.					   */

void fatal_error(CHAR *msg)
{
    printf("Fatal Error -- %s\n", msg);
    exit(-1);
}

/*  Non-fatal error handler routine.  A message gets printed on the        */
/*  stderr device, and the routine returns.                                */

void warning(CHAR *msg)
{
    printf("Warning -- %s\n", msg);
    return;
}
