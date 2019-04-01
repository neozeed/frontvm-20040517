/*
  Hatari - main.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  Main initialization and event handling routines.
*/

#include <time.h>
#include <signal.h>
#ifndef _MSC_VER
#include <sys/time.h>
#include <unistd.h>
#endif

#include <SDL.h>

#include "main.h"
#include "configuration.h"
#include "decode.h"
#include "dialog.h"
#include "audio.h"
#include "file.h"
#include "hostcall.h"
#include "input.h"
#include "reset.h"
#include "keymap.h"
#include "m68000.h"
#include "misc.h"
#include "screen.h"
#include "sdlgui.h"
#include "shortcut.h"
#include "video.h"

#include "../cpu/hatari-glue.h"


#define FORCE_WORKING_DIR                 /* Set default directory to cwd */


BOOL bQuitProgram=FALSE;                  /* Flag to quit program cleanly */
BOOL bUseFullscreen=FALSE;
BOOL bEmulationActive=TRUE;               /* Run emulation when started */
BOOL bAppActive = FALSE;
char szBootDiscImage[MAX_FILENAME_LENGTH] = { "" };

char szWorkingDir[MAX_FILENAME_LENGTH] = { "" };
char szCurrentDir[MAX_FILENAME_LENGTH] = { "" };

unsigned char STRam[MEMORY_SIZE];        /* This is our ST Ram, includes all TOS/hardware areas for ease */


/*-----------------------------------------------------------------------*/
/*
  Error handler
*/
void Main_SysError(char *Error,char *Title)
{
  fprintf(stderr,"%s : %s\n",Title,Error);
}


/*-----------------------------------------------------------------------*/
/*
  Bring up message(handles full-screen as well as Window)
*/
int Main_Message(char *lpText, char *lpCaption/*,unsigned int uType*/)
{
  int Ret=0;

  /* Show message */
  fprintf(stderr,"%s: %s\n", lpCaption, lpText);

  return(Ret);
}


/*-----------------------------------------------------------------------*/
/*
  Pause emulation, stop sound
*/
void Main_PauseEmulation(void)
{
  if( bEmulationActive )
  {
    Audio_EnableAudio(FALSE);
    bEmulationActive = FALSE;
  }
}

/*-----------------------------------------------------------------------*/
/*
  Start emulation
*/
void Main_UnPauseEmulation(void)
{
  if( !bEmulationActive )
  {
    Audio_EnableAudio(ConfigureParams.Sound.bEnableSound);
    bFullScreenHold = FALSE;      /* Release hold  */

    bEmulationActive = TRUE;
  }
}

/* ----------------------------------------------------------------------- */
/*
  Message handler
  Here we process the SDL events (keyboard, mouse, ...) and map it to
  Atari IKBD events.
*/
void Main_EventHandler()
{
  SDL_Event event;

  if( SDL_PollEvent(&event) )
   switch( event.type )
   {
    case SDL_QUIT:
       bQuitProgram = TRUE;
       break;
    case SDL_MOUSEMOTION:               /* Read/Update internal mouse position */
       input.motion_x += event.motion.xrel;
       input.motion_y += event.motion.yrel;
       break;
    case SDL_MOUSEBUTTONDOWN:
       Input_MousePress (event.button.button);
       break;
    case SDL_MOUSEBUTTONUP:
       Input_MouseRelease (event.button.button);
       break;
    case SDL_KEYDOWN:
       Keymap_KeyDown(&event.key.keysym);
       break;
    case SDL_KEYUP:
       Keymap_KeyUp(&event.key.keysym);
       break;
   }
  Input_Update ();
}


/*-----------------------------------------------------------------------*/
/*
  Check for any passed parameters
*/
void Main_ReadParameters(int argc, char *argv[])
{
  int i;

  /* Scan for any which we can use */
  for(i=1; i<argc; i++)
  {
    if (strlen(argv[i])>0)
    {
      if (!strcmp(argv[i],"--help") || !strcmp(argv[i],"-h"))
      {
        printf("Usage:\n frontier [options]\n"
               "Where options are:\n"
               "  --help or -h          Print this help text and exit.\n"
               "  --fullscreen or -f    Try to use fullscreen mode.\n"
               "  --nosound             Disable sound (faster!).\n"
              );
        exit(0);
      }
      else if (!strcmp(argv[i],"--fullscreen") || !strcmp(argv[i],"-f"))
      {
        bUseFullscreen=TRUE;
      }
      else if ( !strcmp(argv[i],"--nosound") )
      {
        bDisableSound=TRUE;
        ConfigureParams.Sound.bEnableSound = FALSE;
      }
      else
      {
	      /* some time make it possible to read alternative
	       * names for fe2.bin from command line */
	      fprintf(stderr,"Illegal parameter: %s\n",argv[i]);
      }
    }
  }
}


/*-----------------------------------------------------------------------*/
/*
  Initialise emulation
*/
void Main_Init(void)
{
  /* Init SDL's video subsystem. Note: Audio and joystick subsystems
     will be initialized later (failures there are not fatal). */
  if(SDL_Init(SDL_INIT_VIDEO) < 0)
  {
    fprintf(stderr, "Could not initialize the SDL library:\n %s\n", SDL_GetError() );
    exit(-1);
  }

  Misc_SeedRandom(1043618);
  SDLGui_Init();
  Screen_Init();
  Init680x0();                  /* Init CPU emulation */
  Audio_Init();
  Keymap_Init();

  GemDOS_Init();
  GemDOS_InitDrives();

  if(Reset_VM())              /* Reset all systems */
  {
    /* If loading of the TOS failed, we bring up the GUI to let the
     * user choose another TOS ROM file. */
    Dialog_DoProperty();
  }
  if(bQuitProgram)
  {
    SDL_Quit();
    exit(-2);
  }
}


/*-----------------------------------------------------------------------*/
/*
  Un-Initialise emulation
*/
void Main_UnInit(void)
{
  Screen_ReturnFromFullScreen();
  GemDOS_UnInitDrives();
  Audio_UnInit();
  SDLGui_UnInit();
  Screen_UnInit();

  /* SDL uninit: */
  SDL_Quit();
}


/*-----------------------------------------------------------------------*/
/*
  Main
*/
int main(int argc, char *argv[])
{

  /* Generate random seed */
  srand( time(NULL) );

  /* Get working directory, if in MSDev force */
  Misc_FindWorkingDirectory(argv[0]);
#ifdef FORCE_WORKING_DIR
  getcwd(szWorkingDir, MAX_FILENAME_LENGTH);
#endif

  /* Set default configuration values: */
  Configuration_SetDefault();

  /* Check for any passed parameters */
  Main_ReadParameters(argc, argv);

  /* Init emulator system */
  Main_Init();

  /* Switch immediately to fullscreen if user wants to */
  if( bUseFullscreen )
    Screen_EnterFullScreen();

  /* Run emulation */
  Main_UnPauseEmulation();
  Start680x0();                 /* Start emulation */

  /* Un-init emulation system */
  Main_UnInit();

  return(0);
}


