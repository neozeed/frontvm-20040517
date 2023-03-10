/*
  Hatari - decode.h

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.
*/

#ifndef HATARI_DECODE_H
#define HATARI_DECODE_H

#include "sysdeps.h"
#include "maccess.h"
#include "memory.h"
#include "newcpu.h"

#define Regs regs.regs       /* Ouah - uggly hack - FIXME! */
#define SR regs.sr           /* Don't forget to call MakeFromSR() and MakeSR() */
/*#define PC regs.pc*/       /* PC should be read with m68k_getpc() */


#define PENDING_INTERRUPT_FLAG_MFP      0x0001    /* 'PendingInterruptFlag' masks */
#define PENDING_INTERRUPT_FLAG_TRACE    0x0002
#define CLEAR_PENDING_INTERRUPT_FLAG_MFP   0xfffe
#define CLEAR_PENDING_INTERRUPT_FLAG_TRACE 0xfffd


extern  unsigned char STRam[MEMORY_SIZE];
extern  short int PendingInterruptFlag;
extern  void *PendingInterruptFunction;
extern  short int PendingInterruptCount;
extern  unsigned long STRamEnd;


/*-----------------------------------------------------------------------*/
/* Offset ST address to PC pointer: */
#define STRAM_ADDR(Var)  ((unsigned long)STRam+((unsigned long)Var&0x00ffffff))


/*-----------------------------------------------------------------------*/
/* Set clock times for each instruction, see '68000 timing' pages for details */
/* NOTE All times are rounded up to nearest 4 cycles */
#define  ROUND_CYCLES_TO4(var)  (((int)(var)+3)&0xfffffffc)

static inline void ADD_CYCLES(op,r,w)
{
  PendingInterruptCount-= (op+3)&0xfffffffc;
}


#endif   /* HATARI_DECODE_H */
