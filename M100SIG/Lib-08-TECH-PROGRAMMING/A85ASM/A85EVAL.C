/*
        HEADER:                CUG267;
        TITLE:                8085 Cross-Assembler (Portable);
        FILENAME:        A85EVAL.C;
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
  
This file contains the assembler's expression evaluator and lexical analyzer.
The lexical analyzer chops the input character stream up into discrete tokens
that are processed by the expression analyzer and the line assembler.  The
expression analyzer processes the token stream into unsigned results of
arithmetic expressions.
*/

/*  Get global goodies:  */

#include "a85.h"

static USHORT		    eval(USHORT pre);
static void                 exp_error(CHAR c);
static void                 make_number(USHORT base);
static BOOL		    isnum(SHORT c);
static BOOL		    ishex(SHORT c);
static BOOL		    isalnum(SHORT c);
static SHORT		    GetChar(FILE *fp);


/*  Expression analysis routine.  The token stream from the lexical        */
/*  analyzer is processed as an arithmetic expression and reduced to an        */
/*  unsigned value.  If an error occurs during the evaluation, the        */
/*  global flag        forwd is set to indicate to the line assembler that it        */
/*  should not base certain decisions on the result of the evaluation.        */

static SHORT     bad;

USHORT expr(void)
{
    SCRATCH unsigned u;

    bad = FALSE;
    u = eval(START);
    return(bad ? 0 : u);
}

static USHORT eval(USHORT pre)
{
    register unsigned op, u, v;

    while (TRUE)
    {
        u = op = lex()->valu;
        switch (token.attr & TYPE)
        {
            case REG:
                exp_error('S');
                break;

            case SEP:
            case EOL:
                unlex();
                exp_error('E');
                return (0);

            case OPR:
                if (!(token.attr & UNARY))
                {
                    exp_error('E');
                    break;
                }
                u = eval((op == '+' || op == '-') ?
                         (unsigned) UOP1 : token.attr & PREC);
                switch (op)
                {
                    case '-':
                        u = word(-u);
                        break;

                    case NOT:
                        u ^= 0xffff;
                        break;

                    case HIGH:
                        u = high(u);
                        break;

                    case LOW:
                        u = low(u);
                        break;
                }

            case VAL:
            case STR:
                while (TRUE)
                {
                    op = lex()->valu;
                    switch (token.attr & TYPE)
                    {
                        case REG:
                            exp_error('S');
                            break;

                        case SEP:
                        case EOL:
                            if (pre == LPREN)
                                exp_error('(');
                            unlex();
                            return(u);

                        case STR:
                        case VAL:
                            exp_error('E');
                            break;

                        case OPR:
                            if (!(token.attr & BINARY))
                            {
                                exp_error('E');
                                break;
                            }
                            if ((token.attr & PREC) >= pre)
                            {
                                unlex();
                                return(u);
                            }
                            if (op != ')')
                                v = eval(token.attr & PREC);
                            switch (op)
                            {
                                case '+':
                                    u += v;
                                    break;

                                case '-':
                                    u -= v;
                                    break;

                                case '*':
                                    u *= v;
                                    break;

                                case '/':
                                    u /= v;
                                    break;

                                case MOD:
                                    u %= v;
                                    break;

                                case AND:
                                    u &= v;
                                    break;

                                case OR:
                                    u |= v;
                                    break;

                                case XOR:
                                    u ^= v;
                                    break;

                                case '<':
                                    u = u < v;
                                    break;

                                case LE:
                                    u = u <= v;
                                    break;

                                case '=':
                                    u = u == v;
                                    break;

                                case GE:
                                    u = u >= v;
                                    break;

                                case '>':
                                    u = u > v;
                                    break;

                                case NE:
                                    u = u != v;
                                    break;

                                case SHL:
                                    if (v > 15)
                                        exp_error('E');
                                    else
                                        u <<= v;
                                    break;

                                case SHR:
                                    if (v > 15)
                                        exp_error('E');
                                    else
                                        u >>= v;
                                    break;

                                case ')':
                                    if (pre == LPREN)
                                        return u;
                                    exp_error('(');
                                    break;
                            }
                            clamp(u);
                            break;
                    }
                }
                break;
        }
    }

    return(0);
}

static void exp_error(CHAR c)
{
    forwd = bad = TRUE;
    error(c);
    return;
}

/*  Lexical analyzer.  The source input character stream is chopped up  */
/*  into its component parts and the pieces are evaluated.  Symbols are */
/*  looked up, operators are looked up, etc.  Everything gets reduced   */
/*  to an attribute word, a numeric value, and (possibly) a string      */
/*  value.                                                              */

static BOOL          oldt = FALSE;
static BOOL          quote = FALSE;

TOKEN *lex(void)
{
    SCRATCH char    c, d, *p;
    SCRATCH unsigned b;
    SCRATCH OPCODE *o;
    SCRATCH SYMBOL *s;

    if (oldt)
    {
        oldt = FALSE;
        return &token;
    }

    trash();
    if (isalph(c = popc()))
    {
        pushc(c);
        pops(token.sval);
        if (!strcmp(token.sval, "$"))
        {
            token.attr = VAL;
            token.valu = pc;
        }
        else
	{
	    if (NULL != (o = find_operator(token.sval)))
	    {
		token.attr = o->attr;
		token.valu = o->valu;
	    }
	    else
	    {
		token.attr = VAL;
		token.valu = 0;
		if (NULL != (s = find_symbol(token.sval)))
		{
		    token.valu = s->valu;
		    if (pass == 2 && s->attr & FORWD)
			forwd = TRUE;
		}
		else
		    exp_error('U');
	    }
	}
    }
    else
    {
	if (isnum(c))
	{
	    pushc(c);
	    pops(token.sval);
	    for (p = token.sval; *p; ++p);
	    switch (toupper(*--p))
	    {
		case 'B':
		    b = 2;
		    break;

		case 'O':
		case 'Q':
		    b = 8;
		    break;

		default:
		    ++p;

		case 'D':
		    b = 10;
		    break;

		case 'H':
		    b = 16;
		    break;
	    }
	    *p = NUL;
	    make_number(b);
	}
	else
	{
	    switch (c)
	    {
		case '(':
		    token.attr = UNARY + LPREN + OPR;
		    goto opr1;

		case ')':
		    token.attr = BINARY + RPREN + OPR;
		    goto opr1;

		case '+':
		    token.attr = BINARY + UNARY + ADDIT + OPR;
		    goto opr1;

		case '-':
		    token.attr = BINARY + UNARY + ADDIT + OPR;
		    goto opr1;

		case '*':
		    token.attr = BINARY + UNARY + MULT + OPR;
		    goto opr1;

		case '/':
		    token.attr = BINARY + MULT + OPR;
opr1:		    token.valu = c;
		    break;

		case '<':
		    token.valu = c;
		    if ((c = popc()) == '=')
			token.valu = LE;
		    else
		    {
			if (c == '>')
			    token.valu = NE;
			else
			    pushc(c);
		    }
		    goto opr2;

		case '=':
		    token.valu = c;
		    if ((c = popc()) == '<')
			token.valu = LE;
		    else
		    {
			if (c == '>')
			    token.valu = GE;
			else
			    pushc(c);
		    }
		    goto opr2;

		case '>':
		    token.valu = c;
		    if ((c = popc()) == '<')
			token.valu = NE;
		    else
		    {
			if (c == '=')
			    token.valu = GE;
			else
			    pushc(c);
		    }
opr2:		    token.attr = BINARY + RELAT + OPR;
		    break;

		case '\'':
		case '"':
		    quote = TRUE;
		    token.attr = STR;
		    for (p = token.sval;; ++p)
		    {
			if ((d = popc()) == '\n')
			{
			    exp_error('"');
			    break;
			}
			if ((*p = d) == c && (d = popc()) != c)
			    break;
		    }
		    pushc(d);
		    *p = NUL;
		    quote = FALSE;
		    token.valu = token.sval[0];
		    if (token.valu && token.sval[1])
			token.valu = (token.valu << 8) + token.sval[1];
		    break;

		case ',':
		    token.attr = SEP;
		    break;

		case '\n':
		    token.attr = EOL;
		    break;
	    }
	}
    }
    return(&token);
}

static void make_number(USHORT base)
{
    SCRATCH char   *p;
    SCRATCH unsigned d;
    void            exp_error();

    token.attr = VAL;
    token.valu = 0;
    for (p = token.sval; *p; ++p)
    {
        d = toupper(*p) - (isnum(*p) ? '0' : 'A' - 10);
        token.valu = token.valu * base + d;
        if (!ishex(*p) || d >= base)
        {
            exp_error('D');
            break;
        }
    }
    clamp(token.valu);
    return;
}

BOOL isalph(SHORT c)
{
    return (c >= '@' && c <= '~') || (c >= '#' && c <= '&')
				  ||
	    (c == '!' || c == '.' || c == ':' || c == '?');
}

static BOOL isnum(SHORT c)
{
    return(c >= '0' && c <= '9');
}

static BOOL ishex(SHORT c)
{
    return(isnum(c) || ((c = toupper(c)) >= 'A' && c <= 'F'));
}

static BOOL isalnum(SHORT c)
{
    return(isalph(c) || isnum(c));
}

/*  Push back the current token into the input stream.  One level of        */
/*  pushback is supported.                                                */

void unlex(void)
{
    oldt = TRUE;
    return;
}

/*  Get an alphanumeric string into the string value part of the        */
/*  current token.  Leading blank space is trashed.                        */

void pops(CHAR *s)
{
    trash();
    for (; isalnum(*s = popc()); ++s)
	;
    pushc(*s);
    *s = NUL;
    return;
}

/*  Trash blank space and push back the character following it.                */

void trash(void)
{
    SCRATCH char    c;

    while ((c = popc()) == SPACE)
	;
    pushc(c);
    return;
}

/*  Get character from input stream.  This routine does a number of        */
/*  other things while it's passing back characters.  All control        */
/*  characters except \t and \n are ignored.  \t is mapped into ' '.        */
/*  Semicolon is mapped to \n.  In addition, a copy of all input is set        */
/*  up in a line buffer for the benefit of the listing.                        */

static SHORT         oldc, eol;
static CHAR        *lptr;

SHORT popc(void)
{
    SCRATCH int     c;

    if (oldc)
    {
        c = oldc;
	oldc = NUL;
        return c;
    }

    if (eol)
	return('\n');

    for (;;)
    {
	if ((c = GetChar(source)) != EOF && (c &= 0377) == ';' && !quote)
        {
            do
	    {
                *lptr++ = c;
	    } while ((c = GetChar(source)) != EOF && (c &= 0377) != '\n');
        }

        if (c == EOF)
            c = '\n';

	if ((*lptr++ = c) >= SPACE && c <= '~')
	    return(c);

        if (c == '\n')
        {
	    eol   = TRUE;
	    *lptr = NUL;
	    return('\n');
        }
    }
}

/*  Push character back onto input stream.  Only one level of push-back        */
/*  supported.  \0 cannot be pushed back, but nobody would want to.        */

void pushc(SHORT c)
{
    oldc = (CHAR) c;
    return;
}

/*  Begin new line of source input.  This routine returns non-zero if        */
/*  EOF        has been reached on the main source file, zero otherwise.        */

SHORT newline(void)
{
    oldc = NUL;
    lptr = line;
    oldt = eol = FALSE;
    while (feof(source))
    {
        if (ferror(source))
            fatal_error(ASMREAD);
        if (filesp)
        {
            fclose(source);
            source = filestk[--filesp];
        }
        else
	    return(TRUE);
    }
    return(FALSE);
}


static SHORT GetChar(FILE *fp)
{
    register SHORT	c;
    static   SHORT	col    = 0;
    static   SHORT	tabs   = 0;

    if (tabs)
    {
	--tabs;
	++col;
	return(SPACE);
    }

    c = getc(fp);

    switch (c)
    {
	case '\n':
	    col    = 0;
	    break;

	case '\t':
	    tabs = 8 - ((col + 8) % 8);
	    c = SPACE;
	    break;
    }

    ++col;
    return(c);
}
