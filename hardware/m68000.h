/*
  Hatari - m68000.h

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.
*/

#ifndef HATARI_M68000_H
#define HATARI_M68000_H

extern unsigned long ExceptionVector;
extern Uint32 BusAddressLocation;
extern Uint32 BusErrorPC;
extern Uint16 BusErrorOpcode;

extern void M68000_Crash (int exception);
extern void M68000_Reset(BOOL bCold);
extern void M68000_Exception(void);

#endif
