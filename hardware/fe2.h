#ifndef _FE2_H
#define _FE2_H

/* Do not use directly - they are just locations in STRam */
extern unsigned long logscreen, logscreen2, physcreen, physcreen2;
/* Use these instead. They read the value */
#define LOGSCREEN	(STRam + STMemory_ReadLong (logscreen))
#define LOGSCREEN2	(STRam + STMemory_ReadLong (logscreen2))
#define PHYSCREEN	(STRam + STMemory_ReadLong (physcreen))
#define PHYSCREEN2	(STRam + STMemory_ReadLong (physcreen2))

struct Point {
	float x, y;
};

/* Returns new xpos */
int DrawStr (int xpos, int ypos, int col, unsigned char *str, bool shadowed);
void DrawTriangle (int Ax, int Ay, int Bx, int By, int Cx, int Cy, int col);
void DrawPoly (struct Point *pt, int len, int col);

#endif /* _FE2_H */
