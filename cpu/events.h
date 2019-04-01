 /*
  * Events
  * These are best for low-frequency events. Having too many of them,
  * or using them for events that occur too frequently, can cause massive
  * slowdown.
  */

#ifndef UAE_EVENTS_H
#define UAE_EVENTS_H

#include "../hardware/main.h"
#include "../hardware/decode.h"


STATIC_INLINE void do_cycles(unsigned long cycles_to_add)
{
  cycles_to_add = 4;
  //cycles_to_add = (cycles_to_add+3)&0xfffffffc;
 // lastInstructionCycles = cycles_to_add;     /* Store to find how many cycles last instruction took to execute */
  PendingInterruptCount -= (short)cycles_to_add;     /* Add cycle time including effective address time */
  if( PendingInterruptCount<=0 || PendingInterruptFlag)	/* Check for any interrupts or flag to service */
  {
    if (PendingInterruptFunction)
      CALL_VAR(PendingInterruptFunction);
  }
}

#endif  /* UAE_EVENTS_H */
