/*
  Hatari - video.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  Video hardware handling. This code handling all to do with the video chip. So, we handle
  VBLs, HBLs, copying the ST screen to a buffer to simulate the TV raster trace, border
  removal, palette changes per HBL, the 'video address pointer' etc...
*/

#include <SDL.h>

#include "main.h"
#include "decode.h"
#include "configuration.h"
#include "int.h"
#include "keymap.h"
#include "m68000.h"
#include "memAlloc.h"
#include "screen.h"
#include "shortcut.h"
#include "stMemory.h"
#include "video.h"
#include "hatari-glue.h"

long VideoAddress;                              /* Address of video display in ST screen space */
unsigned long VideoBase;                        /* Base address in ST Ram for screen(read on each VBL) */
unsigned char *VideoRaster;                      /* Pointer to Video raster, after VideoBase in PC address space. Use to copy data on HBL */
int SyncHandler_Value;                          /* Value to pass to 'Video_SyncHandler_xxxx' functions */
int nScreenRefreshRate = 50;                    /* 50 or 60 Hz in color, 70 Hz in mono */


/*-----------------------------------------------------------------------*/
/*
  Reset video chip
*/
void Video_Reset(void)
{
  /* Reset addresses */
  VideoBase = 0L;
  VideoRaster = STRam;
}

/*-----------------------------------------------------------------------*/
/*
  Read Video address pointer(from current cycle count), and return 24-bit address in 'ebx'
*/
unsigned long Video_ReadAddress(void)
{
  VideoAddress = VideoBase;
  return( VideoAddress );
}

/*
 * 68k prog must call host screen_draw in its vblank.
 */
void Video_InterruptHandler_VBL(void)
{
  /* Clear any key presses which are due to be de-bounced (held for one ST frame) */
  Keymap_DebounceAllKeys();
  /* Check 'Function' keys, so if press F12 we update screen correctly to Window! */
  ShortCut_CheckKeys();

  MakeSR();
  if ((4>FIND_IPL) && (4 > intlev ()))     /* Vertical blank, level 4! */
  {
    ExceptionVector = EXCEPTION_VBLANK;
    M68000_Exception();        /* VBL interrupt */
  }
  else
  {
    /* Higher priority interrupt is currently being executed(eg MFP). Set VBL to occur later */
    if (!Int_InterruptActive(INTERRUPT_VIDEO_VBL_PENDING))
      Int_AddAbsoluteInterrupt(100,INTERRUPT_VIDEO_VBL_PENDING);
  }

  /* And handle any messages, check for quit message */
  Main_EventHandler();         /* Process messages, set 'bQuitProgram' if user tries to quit */
  /* Pass NULL interrupt function to quit cleanly */
  if (bQuitProgram) Int_AddAbsoluteInterrupt(4, 0L);
}


/*-----------------------------------------------------------------------*/
/*
  This doesn't make sense... I always thought if a 68000 interrupt, eg the VBL, occurs while a
  higher priority interrupt was in service the interrupt was ignored. This does not seem to be
  the case. This really needs checking on a real ST, but I have noticed some menu discs run
  sound routines from the MFP timers which overlap the VBL, yet the VBL still occurs...
*/
void Video_InterruptHandler_VBL_Pending(void)
{
  /* Remove this interrupt from list and re-order */
  Int_AcknowledgeInterrupt();

  MakeSR();
  /* Check if can execute VBL */
  if ((4>FIND_IPL) && (4 > intlev ()))     /* Vertical blank, level 4! */
  {
    ExceptionVector = EXCEPTION_VBLANK;
    M68000_Exception();        /* VBL interrupt */
  }
  else
    Int_AddAbsoluteInterrupt(100,INTERRUPT_VIDEO_VBL_PENDING);
}

