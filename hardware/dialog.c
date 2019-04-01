/*
  Hatari - dialog.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  This is normal 'C' code to handle our options dialog. We keep all our configuration details
  in a variable 'ConfigureParams'. When we open our dialog we copy this and then when we 'OK'
  or 'Cancel' the dialog we can compare and makes the necessary changes.
*/

#ifndef _MSC_VER
#include <unistd.h>
#endif

#include "main.h"
#include "configuration.h"
#include "audio.h"
#include "dialog.h"
#include "file.h"
#include "keymap.h"
#include "m68000.h"
#include "memAlloc.h"
#include "misc.h"
#include "reset.h"
#include "screen.h"
#include "video.h"
#include "sdlgui.h"
#include "../cpu/hatari-glue.h"

extern void Screen_DidResolutionChange(void);


/* The main dialog: */
#define MAINDLG_ABOUT    2
#define MAINDLG_SCREEN   3
#define MAINDLG_KEYBD    4
#define MAINDLG_OK     	 5
#define MAINDLG_CANCEL   6
#define MAINDLG_QUIT     7
SGOBJ maindlg[] =
{
  { SGBOX, 0, 0, 0,0, 24,18, NULL },
  { SGTEXT, 0, 0, 2,1, 16,1, "Virtual Machine Menu" },
  { SGBUTTON, 0, 0, 6,4, 12,1, "About" },
  { SGBUTTON, 0, 0, 6,6, 12,1, "Screen" },
  { SGBUTTON, 0, 0, 6,8, 12,1, "Keyboard" },
  { SGBUTTON, 0, 0, 3,13, 8,1, "Okay" },
  { SGBUTTON, 0, 0, 3,15, 8,1, "Cancel" },
  { SGBUTTON, 0, 0, 13,13, 8,3, "Quit" },
  { -1, 0, 0, 0,0, 0,0, NULL }
};


/* The "About"-dialog: */
SGOBJ aboutdlg[] =
{
  { SGBOX, 0, 0, 0,0, 40,21, NULL },
  { SGTEXT, 0, 0, 12,1, 12,1, "Frontier: Elite 2" },
  { SGTEXT, 0, 0, 12,2, 12,1, "=================" },
  { SGTEXT, 0, 0, 1,4, 38,1, "This Frontier virtual machine is based" },
  { SGTEXT, 0, 0, 1,5, 38,1, "on Hatari, by T. Huth, S. Marothy," },
  { SGTEXT, 0, 0, 1,6, 38,1, "S. Berndtsson, P. Bates, B.Schmidt and" },
  { SGTEXT, 0, 0, 1,7, 38,1, "many others."},
  { SGTEXT, 0, 0, 1,8, 38,1, "Hatari code and all additions to it"},
  { SGTEXT, 0, 0, 1,9, 38,1, "are licensed under the terms of the"},
  { SGTEXT, 0, 0, 1,10,38,1, "GNU General Public License version 2."},
  { SGTEXT, 0, 0, 1,11,38,1, "FE2.S and FE2.BIN are reverse-"},
  { SGTEXT, 0, 0, 1,12,38,1, "engineered source and binary of"},
  { SGTEXT, 0, 0, 1,13,38,1, "Frontier: Elite 2, by David Braben."},
  { SGTEXT, 0, 0, 1,14,38,1, "They are probably not legal in many"},
  { SGTEXT, 0, 0, 1,15,38,1, "countries even if you own a copy of"},
  { SGTEXT, 0, 0, 1,16,38,1, "Atari ST Frontier (which they are"},
  { SGTEXT, 0, 0, 1,17,38,1, "based on,) so play quietly."},
  { SGBUTTON, 0, 0, 17,19, 7,1, "YES" },
  { -1, 0, 0, 0,0, 0,0, NULL }
};



/* The screen dialog: */
#define DLGSCRN_FULLSCRN   3
#define DLGSCRN_1X     5
#define DLGSCRN_2X     6
#define DLGSCRN_SCALE2X    7
#define DLGSCRN_EXIT       8

SGOBJ screendlg[] =
{
  { SGBOX, 0, 0, 0,0, 24,20, NULL },
  { SGBOX, 0, 0, 1,1, 21,15, NULL },
  { SGTEXT, 0, 0, 5,2, 14,1, "Screen options" },
  { SGCHECKBOX, 0, 0, 4,6, 12,1, "Fullscreen" },
  { SGTEXT, 0, 0, 2,8, 12,1, "Screen size:" },
  { SGRADIOBUT, 0, 0, 4,10, 8,1, "Normal" },
  { SGRADIOBUT, 0, 0, 4,12, 8,1, "Zoomed" },
  { SGRADIOBUT, 0, 0, 4,14, 8,1, "Scale2x" },
  { SGBUTTON, 0, 0, 2,17, 20,1, "Back to main menu" },
  { -1, 0, 0, 0,0, 0,0, NULL }
};


/* The keyboard dialog: */
#define DLGKEY_SYMBOLIC  3
#define DLGKEY_SCANCODE  4
#define DLGKEY_FROMFILE  5
#define DLGKEY_MAPNAME   7
#define DLGKEY_MAPBROWSE 8
#define DLGKEY_EXIT      9
SGOBJ keyboarddlg[] =
{
  { SGBOX, 0, 0, 0,0, 40,12, NULL },
  { SGTEXT, 0, 0, 13,1, 14,1, "Keyboard setup" },
  { SGTEXT, 0, 0, 2,3, 17,1, "Keyboard mapping:" },
  { SGRADIOBUT, 0, 0, 3,5, 10,1, "Symbolic" },
  { SGRADIOBUT, 0, 0, 15,5, 10,1, "Scancode" },
  { SGRADIOBUT, 0, 0, 27,5, 11,1, "From file" },
  { SGTEXT, 0, 0, 2,7, 13,1, "Mapping file:" },
  { SGTEXT, 0, 0, 2,8, 36,1, NULL },
  { SGBUTTON, 0, 0, 32,7, 6,1, "Browse" },
  { SGBUTTON, 0, 0, 10,10, 20,1, "Back to main menu" },
  { -1, 0, 0, 0,0, 0,0, NULL }
};




CNF_PARAMS DialogParams;   /* List of configuration for dialogs (so the user can also choose 'Cancel') */



/*-----------------------------------------------------------------------*/
/*
  Copy details back to configuration and perform reset
*/
void Dialog_CopyDialogParamsToConfiguration(BOOL bForceReset)
{
  BOOL NeedReset;

  /* Do we need to warn user of that changes will only take effect after reset? */
  if (bForceReset)
    NeedReset = bForceReset;
  else
    NeedReset = FALSE;

  /* Copy details to configuration, so can be saved out or set on reset */
  ConfigureParams = DialogParams;

  /* Set keyboard remap file */
  if(ConfigureParams.Keyboard.nKeymapType == KEYMAP_LOADED)
    Keymap_LoadRemapFile(ConfigureParams.Keyboard.szMappingFileName);

  /* Do we need to perform reset? */
  if (NeedReset)
  {
    Reset_VM();
    /*FM  View_ToggleWindowsMouse(MOUSE_ST);*/
  }

  /* Go into/return from full screen if flagged */
  if ( (!bInFullScreen) && (DialogParams.Screen.bFullScreen) )
    Screen_EnterFullScreen();
  else if ( bInFullScreen && (!DialogParams.Screen.bFullScreen) )
    Screen_ReturnFromFullScreen();
}



/*-----------------------------------------------------------------------*/
/*
  Show and process the screen dialog.
*/
void Dialog_ScreenDlg(void)
{
  int but, i;

  SDLGui_CenterDlg(screendlg);

  /* Set up dialog from actual values: */

  if( DialogParams.Screen.bFullScreen )
    screendlg[DLGSCRN_FULLSCRN].state |= SG_SELECTED;
  else
    screendlg[DLGSCRN_FULLSCRN].state &= ~SG_SELECTED;

  for(i=0; i<3; i++)
    screendlg[DLGSCRN_1X + i].state &= ~SG_SELECTED;

  switch (ConfigureParams.Screen.ChosenDisplayMode) {
	  case DISPLAYMODE_HICOL_1X:
		  screendlg[DLGSCRN_1X].state |= SG_SELECTED;
		  break;
	  case DISPLAYMODE_HICOL_2X:
		  screendlg[DLGSCRN_2X].state |= SG_SELECTED;
		  break;
	  default:
		  screendlg[DLGSCRN_SCALE2X].state |= SG_SELECTED;
		  break;
  }
  
  /* The screen dialog main loop */
  do
  {
    but = SDLGui_DoDialog(screendlg);
  }
  while( but!=DLGSCRN_EXIT && !bQuitProgram );

  /* Read values from dialog */
  DialogParams.Screen.bFullScreen = (screendlg[DLGSCRN_FULLSCRN].state & SG_SELECTED);

  for(i=0; i<3; i++)
  {
    if(screendlg[DLGSCRN_1X + i].state & SG_SELECTED)
    {
      DialogParams.Screen.ChosenDisplayMode = i;
      break;
    }
  }
}


/*-----------------------------------------------------------------------*/
/*
  Show and process the "Keyboard" dialog.
*/
void Dialog_KeyboardDlg(void)
{
  int i, but;
  char dlgmapfile[40];
  char tmpname[MAX_FILENAME_LENGTH];

  SDLGui_CenterDlg(keyboarddlg);

  /* Set up dialog from actual values: */
  for(i = DLGKEY_SYMBOLIC; i <= DLGKEY_FROMFILE; i++)
  {
    keyboarddlg[i].state &= ~SG_SELECTED;
  }
  keyboarddlg[DLGKEY_SYMBOLIC+DialogParams.Keyboard.nKeymapType].state |= SG_SELECTED;

  File_ShrinkName(dlgmapfile, DialogParams.Keyboard.szMappingFileName, keyboarddlg[DLGKEY_MAPNAME].w);
  keyboarddlg[DLGKEY_MAPNAME].txt = dlgmapfile;

  /* Show the dialog: */
  do
  {
    but = SDLGui_DoDialog(keyboarddlg);

    if(but == DLGKEY_MAPBROWSE)
    {
      strcpy(tmpname, DialogParams.Keyboard.szMappingFileName);
      if(!tmpname[0])
      {
        getcwd(tmpname, MAX_FILENAME_LENGTH);
        File_AddSlashToEndFileName(tmpname);
      }
      if( SDLGui_FileSelect(tmpname, NULL) )
      {
        strcpy(DialogParams.Keyboard.szMappingFileName, tmpname);
        if( !File_DoesFileNameEndWithSlash(tmpname) && File_Exists(tmpname) )
          File_ShrinkName(dlgmapfile, tmpname, keyboarddlg[DLGKEY_MAPNAME].w);
        else
          dlgmapfile[0] = 0;
      }
      Screen_Draw(0);
    }

  }
  while(but != DLGKEY_EXIT && !bQuitProgram);

  /* Read values from dialog: */
  if(keyboarddlg[DLGKEY_SYMBOLIC].state & SG_SELECTED)
    DialogParams.Keyboard.nKeymapType = KEYMAP_SYMBOLIC;
  else if(keyboarddlg[DLGKEY_SCANCODE].state & SG_SELECTED)
    DialogParams.Keyboard.nKeymapType = KEYMAP_SCANCODE;
  else
    DialogParams.Keyboard.nKeymapType = KEYMAP_LOADED;
}



/*-----------------------------------------------------------------------*/
/*
  This functions sets up the actual font and then displays the main dialog.
*/
int Dialog_MainDlg(BOOL *bReset)
{
  int retbut;

  if(SDLGui_PrepareFont())
    return FALSE;

  SDLGui_CenterDlg(maindlg);
  SDL_ShowCursor(SDL_ENABLE);

  do
  {
    retbut = SDLGui_DoDialog(maindlg);
    switch(retbut)
    {
      case MAINDLG_ABOUT:
        SDLGui_CenterDlg(aboutdlg);
        SDLGui_DoDialog(aboutdlg);
        break;
      case MAINDLG_SCREEN:
        Dialog_ScreenDlg();
        break;
      case MAINDLG_KEYBD:
        SDLGui_CenterDlg(keyboarddlg);
        Dialog_KeyboardDlg();
        break;
      case MAINDLG_QUIT:
        bQuitProgram = TRUE;
        break;
    }
    Screen_Draw(0);
  }
  while(retbut!=MAINDLG_OK && retbut!=MAINDLG_CANCEL && !bQuitProgram);

  SDL_ShowCursor(SDL_DISABLE);

  return(retbut==MAINDLG_OK);
}


/*-----------------------------------------------------------------------*/
/*
  Open Property sheet Options dialog
  Return TRUE if user choses OK, or FALSE if cancel!
*/
BOOL Dialog_DoProperty(void)
{
  BOOL bOKDialog;  /* Did user 'OK' dialog? */
  BOOL bForceReset;

  Main_PauseEmulation();

  /* Copy details to DialogParams (this is so can restore if 'Cancel' dialog) */
  ConfigureParams.Screen.bFullScreen = bInFullScreen;
  DialogParams = ConfigureParams;

  bForceReset = FALSE;

  bOKDialog = Dialog_MainDlg(&bForceReset);

  if (bOKDialog)
	  Dialog_CopyDialogParamsToConfiguration (bForceReset);
  
  /* Did want to save/restore memory save? If did, need to re-enter emulation mode so can save in 'safe-zone' */
  Main_UnPauseEmulation();

  return(bOKDialog);
}

