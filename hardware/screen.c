/*
  Hatari - screen.c

  This file is distributed under the GNU Public License, version 2 or at your
  option any later version. Read the file gpl.txt for details.

  This code converts a 1/2/4 plane ST format screen to either 8 or 16-bit PC
  format. An awful lost of processing is needed to do this conversion - we
  cannot simply change palettes on  interrupts as it is possible with DOS.
  The main code processes the palette/resolution mask tables to find exactly
  which lines need to updating and the conversion routines themselves only
  update 16-pixel blocks which differ from the previous frame - this gives a
  large performance increase.
  Each conversion routine can convert any part of the source ST screen (which
  includes the overscan border, usually set to colour zero) so they can be used
  for both window and full-screen mode.
  Note that in Hi-Resolution we have no overscan and just two colors so we can
  optimise things further. Also when running in maximum speed we make sure we
  only convert the screen every 50 times a second - inbetween frames are not
  processed.
*/

#include <SDL.h>

#include "main.h"
#include "configuration.h"
#include "m68000.h"
#include "memAlloc.h"
#include "misc.h"
#include "screen.h"
#include "screenConvert.h"
#include "video.h"
#include "scalebit.h"

int len_main_palette;
unsigned short MainPalette[256];
unsigned short CtrlPalette[16];

SCREENDRAW ScreenDraw;                   /* Set up with details of drawing functions  */
unsigned char *pScreenBitmap=NULL;                /* Screen pixels in PC RGB format, allocated with 'CreateDIBSection' */
unsigned char *pPCScreenDest;                     /* Destination PC buffer */
int STScreenStartHorizLine,STScreenEndHorizLine;  /* Start/End lines to be converted */
int PCScreenBytesPerLine, STScreenWidthBytes, STScreenLeftSkipBytes;
BOOL bInFullScreen=FALSE;                         /* TRUE if in full screen */
BOOL bFullScreenHold = FALSE;                     /* TRUE if hold display while full screen */
BOOL bScreenContentsChanged;                      /* TRUE if buffer changed and requires blitting */
BOOL bTooSlowSoSkipAFlip = FALSE;
int nDroppedFrames=0;                             /* Number of dropped frames during emulation run */
int prevChosenDisplayMode = -1;

int STScreenLineOffset[SCREEN_HEIGHT_HBL];        /* Offsets for ST screen lines eg, 0,160,320... */
unsigned long MainRGBPalette[256];
unsigned long CtrlRGBPalette[16];

SDL_Surface *sdlscrn;                             /* The SDL screen surface */
BOOL bGrabMouse = FALSE;                          /* Grab the mouse cursor in the window */


/*-----------------------------------------------------------------------*/
/*
  Set window size
*/
void Screen_SetWindowRes()
{
  prevChosenDisplayMode = ConfigureParams.Screen.ChosenDisplayMode;
  switch (ConfigureParams.Screen.ChosenDisplayMode) {
	  case DISPLAYMODE_HICOL_1X:
	  	sdlscrn=SDL_SetVideoMode(320, 200, 16, SDL_DOUBLEBUF | SDL_ANYFORMAT);
		break;
	  default:
		sdlscrn=SDL_SetVideoMode(640, 400, 16, SDL_DOUBLEBUF | SDL_ANYFORMAT);
		break;
  }
  if ((sdlscrn == NULL) || (sdlscrn->format->BytesPerPixel < 2))
  {
    fprintf(stderr, "Could not set video mode:\n %s\n", SDL_GetError() );
    SDL_Quit();
    exit(-2);
  }
  pScreenBitmap=sdlscrn->pixels;

  if(!bGrabMouse)
  {
    SDL_WM_GrabInput(SDL_GRAB_OFF);  /* Un-grab mouse pointer in windowed mode */
  }
  Screen_SetDrawModes();        /* Set draw modes(store which modes to use!) */
}

/*-----------------------------------------------------------------------*/
/*
  Init Screen bitmap and buffers/tables needed for ST to PC screen conversion
*/
void Screen_Init(void)
{
  Screen_SetWindowRes();

  Screen_SetScreenLineOffsets();                  /* Store offset to each horizontal line */

  /* Configure some SDL stuff: */
  SDL_WM_SetCaption(PROG_NAME, "Frontier");
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  SDL_EventState(SDL_MOUSEBUTTONDOWN, SDL_ENABLE);
  SDL_EventState(SDL_MOUSEBUTTONUP, SDL_ENABLE);
  SDL_ShowCursor(SDL_DISABLE);
}


/*-----------------------------------------------------------------------*/
/*
  Free screen bitmap and allocated resources
*/
void Screen_UnInit(void)
{
}


/*-----------------------------------------------------------------------*/
/*
  Reset screen
*/
void Screen_Reset(void)
{
}

/*-----------------------------------------------------------------------*/
/*
  Store Y offset for each horizontal line in our source ST screen for each reference in assembler(no multiply)
*/
void Screen_SetScreenLineOffsets(void)
{
  int i;

  for(i=0; i<SCREEN_HEIGHT_HBL; i++)
    STScreenLineOffset[i] = i * SCREENBYTES_LINE;
}


/*-----------------------------------------------------------------------*/

/*-----------------------------------------------------------------------*/
/*
  Enter Full screen mode
*/

static SDL_Surface *set_new_sdl_fsmode() {
  SDL_Surface *newsdlscrn;

    newsdlscrn = SDL_SetVideoMode(sdlscrn->w, sdlscrn->h,
		ScreenDraw.BitDepth, SDL_DOUBLEBUF | SDL_ANYFORMAT | SDL_FULLSCREEN);
  return newsdlscrn;
}

void Screen_EnterFullScreen(void)
{
  SDL_Surface *newsdlscrn;

  if (!bInFullScreen)
  {
    Main_PauseEmulation();        /* Hold things... */
    SDL_Delay(20);                /* To give sound time to clear! */

    newsdlscrn = set_new_sdl_fsmode();
    Screen_SetDrawModes();        /* Set draw modes(store which modes to use!) */

    if( newsdlscrn==NULL )
    {
      fprintf(stderr, "Could not set video mode:\n %s\n", SDL_GetError() );
    }
    else
    {
      sdlscrn = newsdlscrn;
      pScreenBitmap = newsdlscrn->pixels;
      bInFullScreen = TRUE;

      Screen_ClearScreen();         /* Black out screen bitmap as will be invalid when return */
    }
    Main_UnPauseEmulation();        /* And off we go... */

    SDL_WM_GrabInput(SDL_GRAB_ON);  /* Grab mouse pointer in fullscreen */
  }
}


/*-----------------------------------------------------------------------*/
/*
  Return from Full screen mode back to a window
*/
void Screen_ReturnFromFullScreen(void)
{
  if (bInFullScreen)
  {
    Main_PauseEmulation();        /* Hold things... */
    SDL_Delay(20);                /* To give sound time to clear! */

    bInFullScreen = FALSE;

    Screen_SetWindowRes();
    Screen_SetDrawModes();

    Main_UnPauseEmulation();          /* And off we go... */
  }
}


/*-----------------------------------------------------------------------*/
/*
  Clear Window display memory
*/
void Screen_ClearScreen(void)
{
  SDL_FillRect(sdlscrn,NULL, SDL_MapRGB(sdlscrn->format, 0, 0, 0) );
}

/*-----------------------------------------------------------------------*/
/*
*/
void Screen_SetDrawModes(void)
{
  /* Clear out */
  Memory_Clear(&ScreenDraw,sizeof(SCREENDRAW));

  ScreenDraw.pDrawFunction = screendrawfuncs[sdlscrn->format->BytesPerPixel][ConfigureParams.Screen.ChosenDisplayMode];
  /* Assign full-screen draw modes from chosen option under dialog */
  switch (ConfigureParams.Screen.ChosenDisplayMode) {

	case DISPLAYMODE_HICOL_1X:
  		ScreenDraw.Width = 320;
  		ScreenDraw.Height = 200;
  		ScreenDraw.BitDepth = sdlscrn->format->BitsPerPixel;
		ScreenDraw.VertPixelsPerLine = 1;
		ScreenDraw.PCStartHorizLine = 0;
		ScreenDraw.MouseScale = 1;
		break;
	case DISPLAYMODE_HICOL_2X:
	default:
		ScreenDraw.Width = 640;
  		ScreenDraw.Height = 480;
  		ScreenDraw.BitDepth = sdlscrn->format->BitsPerPixel;
		ScreenDraw.VertPixelsPerLine = 2;
		ScreenDraw.PCStartHorizLine = 0;
		ScreenDraw.MouseScale = 2;
		break;
  }
}


/*-----------------------------------------------------------------------*/
/*
  Set details for ST screen conversion(Window version)
*/
void Screen_SetWindowConvertDetails(void)
{
  pPCScreenDest = pScreenBitmap;                /* Destination PC screen */

  STScreenStartHorizLine = 0;                   /* Full height */

    /* Always draw to WHOLE screen including ALL borders */
    STScreenLeftSkipBytes = 0;                  /* Number of bytes to skip on ST screen for left(border) */
    STScreenWidthBytes = SCREENBYTES_LINE;      /* Number of horizontal bytes in our ST screen */

    STScreenEndHorizLine = SCREEN_HEIGHT_HBL;

      PCScreenBytesPerLine = sdlscrn->pitch;
}

/*-----------------------------------------------------------------------*/
/*
  Set details for ST screen conversion (Full-Screen version)
*/
void Screen_SetFullScreenConvertDetails(void)
{
  /* Only draw what can fit into full-screen and centre on Y */
  STScreenLeftSkipBytes = 0;
  STScreenWidthBytes = SCREENBYTES_LINE;

  STScreenStartHorizLine = 0;
  STScreenEndHorizLine = SCREEN_HEIGHT_HBL;

  PCScreenBytesPerLine = sdlscrn->pitch;
  pPCScreenDest = (unsigned char *)sdlscrn->pixels;  /* Destination PC screen */
  /* And offset on X */
 // pPCScreenDest += ScreenDraw.PCStartXOffset;
  //pPCScreenDest += ScreenDraw.PCStartHorizLine * PCScreenBytesPerLine;

  /* Is non-interlaced? May need to double up on Y */
    bScrDoubleY = TRUE;
}


/*-----------------------------------------------------------------------*/
/*
  Lock full-screen for drawing
*/
BOOL Screen_Lock(void)
{
  if(SDL_MUSTLOCK(sdlscrn))
  {
    if(SDL_LockSurface(sdlscrn))
    {
      Screen_ReturnFromFullScreen();   /* All OK? If not need to jump back to a window */
      return(FALSE);
    }
  }

  return(TRUE);
}

/*-----------------------------------------------------------------------*/
/*
  UnLock full-screen
*/
void Screen_UnLock(void)
{
  if( SDL_MUSTLOCK(sdlscrn) )
    SDL_UnlockSurface(sdlscrn);
}


/*-----------------------------------------------------------------------*/
/*
  Draw ST screen to window/full-screen framebuffer
*/
void Screen_DrawFrame(BOOL bForceFlip)
{
  void *pDrawFunction;

  if ((!ConfigureParams.Screen.bFullScreen) &&
      (prevChosenDisplayMode != ConfigureParams.Screen.ChosenDisplayMode))
	  Screen_SetWindowRes ();

  //if (!bScreenContentsChanged) return;
  if (bTooSlowSoSkipAFlip) {
	  bTooSlowSoSkipAFlip = FALSE;
	  return;
  }
  
  /* Lock screen ready for drawing */
  if (Screen_Lock()) {
    bScreenContentsChanged = FALSE;
    /* Set details */
    if (bInFullScreen) 
	    Screen_SetFullScreenConvertDetails();
    else
    	    Screen_SetWindowConvertDetails();
    /* Call drawing for full-screen */
      pDrawFunction = ScreenDraw.pDrawFunction;
    
    /* build RGB palettes */
    BuildRGBPalette (MainRGBPalette, MainPalette, len_main_palette);
    BuildRGBPalette (CtrlRGBPalette, CtrlPalette, 16);
      
    if (pDrawFunction)
      CALL_VAR(pDrawFunction)

    /* Unlock screen */
    Screen_UnLock();

    SDL_Flip(sdlscrn);
  }
}

/*-----------------------------------------------------------------------*/
/*
  Draw ST screen to window/full-screen
  This is now called from the 68k program's vblank handler,
  since we need the vblank to update palettes appropriately
  before drawing the screen (for frontier)
*/
void Screen_Draw(unsigned long _dummy)
{
  /* Are we holding screen? Ie let user choose options while in full-screen mode using GDI */
  if (bInFullScreen && bFullScreenHold)
  {
    return;
  }

  if (!bQuitProgram)
  {
    if(VideoBase)
    {
      Screen_DrawFrame(FALSE);
    }
  }

}
