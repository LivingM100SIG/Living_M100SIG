
#ifndef A85_H
#define A85_H

/*****************************************************************************/
/*									     */
/*  HEADER:	    CUG267;						     */
/*  TITLE:	    8085 Cross-Assembler (Portable);			     */
/*  FILENAME:	    A85.H;						     */
/*  VERSION:	    0.1;						     */
/*  DATE:	    08/27/1988; 					     */
/*									     */
/*  DESCRIPTION:    "This program lets you use your computer to assemble     */
/*		    code for the Intel 8080 and 8085 microprocessors.  The   */
/*		    program is written in portable C rather than BDS C.      */
/*		    All assembler features are supported except 	     */
/*		    relocation, linkage, and macros.";                       */
/*									     */
/*  KEYWORDS:	    Software Development, Assemblers, Cross-Assemblers,      */
/*		    Intel, 8080, 8085;					     */
/*									     */
/*  SYSTEM:	    CP/M-80, CP/M-86, HP-UX, MSDOS, PCDOS, QNIX;	     */
/*  COMPILERS:	    Aztec C86, Aztec CII, CI-C86, Eco-C, Eco-C88, HP-UX,     */
/*		    Lattice C, Microsoft C, QNIX C;			     */
/*									     */
/*  WARNINGS:	    "This program has compiled successfully on 2 UNIX        */
/*		    compilers, 5 MSDOS compilers, and 2 CP/M compilers.      */
/*		    A port to BDS C would be extremely difficult.  A port    */
/*		    to Toolworks C is untried."                              */
/*									     */
/*  AUTHORS:	    William C. Colley III;				     */
/*                  Bob Withers                                              */
/*									     */
/*****************************************************************************/
/*									     */
/*		  8085 Cross-Assembler in Portable C			     */
/*									     */
/*	     Copyright (c) 1985,1987 William C. Colley, III		     */
/*									     */
/* Revision History:							     */
/*									     */
/* Ver	  Date		Description					     */
/*									     */
/* 0.0	 AUG 1987    Derived from version 3.4 of my portable 6800/6801	     */
/*		     cross-assembler.  WCC3.				     */
/*									     */
/* 0.1	 AUG 1988    Fixed a bug in the command line parser that puts it     */
/*		     into a VERY long loop if the user types a command line  */
/*		     like "A85 FILE.ASM -L".  WCC3 per Alex Cameron.	     */
/*									     */
/* 0.1a  Oct 1990    (bw) Added -OH option to generate object file in Tandy  */
/*                   Model 100 ASCII hex format.  Added -OB option to make   */
/*                   object file Model 100 binary .CO file.                  */
/*                   Restructured code and tuned some functions.             */
/*                   Corrected a bug that sometimes flagged valid statements */
/*                   as syntax errors depending on if tabs were included in  */
/*                   source line.  Corrected by adding function GetChar to   */
/*                   dynamically expand tabs on input.                       */
/*                                                                           */
/*****************************************************************************/
/*									     */
/* This header file contains the global constants and data type definitions  */
/* for all modules of the cross-assembler.  This also seems a good place to  */
/* put the compilation and linkage instructions for the animal.  This list   */
/* currently includes the following compilers:				     */
/*									     */
/*	       Compiler Name		   Op. Sys.	   Processor	     */
/*									     */
/*	   1)  Aztec C86		   CP/M-86	   8086, 8088	     */
/*					   MSDOS/PCDOS			     */
/*									     */
/*	   2)  AZTEC C II		   CP/M-80	   8080, Z-80	     */
/*									     */
/*	   3)  Computer Innovations C86    MSDOS/PCDOS	   8086, 8088	     */
/*									     */
/*	   4)  Eco-C			   CP/M-80	   Z-80 	     */
/*									     */
/*	   5)  Eco-C88			   MSDOS/PCDOS	   8086, 8088	     */
/*									     */
/*	   6)  HP C			   HP-UX	   68000	     */
/*									     */
/*	   7)  Lattice C		   MSDOS/PCDOS	   8086, 8088	     */
/*									     */
/*	   8)  Microsoft C		   MSDOS/PCDOS	   8086, 8088	     */
/*									     */
/*	   9)  QNIX C			   QNIX 	   8086, 8088	     */
/*									     */
/* Further additions will be made to the list as users feed the information  */
/* to me.  This particularly applies to UNIX and IBM-PC compilers.	     */
/*									     */
/* Compile-assemble-link instructions for this program under various	     */
/* compilers and operating systems:					     */
/*									     */
/*     1)  Aztec C86:							     */
/*									     */
/*	   A)  Uncomment out the "#define AZTEC_C 1" line and comment out    */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Assuming that all files are on drive A:, run the following    */
/*	       sequence of command lines:				     */
/*									     */
/*		   A>cc a85						     */
/*		   A>cc a85eval 					     */
/*		   A>cc a85util 					     */
/*		   A>ln a85.o a85eval.o a85util.o -lc			     */
/*		   A>era a85*.o 					     */
/*									     */
/*     2)  Aztec CII (version 1.06B):					     */
/*									     */
/*	   A)  Uncomment out the "#define AZTEC_C 1" line and comment out    */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Assuming the C compiler is called "CC.COM" and all files are  */
/*	       on drive A:, run the following sequence of command lines:     */
/*									     */
/*		   A>cc a85						     */
/*		   A>as -zap a85					     */
/*		   A>cc a85eval 					     */
/*		   A>as -zap a85eval					     */
/*		   A>cc a85util 					     */
/*		   A>as -zap a85util					     */
/*		   A>ln a85.o a85eval.o a85util.o -lc			     */
/*		   A>era a85*.o 					     */
/*									     */
/*     3)  Computer Innovations C86:					     */
/*									     */
/*	   A)  Uncomment out the "#define CI_C86 1" line and comment out     */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Compile the files A85.C, A85EVAL.C, and A85UTIL.C.  Link      */
/*	       according to instructions that come with the compiler.	     */
/*									     */
/*     4)  Eco-C (CP/M-80 version 3.10):				     */
/*									     */
/*	   A)  Uncomment out the "#define ECO_C 1" line and comment out      */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Assuming all files are on drive A:, run the following	     */
/*	       sequence of command lines:				     */
/*									     */
/*		   A>cp a85 -i -m					     */
/*		   A>cp a85eval -i -m					     */
/*		   A>cp a85util -i -m					     */
/*		   A>l80 a85,a85eval,a85util,a85/n/e			     */
/*		   A>era a85*.mac					     */
/*		   A>era a85*.rel					     */
/*									     */
/*     5)  Eco-C88:							     */
/*									     */
/*	   A)  Uncomment out the "#define ECO_C 1" line and comment out      */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Compile the files A85.C, A85EVAL.C, and A85UTIL.C.  Link      */
/*	       according to instructions that come with the compiler.	     */
/*									     */
/*     6)  HP-UX (a UNIX look-alike running on an HP-9000 Series 200/500,    */
/*	   68000-based machine):					     */
/*									     */
/*	   A)  Uncomment out the "#define HP_UX 1" line and comment out      */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Run the following command line:				     */
/*									     */
/*		   . cc a85.c a85eval.c a85util.c			     */
/*									     */
/*     7)  Lattice C:							     */
/*									     */
/*	   A)  Uncomment out the "#define LATTICE_C 1" line and comment      */
/*	       out all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Compile the files A85.C, A85EVAL.C, and A85UTIL.C.  Link      */
/*	       according to instructions that come with the compiler.	     */
/*									     */
/*     8)  Microsoft C (version 3.00):					     */
/*									     */
/*	   A)  Uncomment out the "#define MICROSOFT_C 1" line and comment    */
/*	       out all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Run the following command line:				     */
/*									     */
/*		   C>cl a85.c a85eval.c a85util.c			     */
/*									     */
/*     9)  QNIX C:							     */
/*									     */
/*	   A)  Uncomment out the "#define QNIX 1" line and comment out	     */
/*	       all other compiler names in A85.H.			     */
/*									     */
/*	   B)  Run the following command line:				     */
/*									     */
/*		   . cc a85.c a85eval.c a85util.c			     */
/*									     */
/* Note that, under CP/M-80, you can't re-execute a core image from a        */
/* previous assembly run with the "@.COM" trick.  This technique is	     */
/* incompatible with the Aztec CII compiler, so I didn't bother to support   */
/* it at all.								     */
/*									     */
/*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#define NUL			    '\0'
#define SPACE			    ' '

#define MAXDIM(a)		    (sizeof(a) / sizeof(a[0]))

typedef signed short		    SHORT;
typedef unsigned short		    USHORT;
typedef signed long		    LONG;
typedef unsigned long		    ULONG;
typedef signed char		    CHAR;
typedef unsigned char		    UCHAR;
typedef double			    DOUBLE;
typedef SHORT			    BOOL;

/*  Comment out all but the line containing the name of your compiler:	*/

#define      MICROSOFT_C
/* #define      AZTEC_C                                                 */
/* #define	CI_C86							*/
/* #define	ECO_C							*/
/* #define	HP_UX							*/
/* #define	LATTICE_C						*/
/* #define	QNIX							*/

/*  Compiler dependencies:						*/

#ifdef	AZTEC_C
#define	getc(f)		agetc(f)
#define	putc(c,f)	aputc(c,f)
#endif

#ifndef	ECO_C
#define	FALSE		0
#define	TRUE		(!0)
#endif

#ifdef	LATTICE_C
#define	void		int
#endif

#ifdef	QNIX
#define	fprintf		tfprintf
#define	printf		tprintf
#endif

/*  On 8-bit machines, the static type is as efficient as the register	*/
/*  type and far more efficient than the auto type.  On larger machines	*/
/*  such as the 8086 family, this is not necessarily the case.  To	*/
/*  let you experiment to see what generates the fastest, smallest code	*/
/*  for your machine, I have declared internal scratch variables in	*/
/*  functions "SCRATCH int", "SCRATCH unsigned", etc.  A SCRATCH	*/
/*  varible is made static below, but you might want to try register	*/
/*  instead.								*/

#define SCRATCH         auto

/*  A slow, but portable way of cracking an unsigned into its various	*/
/*  component parts:							*/

#define	clamp(u)	((u) &= 0xffff)
#define	high(u)		(((u) >> 8) & 0xff)
#define	low(u)		((u) & 0xff)
#define	word(u)		((u) & 0xffff)

/*  The longest source line the assembler can hold without exploding:	*/

#define	MAXLINE		255

/*  The maximum number of source files that can be open simultaneously:	*/

#define	FILES		4

/*  The fatal error messages generated by the assembler:		*/

#define	ASMOPEN		"Source File Did Not Open"
#define	ASMREAD		"Error Reading Source File"
#define	DSKFULL		"Disk or Directory Full"
#define	FLOFLOW		"File Stack Overflow"
#define	HEXOPEN		"Object File Did Not Open"
#define	IFOFLOW		"If Stack Overflow"
#define	LSTOPEN		"Listing File Did Not Open"
#define	NOASM		"No Source File Specified"
#define	SYMBOLS		"Too Many Symbols"

/*  The warning messages generated by the assembler:			*/

#define	BADOPT		"Illegal Option Ignored"
#define	NOHEX		"-o Option Ignored -- No File Name"
#define	NOLST		"-l Option Ignored -- No File Name"
#define	TWOASM		"Extra Source File Ignored"
#define	TWOHEX		"Extra Object File Ignored"
#define	TWOLST		"Extra Listing File Ignored"
#define MULTFMT 	"Multiple object format requests ignored"

/*  Line assembler (A85.C) constants:					*/

#define	BIGINST		3		/*  longest instruction length	*/
#define	IFDEPTH		16		/*  maximum IF nesting level	*/
#define	NOP		0x00		/*  processor's NOP opcode	*/
#define	ON		1		/*  assembly turned on		*/
#define	OFF		-1		/*  assembly turned off		*/

/*  Line assembler (A85.C) opcode attribute word flag masks:		*/

#define	PSEUDO		0x800	/*  is pseudo op			*/
#define	ISIF		0x400	/*  is IF, ELSE, or ENDI		*/
#define	ARG2		0x3c0	/*  second argument descriptor		*/
#define	ARG1		0x03c	/*  first argument descriptor		*/
#define	NONE		0x000	/*	no argument			*/
#define	DST_REG		0x004	/*	destination 8-bit register	*/
#define	SRC_REG		0x008	/*	source 8-bit register		*/
#define	POP_REG		0x00c	/*	B, D, H, or PSW			*/
#define	DAD_REG		0x010	/*	B, D, H, or SP			*/
#define	LDAX_REG	0x014	/*	B or D				*/
#define	DATA_8		0x018	/*	8-bit data			*/
#define	DATA_16		0x01c	/*	16-bit data			*/
#define	RST_NUM		0x020	/*	restart number (0-7)		*/
#define	PORT		0x024	/*	8-bit port number		*/
#define	BYTES		0x003	/*  number of bytes in instruction	*/

/*  Line assembler (A85.C) register values:				*/

#define	B		0x0000	/*			B		*/
#define	C		0x0008	/*			C		*/
#define	D		0x0010	/*			D		*/
#define	E		0x0018	/*			E		*/
#define	H		0x0020	/*			H		*/
#define	L		0x0028	/*			L		*/
#define	M		0x0030	/*			M		*/
#define	PSW		0x0030	/*			PSW		*/
#define	SP		0x0030	/*			SP		*/
#define	A		0x0038	/*			A		*/

/*  Line assembler (A85.C) pseudo-op opcode token values:		*/

#define	DB		1
#define	DS		2
#define	DW		3
#define	ELSE		4
#define	END		5
#define	ENDIF		6
#define	EQU		7
#define	IF		8
#define	INCL		9
#define	ORG		10
#define	PAGE		11
#define	SET		12
#define	TITLE		13

/*  Lexical analyzer (A85EVAL.C) token buffer and stream pointer:	*/

typedef struct
{
    unsigned       attr;
    unsigned       valu;
    char           sval[MAXLINE + 1];
}                  TOKEN;

/*  Lexical analyzer (A85EVAL.C) token attribute values:		*/

#define	EOL		0	/*  end of line				*/
#define	SEP		1	/*  field separator			*/
#define	OPR		2	/*  operator				*/
#define	STR		3	/*  character string			*/
#define	VAL		4	/*  value				*/
#define	REG		5	/*  register designator			*/

/*  Lexical analyzer (A85EVAL.C) token attribute word flag masks:	*/

#define	BINARY		0x8000	/*  Operator:	is binary operator	*/
#define	UNARY		0x4000	/*		is unary operator	*/
#define	PREC		0x0f00	/*		precedence		*/

#define	FORWD		0x8000	/*  Value:	is forward referenced	*/
#define	SOFT		0x4000	/*		is redefinable		*/

#define	BCDEHLMA	0x0080	/*  Register:	is an 8-bit register	*/
#define	BDHPSW		0x0040	/*		is B, D, H, or PSW	*/
#define	BDHSP		0x0020	/*		is B, D, H, or SP	*/
#define	BD		0x0010	/*		is B or D		*/

#define	TYPE		0x000f	/*  All:	token type		*/

/*  Lexical analyzer (A85EVAL.C) operator token values (unlisted ones	*/
/*  use ASCII characters):						*/

#define	AND		0
#define	GE		1
#define	HIGH		2
#define	LE		3
#define	LOW		4
#define	MOD		5
#define	NE		6
#define	NOT		7
#define	OR		8
#define	SHR		9
#define	SHL		10
#define	XOR		11

/*  Lexical analyzer (A85EVAL.C) operator precedence values:		*/

#define	UOP1		0x0000	/*  unary +, unary -			*/
#define	MULT		0x0100	/*  *, /, MOD, SHL, SHR			*/
#define	ADDIT		0x0200	/*  binary +, binary -			*/
#define	RELAT		0x0300	/*  >, >=, =, <=, <, <>			*/
#define	UOP2		0x0400	/*  NOT					*/
#define	LOG1		0x0500	/*  AND					*/
#define	LOG2		0x0600	/*  OR, XOR				*/
#define	UOP3		0x0700	/*  HIGH, LOW				*/
#define	RPREN		0x0800	/*  )					*/
#define	LPREN		0x0900	/*  (					*/
#define	ENDEX		0x0a00	/*  end of expression			*/
#define	START		0x0b00	/*  beginning of expression		*/

/*  Utility package (A85UTIL.C) symbol table routines:			*/

struct _symbol
{
    USHORT		attr;
    USHORT		valu;
    struct _symbol     *left;
    struct _symbol     *right;
    CHAR		sname[1];
};
typedef struct _symbol                SYMBOL;

#define SYMCOLS 	      4

/*  Utility package (A85UTIL.C) opcode/operator table routines:		*/

struct S_OpCode
{
    USHORT	    attr;
    USHORT	    valu;
    CHAR	    oname[6];
};
typedef struct S_OpCode 		OPCODE;

/*  Utility package (A85UTIL.C) hex file output routines:		*/

#define	HEXSIZE		32

#ifdef DRIVER
#define CLASS
#define INIT(x) 		= x
#else
#define CLASS			extern
#define INIT(x)
#endif

CLASS CHAR		errcode;
CLASS CHAR		line[MAXLINE + 1];
CLASS CHAR		title[MAXLINE];
CLASS SHORT		pass		    INIT(0);
CLASS SHORT		eject;
CLASS SHORT		filesp;
CLASS SHORT		forwd;
CLASS SHORT		listhex;
CLASS USHORT		address;
CLASS USHORT		bytes;
CLASS USHORT		errors;
CLASS USHORT		listleft;
CLASS USHORT		obj[MAXLINE];
CLASS USHORT		pagelen;
CLASS USHORT		pc;
CLASS FILE	       *filestk[FILES];
CLASS FILE	       *source;
CLASS FILE	       *list		    INIT(NULL);
CLASS FILE	       *hex		    INIT(NULL);
CLASS TOKEN		token;
CLASS USHORT		usLoAddr	    INIT(-1);
CLASS USHORT		usHiAddr	    INIT(0);
CLASS USHORT		usEntryAddr	    INIT(-1);

#define OBJFMT_INTELHEX 	0
#define OBJFMT_M100HEX		1
#define OBJFMT_M100BIN		2
CLASS SHORT		sObjFmt 	    INIT(-1);

/*  Function prototypes for module a85.c				*/

void			 asm_line(void);

/*  Function prototypes for module a85util.c				*/

SYMBOL		*new_symbol(char  *nam);
SYMBOL		*find_symbol(char  *nam);
OPCODE		*find_code(char  *nam);
OPCODE		*find_operator(char  *nam);
OPCODE		*BinSearch(OPCODE *lo, OPCODE *hi, CHAR  *nam);
void			 lopen(char  *nam);
void			 lputs(void);
void			 lclose(void);
void			 hopen(char  *nam);
void			 hputc(USHORT c);
void			 hseek(USHORT a);
void			 hclose(void);
void			 error(CHAR code);
void			 fatal_error(CHAR *msg);
void			 warning(CHAR *msg);

/*  Function prototypes for module a85util.c				*/

USHORT			 expr(void);
TOKEN			*lex(void);
BOOL			 isalph(SHORT c);
void			 unlex(void);
void			 pops(CHAR *s);
void			 trash(void);
SHORT			 popc(void);
void			 pushc(SHORT c);
SHORT			 newline(void);

#endif                          /* A85_H */
