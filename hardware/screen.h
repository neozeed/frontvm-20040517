/*
  Hatari - screen.h

  This file is distributed under the GNU Public License, version 2 or at your
  option any later version. Read the file gpl.txt for details.
*/

#ifndef HATARI_SCREEN_H
#define HATARI_SCREEN_H

#include <SDL_video.h>    /* for SDL_Surface */


/* WinSTon used NUM_FRAMEBUFFERS=2, but =1 seems to be working better in Hatari... */
#define NUM_FRAMEBUFFERS  1

typedef struct
{
  void *pDrawFunction;              /* Draw function */
  /*int DirectDrawMode;*/           /* Mode required for DirectDraw. eg MODE_320x200x256 */
  int Width,Height,BitDepth,VertPixelsPerLine;
  int PCStartHorizLine,PCStartXOffset;              /* Source ST lines/bytes to skip, Destination screen lines/bytes to skip */
  int MouseScale;
} SCREENDRAW;

/* Update Palette defines */
enum
{
  UPDATE_PALETTE_NONE,
  UPDATE_PALETTE_UPDATE,
  UPDATE_PALETTE_FULLUPDATE
};

/* Palette mask values for 'HBLPaletteMask[]' */
#define PALETTEMASK_RESOLUTION  0x00040000
#define PALETTEMASK_PALETTE     0x0000ffff
#define PALETTEMASK_UPDATERES   0x20000000
#define PALETTEMASK_UPDATEPAL   0x40000000
#define PALETTEMASK_UPDATEFULL  0x80000000
#define PALETTEMASK_UPDATEMASK  (PALETTEMASK_UPDATEFULL|PALETTEMASK_UPDATEPAL|PALETTEMASK_UPDATERES)

/* Available fullscreen modes */
#define NUM_DISPLAYMODEOPTIONS	6
enum
{
  DISPLAYMODE_HICOL_1X,
  DISPLAYMODE_HICOL_2X,
  DISPLAYMODE_HICOL_SCALE2X
};


/* For palette we don't go from colour '0' as the whole background would change, so go from this value */
#define  BASECOLOUR       0x0A
#define  BASECOLOUR_LONG  0x0A0A0A0A

extern SCREENDRAW ScreenDraw;
extern unsigned char *pScreenBitmap;
extern unsigned char *pSTScreen,*pSTScreenCopy;
extern unsigned char *pPCScreenDest;
extern int STScreenStartHorizLine,STScreenEndHorizLine;
extern int PCScreenBytesPerLine,STScreenWidthBytes,STScreenLeftSkipBytes;
extern BOOL bInFullScreen;
extern BOOL bFullScreenHold;
extern BOOL bScreenContentsChanged;
extern BOOL bTooSlowSoSkipAFlip;
extern int STScreenLineOffset[SCREEN_HEIGHT_HBL];
extern unsigned long MainRGBPalette[256];
extern unsigned long CtrlRGBPalette[16];

extern unsigned long ST2RGB[2048];
extern SDL_Surface *sdlscrn;
extern BOOL bGrabMouse;

/* palette length changes as dynamic colours change */
extern int len_main_palette;
extern unsigned short MainPalette[256];
extern unsigned short CtrlPalette[16];

extern void Screen_Init(void);
extern void Screen_UnInit(void);
extern void Screen_Reset(void);
extern void Screen_SetWindowRes();
extern void Screen_SetScreenLineOffsets(void);
extern void Screen_SetFullUpdate(void);
extern void Screen_SetupRGBTable(void);
extern void Screen_EnterFullScreen(void);
extern void Screen_ReturnFromFullScreen(void);
extern void Screen_ClearScreen(void);
extern void Screen_SetDrawModes(void);
extern void Screen_Blit(BOOL bSwapScreen);
extern void Screen_DrawFrame(BOOL bForceFlip);
extern void Screen_Draw(unsigned long _dummy);

#endif  /* ifndef HATARI_SCREEN_H */
