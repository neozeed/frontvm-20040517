 /*
  * UAE - The Un*x Amiga Emulator - CPU core
  *
  * MC68000 emulation
  *
  * (c) 1995 Bernd Schmidt
  *
  * Adaptation to Hatari by Thomas Huth
  *
  * This file is distributed under the GNU Public License, version 2 or at
  * your option any later version. Read the file gpl.txt for details.
  */
static char rcsid[] = "Hatari $Id: newcpu.c,v 1.25 2003/07/04 12:40:13 thothy Exp $";

#include <SDL.h>
#include "sysdeps.h"
#include "hatari-glue.h"
#include "maccess.h"
#include "memory.h"
#include "newcpu.h"
#include "events.h"
#include "../hardware/disasm.h"
#include "../hardware/main.h"
#include "../hardware/m68000.h"
#include "../hardware/hostcall.h"
#include "../hardware/video.h"
#include "../hardware/screen.h"

//#define	DEBUG_PROFILE

#ifdef DEBUG_PROFILE
#include "../hardware/loadfe2.h"
static int profile_runs[0x50000];
static int profile_total;
#endif /* DEBUG_PROFILE */

struct flag_struct regflags;

int lastInstructionCycles;   /* how many cycles last instruction took to execute */

/* Opcode of faulting instruction */
uae_u16 last_op_for_exception_3;
/* PC at fault time */
uaecptr last_addr_for_exception_3;
/* Address that generated the exception */
uaecptr last_fault_for_exception_3;

int areg_byteinc[] = { 1,1,1,1,1,1,1,2 };
int imm8_table[] = { 8,1,2,3,4,5,6,7 };

int movem_index1[256];
int movem_index2[256];
int movem_next[256];

int fpp_movem_index1[256];
int fpp_movem_index2[256];
int fpp_movem_next[256];

cpuop_func *cpufunctbl[65536];


#define COUNT_INSTRS 0

#if COUNT_INSTRS
static unsigned long int instrcount[65536];
static uae_u16 opcodenums[65536];

static int compfn (const void *el1, const void *el2)
{
    return instrcount[*(const uae_u16 *)el1] < instrcount[*(const uae_u16 *)el2];
}

static char *icountfilename (void)
{
    char *name = getenv ("INSNCOUNT");
    if (name)
	return name;
    return COUNT_INSTRS == 2 ? "frequent.68k" : "insncount";
}

void dump_counts (void)
{
    FILE *f = fopen (icountfilename (), "w");
    unsigned long int total;
    int i;

    write_log ("Writing instruction count file...\n");
    for (i = 0; i < 65536; i++) {
	opcodenums[i] = i;
	total += instrcount[i];
    }
    qsort (opcodenums, 65536, sizeof(uae_u16), compfn);

    fprintf (f, "Total: %lu\n", total);
    for (i=0; i < 65536; i++) {
	unsigned long int cnt = instrcount[opcodenums[i]];
	struct instr *dp;
	struct mnemolookup *lookup;
	if (!cnt)
	    break;
	dp = table68k + opcodenums[i];
	for (lookup = lookuptab;lookup->mnemo != dp->mnemo; lookup++)
	    ;
	fprintf (f, "%04x: %lu %s\n", opcodenums[i], cnt, lookup->name);
    }
    fclose (f);
}
#else
void dump_counts (void)
{
}
#endif

int broken_in;

static unsigned long op_illg_1 (uae_u32 opcode) REGPARAM;

static unsigned long REGPARAM2 op_illg_1 (uae_u32 opcode)
{
    op_illg (opcode);
    return 4;
}


void build_cpufunctbl(void)
{
    int i;
    unsigned long opcode;
    struct cputbl *tbl = (cpu_level == 4 ? op_smalltbl_0_ff
			  : cpu_level == 3 ? op_smalltbl_1_ff
			  : cpu_level == 2 ? op_smalltbl_2_ff
			  : cpu_level == 1 ? op_smalltbl_3_ff
			  : ! cpu_compatible ? op_smalltbl_4_ff
			  : op_smalltbl_5_ff);

    write_log ("Building CPU function table (%d %d %d).\n",
	       cpu_level, cpu_compatible, address_space_24);

    for (opcode = 0; opcode < 65536; opcode++)
	cpufunctbl[opcode] = op_illg_1;
    for (i = 0; tbl[i].handler != NULL; i++) {
	if (! tbl[i].specific)
	    cpufunctbl[tbl[i].opcode] = tbl[i].handler;
    }
    for (opcode = 0; opcode < 65536; opcode++) {
	cpuop_func *f;

	if (table68k[opcode].mnemo == i_ILLG || table68k[opcode].clev > cpu_level)
	    continue;

	if (table68k[opcode].handler != -1) {
	    f = cpufunctbl[table68k[opcode].handler];
	    if (f == op_illg_1)
		abort();
	    cpufunctbl[opcode] = f;
	}
    }
    for (i = 0; tbl[i].handler != NULL; i++) {
	if (tbl[i].specific)
	    cpufunctbl[tbl[i].opcode] = tbl[i].handler;
    }

    /* Hatari's illegal opcodes: */
    cpufunctbl[HOSTCALL_OPCODE] = HostCall_OpCode;
    cpufunctbl[HCALL_OPCODE] = HCall_OpCode;
}



void init_m68k (void)
{
    int i;

    for (i = 0 ; i < 256 ; i++) {
	int j;
	for (j = 0 ; j < 8 ; j++) {
		if (i & (1 << j)) break;
	}
	movem_index1[i] = j;
	movem_index2[i] = 7-j;
	movem_next[i] = i & (~(1 << j));
    }
    for (i = 0 ; i < 256 ; i++) {
	int j;
	for (j = 7 ; j >= 0 ; j--) {
		if (i & (1 << j)) break;
	}
	fpp_movem_index1[i] = 7-j;
	fpp_movem_index2[i] = j;
	fpp_movem_next[i] = i & (~(1 << j));
    }
#if COUNT_INSTRS
    {
	FILE *f = fopen (icountfilename (), "r");
	memset (instrcount, 0, sizeof instrcount);
	if (f) {
	    uae_u32 opcode, count, total;
	    char name[20];
	    write_log ("Reading instruction count file...\n");
	    fscanf (f, "Total: %lu\n", &total);
	    while (fscanf (f, "%lx: %lu %s\n", &opcode, &count, name) == 3) {
		instrcount[opcode] = count;
	    }
	    fclose(f);
	}
    }
#endif
    write_log ("Building CPU table for configuration: 68");
    if (address_space_24 && cpu_level > 1)
        write_log ("EC");
    switch (cpu_level) {
    case 1:
        write_log ("010");
        break;
    case 2:
        write_log ("020");
        break;
    case 3:
        write_log ("020/881");
        break;
    case 4:
        /* Who is going to miss the MMU anyway...? :-)  */
        write_log ("040");
        break;
    default:
        write_log ("000");
        break;
    }
    if (cpu_compatible)
        write_log (" (compatible mode)");
    write_log ("\n");

    read_table68k ();
    do_merges ();

    write_log ("%d CPU functions\n", nr_cpuop_funcs);

    build_cpufunctbl ();
}


struct regstruct regs, lastint_regs;
static struct regstruct regs_backup[16];
static int backup_pointer = 0;
static long int m68kpc_offset;
int lastint_no;

#define get_ibyte_1(o) get_byte(regs.pc + (regs.pc_p - regs.pc_oldp) + (o) + 1)
#define get_iword_1(o) get_word(regs.pc + (regs.pc_p - regs.pc_oldp) + (o))
#define get_ilong_1(o) get_long(regs.pc + (regs.pc_p - regs.pc_oldp) + (o))

uae_s32 ShowEA (FILE *f, int reg, amodes mode, wordsizes size, char *buf)
{
    uae_u16 dp;
    uae_s8 disp8;
    uae_s16 disp16;
    int r;
    uae_u32 dispreg;
    uaecptr addr;
    uae_s32 offset = 0;
    char buffer[80];

    switch (mode){
     case Dreg:
	sprintf (buffer,"D%d", reg);
	break;
     case Areg:
	sprintf (buffer,"A%d", reg);
	break;
     case Aind:
	sprintf (buffer,"(A%d)", reg);
	break;
     case Aipi:
	sprintf (buffer,"(A%d)+", reg);
	break;
     case Apdi:
	sprintf (buffer,"-(A%d)", reg);
	break;
     case Ad16:
	disp16 = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	addr = m68k_areg(regs,reg) + (uae_s16)disp16;
	sprintf (buffer,"(A%d,$%04x) == $%08lx", reg, disp16 & 0xffff,
					(unsigned long)addr);
	break;
     case Ad8r:
	dp = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	disp8 = dp & 0xFF;
	r = (dp & 0x7000) >> 12;
	dispreg = dp & 0x8000 ? m68k_areg(regs,r) : m68k_dreg(regs,r);
	if (!(dp & 0x800)) dispreg = (uae_s32)(uae_s16)(dispreg);
	dispreg <<= (dp >> 9) & 3;

	if (dp & 0x100) {
	    uae_s32 outer = 0, disp = 0;
	    uae_s32 base = m68k_areg(regs,reg);
	    char name[10];
	    sprintf (name,"A%d, ",reg);
	    if (dp & 0x80) { base = 0; name[0] = 0; }
	    if (dp & 0x40) dispreg = 0;
	    if ((dp & 0x30) == 0x20) { disp = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x30) == 0x30) { disp = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }
	    base += disp;

	    if ((dp & 0x3) == 0x2) { outer = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x3) == 0x3) { outer = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }

	    if (!(dp & 4)) base += dispreg;
	    if (dp & 3) base = get_long (base);
	    if (dp & 4) base += dispreg;

	    addr = base + outer;
	    sprintf (buffer,"(%s%c%d.%c*%d+%ld)+%ld == $%08lx", name,
		    dp & 0x8000 ? 'A' : 'D', (int)r, dp & 0x800 ? 'L' : 'W',
		    1 << ((dp >> 9) & 3),
		    (long)disp, (long)outer, (unsigned long)addr);
	} else {
	  addr = m68k_areg(regs,reg) + (uae_s32)((uae_s8)disp8) + dispreg;
	  sprintf (buffer,"(A%d, %c%d.%c*%d, $%02x) == $%08lx", reg,
	       dp & 0x8000 ? 'A' : 'D', (int)r, dp & 0x800 ? 'L' : 'W',
	       1 << ((dp >> 9) & 3), disp8,
	       (unsigned long)addr);
	}
	break;
     case PC16:
	addr = m68k_getpc () + m68kpc_offset;
	disp16 = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	addr += (uae_s16)disp16;
	sprintf (buffer,"(PC,$%04x) == $%08lx", disp16 & 0xffff,(unsigned long)addr);
	break;
     case PC8r:
	addr = m68k_getpc () + m68kpc_offset;
	dp = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	disp8 = dp & 0xFF;
	r = (dp & 0x7000) >> 12;
	dispreg = dp & 0x8000 ? m68k_areg(regs,r) : m68k_dreg(regs,r);
	if (!(dp & 0x800)) dispreg = (uae_s32)(uae_s16)(dispreg);
	dispreg <<= (dp >> 9) & 3;

	if (dp & 0x100) {
	    uae_s32 outer = 0,disp = 0;
	    uae_s32 base = addr;
	    char name[10];
	    sprintf (name,"PC, ");
	    if (dp & 0x80) { base = 0; name[0] = 0; }
	    if (dp & 0x40) dispreg = 0;
	    if ((dp & 0x30) == 0x20) { disp = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x30) == 0x30) { disp = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }
	    base += disp;

	    if ((dp & 0x3) == 0x2) { outer = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x3) == 0x3) { outer = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }

	    if (!(dp & 4)) base += dispreg;
	    if (dp & 3) base = get_long (base);
	    if (dp & 4) base += dispreg;

	    addr = base + outer;
	    sprintf (buffer,"(%s%c%d.%c*%d+%ld)+%ld == $%08lx", name,
		    dp & 0x8000 ? 'A' : 'D', (int)r, dp & 0x800 ? 'L' : 'W',
		    1 << ((dp >> 9) & 3),
		    (long)disp, (long)outer, (unsigned long)addr);
	} else {
	  addr += (uae_s32)((uae_s8)disp8) + dispreg;
	  sprintf (buffer,"(PC, %c%d.%c*%d, $%02x) == $%08lx", dp & 0x8000 ? 'A' : 'D',
		(int)r, dp & 0x800 ? 'L' : 'W',  1 << ((dp >> 9) & 3),
		disp8, (unsigned long)addr);
	}
	break;
     case absw:
	sprintf (buffer,"$%08lx", (unsigned long)(uae_s32)(uae_s16)get_iword_1 (m68kpc_offset));
	m68kpc_offset += 2;
	break;
     case absl:
	sprintf (buffer,"$%08lx", (unsigned long)get_ilong_1 (m68kpc_offset));
	m68kpc_offset += 4;
	break;
     case imm:
	switch (size){
	 case sz_byte:
	    sprintf (buffer,"#$%02x", (unsigned int)(get_iword_1 (m68kpc_offset) & 0xff));
	    m68kpc_offset += 2;
	    break;
	 case sz_word:
	    sprintf (buffer,"#$%04x", (unsigned int)(get_iword_1 (m68kpc_offset) & 0xffff));
	    m68kpc_offset += 2;
	    break;
	 case sz_long:
	    sprintf (buffer,"#$%08lx", (unsigned long)(get_ilong_1 (m68kpc_offset)));
	    m68kpc_offset += 4;
	    break;
	 default:
	    break;
	}
	break;
     case imm0:
	offset = (uae_s32)(uae_s8)get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	sprintf (buffer,"#$%02x", (unsigned int)(offset & 0xff));
	break;
     case imm1:
	offset = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	sprintf (buffer,"#$%04x", (unsigned int)(offset & 0xffff));
	break;
     case imm2:
	offset = (uae_s32)get_ilong_1 (m68kpc_offset);
	m68kpc_offset += 4;
	sprintf (buffer,"#$%08lx", (unsigned long)offset);
	break;
     case immi:
	offset = (uae_s32)(uae_s8)(reg & 0xff);
	sprintf (buffer,"#$%08lx", (unsigned long)offset);
	break;
     default:
	break;
    }
    if (buf == 0)
	fprintf (f, "%s", buffer);
    else
	strcat (buf, buffer);
    return offset;
}

/* The plan is that this will take over the job of exception 3 handling -
 * the CPU emulation functions will just do a longjmp to m68k_go whenever
 * they hit an odd address. */
static int verify_ea (int reg, amodes mode, wordsizes size, uae_u32 *val)
{
    uae_u16 dp;
    uae_s8 disp8;
    uae_s16 disp16;
    int r;
    uae_u32 dispreg;
    uaecptr addr;
    /*uae_s32 offset = 0;*/

    switch (mode){
     case Dreg:
	*val = m68k_dreg (regs, reg);
	return 1;
     case Areg:
	*val = m68k_areg (regs, reg);
	return 1;

     case Aind:
     case Aipi:
	addr = m68k_areg (regs, reg);
	break;
     case Apdi:
	addr = m68k_areg (regs, reg);
	break;
     case Ad16:
	disp16 = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	addr = m68k_areg(regs,reg) + (uae_s16)disp16;
	break;
     case Ad8r:
	addr = m68k_areg (regs, reg);
     d8r_common:
	dp = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	disp8 = dp & 0xFF;
	r = (dp & 0x7000) >> 12;
	dispreg = dp & 0x8000 ? m68k_areg(regs,r) : m68k_dreg(regs,r);
	if (!(dp & 0x800)) dispreg = (uae_s32)(uae_s16)(dispreg);
	dispreg <<= (dp >> 9) & 3;

	if (dp & 0x100) {
	    uae_s32 outer = 0, disp = 0;
	    uae_s32 base = addr;
	    if (dp & 0x80) base = 0;
	    if (dp & 0x40) dispreg = 0;
	    if ((dp & 0x30) == 0x20) { disp = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x30) == 0x30) { disp = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }
	    base += disp;

	    if ((dp & 0x3) == 0x2) { outer = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset); m68kpc_offset += 2; }
	    if ((dp & 0x3) == 0x3) { outer = get_ilong_1 (m68kpc_offset); m68kpc_offset += 4; }

	    if (!(dp & 4)) base += dispreg;
	    if (dp & 3) base = get_long (base);
	    if (dp & 4) base += dispreg;

	    addr = base + outer;
	} else {
	  addr += (uae_s32)((uae_s8)disp8) + dispreg;
	}
	break;
     case PC16:
	addr = m68k_getpc () + m68kpc_offset;
	disp16 = get_iword_1 (m68kpc_offset); m68kpc_offset += 2;
	addr += (uae_s16)disp16;
	break;
     case PC8r:
	addr = m68k_getpc () + m68kpc_offset;
	goto d8r_common;
     case absw:
	addr = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	break;
     case absl:
	addr = get_ilong_1 (m68kpc_offset);
	m68kpc_offset += 4;
	break;
     case imm:
	switch (size){
	 case sz_byte:
	    *val = get_iword_1 (m68kpc_offset) & 0xff;
	    m68kpc_offset += 2;
	    break;
	 case sz_word:
	    *val = get_iword_1 (m68kpc_offset) & 0xffff;
	    m68kpc_offset += 2;
	    break;
	 case sz_long:
	    *val = get_ilong_1 (m68kpc_offset);
	    m68kpc_offset += 4;
	    break;
	 default:
	    break;
	}
	return 1;
     case imm0:
	*val = (uae_s32)(uae_s8)get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	return 1;
     case imm1:
	*val = (uae_s32)(uae_s16)get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	return 1;
     case imm2:
	*val = get_ilong_1 (m68kpc_offset);
	m68kpc_offset += 4;
	return 1;
     case immi:
	*val = (uae_s32)(uae_s8)(reg & 0xff);
	return 1;
     default:
	addr = 0;
	break;
    }
    if ((addr & 1) == 0)
	return 1;

    last_addr_for_exception_3 = m68k_getpc () + m68kpc_offset;
    last_fault_for_exception_3 = addr;
    return 0;
}

uae_u32 get_disp_ea_020 (uae_u32 base, uae_u32 dp)
{
    int reg = (dp >> 12) & 15;
    uae_s32 regd = regs.regs[reg];
    if ((dp & 0x800) == 0)
	regd = (uae_s32)(uae_s16)regd;
    regd <<= (dp >> 9) & 3;
    if (dp & 0x100) {
	uae_s32 outer = 0;
	if (dp & 0x80) base = 0;
	if (dp & 0x40) regd = 0;

	if ((dp & 0x30) == 0x20) base += (uae_s32)(uae_s16)next_iword();
	if ((dp & 0x30) == 0x30) base += next_ilong();

	if ((dp & 0x3) == 0x2) outer = (uae_s32)(uae_s16)next_iword();
	if ((dp & 0x3) == 0x3) outer = next_ilong();

	if ((dp & 0x4) == 0) base += regd;
	if (dp & 0x3) base = get_long (base);
	if (dp & 0x4) base += regd;

	return base + outer;
    } else {
	return base + (uae_s32)((uae_s8)dp) + regd;
    }
}

uae_u32 get_disp_ea_000 (uae_u32 base, uae_u32 dp)
{
    int reg = (dp >> 12) & 15;
    uae_s32 regd = regs.regs[reg];
#if 1
    if ((dp & 0x800) == 0)
	regd = (uae_s32)(uae_s16)regd;
    return base + (uae_s8)dp + regd;
#else
    /* Branch-free code... benchmark this again now that
     * things are no longer inline.  */
    uae_s32 regd16;
    uae_u32 mask;
    mask = ((dp & 0x800) >> 11) - 1;
    regd16 = (uae_s32)(uae_s16)regd;
    regd16 &= mask;
    mask = ~mask;
    base += (uae_s8)dp;
    regd &= mask;
    regd |= regd16;
    return base + regd;
#endif
}

void MakeSR (void)
{
#if 0
    assert((regs.t1 & 1) == regs.t1);
    assert((regs.t0 & 1) == regs.t0);
    assert((regs.s & 1) == regs.s);
    assert((regs.m & 1) == regs.m);
    assert((XFLG & 1) == XFLG);
    assert((NFLG & 1) == NFLG);
    assert((ZFLG & 1) == ZFLG);
    assert((VFLG & 1) == VFLG);
    assert((CFLG & 1) == CFLG);
#endif
    regs.sr = ((regs.t1 << 15) | (regs.t0 << 14)
	       | (regs.s << 13) | (regs.m << 12) | (regs.intmask << 8)
	       | (GET_XFLG << 4) | (GET_NFLG << 3) | (GET_ZFLG << 2) | (GET_VFLG << 1)
	       | GET_CFLG);
}

void MakeFromSR (void)
{
    int oldm = regs.m;
    int olds = regs.s;

    regs.t1 = (regs.sr >> 15) & 1;
    regs.t0 = (regs.sr >> 14) & 1;
    regs.s = (regs.sr >> 13) & 1;
    regs.m = (regs.sr >> 12) & 1;
    regs.intmask = (regs.sr >> 8) & 7;
    SET_XFLG ((regs.sr >> 4) & 1);
    SET_NFLG ((regs.sr >> 3) & 1);
    SET_ZFLG ((regs.sr >> 2) & 1);
    SET_VFLG ((regs.sr >> 1) & 1);
    SET_CFLG (regs.sr & 1);
    if (cpu_level >= 2) {
	if (olds != regs.s) {
	    if (olds) {
		if (oldm)
		    regs.msp = m68k_areg(regs, 7);
		else
		    regs.isp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.usp;
	    } else {
		regs.usp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.m ? regs.msp : regs.isp;
	    }
	} else if (olds && oldm != regs.m) {
	    if (oldm) {
		regs.msp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.isp;
	    } else {
		regs.isp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.msp;
	    }
	}
    } else {
	if (olds != regs.s) {
	    if (olds) {
		regs.isp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.usp;
	    } else {
		regs.usp = m68k_areg(regs, 7);
		m68k_areg(regs, 7) = regs.isp;
	    }
	}
    }

    set_special (SPCFLAG_INT);
    if (regs.t1 || regs.t0)
	set_special (SPCFLAG_TRACE);
    else
	/* Keep SPCFLAG_DOTRACE, we still want a trace exception for
	   SR-modifying instructions (including STOP).  */
	unset_special (SPCFLAG_TRACE);
}


void Exception(int nr, uaecptr oldpc)
{
    uae_u32 currpc = m68k_getpc ();

    if( nr>=2 && nr<10 ) {
	    M68000_Crash (nr);
    }

    MakeSR();

    if (!regs.s) {
	regs.usp = m68k_areg(regs, 7);
	if (cpu_level >= 2)
	    m68k_areg(regs, 7) = regs.m ? regs.msp : regs.isp;
	else
	    m68k_areg(regs, 7) = regs.isp;
	regs.s = 1;
    }
    if (cpu_level > 0) {
	if (nr == 2 || nr == 3) {
	    int i;
	    /* @@@ this is probably wrong (?) */
	    for (i = 0 ; i < 12 ; i++) {
		m68k_areg(regs, 7) -= 2;
		put_word (m68k_areg(regs, 7), 0);
	    }
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), 0xa000 + nr * 4);
	} else if (nr ==5 || nr == 6 || nr == 7 || nr == 9) {
	    m68k_areg(regs, 7) -= 4;
	    put_long (m68k_areg(regs, 7), oldpc);
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), 0x2000 + nr * 4);
	} else if (regs.m && nr >= 24 && nr < 32) {
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), nr * 4);
	    m68k_areg(regs, 7) -= 4;
	    put_long (m68k_areg(regs, 7), currpc);
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), regs.sr);
	    regs.sr |= (1 << 13);
	    regs.msp = m68k_areg(regs, 7);
	    m68k_areg(regs, 7) = regs.isp;
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), 0x1000 + nr * 4);
	} else {
	    m68k_areg(regs, 7) -= 2;
	    put_word (m68k_areg(regs, 7), nr * 4);
	}
    }

    /* Push PC on stack: */
    m68k_areg(regs, 7) -= 4;
    put_long (m68k_areg(regs, 7), currpc);
    /* Push SR on stack: */
    m68k_areg(regs, 7) -= 2;
    put_word (m68k_areg(regs, 7), regs.sr);

    /* 68000 bus/address errors: */
    /* Well these 8 more bytes are not here just for debuging.
       It seems adebug expects them to be on the stack when it receives
       a bus error... */
    if (cpu_level==0 && (nr==2 || nr==3)) {
	m68k_areg(regs, 7) -= 8;
	if (nr == 3) {    /* Address error */
            put_word (m68k_areg(regs, 7), 0);  /* FIXME: Add real function code value */
	    put_long (m68k_areg(regs, 7)+2, last_fault_for_exception_3);
	    put_word (m68k_areg(regs, 7)+6, last_op_for_exception_3);
	    put_long (m68k_areg(regs, 7)+10, last_addr_for_exception_3);
              fprintf(stderr,"Address Error at address $%x, PC=$%x\n",last_fault_for_exception_3,currpc);
	}
        else {    /* Bus error */
            put_word (m68k_areg(regs, 7), 0);  /* FIXME: Add real function code value */
	    put_long (m68k_areg(regs, 7)+2, BusAddressLocation);
	    put_word (m68k_areg(regs, 7)+6, BusErrorOpcode);
              fprintf(stderr,"Bus Error at address $%x, PC=$%lx\n",BusAddressLocation,(long)currpc);
        }
    }

    m68k_setpc (get_long (regs.vbr + 4*nr));
    fill_prefetch_0 ();
    regs.t1 = regs.t0 = regs.m = 0;
    unset_special (SPCFLAG_TRACE | SPCFLAG_DOTRACE);

    /* Handle exception cycles: */
    if(nr >= 24 && nr <= 31)
    {
      ADD_CYCLES(44+4, 5, 3);                 /* Interrupt */
    }
    else if(nr >= 32 && nr <= 47)
    {
      ADD_CYCLES(34, 5, 3);                   /* Trap */
    }
    else switch(nr)
    {
      case 2: ADD_CYCLES(50, 4, 7); break;    /* Bus error */
      case 3: ADD_CYCLES(50, 4, 7); break;    /* Address error */
      case 4: ADD_CYCLES(34, 4, 3); break;    /* Illegal instruction */
      case 5: ADD_CYCLES(38, 4, 3); break;    /* Div by zero */
      case 6: ADD_CYCLES(40, 4, 3); break;    /* CHK */
      case 7: ADD_CYCLES(34, 5, 3); break;    /* TRAPV */
      case 8: ADD_CYCLES(34, 4, 3); break;    /* Privilege violation */
      case 9: ADD_CYCLES(34, 4, 3); break;    /* Trace */
      case 10: ADD_CYCLES(34, 4, 3); break;   /* Line-A - probably wrong */
      case 11: ADD_CYCLES(34, 4, 3); break;   /* Line-F - probably wrong */
      default:
#if 0   /* Hatari currently seems to run more instable when adding MFP cycles */
        if(nr < 64)
          ADD_CYCLES(0, 0, 0);       /* Coprocessor and unassigned exceptions (???) */
        else
          ADD_CYCLES(44+4, 5, 3);    /* Must be a MFP interrupt */
#endif
        break;
    }
}


static void Interrupt(int nr)
{
    assert(nr < 8 && nr >= 0);
    lastint_regs = regs;
    lastint_no = nr;
    Exception(nr+24, 0);

    regs.intmask = nr;
    set_special (SPCFLAG_INT);
}


static uae_u32 caar, cacr, itt0, itt1, dtt0, dtt1, tc, mmusr, urp, srp;


int m68k_move2c (int regno, uae_u32 *regp)
{
    if ((cpu_level == 1 && (regno & 0x7FF) > 1)
	|| (cpu_level < 4 && (regno & 0x7FF) > 2)
	|| (cpu_level == 4 && regno == 0x802))
    {
	op_illg (0x4E7B);
	return 0;
    } else {
	switch (regno) {
	case 0: regs.sfc = *regp & 7; break;
	case 1: regs.dfc = *regp & 7; break;
	case 2: cacr = *regp & (cpu_level < 4 ? 0x3 : 0x80008000); break;
	case 3: tc = *regp & 0xc000; break;
	  /* Mask out fields that should be zero.  */
	case 4: itt0 = *regp & 0xffffe364; break;
	case 5: itt1 = *regp & 0xffffe364; break;
	case 6: dtt0 = *regp & 0xffffe364; break;
	case 7: dtt1 = *regp & 0xffffe364; break;

	case 0x800: regs.usp = *regp; break;
	case 0x801: regs.vbr = *regp; break;
	case 0x802: caar = *regp & 0xfc; break;
	case 0x803: regs.msp = *regp; if (regs.m == 1) m68k_areg(regs, 7) = regs.msp; break;
	case 0x804: regs.isp = *regp; if (regs.m == 0) m68k_areg(regs, 7) = regs.isp; break;
	case 0x805: mmusr = *regp; break;
	case 0x806: urp = *regp; break;
	case 0x807: srp = *regp; break;
	default:
	    op_illg (0x4E7B);
	    return 0;
	}
    }
    return 1;
}

int m68k_movec2 (int regno, uae_u32 *regp)
{
    if ((cpu_level == 1 && (regno & 0x7FF) > 1)
	|| (cpu_level < 4 && (regno & 0x7FF) > 2)
	|| (cpu_level == 4 && regno == 0x802))
    {
	op_illg (0x4E7A);
	return 0;
    } else {
	switch (regno) {
	case 0: *regp = regs.sfc; break;
	case 1: *regp = regs.dfc; break;
	case 2: *regp = cacr; break;
	case 3: *regp = tc; break;
	case 4: *regp = itt0; break;
	case 5: *regp = itt1; break;
	case 6: *regp = dtt0; break;
	case 7: *regp = dtt1; break;
	case 0x800: *regp = regs.usp; break;
	case 0x801: *regp = regs.vbr; break;
	case 0x802: *regp = caar; break;
	case 0x803: *regp = regs.m == 1 ? m68k_areg(regs, 7) : regs.msp; break;
	case 0x804: *regp = regs.m == 0 ? m68k_areg(regs, 7) : regs.isp; break;
	case 0x805: *regp = mmusr; break;
	case 0x806: *regp = urp; break;
	case 0x807: *regp = srp; break;
	default:
	    op_illg (0x4E7A);
	    return 0;
	}
    }
    return 1;
}

STATIC_INLINE int
div_unsigned(uae_u32 src_hi, uae_u32 src_lo, uae_u32 div, uae_u32 *quot, uae_u32 *rem)
{
	uae_u32 q = 0, cbit = 0;
	int i;

	if (div <= src_hi) {
	    return 1;
	}
	for (i = 0 ; i < 32 ; i++) {
		cbit = src_hi & 0x80000000ul;
		src_hi <<= 1;
		if (src_lo & 0x80000000ul) src_hi++;
		src_lo <<= 1;
		q = q << 1;
		if (cbit || div <= src_hi) {
			q |= 1;
			src_hi -= div;
		}
	}
	*quot = q;
	*rem = src_hi;
	return 0;
}

void m68k_divl (uae_u32 opcode, uae_u32 src, uae_u16 extra, uaecptr oldpc)
{
#if defined(uae_s64)
    if (src == 0) {
	Exception (5, oldpc);
	return;
    }
    if (extra & 0x800) {
	/* signed variant */
	uae_s64 a = (uae_s64)(uae_s32)m68k_dreg(regs, (extra >> 12) & 7);
	uae_s64 quot, rem;

	if (extra & 0x400) {
	    a &= 0xffffffffu;
	    a |= (uae_s64)m68k_dreg(regs, extra & 7) << 32;
	}
	rem = a % (uae_s64)(uae_s32)src;
	quot = a / (uae_s64)(uae_s32)src;
	if ((quot & UVAL64(0xffffffff80000000)) != 0
	    && (quot & UVAL64(0xffffffff80000000)) != UVAL64(0xffffffff80000000))
	{
	    SET_VFLG (1);
	    SET_NFLG (1);
	    SET_CFLG (0);
	} else {
	    if (((uae_s32)rem < 0) != ((uae_s64)a < 0)) rem = -rem;
	    SET_VFLG (0);
	    SET_CFLG (0);
	    SET_ZFLG (((uae_s32)quot) == 0);
	    SET_NFLG (((uae_s32)quot) < 0);
	    m68k_dreg(regs, extra & 7) = rem;
	    m68k_dreg(regs, (extra >> 12) & 7) = quot;
	}
    } else {
	/* unsigned */
	uae_u64 a = (uae_u64)(uae_u32)m68k_dreg(regs, (extra >> 12) & 7);
	uae_u64 quot, rem;

	if (extra & 0x400) {
	    a &= 0xffffffffu;
	    a |= (uae_u64)m68k_dreg(regs, extra & 7) << 32;
	}
	rem = a % (uae_u64)src;
	quot = a / (uae_u64)src;
	if (quot > 0xffffffffu) {
	    SET_VFLG (1);
	    SET_NFLG (1);
	    SET_CFLG (0);
	} else {
	    SET_VFLG (0);
	    SET_CFLG (0);
	    SET_ZFLG (((uae_s32)quot) == 0);
	    SET_NFLG (((uae_s32)quot) < 0);
	    m68k_dreg(regs, extra & 7) = rem;
	    m68k_dreg(regs, (extra >> 12) & 7) = quot;
	}
    }
#else
    if (src == 0) {
	Exception (5, oldpc);
	return;
    }
    if (extra & 0x800) {
	/* signed variant */
	uae_s32 lo = (uae_s32)m68k_dreg(regs, (extra >> 12) & 7);
	uae_s32 hi = lo < 0 ? -1 : 0;
	uae_s32 save_high;
	uae_u32 quot, rem;
	uae_u32 sign;

	if (extra & 0x400) {
	    hi = (uae_s32)m68k_dreg(regs, extra & 7);
	}
	save_high = hi;
	sign = (hi ^ src);
	if (hi < 0) {
	    hi = ~hi;
	    lo = -lo;
	    if (lo == 0) hi++;
	}
	if ((uae_s32)src < 0) src = -src;
	if (div_unsigned(hi, lo, src, &quot, &rem) ||
	    (sign & 0x80000000) ? quot > 0x80000000 : quot > 0x7fffffff) {
	    SET_VFLG (1);
	    SET_NFLG (1);
	    SET_CFLG (0);
	} else {
	    if (sign & 0x80000000) quot = -quot;
	    if (((uae_s32)rem < 0) != (save_high < 0)) rem = -rem;
	    SET_VFLG (0);
	    SET_CFLG (0);
	    SET_ZFLG (((uae_s32)quot) == 0);
	    SET_NFLG (((uae_s32)quot) < 0);
	    m68k_dreg(regs, extra & 7) = rem;
	    m68k_dreg(regs, (extra >> 12) & 7) = quot;
	}
    } else {
	/* unsigned */
	uae_u32 lo = (uae_u32)m68k_dreg(regs, (extra >> 12) & 7);
	uae_u32 hi = 0;
	uae_u32 quot, rem;

	if (extra & 0x400) {
	    hi = (uae_u32)m68k_dreg(regs, extra & 7);
	}
	if (div_unsigned(hi, lo, src, &quot, &rem)) {
	    SET_VFLG (1);
	    SET_NFLG (1);
	    SET_CFLG (0);
	} else {
	    SET_VFLG (0);
	    SET_CFLG (0);
	    SET_ZFLG (((uae_s32)quot) == 0);
	    SET_NFLG (((uae_s32)quot) < 0);
	    m68k_dreg(regs, extra & 7) = rem;
	    m68k_dreg(regs, (extra >> 12) & 7) = quot;
	}
    }
#endif
}

STATIC_INLINE void
mul_unsigned(uae_u32 src1, uae_u32 src2, uae_u32 *dst_hi, uae_u32 *dst_lo)
{
	uae_u32 r0 = (src1 & 0xffff) * (src2 & 0xffff);
	uae_u32 r1 = ((src1 >> 16) & 0xffff) * (src2 & 0xffff);
	uae_u32 r2 = (src1 & 0xffff) * ((src2 >> 16) & 0xffff);
	uae_u32 r3 = ((src1 >> 16) & 0xffff) * ((src2 >> 16) & 0xffff);
	uae_u32 lo;

	lo = r0 + ((r1 << 16) & 0xffff0000ul);
	if (lo < r0) r3++;
	r0 = lo;
	lo = r0 + ((r2 << 16) & 0xffff0000ul);
	if (lo < r0) r3++;
	r3 += ((r1 >> 16) & 0xffff) + ((r2 >> 16) & 0xffff);
	*dst_lo = lo;
	*dst_hi = r3;
}

void m68k_mull (uae_u32 opcode, uae_u32 src, uae_u16 extra)
{
#if defined(uae_s64)
    if (extra & 0x800) {
	/* signed variant */
	uae_s64 a = (uae_s64)(uae_s32)m68k_dreg(regs, (extra >> 12) & 7);

	a *= (uae_s64)(uae_s32)src;
	SET_VFLG (0);
	SET_CFLG (0);
	SET_ZFLG (a == 0);
	SET_NFLG (a < 0);
	if (extra & 0x400)
	    m68k_dreg(regs, extra & 7) = a >> 32;
	else if ((a & UVAL64(0xffffffff80000000)) != 0
		 && (a & UVAL64(0xffffffff80000000)) != UVAL64(0xffffffff80000000))
	{
	    SET_VFLG (1);
	}
	m68k_dreg(regs, (extra >> 12) & 7) = (uae_u32)a;
    } else {
	/* unsigned */
	uae_u64 a = (uae_u64)(uae_u32)m68k_dreg(regs, (extra >> 12) & 7);

	a *= (uae_u64)src;
	SET_VFLG (0);
	SET_CFLG (0);
	SET_ZFLG (a == 0);
	SET_NFLG (((uae_s64)a) < 0);
	if (extra & 0x400)
	    m68k_dreg(regs, extra & 7) = a >> 32;
	else if ((a & UVAL64(0xffffffff00000000)) != 0) {
	    SET_VFLG (1);
	}
	m68k_dreg(regs, (extra >> 12) & 7) = (uae_u32)a;
    }
#else
    if (extra & 0x800) {
	/* signed variant */
	uae_s32 src1,src2;
	uae_u32 dst_lo,dst_hi;
	uae_u32 sign;

	src1 = (uae_s32)src;
	src2 = (uae_s32)m68k_dreg(regs, (extra >> 12) & 7);
	sign = (src1 ^ src2);
	if (src1 < 0) src1 = -src1;
	if (src2 < 0) src2 = -src2;
	mul_unsigned((uae_u32)src1,(uae_u32)src2,&dst_hi,&dst_lo);
	if (sign & 0x80000000) {
		dst_hi = ~dst_hi;
		dst_lo = -dst_lo;
		if (dst_lo == 0) dst_hi++;
	}
	SET_VFLG (0);
	SET_CFLG (0);
	SET_ZFLG (dst_hi == 0 && dst_lo == 0);
	SET_NFLG (((uae_s32)dst_hi) < 0);
	if (extra & 0x400)
	    m68k_dreg(regs, extra & 7) = dst_hi;
	else if ((dst_hi != 0 || (dst_lo & 0x80000000) != 0)
		 && ((dst_hi & 0xffffffff) != 0xffffffff
		     || (dst_lo & 0x80000000) != 0x80000000))
	{
	    SET_VFLG (1);
	}
	m68k_dreg(regs, (extra >> 12) & 7) = dst_lo;
    } else {
	/* unsigned */
	uae_u32 dst_lo,dst_hi;

	mul_unsigned(src,(uae_u32)m68k_dreg(regs, (extra >> 12) & 7),&dst_hi,&dst_lo);

	SET_VFLG (0);
	SET_CFLG (0);
	SET_ZFLG (dst_hi == 0 && dst_lo == 0);
	SET_NFLG (((uae_s32)dst_hi) < 0);
	if (extra & 0x400)
	    m68k_dreg(regs, extra & 7) = dst_hi;
	else if (dst_hi != 0) {
	    SET_VFLG (1);
	}
	m68k_dreg(regs, (extra >> 12) & 7) = dst_lo;
    }
#endif
}

static char* ccnames[] =
{ "T ","F ","HI","LS","CC","CS","NE","EQ",
  "VC","VS","PL","MI","GE","LT","GT","LE" };

void m68k_reset (void)
{
    regs.s = 1;
    regs.m = 0;
    regs.stopped = 0;
    regs.t1 = 0;
    regs.t0 = 0;
    SET_ZFLG (0);
    SET_XFLG (0);
    SET_CFLG (0);
    SET_VFLG (0);
    SET_NFLG (0);
    regs.spcflags &= SPCFLAG_MODE_CHANGE;   /* Clear specialflags except mode-change */
    regs.intmask = 7;
    regs.vbr = regs.sfc = regs.dfc = 0;
    regs.fpcr = regs.fpsr = regs.fpiar = 0;

    m68k_areg(regs, 7) = get_long(0);
    m68k_setpc(get_long(4));
    refill_prefetch (m68k_getpc(), 0);
}

unsigned long REGPARAM2 op_illg (uae_u32 opcode)
{
    uaecptr pc = m68k_getpc ();

    if (opcode == 0x4E7B && get_long (0x10) == 0 ) {
	write_log ("This program requires a 68020 CPU!\n");
	broken_in = 1;
	set_special (SPCFLAG_BRK);
	bQuitProgram = 1;
    }

    if ((opcode & 0xF000) == 0xF000) {
	Exception(0xB,0);
	return 4;
    }
    if ((opcode & 0xF000) == 0xA000) {
	Exception(0xA,0);
	return 4;
    }

#if 0
    write_log ("Illegal instruction: %04x at %08lx\n", opcode, (long)pc);
#endif
    Exception (4,0);
    return 4;
}

void mmu_op(uae_u32 opcode, uae_u16 extra)
{
    if ((opcode & 0xFE0) == 0x0500) {
	/* PFLUSH */
	mmusr = 0;
	write_log ("PFLUSH\n");
    } else if ((opcode & 0x0FD8) == 0x548) {
	/* PTEST */
	write_log ("PTEST\n");
    } else
	op_illg (opcode);
}


static uaecptr last_trace_ad = 0;

static void do_trace (void)
{
    if (regs.t0 && cpu_level >= 2) {
	uae_u16 opcode;
	/* should also include TRAP, CHK, SR modification FPcc */
	/* probably never used so why bother */
	/* We can afford this to be inefficient... */
	m68k_setpc (m68k_getpc ());
	fill_prefetch_0 ();
	opcode = get_word (regs.pc);
	if (opcode == 0x4e72 		/* RTE */
	    || opcode == 0x4e74 		/* RTD */
	    || opcode == 0x4e75 		/* RTS */
	    || opcode == 0x4e77 		/* RTR */
	    || opcode == 0x4e76 		/* TRAPV */
	    || (opcode & 0xffc0) == 0x4e80 	/* JSR */
	    || (opcode & 0xffc0) == 0x4ec0 	/* JMP */
	    || (opcode & 0xff00) == 0x6100  /* BSR */
	    || ((opcode & 0xf000) == 0x6000	/* Bcc */
		&& cctrue((opcode >> 8) & 0xf))
	    || ((opcode & 0xf0f0) == 0x5050 /* DBcc */
		&& !cctrue((opcode >> 8) & 0xf)
		&& (uae_s16)m68k_dreg(regs, opcode & 7) != 0))
	{
	    last_trace_ad = m68k_getpc ();
	    unset_special (SPCFLAG_TRACE);
	    set_special (SPCFLAG_DOTRACE);
	}
    } else if (regs.t1) {
	last_trace_ad = m68k_getpc ();
	unset_special (SPCFLAG_TRACE);
	set_special (SPCFLAG_DOTRACE);
    }
}


static int do_specialties (void)
{
    if(regs.spcflags & SPCFLAG_BUSERROR) {
	/* We can not execute bus errors directly in the memory handler
	 * functions since the PC should point to the address of the next
	 * instruction, so we're executing the bus errors here: */
        unset_special(SPCFLAG_BUSERROR);
	Exception(2,0);
    }

    if (regs.spcflags & SPCFLAG_DOTRACE) {
	Exception (9,last_trace_ad);
    }
    while (regs.spcflags & SPCFLAG_STOP) {
	do_cycles (8);
	if (regs.intmask>5) {
            /* We still have to care about events when IPL==7 ! */
            Main_EventHandler();
            if(bQuitProgram)  unset_special(SPCFLAG_STOP);
        }
	if (regs.spcflags & (SPCFLAG_INT | SPCFLAG_DOINT)) {
	    int intr = intlev ();
	    unset_special (SPCFLAG_INT | SPCFLAG_DOINT);
	    if (intr != -1 && intr > regs.intmask) {
		Interrupt (intr);
		regs.stopped = 0;
		unset_special (SPCFLAG_STOP);
	    }
	}
    }
    if (regs.spcflags & SPCFLAG_TRACE)
	do_trace ();

    if (regs.spcflags & SPCFLAG_DOINT) {
	int intr = intlev ();
	unset_special (SPCFLAG_DOINT);
	if (intr != -1 && intr > regs.intmask) {
	    Interrupt (intr);
	    regs.stopped = 0;
	}
    }
    if (regs.spcflags & SPCFLAG_INT) {
	unset_special (SPCFLAG_INT);
	set_special (SPCFLAG_DOINT);
    }
    if (regs.spcflags & (SPCFLAG_BRK | SPCFLAG_MODE_CHANGE)) {
	unset_special (SPCFLAG_BRK | SPCFLAG_MODE_CHANGE);
	return 1;
    }
    return 0;
}


/* It's really sad to have two almost identical functions for this, but we
   do it all for performance... :( */
static void m68k_run_1 (void)
{
#ifdef DEBUG_PREFETCH
    uae_u8 saved_bytes[20];
    uae_u16 *oldpcp;
#endif
    while(!bQuitProgram) {
	int cycles;
	uae_u32 opcode = get_iword_prefetch (0);
#ifdef DEBUG_PREFETCH
	if (get_ilong (0) != do_get_mem_long (&regs.prefetch)) {
	    fprintf (stderr, "Prefetch differs from memory.\n");
	    debugging = 1;
	    return;
	}
	oldpcp = regs.pc_p;
	memcpy (saved_bytes, regs.pc_p, 20);
#endif

	/*m68k_dumpstate(stderr, NULL);*/
	/*m68k_disasm(stderr, m68k_getpc (), NULL, 1);*/

	/* assert (!regs.stopped && !(regs.spcflags & SPCFLAG_STOP)); */
/*	regs_backup[backup_pointer = (backup_pointer + 1) % 16] = regs;*/
#if COUNT_INSTRS == 2
	if (table68k[opcode].handler != -1)
	    instrcount[table68k[opcode].handler]++;
#elif COUNT_INSTRS == 1
	instrcount[opcode]++;
#endif

	cycles = (*cpufunctbl[opcode])(opcode);

#ifdef DEBUG_PREFETCH
	if (memcmp (saved_bytes, oldpcp, 20) != 0) {
	    fprintf (stderr, "Self-modifying code detected.\n");
	    set_special (SPCFLAG_BRK);
	    debugging = 1;
	}
#endif

	do_cycles (cycles);
	if (regs.spcflags) {
	    if (do_specialties ())
		return;
	}
    }
}


/* Same thing, but don't use prefetch to get opcode.  */
static void m68k_run_2 (void)
{
    /* VBL every 20ms (50Hz) */
    Uint32 now;
    Uint32 last_vbl = 0;
    Uint32 last_eventpoll = 0;
    int iters_this_frame = 0;
    int lag = 0;
    
    while(!bQuitProgram) {
	int cycles;

#ifdef DEBUG_PROFILE
	profile_runs [ m68k_getpc() >> 1 ] += 1;
	profile_total++;
#endif /* DEBUG_PROFILE */
	
	uae_u32 opcode = get_iword (0);

	/*m68k_dumpstate(stderr, NULL);*/
	/*m68k_disasm(stderr, m68k_getpc (), NULL, 1);*/

	/* assert (!regs.stopped && !(regs.spcflags & SPCFLAG_STOP)); */
/*	regs_backup[backup_pointer = (backup_pointer + 1) % 16] = regs;*/
#if COUNT_INSTRS == 2
	if (table68k[opcode].handler != -1)
	    instrcount[table68k[opcode].handler]++;
#elif COUNT_INSTRS == 1
	instrcount[opcode]++;
#endif

	cycles = (*cpufunctbl[opcode])(opcode);
	do_cycles (cycles);
	iters_this_frame++;

	if (regs.spcflags) {
	    do_specialties ();
	}

	/* check if 20ms has elapsed and if so do a VBL (50fps).
	 * this test is done every now and again... */
	if  ((iters_this_frame & 0xffff) == 0) {
		now = SDL_GetTicks ();

		/* poll events every ms */
		if (now - last_eventpoll) {
			last_eventpoll = now;
			Main_EventHandler ();
		}
		
		/* some jitter present which fucks audio a little */
		if (now - last_vbl + lag >= 20) {
			lag = now - last_vbl + lag - 20;
			/* crap pooter that can't keep up */
			if (lag > 20) {
				lag -= 20;
				bTooSlowSoSkipAFlip = TRUE;
			}
			//printf ("VBL (%dms, %d cycles, %d lag)\n", now-last_vbl, iters_this_frame, lag);
			last_vbl = now;
			Video_InterruptHandler_VBL ();
			iters_this_frame = 0;
		}
	}
    }
}


int in_m68k_go = 0;

void m68k_go (int may_quit)
{
#ifdef DEBUG_PROFILE
	int i;
	int start_sec = 0;
	int last_runs = 0;
	int num;
#endif
	
    if (in_m68k_go || !may_quit) {
	write_log ("Bug! m68k_go is not reentrant.\n");
	abort ();
    }

    in_m68k_go++;
    while(!bQuitProgram) {
        if(cpu_compatible)
          m68k_run_1();
         else
          m68k_run_2();
    }
#ifdef DEBUG_PROFILE
    for (i=0; i<0x50000; i++) {
	    if (profile_runs[i] != last_runs) {
		    num = i - start_sec;
		    if (start_sec == i-1) {
			    printf ("0x%x:\t\t\(%d inst)\t%d cycles\t(%.4f%%)\n", (start_sec*2)-FE2BASE, num, num*last_runs, 100.0*num*last_runs/(float)profile_total);
		    } else {
			    printf ("0x%x - 0x%x:\t(%d inst)\t%d cycles\t(%.4f%%)\n", (start_sec*2)-FE2BASE, ((i-1)*2)-FE2BASE, num, num*last_runs, 100.0*num*last_runs/(float)profile_total);
		    }
		    start_sec = i;
		    last_runs = profile_runs[i];
	    }
    }
#endif

    in_m68k_go--;
}

static void m68k_verify (uaecptr addr, uaecptr *nextpc)
{
    uae_u32 opcode, val;
    struct instr *dp;

    opcode = get_iword_1(0);
    last_op_for_exception_3 = opcode;
    m68kpc_offset = 2;

    if (cpufunctbl[opcode] == op_illg_1) {
	opcode = 0x4AFC;
    }
    dp = table68k + opcode;

    if (dp->suse) {
	if (!verify_ea (dp->sreg, dp->smode, dp->size, &val)) {
	    Exception (3, 0);
	    return;
	}
    }
    if (dp->duse) {
	if (!verify_ea (dp->dreg, dp->dmode, dp->size, &val)) {
	    Exception (3, 0);
	    return;
	}
    }
}

void m68k_disasm (FILE *f, uaecptr addr, uaecptr *nextpc, int cnt)
{
    uaecptr newpc = 0;
    m68kpc_offset = addr - m68k_getpc ();
    while (cnt-- > 0) {
	char instrname[20],*ccpt;
	int opwords;
	uae_u32 opcode;
	struct mnemolookup *lookup;
	struct instr *dp;
	fprintf (f, "%08lx: ", m68k_getpc () + m68kpc_offset);
	for (opwords = 0; opwords < 5; opwords++){
	    fprintf (f, "%04x ", get_iword_1 (m68kpc_offset + opwords*2));
	}
	opcode = get_iword_1 (m68kpc_offset);
	m68kpc_offset += 2;
	if (cpufunctbl[opcode] == op_illg_1) {
	    opcode = 0x4AFC;
	}
	dp = table68k + opcode;
	for (lookup = lookuptab;lookup->mnemo != dp->mnemo; lookup++)
	    ;

	strcpy (instrname, lookup->name);
	ccpt = strstr (instrname, "cc");
	if (ccpt != 0) {
	    strncpy (ccpt, ccnames[dp->cc], 2);
	}
	fprintf (f, "%s", instrname);
	switch (dp->size){
	 case sz_byte: fprintf (f, ".B "); break;
	 case sz_word: fprintf (f, ".W "); break;
	 case sz_long: fprintf (f, ".L "); break;
	 default: fprintf (f, "   "); break;
	}

	if (dp->suse) {
	    newpc = m68k_getpc () + m68kpc_offset;
	    newpc += ShowEA (f, dp->sreg, dp->smode, dp->size, 0);
	}
	if (dp->suse && dp->duse)
	    fprintf (f, ",");
	if (dp->duse) {
	    newpc = m68k_getpc () + m68kpc_offset;
	    newpc += ShowEA (f, dp->dreg, dp->dmode, dp->size, 0);
	}
	if (ccpt != 0) {
	    if (cctrue(dp->cc))
		fprintf (f, " == %08lx (TRUE)", (long)newpc);
	    else
		fprintf (f, " == %08lx (FALSE)", (long)newpc);
	} else if ((opcode & 0xff00) == 0x6100) /* BSR */
	    fprintf (f, " == %08lx", (long)newpc);
	fprintf (f, "\n");
    }
    if (nextpc)
	*nextpc = m68k_getpc () + m68kpc_offset;
}

void m68k_dumpstate (FILE *f, uaecptr *nextpc)
{
    int i;
    for (i = 0; i < 8; i++){
	fprintf (f, "D%d: %08lx ", i, (long)m68k_dreg(regs, i));
	if ((i & 3) == 3) fprintf (f, "\n");
    }
    for (i = 0; i < 8; i++){
	fprintf (f, "A%d: %08lx ", i, (long)m68k_areg(regs, i));
	if ((i & 3) == 3) fprintf (f, "\n");
    }
    if (regs.s == 0) regs.usp = m68k_areg(regs, 7);
    if (regs.s && regs.m) regs.msp = m68k_areg(regs, 7);
    if (regs.s && regs.m == 0) regs.isp = m68k_areg(regs, 7);
    fprintf (f, "USP=%08lx ISP=%08lx MSP=%08lx VBR=%08lx\n",
	     (long)regs.usp,(long)regs.isp,(long)regs.msp,(long)regs.vbr);
    fprintf (f, "T=%d%d S=%d M=%d X=%d N=%d Z=%d V=%d C=%d IMASK=%d\n",
	     regs.t1, regs.t0, regs.s, regs.m,
	     GET_XFLG, GET_NFLG, GET_ZFLG, GET_VFLG, GET_CFLG, regs.intmask);
    for (i = 0; i < 8; i++){
	fprintf (f, "FP%d: %g ", i, regs.fp[i]);
	if ((i & 3) == 3) fprintf (f, "\n");
    }
    fprintf (f, "N=%d Z=%d I=%d NAN=%d\n",
	     (regs.fpsr & 0x8000000) != 0,
	     (regs.fpsr & 0x4000000) != 0,
	     (regs.fpsr & 0x2000000) != 0,
	     (regs.fpsr & 0x1000000) != 0);
    if (cpu_compatible)
	fprintf (f, "prefetch %08lx\n", (unsigned long)do_get_mem_long(&regs.prefetch));

    m68k_disasm (f, m68k_getpc (), nextpc, 1);
    if (nextpc)
	fprintf (f, "next PC: %08lx\n", (long)*nextpc);
}
