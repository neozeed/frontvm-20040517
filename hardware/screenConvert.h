/*
  Hatari - screenConvert.h

  This file is distributed under the GNU Public License, version 2 or at your
  option any later version. Read the file gpl.txt for details.
*/


extern int ScrUpdateFlag;
extern BOOL bScrDoubleY;

extern void BuildRGBPalette (unsigned long *rgb, unsigned short *st, int len);
extern void ConvertLowRes_320x16Bit(void);
extern void ConvertLowRes_640x16Bit(void);
extern void Convert_Scale2X ();
extern void Line_ConvertLowRes_640x16Bit(Uint32 *edi, Uint32 *ebp, Uint32 *esi, Uint32 eax);

typedef void (*SCREENDRAWFUNC) (void);
SCREENDRAWFUNC screendrawfuncs [5][3];


