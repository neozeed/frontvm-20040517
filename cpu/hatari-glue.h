/*
  Hatari - hatari-glue.h

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.
*/

#ifndef HATARI_GLUE_H
#define HATARI_GLUE_H


#include "sysdeps.h"


extern int illegal_mem;
extern int address_space_24;
extern int cpu_level;
extern int cpu_compatible;
extern int requestedInterrupt;

int Init680x0(void);
void Exit680x0(void);
void Start680x0(void);
void customreset(void);
int intlev (void);
void check_prefs_changed_cpu(int new_level, int new_compatible);

#define write_log 


#endif /* HATARI_GLUE_H */
