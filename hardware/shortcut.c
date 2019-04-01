/*
  Hatari

  Shortcut keys
*/

#include <SDL.h>

#include "main.h"
#include "dialog.h"
#include "audio.h"
#include "memAlloc.h"
#include "reset.h"
#include "screen.h"
#include "shortcut.h"


/* List of possible short-cuts(MUST match SHORTCUT_xxxx) */
char *pszShortCutTextStrings[NUM_SHORTCUTS+1] = {
  "(not assigned)",
  "Full Screen",
  "Mouse Mode",
  "Reset",
  NULL  /*term*/
};

char *pszShortCutF11TextString[] = {
  "Full Screen",
  NULL  /*term*/
};

char *pszShortCutF12TextString[] = {
  "Mouse Mode",
  NULL  /*term*/
};

ShortCutFunction_t pShortCutFunctions[NUM_SHORTCUTS] = {
  NULL,
  ShortCut_FullScreen,
  ShortCut_MouseMode,
  ShortCut_ColdReset,
};

SHORTCUT_KEY ShortCutKey;

/*-----------------------------------------------------------------------*/
/*
  Clear shortkey structure
*/
void ShortCut_ClearKeys(void)
{
  /* Clear short-cut key structure */
  Memory_Clear(&ShortCutKey,sizeof(SHORTCUT_KEY));
}

/*-----------------------------------------------------------------------*/
/*
  Check to see if pressed any shortcut keys, and call handling function
*/
void ShortCut_CheckKeys(void)
{
  /* Check for supported keys: */
  switch(ShortCutKey.Key) {
     case SDLK_F12:                  /* Show options dialog */
       Dialog_DoProperty();
       break;
     case SDLK_F11:                  /* Switch between fullscreen/windowed mode */
       ShortCut_FullScreen();
       break;
     case SDLK_m:                    /* Toggle mouse mode */
       ShortCut_MouseMode();
       break;
     case SDLK_r:                    /* Cold reset */
       ShortCut_ColdReset();
       break;
     case SDLK_q:                    /* Quit program */
       bQuitProgram = TRUE;
       break;
  }

    /* And clear */
    ShortCut_ClearKeys();
}


/*-----------------------------------------------------------------------*/
/*
  Shortcut to toggle full-screen
*/
void ShortCut_FullScreen(void)
{
  if(!bInFullScreen)
  {
    Screen_EnterFullScreen();
  }
  else
  {
    Screen_ReturnFromFullScreen();
  }
}


/*-----------------------------------------------------------------------*/
/*
  Shortcut to toggle mouse mode
*/
void ShortCut_MouseMode(void)
{
  bGrabMouse = !bGrabMouse;        /* Toggle flag */

  /* If we are in windowed mode, toggle the mouse cursor mode now: */
  if(!bInFullScreen)
  {
    if(bGrabMouse)
    {
      SDL_WM_GrabInput(SDL_GRAB_ON);
    }
    else
    {
      SDL_WM_GrabInput(SDL_GRAB_OFF);
    }
  }
}


/*-----------------------------------------------------------------------*/
/*
  Shortcut to 'Cold' reset
*/
void ShortCut_ColdReset(void)
{
  Reset_VM();                 /* Reset emulator with 'cold' (clear all) */
}

