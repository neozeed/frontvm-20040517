/*
  Hatari - m68000.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  These routines originally (in WinSTon) handled exceptions as well as some
  few OpCode's such as Line-F and Line-A. In Hatari it has mainly become a
  wrapper between the WinSTon sources and the UAE CPU code.
*/

#include <SDL.h>
#include "main.h"
#include "decode.h"
#include "hatari-glue.h"
#include "int.h"
#include "m68000.h"
#include "stMemory.h"
#include "disasm.h"

unsigned long ExceptionVector;
short int PendingInterruptFlag;
void *PendingInterruptFunction;
short int PendingInterruptCount;
Uint32 BusAddressLocation;       /* Stores the offending address for bus-/address errors */
Uint32 BusErrorPC;               /* Value of the PC when bus error occurs */
Uint16 BusErrorOpcode;           /* Opcode of faulting instruction */


/*-----------------------------------------------------------------------*/
/*
  Reset CPU 68000 variables
*/
void M68000_Reset(BOOL bCold)
{
  int i;

  /* Clear registers */
  if (bCold)
  {
    for(i=0; i<(16+1); i++)
      Regs[i] = 0;
  }

  PendingInterruptFlag = 0;     /* Clear pending flag */

  /* Now directly reset the UAE CPU core: */
  m68k_reset();
}

static void dump_registers ()
{
	int i;
	for (i=0; i<8; i++) {
		fprintf (stderr, "D%d: 0x%08x\t\tA%d: 0x%08x\n", i, Regs[i], i, Regs[i+8]);
	}
}

void M68000_Crash (int exception)
{
	int pc = m68k_getpc();
	
	fprintf(stderr, "Exception (-> %i bombs) at 0x%x!\n\n", exception, pc);
	dump_registers ();
	dump_code (pc, 32);
	SDL_Quit ();
	exit (-2);
}

/*-----------------------------------------------------------------------*/
/*
  Exception handler
*/
void M68000_Exception(void)
{
  int exceptionNr = ExceptionVector/4;

  if(exceptionNr>24 && exceptionNr<32)  /* 68k autovector interrupt? */
  {
    /* Handle autovector interrupts the UAE's way
     * (see intlev() and do_specialties() in UAE CPU core) */
#if 1
    if(requestedInterrupt != -1)
      fprintf(stderr,"Warning: Overriding interrupt %d with %d\n",
              requestedInterrupt, exceptionNr-24);
#endif
    requestedInterrupt = exceptionNr - 24;
    set_special(SPCFLAG_INT);
  }
  else
  {
    /* Was the CPU stopped, i.e. by a STOP instruction? */
    regs.stopped = 0;
    unset_special(SPCFLAG_STOP);        /* All is go,go,go! */

    /* 68k exceptions are handled by Exception() of the UAE CPU core */
    Exception(exceptionNr, m68k_getpc());

    MakeSR();
    /* Set Status Register so interrupt can ONLY be stopped by another interrupt
     * of higher priority! */
#if 0  /* VBL and HBL are handled in the UAE CPU core (see above). */
    if (ExceptionVector==EXCEPTION_VBLANK)
      SR = (SR&SR_CLEAR_IPL)|0x0400;  /* VBL, level 4 */
    else if (ExceptionVector==EXCEPTION_HBLANK)
      SR = (SR&SR_CLEAR_IPL)|0x0200;  /* HBL, level 2 */
    else
#endif
    MakeFromSR();
  }
}

