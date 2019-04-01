/*
  Hatari
*/

// Interrupt handlers in system
enum {
  INTERRUPT_NULL,
  INTERRUPT_VIDEO_VBL_PENDING,
  
  MAX_INTERRUPTS
};

// Event timer structure - keeps next timer to occur in structure so don't need to check all entries
typedef struct {
  BOOL bUsed;                      // Is interrupt active?
  int Cycles;
  void *pFunction;
} INTERRUPTHANDLER;

extern void *pIntHandlerFunctions[];
extern int nCyclesOver;

extern void Int_Reset(void);
extern int Int_HandlerFunctionToID(void *pHandlerFunction);
extern void *Int_IDToHandlerFunction(int ID);
extern void Int_SetNewInterrupt(void);
extern void Int_AcknowledgeInterrupt(void);
extern void Int_AddAbsoluteInterrupt(int CycleTime, int Handler);
extern void Int_AddRelativeInterrupt(int CycleTime, int Handler);
extern void Int_RemovePendingInterrupt(int Handler);
extern BOOL Int_InterruptActive(int Handler);
extern int Int_FindCyclesPassed(int Handler);
