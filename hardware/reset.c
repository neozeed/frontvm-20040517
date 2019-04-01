/*
  Hatari

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  Reset emulation state.
*/

#include "main.h"
#include "decode.h"
#include "hostcall.h"
#include "int.h"
#include "m68000.h"
#include "misc.h"
#include "reset.h"
#include "screen.h"
#include "audio.h"
#include "stMemory.h"
#include "video.h"
#include "loadfe2.h"
#include "dialog.h"

unsigned long STRamEnd;                 /* End of ST Ram, above this address is no-mans-land and hardware vectors */

/*-----------------------------------------------------------------------*/
/*
  Set default memory configuration, connected floppies and memory size
*/
void SetDefaultMemoryConfig(void)
{
  STMemory_WriteLong(0x42e, MEMORY_SIZE);          /* phys top */
  
  /* Set memory range */
  STRamEnd = MEMORY_SIZE;  /* Set end of RAM */

  /* Initialize the memory banks: */
  memory_uninit();
  memory_init(STRamEnd, 0, MEMORY_SIZE);
}


/*-----------------------------------------------------------------------*/
/*
  Reset ST emulator states, chips, interrupts and registers
*/
int Reset_VM ()
{
  STMemory_Clear(0x00000000, MEMORY_SIZE);   /* Clear First 4Mb */

  SetDefaultMemoryConfig();
  LoadFE2 ();
  STMemory_WriteLong(4, FE2BASE);        /* Set reset vector */
  STMemory_WriteLong(0, MEMORY_SIZE);        /* And reset stack pointer */
  
  Int_Reset();                  /* Reset interrupts */
  Video_Reset();                /* Reset video */

  GemDOS_Reset();               /* Reset GEMDOS emulation */

  Audio_Reset();                /* Reset Sound */
  Screen_Reset();               /* Reset screen */
  M68000_Reset(TRUE);          /* Reset CPU */

  /* And keyboard check for debugger */
#ifdef USE_DEBUGGER
  Int_AddAbsoluteInterrupt(CYCLES_DEBUGGER, INTERRUPT_DEBUGGER);
#endif

  return 0;
}
