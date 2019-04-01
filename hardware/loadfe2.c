/*
 * Loads fe2.bin into ST memory and applies all the relocations.
 * fe2.bin (and any crap as68k generates) is just plain atari
 * prg format, so we could load anything that understood the
 * stripped down and weirdified hardware of this VM.
 */

#include <SDL.h>
#include <SDL_types.h>

#include "main.h"
#include "decode.h"
#include "dialog.h"
#include "file.h"
#include "m68000.h"
#include "memAlloc.h"
#include "stMemory.h"
#include "loadfe2.h"

static void *fe2file;
static long len;
static long code_end;
static int buf_pos;


static int rd_int ()
{
#ifdef _MSC_VER
	int val = STMemory_Swap68000Long (*(Uint32 *)((int )fe2file+buf_pos));
#else
	int val = STMemory_Swap68000Long (*(Uint32 *)(fe2file+buf_pos));
#endif

	buf_pos += 4;
	return val;
}

static unsigned char rd_byte ()
{
#ifdef _MSC_VER
	unsigned char val = *(unsigned char*)((int )fe2file+buf_pos);
#else
	unsigned char val = *(unsigned char*)(fe2file+buf_pos);
#endif
	buf_pos++;
	return val;
}

static int get_fixup (int reloc)
{
	int old_bufpos;
	int next;
	static int reloc_pos;

	old_bufpos = buf_pos;
	if (reloc == 0) {
		buf_pos = code_end;
		reloc = rd_int ();
		reloc_pos = buf_pos;
		buf_pos = old_bufpos;
		if (reloc == 0) return 0;
		else return reloc + FE2BASE;
	} else {
		buf_pos = reloc_pos;
again:
		next = rd_byte ();
		if (next == 0) {
			buf_pos = old_bufpos;
			return 0;
		} else if (next == 1) {
			reloc += 254;
			goto again;
		}
		else reloc += next;
		reloc_pos = buf_pos;
		buf_pos = old_bufpos;
		return reloc;
	}
}

void LoadFE2 ()
{
	int reloc, next, pos, i = 0;
	fe2file = File_Read ("fe2.bin", NULL, &len, NULL);
	
	if (!len) {
		printf ("Error loading fe2.bin\n");
		SDL_Quit ();
		exit (-2);
	}
	buf_pos = 2;
	code_end = 0x1c + rd_int ();
	
	reloc = FE2BASE;
	for (i=0x1c; i<code_end; i++) {
#ifdef _MSC_VER
		STMemory_WriteByte (reloc, *(char *)((int )fe2file+i));
#else
		STMemory_WriteByte (reloc, *(char *)(fe2file+i));
#endif
		reloc++;
	}

	i=0;
	reloc = get_fixup (0);
	while (reloc) {
		i++;
		pos = buf_pos;
		/* address to be modified */
		buf_pos = reloc;
		next = STMemory_ReadLong (buf_pos);
		next += FE2BASE;
		STMemory_WriteLong (buf_pos, next);
		if (next > code_end+FE2BASE) {
			printf ("Reloc 0x%x (0x%x) out of range..\n", next, reloc+FE2BASE);
		}
		buf_pos = pos;
		reloc = get_fixup (reloc);
	}
	printf ("fe2.bin 0x%lx bytes (code end 0x%lx), %d fixups; loaded at 0x%x.\n", len, code_end, i, FE2BASE);
	
	Memory_Free (fe2file);
}
