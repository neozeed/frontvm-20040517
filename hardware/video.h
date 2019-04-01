
extern unsigned long VideoBase;
extern unsigned char *VideoRaster;
extern int nScreenRefreshRate;

extern void Video_Reset(void);
extern unsigned long Video_ReadAddress(void);
extern void Video_InterruptHandler_VBL(void);
extern void Video_InterruptHandler_VBL_Pending(void);
