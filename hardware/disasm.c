
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include <SDL_types.h>

#include "main.h"
#include "decode.h"
#include "dialog.h"
#include "file.h"
#include "m68000.h"
#include "memAlloc.h"
#include "stMemory.h"

typedef unsigned int uint;

static int buf_pos = 0;

static void output (const char *format, ...)
{
	va_list argptr;

	va_start (argptr, format);
	vprintf (format, argptr);
	va_end (argptr);
}

static void output_lab (int addr)
{
	printf ("$%x", addr);
}

unsigned char rd_byte(void)
{
	int val = STMemory_ReadByte (buf_pos);
	buf_pos++;
	return val;
}

short rd_short(void)
{
	short val = STMemory_ReadWord (buf_pos);
	buf_pos+=2;
	return val;
}

int rd_int(void)
{
	int val = STMemory_ReadLong (buf_pos);
	buf_pos+=4;
	return val;
}

const char *size_str[4] = { ".b", ".w", ".l", ".?" };
/* to convert weird move sizes to standard sizes */
const int move_size[4] = { 3, 0, 2, 1 };
const char *Bcc_str[16] = {
	NULL,NULL,"hi","ls","cc","cs","ne","eq",
	"vc","vs","pl","mi","ge","lt","gt","le"
};

const char *DBcc_str[16] = {
	"t","ra","hi","ls","cc","cs","ne","eq",
	"vc","vs","pl","mi","ge","lt","gt","le"
};

typedef union Opcode {
	unsigned short code;
	struct move {
		uint src_reg : 3;
		uint src_mode : 3;
		uint dest_mode : 3;
		uint dest_reg : 3;
		uint size : 2;
		uint op : 2;
	} move;
	struct adr_index {
		int displacement : 8;
		uint zeros : 3;
		uint ind_size : 1;
		uint reg : 3;
		uint reg_type : 1;
	} adr_index;
	struct addq {
		uint dest_reg : 3;
		uint dest_mode : 3;
		uint size : 2;
		uint issub : 1;
		uint data : 3;
		uint op : 4;
	} addq;
	struct jmp {
		uint dest_reg : 3;
		uint dest_mode : 3;
		uint op : 10;
	} jmp;
	struct addi {
		uint dest_reg : 3;
		uint dest_mode : 3;
		uint size : 2;
		uint OP6 : 8;
	} addi;
	/* size and effective address */
	struct type1 {
		uint ea_reg : 3;
		uint ea_mode : 3;
		uint size : 2;
		uint op : 8;
	} type1;
	/* reg, opmode, ea */
	struct type2 {
		uint ea_reg : 3;
		uint ea_mode : 3;
		uint op_mode : 3;
		uint reg : 3;
		uint op : 4;
	} type2;
	struct MemShift {
		uint ea_reg : 3;
		uint ea_mode : 3;
		uint OP3 : 2;
		uint dr : 1;
		uint type : 2;
		uint OP0x1c : 5;
	} MemShift;
	struct ASx {
		uint reg : 3;
		uint OP0 : 2;
		uint ir : 1;
		uint size : 2;
		uint dr : 1;
		uint count_reg : 3;
		uint OP0xe : 4;
	} ASx;
	struct abcd {
		uint src_reg : 3;
		uint rm : 1;
		uint OP16 : 5;
		uint dest_reg : 3;
		uint OP12 : 4;
	} abcd;
	struct addx {
		uint src_reg : 3;
		uint rm : 1;
		uint OP0 : 2;
		uint size : 2;
		uint OP1 : 1;
		uint dest_reg : 3;
		uint op : 4;
	} addx;
	struct cmpm {
		uint src_reg : 3;
		uint OP1_1 : 3;
		uint size : 2;
		uint OP2_1 : 1;
		uint dest_reg : 3;
		uint OP0xb : 4;
	} cmpm;
	/* branches */
	struct DBcc {
		uint reg : 3;
		uint OP25 : 5;
		uint cond : 4;
		uint OP5 : 4;
	} DBcc;
	struct Bcc {
		int displacement : 8;
		uint cond : 4;
		uint op : 4;
	} Bcc;
	struct bra {
		int displacement : 8;
		uint op : 8;
	} bra;
	struct movem {
		uint dest_reg : 3;
		uint dest_mode : 3;
		uint sz : 1;
		uint ONE : 3;
		uint dr : 1;
		uint NINE : 5;
	} movem;
	struct lea {
		uint dest_reg : 3;
		uint dest_mode : 3;
		uint SEVEN : 3;
		uint reg : 3;
		uint FOUR : 4;
	} lea;
	struct moveq {
		int data : 8;
		uint ZERO : 1;
		uint reg : 3;
		uint SEVEN : 4;
	} moveq;
	struct exg {
		uint dest_reg : 3;
		uint op_mode : 5;
		uint OP1 : 1;
		uint src_reg : 3;
		uint OP0xc : 4;
	} exg;
} Opcode;

/*
 * Skip size is used when there is immediate data, for addressing
 * modes $addr(Ax,Dy.s), and the PC flavoured version of that.
 * The immediate data comes first and must be skipped
 */
int is_adrmod (int mode, int reg, int op_size, int skip_size)
{
	Opcode ext;
	switch (skip_size) {
		case -1: skip_size = 0; break;
		case  0: case 1: skip_size = 2; break;
		default: skip_size = 4; break;
	}
	switch (mode) {
		case 0: case 1: case 2: case 3: case 4:
			return 1;
		case 5: return 1;
		case 6: buf_pos += skip_size;
			ext.code = rd_short ();
			buf_pos -= 2 + skip_size;
			if (ext.adr_index.zeros != 0) return 0;
			else return 1;
		case 7: 
			switch (reg) {
				case 0: return 1;
				case 1: return 1;
				case 4:
					return 1;
				case 2:
					return 1;
				case 3: buf_pos += skip_size;
					ext.code = rd_short ();
					buf_pos -= 2 + skip_size;
					if (ext.adr_index.zeros != 0) return 0;
					else return 1;
				default:
					return 0;
			}
			break;
		default:
			return 0;
	}
			
}

/* returns abs address if possible or 0xdeadbeef if not */
uint put_adrmod (int mode, int reg, int op_size)
{
	uint temp;
	Opcode ext;
	switch (mode) {
		case 0: output ("d%d", reg); break;
		case 1: output ("a%d", reg); break;
		case 2: output ("(a%d)", reg); break;
		case 3: output ("(a%d)+", reg); break;
		case 4: output ("-(a%d)", reg); break;
		case 5: output ("%hd(a%d)", rd_short(), reg); break;
		case 6: ext.code = rd_short ();
			if (ext.adr_index.zeros != 0) output ("???");
			output ("%hd(a%d,", ext.adr_index.displacement, reg);
			if (ext.adr_index.reg_type) {
				output ("a%d", ext.adr_index.reg);
			} else {
				output ("d%d", ext.adr_index.reg);
			}
			if (ext.adr_index.ind_size) {
				output (".l)");
			} else {
				output (".w)");
			}
			break;
		case 7: 
			switch (reg) {
				case 0: output ("$%hx.w", rd_short()); break;
				case 1: temp = rd_int ();
					output ("$%x.l", temp);
					return temp;
				case 4:
					if (op_size == 0) {
						if (rd_byte () != 0) output ("???");
						output ("#$%x", rd_byte ());
					} else if (op_size == 2) {
						output ("#");
						output ("$%x", rd_int ());
					} else if (op_size == 1) {
						output ("#$%hx", rd_short ());
					} else {
						output ("#???");
					}
					break;
				case 2:
					temp = buf_pos;
					temp += rd_short ();
					output ("$%x(pc)", temp);
					return temp;
				case 3: temp = buf_pos;
					ext.code = rd_short ();
					if (ext.adr_index.zeros != 0) output ("???");
					output ("$%x", temp + ext.adr_index.displacement);
					if (ext.adr_index.reg_type) {
						output ("(pc,a%d", ext.adr_index.reg);
					} else {
						output ("(pc,d%d", ext.adr_index.reg);
					}
					if (ext.adr_index.ind_size) {
						output (".l)");
					} else {
						output (".w)");
					}
					break;
				default:
					output ("???"); break;
			}
			break;
		default:
			output ("???"); break;
	}
	return 0xdeadbeef;
}

void aux_put_movem_regs (int mode, int low, int high)
{
	if (!mode) {
		/* (Ax)+ and control modes */
		if (low < 8) {
			if (low == high) {
				output ("d%d", low);
				return;
			}
			if (high >7) {
				if (low == 7) output ("d7/");
				else output ("d%d-7/", low);
			} else {
				output ("d%d-%d", low, high);
				return;
			}
		}
		if (high > 7) {
			if (low == high) {
				output ("a%d", low-8);
				return;
			}
			if (low > 7) {
				output ("a%d-%d", low-8, high-8);
			} else {
				if (high == 8) output ("a0");
				else output ("a0-%d", high-8);
			}
		}
	} else {
		/* -(Ax) mode */
		if (high > 7) {
			if (low == high) {
				output ("d%d", 15-low);
				return;
			}
			if (low > 7) {
				output ("d%d-%d", 15-high, 15-low);
				return;
			} else {
				if (high == 8) output ("d7/");
				else output ("d%d-7/", 15-high);
			}
		}
		if (low < 8) {
			if (low == high) {
				output ("a%d", 7-low);
				return;
			}
			if (high >7) {
				if (low == 7) output ("a0");
				else output ("a0-%d", 7-low);
			} else {
				output ("a%d-%d", 7-high, 7-low);
			}
		}
	}
}

void put_movem_regs (int mask, int mode)
{
	int start;
	int pos;
	int pixie = 0;

	start = -1;
	for (pos=0; pos < 16; pos++) {
		if ((mask & (1<<pos)) && (start == -1)) start = pos;
		else if ((!(mask & (1<<pos))) && (start != -1)) {
			if (pixie) output ("/");
			else pixie = 1;
			aux_put_movem_regs (mode, start, pos-1);
			start = -1;
		}
	}
	if (mask & (1<<15)) {
		if (pixie) output ("/");
		else pixie = 1;
		aux_put_movem_regs (mode, start, pos-1);
		start = -1;
	}
}

void put_imm (int size)
{
	if (size == 0) {
		rd_byte ();
		output ("#$%x", (int)rd_byte ());
	} else if (size == 1) {
		output ("#$%hx", (int)rd_short ());
	} else {
		output ("#$%x", (int)rd_int ());
	}
}

/*
 * Disassemble _count bytes from _start.
 */
void dump_code (int _start, int _count)
{
	Opcode op;
	int size;
	int temp;
	const char *str;
	int last_ip;
	buf_pos = _start;

	while (buf_pos < _start+_count) {
		output ("\r\n$%x\t", buf_pos);
		last_ip = buf_pos;
		op.code = rd_short ();
		output ("($%hx)\t", op.code);
		/* ABCD/SBCD */
		while (op.abcd.OP16 == 16) {
			if (op.abcd.OP12 == 12) output ("abcd\t");
			else if (op.abcd.OP12 == 8) output ("sbcd\t");
			else break;
			if (op.abcd.rm) {
				output ("-(a%d),-(a%d)", op.abcd.src_reg, op.abcd.dest_reg);
			} else {
				output ("d%d,d%d", op.abcd.src_reg, op.abcd.dest_reg);
			}
			goto done;
		}
		/* ADD/SUB */
		while ((op.type2.op == 0xd) || (op.type2.op == 0x9)) {
			if (op.type2.op == 0xd) str = "add";
			else str = "sub";
			if (op.type2.op_mode == 3) {
				/* ADDA.W */
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1, -1)) break;
				output ("%sa.w\t", str);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1);
				output (",a%d", op.type2.reg);
			}
			else if (op.type2.op_mode == 7) {
				/* ADDA.L */
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2, -1)) break;
				output ("%sa.l\t", str);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2);
				output (",a%d", op.type2.reg);
			}
			else if (op.type2.op_mode < 3) {
				/* dest is reg */
				/* no .b size Ax sources */
				if ((op.type2.op_mode == 0) && (op.type2.ea_mode == 0x1)) break;
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode, -1)) break;
				output ("%s%s\t", str, size_str[op.type2.op_mode]);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode);
				output (",d%d", op.type2.reg);
			} else {
				/* dest is ea */
				if (op.type2.ea_mode == 0x0) break;
				if (op.type2.ea_mode == 0x1) break;
				if (op.type2.ea_mode == 0x7) {
					if ((op.type2.ea_reg == 2) ||
					    (op.type2.ea_reg == 3) ||
					    (op.type2.ea_reg == 4)) break;
				}
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode-4, -1)) break;
				output ("%s%s\t", str, size_str[op.type2.op_mode-4]);
				output ("d%d,", op.type2.reg);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode-4);
			}
			goto done;
		}
		/* ADDI/SUBI */
		while ((op.addi.OP6 == 6) || (op.addi.OP6 == 4)) {
			if (op.addi.size == 3) break;
			if (op.addi.dest_mode == 0x1) break;
			if (op.addi.dest_mode == 0x7) {
				if ((op.addi.dest_reg == 2) ||
				    (op.addi.dest_reg == 3) ||
				    (op.addi.dest_reg == 4)) break;
			}
			if (!is_adrmod (op.addi.dest_mode, op.addi.dest_reg, op.addi.size, op.addi.size)) break;
			if (op.addi.OP6 == 6) output ("addi%s\t", size_str[op.addi.size]);
			else output ("subi%s\t", size_str[op.addi.size]);
			put_imm (op.addi.size);
			output (",");
			put_adrmod (op.addi.dest_mode, op.addi.dest_reg, op.addi.size);
			goto done;
		}
		/* ADDQ/SUBQ */
		while (op.addq.op == 0x5) {
			if (op.addq.size == 3) break;
			/* no immediate or pc relative dest */
			if (op.addq.dest_mode == 0x7) {
				if (op.addq.dest_reg > 0x1) break;
			}
			/* no addq.b to address registers */
			if ((op.addq.size == 0) && (op.addq.dest_mode == 1)) break;
			if (!is_adrmod (op.addq.dest_mode, op.addq.dest_reg, op.addq.size, -1)) break;
			if (op.addq.issub) output ("subq%s\t", size_str[op.addq.size]);
			else output ("addq%s\t", size_str[op.addq.size]);
			output ("#%d,", (op.addq.data == 0 ? 8 : op.addq.data));
			put_adrmod (op.addq.dest_mode, op.addq.dest_reg, op.addq.size);
			goto done;
		}
		/* ADDX/SUBX */
		while (((op.addx.op == 0xd) || (op.addx.op == 0x9)) && (op.addx.OP1 == 1) && (op.addx.OP0 == 0)) {
			if (op.addx.size == 3) break;
			if (op.addx.op == 0xd) output ("addx%s\t", size_str[op.addx.size]);
			else output ("subx%s\t", size_str[op.addx.size]);
			if (op.addx.rm) {
				/* memory to memory */
				output ("-(a%d),-(a%d)", op.addx.src_reg, op.addx.dest_reg);
			} else {
				output ("d%d,d%d", op.addx.src_reg, op.addx.dest_reg);
			}

			goto done;
		}
		/* AND/OR */
		while ((op.type2.op == 0xc) || (op.type2.op == 0x8)) {
			if (op.type2.op_mode == 3) break;
			if (op.type2.op_mode == 7) break;
			if (op.type2.op == 0xc) str = "and";
			else str = "or";
			if (op.type2.op_mode < 3) {
				/* dest is reg */
				if (op.type2.ea_mode == 0x1) break;
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode, -1)) break;
				output ("%s%s\t", str, size_str[op.type2.op_mode]);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode);
				output (",d%d", op.type2.reg);
			} else {
				/* dest is ea */
				if (op.type2.ea_mode == 0x0) break;
				if (op.type2.ea_mode == 0x1) break;
				if (op.type2.ea_mode == 0x7) {
					if (op.type2.ea_reg > 1) break;
				}
				if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode-4, -1)) break;
				output ("%s%s\t", str, size_str[op.type2.op_mode-4]);
				output ("d%d,", op.type2.reg);
				put_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode-4);
			}
			goto done;
		}
		/* ANDI/EORI/ORI */
		while ((op.type1.op == 0x02) || (op.type1.op == 0xa) || (op.type1.op == 0x0)) {
			if (op.type1.size == 3) break;
			/* no address reg direct */
			if (op.type1.ea_mode == 0x1) break;
			/* no immediate or pc relative dest */
			if (op.type1.ea_mode == 0x7) {
				if (op.type1.ea_reg > 0x1) break;
			}
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, op.type1.size)) break;
			if (op.type1.op == 0x2) output ("andi%s\t", size_str[op.type1.size]);
			else if (op.type1.op == 0xa) output ("eori%s\t", size_str[op.type1.size]);
			else output ("ori%s\t", size_str[op.type1.size]);
			put_imm (op.addi.size);
			output (",");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size);
			goto done;
		}
		/* ANDI to CCR */
		while (op.code == 0x023c) {
			rd_byte ();
			output ("andi\t#$%x,ccr", rd_byte ());
			goto done;
		}
		/* ANDI to SR */
		while (op.code == 0x027c) {
			output ("andi\t#$%hx,sr", rd_short ());
			goto done;
		}
		/* ASx/LSx reg/imm */
		while (op.ASx.OP0xe == 0xe) {
			if (op.ASx.size == 3) break;
			switch (op.ASx.OP0) {
				case 0: str = "as"; break;
				case 1: str = "ls"; break;
				case 2: str = "rox"; break;
				default: case 3: str = "ro"; break;
			}
			if (op.ASx.ir) {
				/* data register shift */
				output ("%s%c%s\td%d,d%d", str,
						(op.ASx.dr ? 'l' : 'r'),
						size_str[op.ASx.size],
						op.ASx.count_reg, op.ASx.reg);
			} else {
				/* count shift thingy */
				output ("%s%c%s\t#%d,d%d", str,
						(op.ASx.dr ? 'l' : 'r'),
						size_str[op.ASx.size],
						(op.ASx.count_reg == 0 ? 8 : op.ASx.count_reg),
						op.ASx.reg);
			}
			goto done;
		}
		/* ASx/LSx memory shift */
		while ((op.MemShift.OP3 == 3) && (op.MemShift.OP0x1c == 0x1c)) {
			if (op.type1.ea_mode < 0x2) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 0x1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1, -1)) break;
			switch (op.MemShift.type) {
				case 0: str = "as"; break;
				case 1: str = "ls"; break;
				case 2: str = "rox"; break;
				default: case 3: str = "ro"; break;
			}
			output ("%s%c.w\t", str, (op.ASx.dr ? 'l' : 'r'));
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1);
			goto done;
		}
		/* Bcc */
		while (op.Bcc.op == 0x6) {
			if (Bcc_str [op.Bcc.cond] == NULL) break;
			if (op.bra.displacement) {
				temp = buf_pos + op.Bcc.displacement;
				output ("b%s.s\t", Bcc_str[op.Bcc.cond]);
				output_lab (temp);
			} else {
				temp = buf_pos;
				temp += rd_short ();
				output ("b%s.w\t", Bcc_str[op.Bcc.cond]);
				output_lab (temp);
			}
			goto done;
		}
		/* BRA */
		while (op.bra.op == 0x60) {
			if (op.bra.displacement) {
				temp = buf_pos + op.bra.displacement;
				output ("bra.s\t");
				output_lab (temp);
			} else {
				temp = buf_pos;
				temp += rd_short ();
				output ("bra.w\t");
				output_lab (temp);
			}
			goto done;
		}
		/* BSR */
		while ((op.code & 0xff00) == 0x6100) {
			if (op.bra.displacement) {
				temp = buf_pos + op.bra.displacement;
				output ("bsr.s\t");
				output_lab (temp);
			} else {
				temp = buf_pos;
				temp += rd_short ();
				output ("bsr.w\t");
				output_lab (temp);
			}
			goto done;
		}
		/* BCHG/BCLR/BSET/BTST (Dn,ea) */
		while ((op.type2.op == 0) && ((op.type2.op_mode == 0x4) || (op.type2.op_mode == 0x5) || (op.type2.op_mode == 0x6) || (op.type2.op_mode == 0x7))) {
			if (op.type2.ea_mode == 0x1) break;
			if ((op.type2.op_mode != 0x4) && (op.type2.ea_mode == 0x7)) {
				if (op.type2.ea_reg > 1) break;
			}
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2, -1)) break;
			
			if (op.type2.op_mode == 0x4) output ("btst\t");
			else if (op.type2.op_mode == 0x5) output ("bchg\t");
			else if (op.type2.op_mode == 0x6) output ("bclr\t");
			else output ("bset\t");
			output ("d%d,", op.type2.reg);
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2);
			goto done;
		}
		/* BCHG/BCLR/BSET (#<data>,ea) */
		while ((op.type2.op == 0) && (op.type2.reg == 4) &&
				((op.type2.op_mode == 0) || (op.type2.op_mode == 1) || (op.type2.op_mode == 2) || (op.type2.op_mode == 3))) {
			if (op.type2.ea_mode == 0x1) break;
			if ((op.type2.ea_mode == 0x7) && (op.type2.ea_reg > 1)) break;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2, 1)) break;
			temp = rd_byte ();
			if (temp != 0) {
				buf_pos--;
				break;
			}
			if (op.type2.op_mode == 0) {
				output ("btst\t");
			} else if (op.type2.op_mode == 1) {
				output ("bchg\t");
			} else if (op.type2.op_mode == 2) {
				output ("bclr\t");
			} else {
				output ("bset\t");
			}
			output ("#$%x,", (int)rd_byte ());
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 2);
			goto done;
		}
		/* BKPT */
		/*while ((op.code & 0xfff8) == 0x4848) {
			output ("bkpt\t#%d", op.code & 0x7);
			goto done;
		}*/
		/* CHK */
		while ((op.type2.op == 0x4) && (op.type2.op_mode == 0x6)) {
			/* no address reg direct */
			if (op.type2.ea_mode == 0x1) break;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1, -1)) break;
			
			output ("chk\t");
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1);
			output (",d%d", op.type2.reg);
			
			goto done;
		}
		/* CLR */
		while (op.type1.op == 0x42) {
			if (op.type1.size == 3) break;
			/* no address reg direct */
			if (op.type1.ea_mode == 0x1) break;
			/* no immediate or pc relative dest */
			if (op.type1.ea_mode == 0x7) {
				if (op.type1.ea_reg > 0x1) break;
			}
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, -1)) break;
			output ("clr%s\t", size_str[op.type1.size]);
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size);
			goto done;
		}
		/* CMP */
		while (op.type2.op == 11) {
			if (op.type2.op_mode > 2) break;
			/* no .b size for adr reg direct */
			if ((op.type2.op_mode == 0) && (op.type2.ea_mode == 0x1)) break;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode, -1)) break;
			output ("cmp%s\t", size_str[op.type2.op_mode]);
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, op.type2.op_mode);
			output (",d%d", op.type2.reg);
			goto done;
		}
		/* CMPA */
		while (op.type2.op == 11) {
			if ((op.type2.op_mode != 0x3) && (op.type2.op_mode != 0x7)) break;
			if (op.type2.op_mode == 0x3) size = 1;
			else size = 2;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, size, -1)) break;
			output ("cmpa%s\t", size_str [size]);
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, size);
			output (",a%d", op.type2.reg);
			goto done;
		}
		/* CMPI */
		while ((op.type1.op == 0x0c) && (op.type1.size != 0x3)) {
			if (op.type1.ea_mode == 0x1) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 0x1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, op.type1.size)) break;
			output ("cmpi%s\t", size_str [op.type1.size]);
			put_imm (op.type1.size);
			output (",");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size);
			goto done;
		}
		/* CMPM */
		while ((op.cmpm.OP0xb == 0xb) && (op.cmpm.OP2_1 == 0x1) && (op.cmpm.OP1_1 == 0x1)) {
			if (op.cmpm.size == 3) break;
			output ("cmpm%s\t(a%d)+,(a%d)+", size_str [op.cmpm.size], op.cmpm.src_reg, op.cmpm.dest_reg);
			goto done;
		}
		/* DBcc */
		while ((op.DBcc.OP5 == 5) && (op.DBcc.OP25 == 25)) {
			if (DBcc_str [op.DBcc.cond] == NULL) break;
			temp = buf_pos;
			temp += rd_short ();
			output ("db%s\td%d,", DBcc_str[op.DBcc.cond],
					op.DBcc.reg);
			output_lab (temp);
			goto done;
		}
		/* DIVS/DIVU */
		while ((op.type2.op == 0x8) && ((op.type2.op_mode == 0x7) || (op.type2.op_mode == 0x3))) {
			if (op.type2.ea_mode == 0x1) break;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1, -1)) break;
			if (op.type2.op_mode == 0x7) output ("divs\t");
			else output ("divu\t");
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1);
			output (",d%d", op.type2.reg);
			goto done;
		}
		/* EOR */
		while (op.type2.op == 0xb) {
			if ((op.type2.op_mode < 4) || (op.type2.op_mode > 6)) break;
			if (op.type2.ea_mode == 0x1) break;
			if ((op.type2.ea_mode == 0x7) && (op.type2.ea_reg > 0x1)) break;
			size = op.type2.op_mode - 4;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, size, -1)) break;
			output ("eor%s\t", size_str [size]);
			output ("d%d,", op.type2.reg);
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, size);
			goto done;
		}
		/* EORI to CCR */
		while (op.code == 0x0a3c) {
			rd_byte ();
			output ("eori\t#$%x,ccr", rd_byte ());
			goto done;
		}
		/* EORI to SR */
		while (op.code == 0x0a7c) {
			output ("eori\t#$%hx,sr", rd_short ());
			goto done;
		}
		/* EXG */
		while ((op.exg.OP0xc == 0xc) && (op.exg.OP1 == 1)) {
			if (op.exg.op_mode == 0x8) {
				/* data reg swap */
				output ("exg\td%d,d%d", op.exg.src_reg, op.exg.dest_reg);
			} else if (op.exg.op_mode == 0x9) {
				/* address reg swap */
				output ("exg\ta%d,a%d", op.exg.src_reg, op.exg.dest_reg);
			} else if (op.exg.op_mode == 0x11) {
				/* data & adr reg swap */
				output ("exg\td%d,a%d", op.exg.src_reg, op.exg.dest_reg);
			} else {
				break;
			}
			goto done;
		}
		/* EXT */
		while ((op.code & 0xfe38) == 0x4800) {
			if (op.type2.op_mode == 0x2) {
				output ("ext.w\td%d", op.type2.ea_reg);
			} else if (op.type2.op_mode == 0x3) {
				output ("ext.l\td%d", op.type2.ea_reg);
			} else {
				break;
			}
			goto done;
		}
		/* ILLEGAL */
		while (op.code == 0x4afc) {
			output ("illegal");
			goto done;
		}
		/* JMP */
		while ((op.code & 0xffc0) == 0x4ec0) {
			if (op.jmp.dest_mode == 0) break;
			if (op.jmp.dest_mode == 1) break;
			if (op.jmp.dest_mode == 3) break;
			if (op.jmp.dest_mode == 4) break;
			if ((op.jmp.dest_mode == 7) &&
			    (op.jmp.dest_reg == 4)) break;
			if (!is_adrmod (op.jmp.dest_mode, op.jmp.dest_reg, 2, -1)) break;
			output ("jmp\t");
			temp = put_adrmod (op.jmp.dest_mode, op.jmp.dest_reg, 2);
			goto done;
		}
		/* JSR */
		while ((op.code & 0xffc0) == 0x4e80) {
			if (op.type1.ea_mode == 0) break;
			if (op.type1.ea_mode == 1) break;
			if (op.type1.ea_mode == 3) break;
			if (op.type1.ea_mode == 4) break;
			/* no immediate dest */
			if ((op.type1.ea_mode == 7) && (op.type1.ea_reg == 4)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 2, -1)) break;
			output ("jsr\t");
			temp = put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 2);
			goto done;
		}
		/* LEA */
		while ((op.lea.SEVEN == 7) && (op.lea.FOUR == 4)) {
			if (op.lea.dest_mode == 0) break;
			if (op.lea.dest_mode == 1) break;
			if (op.lea.dest_mode == 3) break;
			if (op.lea.dest_mode == 4) break;
			/* no immediate dest */
			if ((op.lea.dest_mode == 7) && (op.lea.dest_reg == 4)) break;
			if (!is_adrmod (op.lea.dest_mode, op.lea.dest_reg, 2, -1)) break;
			output ("lea\t");
			put_adrmod (op.lea.dest_mode, op.lea.dest_reg, 2);
			output (",a%d", op.lea.reg);
			goto done;
		}
		/* LINK */
		while ((op.code & 0xfff8) == 0x4e50) {
			output ("link\ta%d,", op.type1.ea_reg);
			put_imm (1);
			goto done;
		}
		/* MOVE/MOVEA */
		while (op.move.op == 0) {
			if (op.move.size == 0) break;
			/* byte size and address reg direct is not allowed */
			if ((op.move.size == 1) && (op.move.src_mode == 0x1)) break;
			if ((op.move.size == 1) && (op.move.dest_mode == 0x1)) break;
			if (op.move.dest_mode == 0x7) {
				if (op.move.dest_reg > 1) break;
			}
			size = move_size [op.move.size];
			if (!is_adrmod (op.move.src_mode, op.move.src_reg, size, -1)) break;
			if ((op.move.src_mode == 0x7) && (op.move.src_reg == 0x4)) {
				/* immediate crap in the source so we must skip it */
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, size)) break;
			} else if ((op.move.src_mode == 0x7) && (op.move.src_reg > 0x1)) {
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, 1)) break;
			} else if ((op.move.src_mode == 0x7) && (op.move.src_reg == 0x1)) {
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, 2)) break;
			} else if ((op.move.src_mode == 0x7) && (op.move.src_reg == 0x0)) {
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, 1)) break;
			} else if ((op.move.src_mode == 0x6) || (op.move.src_mode == 0x5)) {
				/* PC with disp + Dx, (Ax) with disp + Dx */
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, 1)) break;
			} else {
				if (!is_adrmod (op.move.dest_mode, op.move.dest_reg, size, -1)) break;
			}
			if (op.move.dest_mode == 0x1) {
				output ("movea%s\t", size_str[size]);
			} else {
				output ("move%s\t", size_str[size]);
			}
			
			put_adrmod (op.move.src_mode, op.move.src_reg, size);
			output (",");
			put_adrmod (op.move.dest_mode, op.move.dest_reg, size);
			goto done;
		}
		/* MOVE to CCR */
		while ((op.code & 0xffc0) == 0x44c0) {
			if (op.type1.ea_mode == 0x1) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1, -1)) break;
			output ("move.w\t");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1);
			output (",ccr");
			goto done;
		}
		/* MOVE from SR */
		while ((op.code & 0xffc0) == 0x40c0) {
			if (op.type1.ea_mode == 0x1) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 0x1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1, -1)) break;
			output ("move.w\tsr,");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1);
			goto done;
		}
		/* MOVE to SR */
		while ((op.code & 0xffc0) == 0x46c0) {
			if (op.type1.ea_mode == 0x1) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1, -1)) break;
			output ("move.w\t");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 1);
			output (",sr");
			goto done;
		}
		/* MOVE USP */
		while ((op.code & 0xfff0) == 0x4e60) {
			if (op.addx.rm) {
				/* USP to Ax */
				output ("move.l\tusp,a%d", op.addx.src_reg);
			} else {
				output ("move.l\ta%d,usp", op.addx.src_reg);
			}
			goto done;
		}
		/* TODO MOVEC */
		/* TODO MOVEP */
		/* MOVEM */
		while ((op.movem.NINE == 9) && (op.movem.ONE == 1)) {
			if (op.movem.dr) {
				/* memory to register */
				if (op.movem.dest_mode < 2) break;
				if (op.movem.dest_mode == 4) break;
				if ((op.movem.dest_mode == 7) && (op.movem.dest_reg == 4)) break;
				if (!is_adrmod (op.movem.dest_mode, op.movem.dest_reg, op.movem.sz+1, 1)) break;
				temp = rd_short ();
				output ("movem%s\t", size_str [op.movem.sz+1]);
				put_adrmod (op.movem.dest_mode, op.movem.dest_reg, op.movem.sz+1);
				output (",");
				put_movem_regs (temp, 0);
			} else {
				/* register to memory */
				if (op.movem.dest_mode < 2) break;
				if (op.movem.dest_mode == 3) break;
				if ((op.movem.dest_mode == 7) && (op.movem.dest_reg > 1)) break;
				if (!is_adrmod (op.movem.dest_mode, op.movem.dest_reg, op.movem.sz+1, 1)) break;
				output ("movem%s\t", size_str [op.movem.sz+1]);
				put_movem_regs (rd_short (), (op.movem.dest_mode == 4));
				output (",");
				put_adrmod (op.movem.dest_mode, op.movem.dest_reg, op.movem.sz+1);
			}
			goto done;
		}
		/* MOVEQ */
		while ((op.moveq.SEVEN == 7) && (op.moveq.ZERO == 0)) {
			output ("moveq\t#%d,d%d", op.moveq.data, op.moveq.reg);
			goto done;
		}
		/* MULS/MULU */
		while ((op.type2.op == 0xc) && ((op.type2.op_mode == 0x7) || (op.type2.op_mode == 0x3))) {
			if (op.type2.ea_mode == 0x1) break;
			if (!is_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1, -1)) break;
			if (op.type2.op_mode == 0x7) output ("muls\t");
			else output ("mulu\t");
			put_adrmod (op.type2.ea_mode, op.type2.ea_reg, 1);
			output (",d%d", op.type2.reg);
			goto done;
		}
		/* NBCD */
		while ((op.code & 0xffc0) == 0x4800) {
			if (op.type1.ea_mode == 0x1) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0, -1)) break;
			output ("nbcd\t");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0);
			goto done;
		}
		/* NEG/NEGX/NOT */
		while ((op.type1.op == 0x44) || (op.type1.op == 0x40) || (op.type1.op == 0x46)) {
			if (op.type1.size == 3) break;
			if (op.type1.ea_mode == 0x1) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, -1)) break;
			if (op.type1.op == 0x44) output ("neg%s\t", size_str [op.type1.size]);
			else if (op.type1.op == 0x40) output ("negx%s\t", size_str [op.type1.size]);
			else output ("not%s\t", size_str [op.type1.size]);
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size);
			goto done;
		}
		/* NOP */
		while (op.code == 0x4e71) {
			output ("nop");
			goto done;
		}
		/* ORI to CCR */
		while (op.code == 0x003c) {
			rd_byte ();
			output ("ori\t#$%x,ccr", rd_byte ());
			goto done;
		}
		/* ORI to SR */
		while (op.code == 0x007c) {
			output ("ori\t#$%hx,sr", rd_short ());
			goto done;
		}
		/* PEA */
		while ((op.code & 0xffc0) == 0x4840) {
			if (op.type1.ea_mode < 2) break;
			if (op.type1.ea_mode == 3) break;
			if (op.type1.ea_mode == 4) break;
			if ((op.type1.ea_mode == 7) && (op.type1.ea_reg == 4)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, -1)) break;
			output ("pea\t");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 2);
			goto done;
		}
		/* RESET */
		while (op.code == 0x4e70) {
			output ("reset");
			goto done;
		}
		/* RTE */
		while (op.code == 0x4e73) {
			output ("rte");
			goto done;
		}
		/* RTR */
		while (op.code == 0x4e77) {
			output ("rtr");
			goto done;
		}
		/* RTS */
		while (op.code == 0x4e75) {
			output ("rts");
			goto done;
		}
		/* Scc */
		while ((op.code & 0xf0c0) == 0x50c0) {
			if (op.type1.ea_mode == 1) break;
			if ((op.type1.ea_mode == 7) && (op.type1.ea_reg > 1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0, -1)) break;
			output ("s%s\t", DBcc_str[op.DBcc.cond]);
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0);
			goto done;
		}
		/* STOP */
		while (op.code == 0x4e72) {
			output ("stop\t");
			put_imm (1);
			goto done;
		}
		/* SWAP */
		while ((op.code & 0xfff8) == 0x4840) {
			output ("swap\td%d", op.code & 0x7);
			goto done;
		}
		/* TAS */
		while ((op.code & 0xffc0) == 0x4ac0) {
			if (op.type1.ea_mode == 0x1) break;
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 0x1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0, -1)) break;
			output ("tas\t");
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, 0);
			goto done;
		}
		/* TRAP */
		while ((op.code & 0xfff0) == 0x4e40) {
			output ("trap\t#%d", op.code & 0xf);
			goto done;
		}
		/* TRAPV */
		while (op.code == 0x4e76) {
			output ("trapv");
			goto done;
		}
		/* TST */
		while (op.type1.op == 0x4a) {
			if (op.type1.size == 3) break;
			/* no address reg direct */
			if (op.type1.ea_mode == 0x1) break;
			/* no immediate or pc relative dest */
			if ((op.type1.ea_mode == 0x7) && (op.type1.ea_reg > 0x1)) break;
			if (!is_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size, -1)) break;
			output ("tst%s\t", size_str[op.type1.size]);
			put_adrmod (op.type1.ea_mode, op.type1.ea_reg, op.type1.size);
			goto done;
		}
		/* UNLK */
		while ((op.code & 0xfff8) == 0x4e58) {
			output ("unlk\ta%d", op.code & 0x7);
			goto done;
		}
		/* fuck knows */
		output ("dc.w\t$%hx", op.code);
done:
		continue;
	}
	output ("\r\n");
}

