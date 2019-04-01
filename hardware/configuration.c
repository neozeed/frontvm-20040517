/*
  Hatari - configuration.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  Configuration File

  The configuration file is now stored in an ASCII format to allow the user
  to edit the file manually.
*/

#include "main.h"
#include "configuration.h"
#include "dialog.h"
#include "video.h"
#include "screen.h"
#include "shortcut.h"
#include "memAlloc.h"
#include "file.h"
#include "../cpu/hatari-glue.h"


BOOL bFirstTimeInstall = FALSE;             /* Has been run before? Used to set default joysticks etc... */
CNF_PARAMS ConfigureParams;                 /* List of configuration for the emulator */


/*-----------------------------------------------------------------------*/
/*
  Set default configuration values.
*/
void Configuration_SetDefault(void)
{
  /* Clear parameters */
  Memory_Clear(&ConfigureParams, sizeof(CNF_PARAMS));

  /* Set defaults for Keyboard */
  ConfigureParams.Keyboard.bDisableKeyRepeat = TRUE;
  ConfigureParams.Keyboard.nKeymapType = KEYMAP_SYMBOLIC;
  strcpy(ConfigureParams.Keyboard.szMappingFileName, "");

  /* Set defaults for Screen */
  ConfigureParams.Screen.bFullScreen = FALSE;
  ConfigureParams.Screen.bDoubleSizeWindow = TRUE;
  ConfigureParams.Screen.ChosenDisplayMode = DISPLAYMODE_HICOL_2X;
  ConfigureParams.Screen.bCaptureChange = FALSE;
  ConfigureParams.Screen.nFramesPerSecond = 1;

  /* Set defaults for Sound */
  ConfigureParams.Sound.bEnableSound = TRUE;

  /* Set defaults for System */
  ConfigureParams.System.nCpuLevel = 0;
  ConfigureParams.System.bCompatibleCpu = FALSE;
  ConfigureParams.System.bAddressSpace24 = TRUE;
  ConfigureParams.System.nMinMaxSpeed = MINMAXSPEED_MIN;

}


