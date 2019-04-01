/*
  Hatari - configuration.h

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.
*/

#ifndef HATARI_CONFIGURATION_H
#define HATARI_CONFIGURATION_H


/* Sound configuration */
typedef enum
{
  PLAYBACK_LOW,
  PLAYBACK_MEDIUM,
  PLAYBACK_HIGH
} SOUND_QUALITIY;

typedef struct
{
  BOOL bEnableSound;
} CNF_SOUND;


/* Dialog Keyboard */
typedef enum
{
  KEYMAP_SYMBOLIC,  /* Use keymapping with symbolic (ASCII) key codes */
  KEYMAP_SCANCODE,  /* Use keymapping with PC keyboard scancodes */
  KEYMAP_LOADED     /* Use keymapping with a map configuration file */
} KEYMAPTYPE;

typedef struct
{
  BOOL bDisableKeyRepeat;
  KEYMAPTYPE nKeymapType;
  char szMappingFileName[MAX_FILENAME_LENGTH];
} CNF_KEYBOARD;



/* Hard discs configuration */
#define DRIVELIST_TO_DRIVE_INDEX(DriveList)  (DriveList+1)

typedef enum
{
  DRIVELIST_NONE,
  DRIVELIST_C,
  DRIVELIST_CD,
  DRIVELIST_CDE,
  DRIVELIST_CDEF
} DRIVELIST;

typedef enum
{
  DRIVE_C,
  DRIVE_D,
  DRIVE_E,
  DRIVE_F
} DRIVELETTER;

/* Screen configuration */
typedef struct
{
  BOOL bFullScreen;
  BOOL bDoubleSizeWindow;
  int ChosenDisplayMode;
  BOOL bCaptureChange;
  int nFramesPerSecond;
} CNF_SCREEN;



/* Dialog System */
typedef enum
{
  MINMAXSPEED_MIN,
  MINMAXSPEED_1,
  MINMAXSPEED_2,
  MINMAXSPEED_3,
  MINMAXSPEED_MAX
} MINMAXSPEED_TYPE;

typedef struct
{
  int nCpuLevel;
  BOOL bCompatibleCpu;
  BOOL bAddressSpace24;
  MINMAXSPEED_TYPE nMinMaxSpeed;
} CNF_SYSTEM;


/* State of system is stored in this structure */
/* On reset, variables are copied into system globals and used. */
typedef struct
{
  /* Configure */
  CNF_SCREEN Screen;
  CNF_KEYBOARD Keyboard;
  CNF_SOUND Sound;
  CNF_SYSTEM System;
} CNF_PARAMS;


extern BOOL bFirstTimeInstall;
extern CNF_PARAMS ConfigureParams;

extern void Configuration_SetDefault(void);

#endif
