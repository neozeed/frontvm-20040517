/*
  Hatari - hatari-glue.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  This file contains some code to glue the UAE CPU core to the rest of the
  emulator and Hatari's "illegal" opcodes.
*/
static char rcsid[] = "Hatari $Id: hatari-glue.c,v 1.19 2003/06/20 13:13:22 thothy Exp $";


#include <stdio.h>

#include "../hardware/main.h"
#include "../hardware/int.h"
#include "../hardware/stMemory.h"

#include "sysdeps.h"
#include "maccess.h"
#include "memory.h"
#include "newcpu.h"

#ifndef FALSE
#define FALSE 0
#define TRUE 1
#endif


int illegal_mem = FALSE;
int address_space_24 = TRUE;
int cpu_level = 0;              /* 68000 (default) */
int cpu_compatible = FALSE;

int requestedInterrupt = -1;


/* Reset custom chips */
void customreset(void)
{
  requestedInterrupt = -1;
}


/* Return interrupt number (1 - 7), -1 means no interrupt. */
int intlev(void)
{
  int ret = requestedInterrupt;
  requestedInterrupt = -1;

  return ret;
}


/* Initialize 680x0 emulation */
int Init680x0(void)
{
  /* Note: memory_init() is now done in tos.c */

  init_m68k();
  return TRUE;
}


/* Deinitialize 680x0 emulation */
void Exit680x0(void)
{
  memory_uninit();
}


/* Reset and start 680x0 emulation */
void Start680x0(void)
{
  m68k_reset();
  m68k_go(TRUE);
}


/* Check if the CPU type has been changed */
void check_prefs_changed_cpu(int new_level, int new_compatible)
{
  if(cpu_level!=new_level || cpu_compatible!=new_compatible)
  {
    cpu_level = new_level;
    cpu_compatible = new_compatible;
    set_special(SPCFLAG_MODE_CHANGE);
    if (table68k)
      build_cpufunctbl ();
  }
}



