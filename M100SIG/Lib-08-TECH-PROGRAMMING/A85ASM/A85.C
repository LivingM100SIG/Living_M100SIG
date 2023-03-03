/*
        HEADER:                CUG267;
        TITLE:                8085 Cross-Assembler (Portable);
        FILENAME:        A85.C;
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
  
This file contains the main program and line assembly routines for the
assembler.  The main program parses the command line, feeds the source lines
to the line assembly routine, and sends the results to the listing and object
file output routines.  It also coordinates the activities of everything.  The
line assembly routines uses the expression analyzer and the lexical analyzer
to parse the source line and convert it into the object bytes that it
represents.
*/

/*  Get global goodies:  */

#define DRIVER
#include "a85.h"

static void		    Usage(void);
static void                 flush(void);
static void                 do_label(void);
static void                 normal_op(void);
static void                 pseudo_op(void);


/*  Mainline routine.  This routine parses the command line, sets up        */
/*  the assembler at the beginning of each pass, feeds the source text        */
/*  to the line assembler, feeds the result to the listing and hex file        */
/*  drivers, and cleans everything up at the end of the run.                */

static int      done, ifsp, off;

void main(int argc, CHAR **argv)
{
    SCRATCH  USHORT    *o;

    printf("8085 Cross-Assembler (Portable) Ver 0.1a\n");
    printf("Copyright (c) 1985,1987 William C. Colley, III\n");
    printf("Enhancements by Bob Withers - 1990\n\n");

    if (argc < 2)
	Usage();

    while (--argc > 0)
    {
        if (**++argv == '-')
        {
            switch (toupper(*++*argv))
            {
                case 'L':
                    if (!*++*argv)
                    {
                        if (!--argc)
                        {
                            warning(NOLST);
                            break;
                        }
                        else
                            ++argv;
                    }
                    lopen(*argv);
                    break;

                case 'O':
		    switch (toupper(*++*argv))
		    {
			case 'H':
			    sObjFmt = OBJFMT_M100HEX;
			    break;

			case 'B':
			    sObjFmt = OBJFMT_M100BIN;
			    break;

			case 'I':
			    sObjFmt = OBJFMT_INTELHEX;
			    break;

			default:
			    --*argv;
			    break;
		    }

                    if (!*++*argv)
                    {
                        if (!--argc)
                        {
                            warning(NOHEX);
                            break;
                        }
                        else
                            ++argv;
                    }
                    hopen(*argv);
                    break;

                default:
                    warning(BADOPT);
            }
        }
        else
	{
	    if (filestk[0])
		warning(TWOASM);
	    else
		if (!(filestk[0] = fopen(*argv, "r")))
		    fatal_error(ASMOPEN);
	}
    }

    if (!filestk[0])
        fatal_error(NOASM);

    if (-1 == sObjFmt)
	sObjFmt = OBJFMT_INTELHEX;

    while (++pass < 3)
    {
        fseek(source = filestk[0], 0L, 0);
        done = off = FALSE;
        errors = filesp = ifsp = pagelen = pc = 0;
	title[0] = NUL;
        while (!done)
        {
	    errcode = SPACE;
            if (newline())
            {
                error('*');
                strcpy(line, "\tEND\n");
                done = eject = TRUE;
                listhex = FALSE;
                bytes = 0;
            }
            else
                asm_line();
            pc = word(pc + bytes);
            if (pass == 2)
            {
                lputs();

		if (bytes)
		{
		    if (pc - bytes < usLoAddr)
			usLoAddr = pc - bytes;

		    if (pc - 1 > usHiAddr)
			usHiAddr = pc - 1;
		}

		for (o = obj; bytes--; hputc(*o++))
		    ;
            }
        }
    }

    fclose(filestk[0]);
    lclose();
    hclose();

    printf("\nStart addr: %5u (%04X)\n", usLoAddr, usLoAddr);
    printf("End addr  : %5u (%04X)\n", usHiAddr, usHiAddr);
    if ((USHORT) -1 != usEntryAddr)
	printf("Entry addr: %5u (%04X)\n", usEntryAddr, usEntryAddr);

    if (errors)
	printf("\n%d Error%s\n", errors, 1 == errors ? "" : "s");
    else
	printf("\nNo Errors\n");

    exit(errors);
}


static void Usage(void)
{
    printf("A85 <source file> [-L <list file>] [-O[IHB] <obj file>]\n\n");
    printf("    Optional switches:  -L specify listing file\n");
    printf("                        -O specify object file\n");
    printf("                           -OI Intel hex format (default)\n");
    printf("                           -OH M100 hex format\n");
    printf("                           -OB M100 .CO format\n");
    exit(0);
}


/*  Line assembly routine.  This routine gets expressions and tokens        */
/*  from the source file using the expression evaluator and lexical        */
/*  analyzer, respectively.  It fills a buffer with the machine code        */
/*  bytes and returns nothing.                                                */

static CHAR	label[MAXLINE];
static SHORT	ifstack[IFDEPTH] = {ON};

static OPCODE  *opcod;

void asm_line(void)
{
    SCRATCH CHAR   *p;
    SCRATCH SHORT   i;

    address = pc;
    bytes = 0;
    eject = forwd = listhex = FALSE;
    for (i = 0; i < BIGINST; obj[i++] = NOP)
	;

    label[0] = NUL;
    if ((i = popc()) != SPACE && i != '\n')
    {
        if (isalph(i))
        {
            pushc(i);
            pops(label);
            for (p = label; *p; ++p);
            if (*--p == ':')
		*p = NUL;
            if (find_operator(label))
            {
		label[0] = NUL;
                error('L');
            }
        }
        else
        {
            error('L');
	    while ((i = popc()) != SPACE && i != '\n')
		;
        }
    }

    trash();
    opcod = NULL;
    if ((i = popc()) != '\n')
    {
        if (!isalph(i))
            error('S');
        else
        {
            pushc(i);
            pops(token.sval);
            if (!(opcod = find_code(token.sval)))
                error('O');
        }
        if (!opcod)
        {
            listhex = TRUE;
            bytes = BIGINST;
        }
    }

    if (opcod && opcod->attr & ISIF)
    {
        if (label[0])
            error('L');
    }
    else
    if (off)
    {
        listhex = FALSE;
        flush();
        return;
    }

    if (!opcod)
    {
        do_label();
        flush();
    }
    else
    {
        listhex = TRUE;
        if (opcod->attr & PSEUDO)
            pseudo_op();
        else
            normal_op();
        while ((i = popc()) != '\n')
	{
	    if (SPACE != i)
                error('T');
	}
    }
    source = filestk[filesp];
    return;
}

static void flush(void)
{
    while (popc() != '\n')
	;
    return;
}

static void do_label(void)
{
    SCRATCH SYMBOL *l;

    if (label[0])
    {
        listhex = TRUE;
        if (pass == 1)
        {
            if (!((l = new_symbol(label))->attr))
            {
                l->attr = FORWD + VAL;
                l->valu = pc;
            }
        }
        else
        {
            if (NULL != (l = find_symbol(label)))
            {
                l->attr = VAL;
                if (l->valu != pc)
                    error('M');
            }
            else
                error('P');
        }
    }
    return;
}

static void normal_op(void)
{
    SCRATCH unsigned attrib, u;

    do_label();
    bytes = (attrib = opcod->attr) & BYTES;
    if (pass < 2)
        return;
    obj[0] = opcod->valu;
    obj[1] = obj[2] = 0;

    while (attrib & ARG1)
    {
        lex();
        switch (attrib & ARG1)
        {
            case DATA_16:
                unlex();
                obj[1] = low(u = expr());
                obj[2] = high(u);
                break;

            case DATA_8:
                unlex();
                if ((u = expr()) > 0xff && u < 0xff80)
                {
                    error('V');
                    u = 0;
                }
                obj[1] = low(u);
                break;

            case PORT:
                unlex();
                if ((u = expr()) > 0xff)
                {
                    error('V');
                    u = 0;
                }
                obj[1] = low(u);
                break;

            case RST_NUM:
                unlex();
                if ((u = expr()) > 7)
                {
                    error('V');
                    u = 0;
                }
                obj[0] |= u << 3;
                break;

            case LDAX_REG:
                u = BD;
                goto do_reg;

            case DAD_REG:
                u = BDHSP;
                goto do_reg;

            case POP_REG:
                u = BDHPSW;
                goto do_reg;

            case SRC_REG:
                token.valu >>= 3;
                u = BCDEHLMA;
                goto do_reg;

            case DST_REG:
                u = BCDEHLMA;
do_reg: 	if ((token.attr & TYPE) != REG)
                {
                    error('S');
                    break;
                }
                if (!(token.attr & u))
                {
                    error('R');
                    break;
                }
                obj[0] |= token.valu;
                break;
        }

        if (((attrib >>= 4) & ARG1) && (lex()->attr & TYPE) != SEP)
        {
            error('S');
            break;
        }

        if (obj[0] == 0x76)
            error('R');
    }
    return;
}

static void pseudo_op(void)
{
    SCRATCH CHAR    *s;
    SCRATCH SHORT    c;
    SCRATCH USHORT  *o, u;
    SCRATCH SYMBOL  *l;

    o = obj;
    switch (opcod->valu)
    {
        case DB:
            do_label();
            do
            {
                switch (lex()->attr & TYPE)
                {
                    case SEP:
                        unlex();
                        u = 0;
                        goto save_byte;

                    case STR:
                        trash();
                        pushc(c = popc());
                        if (c == ',' || c == '\n')
                        {
			    for (s = token.sval; *s; *o++ = *s++)
                                ++bytes;
                            break;
                        }

                    default:
                        unlex();
                        if ((u = expr()) > 0xff &&
                            u < 0xff80)
                        {
                            u = 0;
                            error('V');
                        }
                save_byte:*o++ = low(u);
                        ++bytes;
                        break;
                }
            } while ((lex()->attr & TYPE) == SEP);
            break;

        case DS:
            do_label();
            u = word(pc + expr());
            if (forwd)
                error('P');
            else
            {
                pc = u;
                if (pass == 2)
                    hseek(pc);
            }
            break;

        case DW:
            do_label();
            do
            {
                lex();
                unlex();
                u = ((token.attr & TYPE) == SEP) ? 0 : expr();
                *o++ = low(u);
                *o++ = high(u);
                bytes += 2;
            } while ((lex()->attr & TYPE) == SEP);
            break;

        case ELSE:
            listhex = FALSE;
            if (ifsp)
                off = (ifstack[ifsp] = -ifstack[ifsp]) != ON;
            else
                error('I');
            break;

        case END:
            do_label();
            if (filesp)
            {
                listhex = FALSE;
                error('*');
            }
            else
            {
                done = eject = TRUE;
                if (pass == 2)
                {
                    if ((lex()->attr & TYPE) != EOL)
                    {
                        unlex();
                        hseek(address = expr());
			usEntryAddr = address;
                    }
                }
                if (ifsp)
                    error('I');
            }
            break;

        case ENDIF:
            listhex = FALSE;
            if (ifsp)
                off = ifstack[--ifsp] != ON;
            else
                error('I');
            break;

        case EQU:
            if (label[0])
            {
                if (pass == 1)
                {
                    if (!((l = new_symbol(label))->attr))
                    {
                        l->attr = FORWD + VAL;
                        address = expr();
                        if (!forwd)
                            l->valu = address;
                    }
                }
                else
                {
                    if (NULL != (l = find_symbol(label)))
                    {
                        l->attr = VAL;
                        address = expr();
                        if (forwd)
                            error('P');
                        if (l->valu != address)
                            error('M');
                    }
                    else
                        error('P');
                }
            }
            else
                error('L');
            break;

        case IF:
            if (++ifsp == IFDEPTH)
                fatal_error(IFOFLOW);
            address = expr();
            if (forwd)
            {
                error('P');
                address = TRUE;
            }
            if (off)
            {
                listhex = FALSE;
                ifstack[ifsp] = 0;
            }
            else
            {
                ifstack[ifsp] = address ? ON : OFF;
                if (!address)
                    off = TRUE;
            }
            break;

        case INCL:
            listhex = FALSE;
            do_label();
            if ((lex()->attr & TYPE) == STR)
            {
                if (++filesp == FILES)
                    fatal_error(FLOFLOW);
                if (!(filestk[filesp] = fopen(token.sval, "r")))
                {
                    --filesp;
                    error('V');
                }
            }
            else
                error('S');
            break;

        case ORG:
            u = expr();
            if (forwd)
                error('P');
            else
            {
                pc = address = u;
                if (pass == 2)
                    hseek(pc);
            }
            do_label();
            break;

        case PAGE:
            listhex = FALSE;
            do_label();
            if ((lex()->attr & TYPE) != EOL)
            {
                unlex();
                if ((pagelen = expr()) > 0 && pagelen < 3)
                {
                    pagelen = 0;
                    error('V');
                }
            }
            eject = TRUE;
            break;

        case SET:
            if (label[0])
            {
                if (pass == 1)
                {
                    if (!((l = new_symbol(label))->attr)
                        || (l->attr & SOFT))
                    {
                        l->attr = FORWD + SOFT + VAL;
                        address = expr();
                        if (!forwd)
                            l->valu = address;
                    }
                }
                else
                {
                    if (NULL != (l = find_symbol(label)))
                    {
                        address = expr();
                        if (forwd)
                            error('P');
                        else
                        if (l->attr & SOFT)
                        {
                            l->attr = SOFT + VAL;
                            l->valu = address;
                        }
                        else
                            error('M');
                    }
                    else
                        error('P');
                }
            }
            else
                error('L');
            break;

        case TITLE:
            listhex = FALSE;
            do_label();
            if ((lex()->attr & TYPE) == EOL)
		title[0] = NUL;
            else
	    {
		if ((token.attr & TYPE) != STR)
		    error('S');
		else
		    strcpy(title, token.sval);
	    }
            break;
    }
    return;
}
