
#include <SDL.h>
#include <SDL_endian.h>

#include "main.h"
#include "screen.h"
#include "screenConvert.h"
#include "video.h"
#include "scalebit.h"


int ScrX,ScrY;                   /* Locals */
int ScrUpdateFlag;               /* Bit mask of how to update screen */
BOOL bScrDoubleY;                /* TRUE if double on Y */
unsigned long *RGBPalette;

void BuildRGBPalette (unsigned long *rgb, unsigned short *st, int len)
{
	int i;
	int st_col, r, g, b;

	for (i=0; i<len; i++, st++) {
		st_col = *st;
		b = (st_col & 0xf)<<4;
		g = (st_col & 0xf0);
		r = (st_col & 0xf00)>>4;
		//printf ("%x: %x, %x, %x\n", st_col, r,g,b);
		rgb[i] = SDL_MapRGB(sdlscrn->format, r, g, b);
	}
}

static inline void AdjustLinePaletteRemap(int y)
{
  /* Copy palette and convert to RGB in display format */
  if (y >= 168) {
	  RGBPalette = CtrlRGBPalette;
  } else {
	  RGBPalette = MainRGBPalette;
  }
}


/*-----------------------------------------------------------------------*/
/*
  Run updates to palette(STRGBPalette[]) until get to screen line we are to convert from
*/
void Convert_StartFrame(void)
{
 int ecx;
 ecx=STScreenStartHorizLine;            /* Get #lines before conversion starts */
 if( ecx==0 )  return;
 ScrY=0;
 do
  {
   AdjustLinePaletteRemap(ScrY);            /* Update palette */
   ++ScrY;
   --ecx;
  }
 while( ecx );
}

void Draw_320x16Bit(void)
{
	Uint8 *st_pix;
	Uint16 *pc_pix;
	int x;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		pc_pix = (Uint16 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			*pc_pix = RGBPalette [*st_pix];
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 320*2;
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}


void Draw_320x24Bit(void)
{
	Uint8 *st_pix;
	Uint8 *pc_pix;
	int x, col;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;
	pc_pix = (Uint8 *)pPCScreenDest;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			col = RGBPalette [*st_pix];
			if (SDL_BYTEORDER == SDL_BIG_ENDIAN) {
				*pc_pix++ = (col >> 16) & 0xff;
				*pc_pix++ = (col >> 8) & 0xff;
				*pc_pix++ = col & 0xff;
			} else {
				*pc_pix++ = col & 0xff;
				*pc_pix++ = (col >> 8) & 0xff;
				*pc_pix++ = (col >> 16) & 0xff;
			}
			st_pix++;
		}
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}


void Draw_320x32Bit(void)
{
	Uint8 *st_pix;
	Uint32 *pc_pix;
	int x;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		pc_pix = (Uint32 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			*pc_pix = RGBPalette [*st_pix];
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 320*4;
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}

void Draw_640x16Bit(void)
{
	Uint8 *st_pix;
	Uint16 *pc_pix;
	int x, col;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		pc_pix = (Uint16 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			col = RGBPalette [*st_pix];
			*pc_pix = col;
			*(pc_pix + 320*2) = col;
			pc_pix++;
			*pc_pix = col;
			*(pc_pix + 320*2) = col;
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 640*4;
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}


void Draw_640x24Bit(void)
{
	Uint8 *st_pix;
	Uint8 *pc_pix;
	int x, col;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;
	pc_pix = (Uint8 *)pPCScreenDest;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			col = RGBPalette [*st_pix];
			if (SDL_BYTEORDER == SDL_BIG_ENDIAN) {
				*pc_pix = *(pc_pix+640*3) = (col >> 16) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 8) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = col & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 16) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 8) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = col & 0xff;
				pc_pix++;
			} else {
				*pc_pix = *(pc_pix+640*3) = col & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 8) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 16) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = col & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 8) & 0xff;
				pc_pix++;
				*pc_pix = *(pc_pix+640*3) = (col >> 16) & 0xff;
				pc_pix++;
			}
			st_pix++;
		}
		pc_pix += 640*3;
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}

void Draw_640x32Bit(void)
{
	Uint8 *st_pix;
	Uint32 *pc_pix;
	int x, col;
	Convert_StartFrame ();
	
	ScrY = STScreenStartHorizLine;

	do {
		st_pix = (Uint8 *)VideoRaster + STScreenLineOffset[ScrY];
		pc_pix = (Uint32 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY);
		
		for (x=STScreenWidthBytes; x>0; x--) {
			col = RGBPalette [*st_pix];
			*pc_pix = col;
			*(pc_pix + 320*2) = col;
			pc_pix++;
			*pc_pix = col;
			*(pc_pix + 320*2) = col;
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 640*8;
		ScrY++;
	} while (ScrY < STScreenEndHorizLine);
}

#define SCALE_OPT	2
#define SRC_PIX		1	/* 8bpp */
#define DEST_SLICE	(320 * SRC_PIX * SCALE_OPT)

char scale2x_buf[DEST_SLICE * 200 * SCALE_OPT];

void Draw_Scale2x16Bit ()
{
	Uint8 *st_pix;
	Uint16 *pc_pix;
	int x;
	
	scale (SCALE_OPT, scale2x_buf, DEST_SLICE, VideoRaster, 320*SRC_PIX, SRC_PIX, 320, 200);
	
	Convert_StartFrame ();
	
	ScrY = 0;

	do {
		st_pix = (Uint8 *)scale2x_buf + 640*ScrY;
		pc_pix = (Uint16 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY>>1);
		
		for (x=640; x>0; x--) {
			*pc_pix = RGBPalette [*st_pix];
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 640*2;
		ScrY++;
	} while (ScrY < SCREEN_HEIGHT_HBL*2);
}


void Draw_Scale2x24Bit ()
{
	Uint8 *st_pix;
	Uint8 *pc_pix;
	int x, col;
	
	scale (SCALE_OPT, scale2x_buf, DEST_SLICE, VideoRaster, 320*SRC_PIX, SRC_PIX, 320, 200);
	
	Convert_StartFrame ();
	
	ScrY = 0;
	pc_pix = (Uint8 *)pPCScreenDest;

	do {
		st_pix = (Uint8 *)scale2x_buf + 640*ScrY;
		
		AdjustLinePaletteRemap(ScrY>>1);
		
		for (x=640; x>0; x--) {
			col = RGBPalette [*st_pix];
			if (SDL_BYTEORDER == SDL_BIG_ENDIAN) {
				*pc_pix++ = (col >> 16) & 0xff;
				*pc_pix++ = (col >> 8) & 0xff;
				*pc_pix++ = col & 0xff;
			} else {
				*pc_pix++ = col & 0xff;
				*pc_pix++ = (col >> 8) & 0xff;
				*pc_pix++ = (col >> 16) & 0xff;
			}
			st_pix++;
		}
		
		ScrY++;
	} while (ScrY < SCREEN_HEIGHT_HBL*2);
}


void Draw_Scale2x32Bit ()
{
	Uint8 *st_pix;
	Uint32 *pc_pix;
	int x;
	
	scale (SCALE_OPT, scale2x_buf, DEST_SLICE, VideoRaster, 320*SRC_PIX, SRC_PIX, 320, 200);
	
	Convert_StartFrame ();
	
	ScrY = 0;

	do {
		st_pix = (Uint8 *)scale2x_buf + 640*ScrY;
		pc_pix = (Uint32 *)pPCScreenDest;
		
		AdjustLinePaletteRemap(ScrY>>1);
		
		for (x=640; x>0; x--) {
			*pc_pix = RGBPalette [*st_pix];
			pc_pix++;
			st_pix++;
		}
		
		pPCScreenDest += 640*4;
		ScrY++;
	} while (ScrY < SCREEN_HEIGHT_HBL*2);
}


/* [bytes per pixel][mode] */
SCREENDRAWFUNC screendrawfuncs [5][3] = {
	{ NULL, NULL, NULL },
	{ NULL, NULL, NULL },
	{ &Draw_320x16Bit, &Draw_640x16Bit, &Draw_Scale2x16Bit },
	{ &Draw_320x24Bit, &Draw_640x24Bit, &Draw_Scale2x24Bit },
	{ &Draw_320x32Bit, &Draw_640x32Bit, &Draw_Scale2x32Bit }
};

