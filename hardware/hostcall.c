/*
  Hatari - gemdos.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  GEMDOS intercept routines.
  These are used mainly for hard drive redirection of high level file routines.

  Now case is handled by using glob. See the function
  GemDOS_CreateHardDriveFileName for that. It also knows about symlinks.
  A filename is recognized on its eight first characters, do don't try to
  push this too far, or you'll get weirdness ! (But I can even run programs
  directly from a mounted cd in lower cases, so I guess it's working well !).
*/

#include <sys/stat.h>
#include <time.h>
#ifdef _MSC_VER
#include "msvc_dirent.h"
#else
#include <dirent.h>
#include <unistd.h>
#endif
#include <ctype.h>


#ifdef _WIN32
#include "win32-glob.h"
#include "scandir.h"
typedef unsigned short mode_t;
#else
#include <glob.h>
#endif

#include <SDL.h>
#include <SDL_endian.h>

#include "main.h"
#include "decode.h"
#include "configuration.h"
#include "file.h"
#include "hostcall.h"
#include "m68000.h"
#include "memAlloc.h"
#include "misc.h"
#include "stMemory.h"
#include "screen.h"
#include "video.h"
#include "audio.h"
#include "input.h"
#include "fe2.h"

#include "../cpu/hatari-glue.h"

#ifdef _MSC_VER
//not #if defined(_WIN32) || defined(_WIN64) because we have strncasecmp in mingw
#define strncasecmp _strnicmp
#define strcasecmp _stricmp
#endif


//#define GEMDOS_VERBOSE
// uncomment the following line to debug filename lookups on hd
// #define FILE_DEBUG 1

#define ENABLE_SAVING 1            /* Turn on saving stuff */

// this conflicts with INVALID_HANDLE_VALUE
// but apparently isn't used?
// #define INVALID_HANDLE_VALUE -1

#ifndef MAX_PATH
#define MAX_PATH 256
#endif

/* GLOB_ONLYDIR is a GNU extension for the glob() function and not defined
 * on some systems. We should probably use something different for this
 * case, but at the moment it we simply define it as 0... */
#ifndef GLOB_ONLYDIR
//#warning GLOB_ONLYDIR was not defined.
#define GLOB_ONLYDIR 0
#endif


/* structure with all the drive-specific data for our emulated drives */
EMULATEDDRIVE emudrive;

typedef struct
{
  BOOL bUsed;
  FILE *FileHandle;
  char szActualName[MAX_PATH];   /* used by F_DATIME (0x57) */
} FILE_HANDLE;

typedef struct
{
  BOOL bUsed;
  int  nentries;                   /* number of entries in fs directory */
  int  centry;                     /* current entry # */
  struct dirent **found;           /* legal files */
  char path[MAX_PATH];             /* sfirst path */
} INTERNAL_DTA;

FILE_HANDLE  FileHandles[MAX_FILE_HANDLES];
INTERNAL_DTA InternalDTAs[MAX_DTAS_FILES];
int DTAIndex;                                 /* Circular index into above */
DTA *pDTA;                                    /* Our GEMDOS hard drive Disc Transfer Address structure */
unsigned char GemDOS_ConvertAttribute(mode_t mode);


/*-------------------------------------------------------*/
/*
  Routines to convert time and date to MSDOS format.
  Originally from the STonX emulator. (cheers!)
*/
unsigned short time2dos (time_t t)
{
	struct tm *x;
	x = localtime (&t);
	return (x->tm_sec>>1)|(x->tm_min<<5)|(x->tm_hour<<11);
}

unsigned short date2dos (time_t t)
{
	struct tm *x;
	x = localtime (&t);
	return x->tm_mday | ((x->tm_mon+1)<<5) | ( ((x->tm_year-80>0)?x->tm_year-80:0) << 9);
}


/*-----------------------------------------------------------------------*/
/*
  Populate a DATETIME structure with file info
*/
BOOL GetFileInformation(char *name, DATETIME *DateTime)
{
  struct stat filestat;
  int n;
  struct tm *x;

  n = stat(name, &filestat);
  if( n != 0 ) return(FALSE);
  x = localtime( &filestat.st_mtime );

  DateTime->word1 = 0;
  DateTime->word2 = 0;

  DateTime->word1 |= (x->tm_mday & 0x1F);         /* 5 bits */
  DateTime->word1 |= (x->tm_mon & 0x0F)<<5;       /* 4 bits */
  DateTime->word1 |= (((x->tm_year-80>0)?x->tm_year-80:0) & 0x7F)<<9;      /* 7 bits*/

  DateTime->word2 |= (x->tm_sec & 0x1F);          /* 5 bits */
  DateTime->word2 |= (x->tm_min & 0x3F)<<5;       /* 6 bits */
  DateTime->word2 |= (x->tm_hour & 0x1F)<<11;     /* 5 bits */

  return(TRUE);
}


/*-----------------------------------------------------------------------*/
/*
  Populate the DTA buffer with file info
*/
int PopulateDTA(char *path, struct dirent *file)
{
  char tempstr[MAX_PATH];
  struct stat filestat;
  int n;

  sprintf(tempstr, "%s/%s", path, file->d_name);
  n = stat(tempstr, &filestat);
  if(n != 0) return(FALSE); /* return on error */

  if(!pDTA) return(FALSE); /* no DTA pointer set */
  Misc_strupr(file->d_name);    /* convert to atari-style uppercase */
  strncpy(pDTA->dta_name,file->d_name,TOS_NAMELEN); /* FIXME: better handling of long file names */
  STMemory_WriteLong_PCSpace(pDTA->dta_size, (long)filestat.st_size);
  STMemory_WriteWord_PCSpace(pDTA->dta_time, time2dos(filestat.st_mtime));
  STMemory_WriteWord_PCSpace(pDTA->dta_date, date2dos(filestat.st_mtime));
  pDTA->dta_attrib = GemDOS_ConvertAttribute(filestat.st_mode);

  return(TRUE);
}


/*-----------------------------------------------------------------------*/
/*
  Clear a used DTA structure.
*/
void ClearInternalDTA(){
  int i;

  /* clear the old DTA structure */
  if(InternalDTAs[DTAIndex].found != NULL){
    for(i=0; i <InternalDTAs[DTAIndex].nentries; i++)
      free(InternalDTAs[DTAIndex].found[i]);
    free(InternalDTAs[DTAIndex].found);
  }
  InternalDTAs[DTAIndex].bUsed = FALSE;
}


/*-----------------------------------------------------------------------*/
/*
  Match a file to a dir mask.
*/
static int match (char *pat, char *name)
{
  /* make uppercase copies */
  char p0[MAX_PATH], n0[MAX_PATH];
  strcpy(p0, pat);
  strcpy(n0, name);
  Misc_strupr(p0);
  Misc_strupr(n0);

  if(name[0] == '.') return(FALSE);                   /* no .* files */
  if (strcmp(pat,"*.*")==0) return(TRUE);
  else if (strcasecmp(pat,name)==0) return(TRUE);
  else
    {
      char *p=p0,*n=n0;
      for(;*n;)
	{
	  if (*p=='*') {while (*n && *n != '.') n++;p++;}
	  else if (*p=='?' && *n) {n++;p++;}
	  else if (*p++ != *n++) return(FALSE);
	}
      if (*p==0)
	{
	  return(TRUE);
	}
    }
  return(FALSE);
}

/*-----------------------------------------------------------------------*/
/*
  Parse directory from sfirst mask
  - e.g.: input:  "hdemudir/auto/mask*.*" outputs: "hdemudir/auto"
*/
void fsfirst_dirname(char *string, char *new){
  int i=0;

  sprintf(new, string);
  /* convert to front slashes. */
  i=0;
  while(new[i] != '\0'){
    if(new[i] == '\\') new[i] = '/';
    i++;
  }
  while(string[i] != '\0'){new[i] = string[i]; i++;} /* find end of string */
  while(new[i] != '/') i--; /* find last slash */
  new[i] = '\0';

}

/*-----------------------------------------------------------------------*/
/*
  Parse directory mask, e.g. "*.*"
*/
void fsfirst_dirmask(char *string, char *new){
  int i=0, j=0;
  while(string[i] != '\0')i++;   /* go to end of string */
  while(string[i] != '/') i--;   /* find last slash */
  i++;
  while(string[i] != '\0')new[j++] = string[i++]; /* go to end of string */
  new[j++] = '\0';
}

/*-----------------------------------------------------------------------*/
/*
  Initialize GemDOS/PC file system
*/
void GemDOS_Init(void)
{
  int i;

  /* Clear handles structure */
  Memory_Clear(FileHandles, sizeof(FILE_HANDLE)*MAX_FILE_HANDLES);
  /* Clear DTAs */
  for(i=0; i<MAX_DTAS_FILES; i++)
  {
    InternalDTAs[i].bUsed = FALSE;
    InternalDTAs[i].nentries = 0;
    InternalDTAs[i].found = NULL;
  }
  DTAIndex = 0;
}

/*-----------------------------------------------------------------------*/
/*
  Reset GemDOS file system
*/
void GemDOS_Reset()
{
  int i;

  /* Init file handles table */
  for(i=0; i<MAX_FILE_HANDLES; i++)
  {
    /* Was file open? If so close it */
    if (FileHandles[i].bUsed)
      fclose(FileHandles[i].FileHandle);

    FileHandles[i].FileHandle = NULL;
    FileHandles[i].bUsed = FALSE;
  }

  for(i=0; i<MAX_DTAS_FILES; i++)
  {
    InternalDTAs[i].bUsed = FALSE;
    InternalDTAs[i].nentries = 0;
    InternalDTAs[i].found = NULL;
  }

  /* Reset */
  pDTA = NULL;
  DTAIndex = 0;
}


/*-----------------------------------------------------------------------*/
/*
  Initialize a GEMDOS drive.
  Only 1 emulated drive allowed, as of yet.
*/
void GemDOS_InitDrives()
{
    /* set emulation directory string */
    strcpy(emudrive.hd_emulation_dir, "./");

    /* remove trailing slash, if any in the directory name */
    File_CleanFileName(emudrive.hd_emulation_dir);

    emudrive.hd_letter = 2;
}


/*-----------------------------------------------------------------------*/
/*
  Un-init the GEMDOS drive
*/
void GemDOS_UnInitDrives()
{
  GemDOS_Reset();        /* Close all open files on emulated drive*/
}


/*-----------------------------------------------------------------------*/
/*
  Return free PC file handle table index, or -1 if error
*/
int GemDOS_FindFreeFileHandle(void)
{
  int i;

  /* Scan our file list for free slot */
  for(i=0; i<MAX_FILE_HANDLES; i++) {
    if (!FileHandles[i].bUsed)
      return(i);
  }

  /* Cannot open any more files, return error */
  return(-1);
}

/*-----------------------------------------------------------------------*/
/*
  Check ST handle is within our table range, return TRUE if not
*/
BOOL GemDOS_IsInvalidFileHandle(int Handle)
{
  BOOL bInvalidHandle=FALSE;

  /* Check handle was valid with our handle table */
  if ( (Handle<0) || (Handle>=MAX_FILE_HANDLES) )
    bInvalidHandle = TRUE;
  else if (!FileHandles[Handle].bUsed)
    bInvalidHandle = TRUE;

  return(bInvalidHandle);
}

int baselen(char *s) {
  /* Returns the length of the basename of the file passed in parameter
     (ie the file without extension) */
  char *ext = strchr(s,'.');
  if (ext) return ext-s;
  return strlen(s);
}

/*-----------------------------------------------------------------------*/
/*
  Use hard-drive directory, current ST directory and filename to create full path
*/
void GemDOS_CreateHardDriveFileName(int Drive,char *pszFileName,char *pszDestName)
{
  /*  int DirIndex = Misc_LimitInt(Drive-2, 0,ConfigureParams.HardDisc.nDriveList-1); */
  char *s,*start;

  if(pszFileName[0] == '\0') return; /* check for valid string */

  /* case full filename "C:\foo\bar" */
  s=pszDestName; start=NULL;

  if(pszFileName[1] == ':') {
    sprintf(pszDestName, "%s%s", emudrive.hd_emulation_dir, File_RemoveFileNameDrive(pszFileName));
  }
  /* case referenced from root:  "\foo\bar" */
  else if(pszFileName[0] == '\\'){
    sprintf(pszDestName, "%s%s", emudrive.hd_emulation_dir, pszFileName);
  }
  /* case referenced from current directory */
  else {
    sprintf(pszDestName, "%s%s",  emudrive.fs_currpath, pszFileName);
    start = pszDestName + strlen(emudrive.fs_currpath)-1;
  }

  /* convert to front slashes. */
  while((s = strchr(s+1,'\\'))) {
    if (!start) {
      start = s;
      continue;
    }
    {
      glob_t globbuf;
      char old1,old2,dest[256];
      int len,j,found,base_len;

      *start++ = '/';
      old1 = *start; *start++ = '*';
      old2 = *start; *start = 0;
      glob(pszDestName,GLOB_ONLYDIR,NULL,&globbuf);
      *start-- = old2; *start = old1;
      *s = 0;
      len = strlen(pszDestName);
      base_len = baselen(start);
      found = 0;
      for (j=0; j<globbuf.gl_pathc; j++) {
	/* If we search for a file of at least 8 characters, then it might
	   be a longer filename since the ST can access only the first 8
	   characters. If not, then it's a precise match (with case). */
	if (!(base_len < 8 ? strcasecmp(globbuf.gl_pathv[j],pszDestName) :
	      strncasecmp(globbuf.gl_pathv[j],pszDestName,len))) {
	  /* we found a matching name... */
	  sprintf(dest,"%s%c%s",globbuf.gl_pathv[j],'/',s+1);
	  strcpy(pszDestName,dest);
	  j = globbuf.gl_pathc;
	  found = 1;
	}
      }
      globfree(&globbuf);
      if (!found) {
	/* didn't find it. Let's try normal files (it might be a symlink) */
	*start++ = '*';
	*start = 0;
	glob(pszDestName,0,NULL,&globbuf);
	*start-- = old2; *start = old1;
	for (j=0; j<globbuf.gl_pathc; j++) {
	  if (!strncasecmp(globbuf.gl_pathv[j],pszDestName,len)) {
	    /* we found a matching name... */
	    sprintf(dest,"%s%c%s",globbuf.gl_pathv[j],'/',s+1);
	    strcpy(pszDestName,dest);
	    j = globbuf.gl_pathc;
	    found = 1;
	  }
	}
	globfree(&globbuf);
	if (!found) {           /* really nothing ! */
	  *s = '/';
	  fprintf(stderr,"no path for %s\n",pszDestName);
	}
      }
    }
    start = s;
  }

  if (!start) start = strrchr(pszDestName,'/'); // path already converted ?

  if (start) {
    *start++ = '/';     /* in case there was only 1 anti slash */
    if (*start && !strchr(start,'?') && !strchr(start,'*')) {
      /* We have a complete name after the path, not a wildcard */
      glob_t globbuf;
      char old1,old2;
      int len,j,found,base_len;

      old1 = *start; *start++ = '*';
      old2 = *start; *start = 0;
      glob(pszDestName,0,NULL,&globbuf);
      *start-- = old2; *start = old1;
      len = strlen(pszDestName);
      base_len = baselen(start);
      found = 0;
      for (j=0; j<globbuf.gl_pathc; j++) {
	/* If we search for a file of at least 8 characters, then it might
	   be a longer filename since the ST can access only the first 8
	   characters. If not, then it's a precise match (with case). */
	if (!(base_len < 8 ? strcasecmp(globbuf.gl_pathv[j],pszDestName) :
	      strncasecmp(globbuf.gl_pathv[j],pszDestName,len))) {
	  /* we found a matching name... */
	  strcpy(pszDestName,globbuf.gl_pathv[j]);
	  j = globbuf.gl_pathc;
	  found = 1;
	}
      }
#if FILE_DEBUG
      if (!found) {
	/* It's often normal, the gem uses this to test for existence */
	/* of desktop.inf or newdesk.inf for example. */
	fprintf(stderr,"didn't find filename %s\n",pszDestName);
      }
#endif
      globfree(&globbuf);
    }
  }

#if FILE_DEBUG
 fprintf(stderr,"conv %s -> %s\n",pszFileName,pszDestName);
#endif
}

/*-----------------------------------------------------------------------*/
/*
  Covert from FindFirstFile/FindNextFile attribute to GemDOS format
*/
unsigned char GemDOS_ConvertAttribute(mode_t mode)
{
  unsigned char Attrib=0;

  /* FIXME: More attributes */
  if(S_ISDIR(mode)) Attrib |= GEMDOS_FILE_ATTRIB_SUBDIRECTORY;

/* FIXME */
/*
  // Look up attributes
  if (dwFileAttributes&FILE_ATTRIBUTE_READONLY)
    Attrib |= GEMDOS_FILE_ATTRIB_READONLY;
  if (dwFileAttributes&FILE_ATTRIBUTE_HIDDEN)
    Attrib |= GEMDOS_FILE_ATTRIB_HIDDEN;
  if (dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY)
    Attrib |= GEMDOS_FILE_ATTRIB_SUBDIRECTORY;
*/
  return(Attrib);
}


/*-----------------------------------------------------------------------*/
/*
  GEMDOS Set Disc Transfer Address (DTA)
  Call 0x1A
*/
void GemDOS_SetDTA(unsigned long Params)
{
  /* Look up on stack to find where DTA is! Store as PC pointer */
  pDTA = (DTA *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD));
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Create file
  Call 0x3C
*/
void GemDOS_Create(unsigned long Params)
{
  char szActualFileName[MAX_PATH];
  char *pszFileName;
  char *rwflags[] = { "w+", /* read / write (truncate if exists) */
		      "wb"  /* write only */
  };
  int Drive,Index,Mode;

  /* Find filename */
  pszFileName = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD));
  Mode = STMemory_ReadWord(Params+SIZE_WORD+SIZE_LONG);
  Drive = 2;
    /* And convert to hard drive filename */
    GemDOS_CreateHardDriveFileName(Drive,pszFileName,szActualFileName);

    /* Find slot to store file handle, as need to return WORD handle for ST */
    Index = GemDOS_FindFreeFileHandle();
    if (Index==-1) {
      /* No free handles, return error code */
      Regs[REG_D0] = GEMDOS_ENHNDL;       /* No more handles */
      return;
    }
    else {
#ifdef ENABLE_SAVING

      FileHandles[Index].FileHandle = fopen(szActualFileName, rwflags[Mode&0x01]);

      if (FileHandles[Index].FileHandle != NULL) {
        /* Tag handle table entry as used and return handle */
        FileHandles[Index].bUsed = TRUE;
        Regs[REG_D0] = Index+BASE_FILEHANDLE;  /* Return valid ST file handle from range 6 to 45! (ours start from 0) */
        return;
      }
      else {
        Regs[REG_D0] = GEMDOS_EFILNF;     /* File not found */
        return;
      }
#else
      Regs[REG_D0] = GEMDOS_EFILNF;       /* File not found */
      return;
#endif
    }
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Open file
  Call 0x3D
*/
void GemDOS_Open(unsigned long Params)
{
  char szActualFileName[MAX_PATH];
  char *pszFileName;
  char *open_modes[] = { "rb", "wb", "r+" };  /* convert atari modes to stdio modes */
  int Drive,Index,Mode;

  /* Find filename */
  pszFileName = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD));
  Mode = STMemory_ReadWord(Params+SIZE_WORD+SIZE_LONG);
  Drive = 2;

    /* And convert to hard drive filename */
    GemDOS_CreateHardDriveFileName(Drive,pszFileName,szActualFileName);
    /* Find slot to store file handle, as need to return WORD handle for ST  */
    Index = GemDOS_FindFreeFileHandle();
    if (Index == -1) {
      /* No free handles, return error code */
      Regs[REG_D0] = GEMDOS_ENHNDL;       /* No more handles */
      return;
    }

    /* Open file */
    FileHandles[Index].FileHandle =  fopen(szActualFileName, open_modes[Mode&0x03]);

    sprintf(FileHandles[Index].szActualName,"%s",szActualFileName);

    if (FileHandles[Index].FileHandle != NULL) {
      /* Tag handle table entry as used and return handle */
      FileHandles[Index].bUsed = TRUE;
      Regs[REG_D0] = Index+BASE_FILEHANDLE;  /* Return valid ST file handle from range 6 to 45! (ours start from 0) */
      return;
    }
    Regs[REG_D0] = GEMDOS_EFILNF;     /* File not found/ error opening */
    return;
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Close file
  Call 0x3E
*/
void GemDOS_Close(unsigned long Params)
{
  int Handle;

  /* Find our handle - may belong to TOS */
  Handle = STMemory_ReadWord(Params+SIZE_WORD)-BASE_FILEHANDLE;

  /* Check handle was valid */
  if (GemDOS_IsInvalidFileHandle(Handle)) {
    /* No assume was TOS */
    return;
  }
  else {
    /* Close file and free up handle table */
    fclose(FileHandles[Handle].FileHandle);
    FileHandles[Handle].bUsed = FALSE;
    /* Return no error */
    Regs[REG_D0] = GEMDOS_EOK;
    return;
  }
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Read file
  Call 0x3F
*/
void GemDOS_Read(unsigned long Params)
{
  char *pBuffer;
  unsigned long nBytesRead,Size,CurrentPos,FileSize;
  long nBytesLeft;
  int Handle;

  /* Read details from stack */
  Handle = STMemory_ReadWord(Params+SIZE_WORD)-BASE_FILEHANDLE;
  Size = STMemory_ReadLong(Params+SIZE_WORD+SIZE_WORD);
  pBuffer = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD+SIZE_WORD+SIZE_LONG));

  /* Check handle was valid */
  if (GemDOS_IsInvalidFileHandle(Handle)) {
    /* No -  assume was TOS */
    return;
  }
  else {

    /* To quick check to see where our file pointer is and how large the file is */
    CurrentPos = ftell(FileHandles[Handle].FileHandle);
    fseek(FileHandles[Handle].FileHandle, 0, SEEK_END);
    FileSize = ftell(FileHandles[Handle].FileHandle);
    fseek(FileHandles[Handle].FileHandle, CurrentPos, SEEK_SET);

    nBytesLeft = FileSize-CurrentPos;

    /* Check for End Of File */
    if (nBytesLeft == 0) {
      /* FIXME: should we return zero (bytes read) or an error? */
       Regs[REG_D0] = 0;
      return;
    }
    else {
      /* Limit to size of file to prevent windows error */
      if (Size>FileSize)
        Size = FileSize;
      /* And read data in */
      nBytesRead = fread(pBuffer, 1, Size, FileHandles[Handle].FileHandle);

      /* Return number of bytes read */
      Regs[REG_D0] = nBytesRead;

      return;
    }
  }
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Write file
  Call 0x40
*/
void GemDOS_Write(unsigned long Params)
{
  char *pBuffer;
  unsigned long Size,nBytesWritten;
  int Handle;

#ifdef ENABLE_SAVING
  /* Read details from stack */
  Handle = STMemory_ReadWord(Params+SIZE_WORD)-BASE_FILEHANDLE;
  Size = STMemory_ReadLong(Params+SIZE_WORD+SIZE_WORD);
  pBuffer = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD+SIZE_WORD+SIZE_LONG));

  /* Check handle was valid */
  if (GemDOS_IsInvalidFileHandle(Handle)) {
    /* No assume was TOS */
    return;
  }
  else {

    nBytesWritten = fwrite(pBuffer, 1, Size, FileHandles[Handle].FileHandle);
    if (nBytesWritten>=0) {

      Regs[REG_D0] = nBytesWritten;      /* OK */
    }
    else
      Regs[REG_D0] = GEMDOS_EACCDN;      /* Access denied(ie read-only) */

    return;
  }
#endif

  return;
}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS UnLink(Delete) file
  Call 0x41
*/
void GemDOS_UnLink(unsigned long Params)
{
#ifdef ENABLE_SAVING
  char szActualFileName[MAX_PATH];
  char *pszFileName;
  int Drive;

  /* Find filename */
  pszFileName = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD));
  Drive = 2;
    /* And convert to hard drive filename */
    GemDOS_CreateHardDriveFileName(Drive,pszFileName,szActualFileName);

    /* Now delete file?? */
    if ( unlink(szActualFileName)==0 )
      Regs[REG_D0] = GEMDOS_EOK;          /* OK */
    else
      Regs[REG_D0] = GEMDOS_EFILNF;       /* File not found */

    return;
#endif

}

/*-----------------------------------------------------------------------*/
/*
  GEMDOS Search Next
  Call 0x4F
*/
void GemDOS_SNext(unsigned long Params)
{
  struct dirent **temp;
  int Index;

  /* Was DTA ours or TOS? */
  if (STMemory_ReadLong_PCSpace(pDTA->magic)==DTA_MAGIC_NUMBER) {

    /* Find index into our list of structures */
    Index = STMemory_ReadWord_PCSpace(pDTA->index)&(MAX_DTAS_FILES-1);

    if(InternalDTAs[Index].centry >= InternalDTAs[Index].nentries){
      Regs[REG_D0] = GEMDOS_ENMFIL;    /* No more files */
      return;
    }

    temp = InternalDTAs[Index].found;
    if(PopulateDTA(InternalDTAs[Index].path, temp[InternalDTAs[Index].centry++]) == FALSE){
      fprintf(stderr,"\tError setting DTA.\n");
      return;
    }

    Regs[REG_D0] = GEMDOS_EOK;
    return;
  }

  return;
}


/*-----------------------------------------------------------------------*/
/*
  GEMDOS Find first file
  Call 0x4E
*/
void GemDOS_SFirst(unsigned long Params)
{
  char szActualFileName[MAX_PATH];
  char tempstr[MAX_PATH];
  char *pszFileName;
  struct dirent **files;
  unsigned short int Attr;
  int Drive;
  DIR *fsdir;
  int i,j,k;

  /* Find filename to search for */
  pszFileName = (char *)STRAM_ADDR(STMemory_ReadLong(Params+SIZE_WORD));
  Attr = STMemory_ReadWord(Params+SIZE_WORD+SIZE_LONG);

  Drive = 2;

    /* And convert to hard drive filename */
    GemDOS_CreateHardDriveFileName(Drive,pszFileName,szActualFileName);

    /* Populate DTA, set index for our use */
    STMemory_WriteWord_PCSpace(pDTA->index,DTAIndex);
    STMemory_WriteLong_PCSpace(pDTA->magic,DTA_MAGIC_NUMBER); /* set our dta magic num */

    if(InternalDTAs[DTAIndex].bUsed == TRUE) ClearInternalDTA();
    InternalDTAs[DTAIndex].bUsed = TRUE;

    /* Were we looking for the volume label? */
    if (Attr&GEMDOS_FILE_ATTRIB_VOLUME_LABEL) {
      /* Volume name */
      strcpy(pDTA->dta_name,"EMULATED.001");
      Regs[REG_D0] = GEMDOS_EOK;          /* Got volume */
      return;
    }

    /* open directory */
    fsfirst_dirname(szActualFileName, InternalDTAs[DTAIndex].path);
    fsdir = opendir(InternalDTAs[DTAIndex].path);

    if( fsdir == NULL ){
      Regs[REG_D0] = GEMDOS_EPTHNF;        /* Path not found */
      return;
    }
    /* close directory */
    closedir( fsdir );

    InternalDTAs[DTAIndex].nentries = scandir(InternalDTAs[DTAIndex].path, &files, 0, alphasort);
//fprintf(stderr,"hostcall.c using scandir without alphasort...!\n");
//    InternalDTAs[DTAIndex].nentries = scandir(InternalDTAs[DTAIndex].path, &files, 0, 0);
    if( InternalDTAs[DTAIndex].nentries < 0 ){
      Regs[REG_D0] = GEMDOS_EFILNF;        /* File (directory actually) not found */
      return;
    }

    InternalDTAs[DTAIndex].centry = 0;        /* current entry is 0 */
    fsfirst_dirmask(szActualFileName, tempstr); /* get directory mask */

    /* Create and populate a list of matching files. */

    j = 0;                     /* count number of entries matching mask */
    for(i=0;i<InternalDTAs[DTAIndex].nentries;i++)
      if(match(tempstr, files[i]->d_name)) j++;

    if (j==0) {
      return;
    }

    InternalDTAs[DTAIndex].found = (struct dirent **)malloc(sizeof(struct dirent *) * j);

    /* copy the dirent pointers for files matching the mask to our list */
    k = 0;
    for(i=0;i<InternalDTAs[DTAIndex].nentries;i++)
      if(match(tempstr, files[i]->d_name)){
	InternalDTAs[DTAIndex].found[k] = files[i];
	k++;
      }

    InternalDTAs[DTAIndex].nentries = j; /* set number of legal entries */

    if(InternalDTAs[DTAIndex].nentries == 0){
      /* No files of that match, return error code */
      Regs[REG_D0] = GEMDOS_EFILNF;        /* File not found */
      return;
    }

    /* Scan for first file (SNext uses no parameters) */
    GemDOS_SNext(0);
    /* increment DTA index */
    DTAIndex++;
    DTAIndex&=(MAX_DTAS_FILES-1);

    return;
}


void Call_Memset (unsigned long Params)
{
	int adr, count;
	count = STMemory_ReadLong (Params+SIZE_WORD);
	adr = STMemory_ReadLong (Params+SIZE_WORD+SIZE_LONG);
	memset (STRam+adr, 0, count);
}

void Call_MemsetBlue (unsigned long Params)
{
	int adr, count;
	count = STMemory_ReadLong (Params+SIZE_WORD);
	adr = STMemory_ReadLong (Params+SIZE_WORD+SIZE_LONG);
	memset (STRam+adr, 0xe, count);
}

void Call_Memcpy (unsigned long Params)
{
	int dest, src, count;

	dest = STMemory_ReadLong (Params + SIZE_WORD);
	src = STMemory_ReadLong (Params + SIZE_WORD + SIZE_LONG);
	count = STMemory_ReadLong (Params + SIZE_WORD + 2*SIZE_LONG);

	memcpy (STRam+dest, STRam+src, count);
}

static const char mouse_bmp[256] = {
 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0,15, 0,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 0, 0,-1, 0,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1, 0,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1, 0,15,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1, 0,15,15,15, 0,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1, 0,15, 0,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
};

Uint8 under_mouse[256];

void Call_BlitCursor (unsigned long Params)
{
	int x, y, adr, org_x, org_y;
	Uint8 *pixbase, *pix;
	const char *bmp;
	Uint8 *save;
	org_x = STMemory_ReadLong (Params+SIZE_WORD);
	org_y = STMemory_ReadLong (Params+SIZE_WORD+SIZE_LONG);
	adr = STMemory_ReadLong (Params+SIZE_WORD+2*SIZE_LONG);

	pixbase = STRam + adr + (org_y*SCREENBYTES_LINE) + org_x;
	bmp = mouse_bmp;
	save = under_mouse;

	for (y=0; y<16; y++) {
		if (y + org_y > SCREEN_HEIGHT_HBL) break;
		pix = pixbase;
		pixbase += SCREENBYTES_LINE;
		for (x=0; x<16; x++, pix++, bmp++, save++) {
			if (x+org_x >= SCREENBYTES_LINE) continue;
			*save = *pix;
			if (*bmp != -1) *pix = *bmp;
		}
	}
}

void Call_RestoreUnderCursor (unsigned long Params)
{
	int x, y, adr, org_x, org_y;
	Uint8 *pixbase, *pix;
	char *bmp;
	org_x = STMemory_ReadLong (Params+SIZE_WORD);
	org_y = STMemory_ReadLong (Params+SIZE_WORD+SIZE_LONG);
	adr = STMemory_ReadLong (Params+SIZE_WORD+2*SIZE_LONG);

	pixbase = STRam + adr + (org_y*SCREENBYTES_LINE) + org_x;
	bmp = under_mouse;

	for (y=0; y<16; y++) {
		if (y + org_y > SCREEN_HEIGHT_HBL) break;
		pix = pixbase;
		pixbase += SCREENBYTES_LINE;
		for (x=0; x<16; x++, pix++, bmp++) {
			if (x+org_x >= SCREENBYTES_LINE) continue;
			if (*bmp != -1) *pix = *bmp;
		}
	}
}

void Call_PutPix (unsigned long Params)
{
	int col, org_x, scr;
	char *pix;
	col = STMemory_ReadWord (Params+SIZE_WORD)>>2;
	org_x = Regs[REG_D4] & 0xffff;
	scr = Regs[REG_A3];

	/* hack to fix screen line. frontier's logic still thinks
	 * there are 160 bytes per line */
	/* which screen buffer it is based on */
	if (scr & 0x100000) {
		scr -= 0x100000;
		scr *= 2;
		scr += 0x100000;
	} else {
		scr -= 0xf0000;
		scr *= 2;
		scr += 0xf0000;
	}
	pix = (char *)STRam + scr + org_x;
	*pix = col;
	return;
}

void Call_FillLine (unsigned long Params)
{
	int org_x,len,scr,col;
	char *pix;

	col = STMemory_ReadWord (Params+SIZE_WORD)>>2;
	org_x = Regs[REG_D4] & 0xffff;
	len = (~Regs[REG_D5]) & 0xffff;
	scr = Regs[REG_A3];
	
	/* hack to fix screen line. frontier's logic still thinks
	 * there are 160 bytes per line */
	/* which screen buffer it is based on */
	if (scr & 0x100000) {
		scr -= 0x100000;
		scr *= 2;
		scr += 0x100000;
	} else {
		scr -= 0xf0000;
		scr *= 2;
		scr += 0xf0000;
	}
	pix = (char *)STRam + scr;
	org_x = SCREENBYTES_LINE;
	while (org_x--) {
		*pix = col;
		pix++;
	}
}

/*
 * This is used by the scanner code to draw object stalks
 * which are below the plane of the scanner.
 * The mask d7 indicates which pixels in the plane to set,
 * and they are set if their current colour is zero.
 *
 * This implementation isn't the way the function is really
 * supposed to be implemented (colour and draw mask was
 * combined in d6 but the colour mask is wrong now for
 * non-planar screen).
 */
void Call_BackHLine (unsigned long Params)
{
	int i,scr,col,bitfield;
	char *pix;

	col = STMemory_ReadWord (Params+SIZE_WORD)>>2;
	scr = Regs[REG_A3];
	bitfield = Regs[REG_D7] & 0xffff;
	
	/* hack to fix screen line. frontier's logic still thinks
	 * there are 160 bytes per line */
	/* which screen buffer it is based on */
	if (scr & 0x100000) {
		scr -= 0x100000;
		scr *= 2;
		scr += 0x100000;
	} else {
		scr -= 0xf0000;
		scr *= 2;
		scr += 0xf0000;
	}
	pix = STRam + scr;
	for (i=15; i>=0; i--) {
		if ((bitfield & (1<<i)) && (*pix == 0)) *pix = col;
		pix++;
	}
}

void Call_OldHLine (unsigned long Params)
{
	int org_x,len,scr,col;
	char *pix;

	col = STMemory_ReadWord (Params+SIZE_WORD)>>2;
	//printf ("col=%d, d4=%d, (idx) d5=%d, (scr_line) a3=%p\n", col, Regs[REG_D4]&0xffff, Regs[REG_D5]&0xffff, (void*)Regs[REG_A3]);
	org_x = Regs[REG_D4] & 0xffff;
	len = Regs[REG_D5] & 0xffff;
	scr = Regs[REG_A3];
	
	/* hack to fix screen line. frontier's logic still thinks
	 * there are 160 bytes per line */
	/* which screen buffer it is based on */
	if (scr & 0x100000) {
		scr -= 0x100000;
		scr *= 2;
		scr += 0x100000;
	} else {
		scr -= 0xf0000;
		scr *= 2;
		scr += 0xf0000;
	}
	len = len/2;
	/* horizontal line */
	pix = STRam + scr + org_x;
	while (len--) {
		*pix = col;
		pix++;
	}
}

void Call_HLine (unsigned long Params)
{
	int org_x,len,scr,col;
	char *pix;

	col = (Regs[REG_D1] & 0xffff)>>2;
	org_x = Regs[REG_D4] & 0xffff;
	len = Regs[REG_D5] & 0xffff;
	scr = Regs[REG_A3];
	
	/* horizontal line */
	pix = STRam + scr + org_x;
	while (len--) {
		*pix = col;
		pix++;
	}
}

/*
 * Blits frontier format 4-plane thingy
 */
void Call_BlitBmp (unsigned long Params)
{
	int width, height, org_x, org_y, bmp, scr;
	char *bmp_pix, *scr_pix, *ybase;
	int xpoo, i, ypoo, plane_incr;
	
	short word0, word1, word2, word3;
	
	width = STMemory_ReadWord (Params+SIZE_WORD);
	height = STMemory_ReadWord (Params+SIZE_WORD*2);
	org_x = STMemory_ReadWord (Params+SIZE_WORD*3);
	org_y = STMemory_ReadWord (Params+SIZE_WORD*4);
	bmp = STMemory_ReadLong (Params+SIZE_WORD*5);
	scr = STMemory_ReadLong (Params+SIZE_WORD*5 + SIZE_LONG);

	/* width is in words (width/16) */
	//printf ("Blit %dx%d to %d,%d, bmp 0x%x, scr 0x%x.\n", width, height, org_x, org_y, bmp, scr);
	bmp_pix = STRam + bmp + 4;
	ybase = STRam + scr + (org_y*SCREENBYTES_LINE) + org_x;

	/* These checks were in the original blit routine */
	if (org_x < 0) return;
	if (org_y < 0) return;
	if (height > 200) return;
	if (width > 320) return;
	
	plane_incr = 2*height*width;
	
	ypoo = height;
	while (ypoo--) {
		scr_pix = (char *)ybase;
		ybase += SCREENBYTES_LINE;
		for (xpoo = width; xpoo; xpoo--) {
			word0 = SDL_SwapBE16 (*((short*)bmp_pix));
			bmp_pix += plane_incr;
			word1 = SDL_SwapBE16 (*((short*)bmp_pix));
			bmp_pix += plane_incr;
			word2 = SDL_SwapBE16 (*((short*)bmp_pix));
			bmp_pix += plane_incr;
			word3 = SDL_SwapBE16 (*((short*)bmp_pix));
			
			for (i=0; i<16; i++) {
				*scr_pix = (word0 >> (15-i))&0x1;
				*scr_pix |= ((word1 >> (15-i))&0x1)<<1;
				*scr_pix |= ((word2 >> (15-i))&0x1)<<2;
				*scr_pix |= ((word3 >> (15-i))&0x1)<<3;
				scr_pix++;
			}
			bmp_pix -= 3*plane_incr;
			bmp_pix += 2;
		}
	}
}

#define SCR_W	320

void Call_DrawStrShadowed (Params)
{
	unsigned char *str;
	
	str = Regs[REG_A0] + STRam;

	Regs[REG_D1] = DrawStr (
			Regs[REG_D1], Regs[REG_D2],
			Regs[REG_D0], str, TRUE);
}

void Call_DrawStr (Params)
{
	unsigned char *str;
	
	str = Regs[REG_A0] + STRam;

	Regs[REG_D1] = DrawStr (
			Regs[REG_D1], Regs[REG_D2],
			Regs[REG_D0], str, FALSE);
}

void Call_SetMainPalette (unsigned long Params)
{
	Uint32 pal_ptr;
	int i;
	
	pal_ptr = STMemory_ReadLong (Params+SIZE_WORD);
	
	for (i=0; i<16; i++) {
		MainPalette[i] = STMemory_ReadWord (pal_ptr);
		//printf ("%hx ", MainPalette[i]);
		pal_ptr+=2;
	}
	//printf ("\n");
}

void Call_SetCtrlPalette (unsigned long Params)
{
	Uint32 pal_ptr;
	int i;
	
	pal_ptr = STMemory_ReadLong (Params+SIZE_WORD);
	
	for (i=0; i<16; i++) {
		CtrlPalette[i] = STMemory_ReadWord (pal_ptr);
		pal_ptr+=2;
	}
}

int len_working_ext_pal;
unsigned short working_ext_pal[240];

void Call_InformScreens (unsigned long Params)
{
	physcreen2 = STMemory_ReadLong (Params+SIZE_WORD);
	logscreen2 = STMemory_ReadLong (Params+SIZE_WORD+SIZE_LONG);
	physcreen = STMemory_ReadLong (Params+SIZE_WORD+2*SIZE_LONG);
	logscreen = STMemory_ReadLong (Params+SIZE_WORD+3*SIZE_LONG);
}

/* also copies the extended palette into main palette */
void Call_SetScreenBase (unsigned long Params)
{
	int i;
	VideoBase = STMemory_ReadLong (Params+SIZE_WORD);
	VideoRaster = STRam + VideoBase;

	for (i=0; i<len_working_ext_pal; i++) {
		MainPalette[16+i] = working_ext_pal[i];
	}
	len_main_palette = 16 + len_working_ext_pal;
}

void Call_MakeExtPalette (unsigned long Params)
{
	int col_list, len, col_idx, col_val, i;

	col_list = STMemory_ReadLong (Params+SIZE_WORD);

	len = STMemory_ReadWord (col_list) >> 2;
	len_working_ext_pal = len;
	col_list+=2;
	//printf ("%d colours.\n", len+2);
	for (i=0; i<len; i++) {
		col_val = STMemory_ReadWord (col_list);
		working_ext_pal[i] = col_val;
		col_list += 2;
		col_idx = STMemory_ReadWord (col_list);
		/* offset dynamic colours into extended palette
		 * range (colours 16+) */
		col_idx += 16<<2;
		STMemory_WriteWord (col_list, col_idx);
		col_list += 2;
	}
}

void Call_DumpRegs (unsigned long Params)
{
	printf ("0x%x d0.l=%d ", m68k_getpc(), Regs[REG_D0]);
	printf ("d1.l=%d ", Regs[REG_D1]);
	printf ("d2.l=%d ", Regs[REG_D2]);
	printf ("d3.l=%d ", Regs[REG_D3]);
	printf ("d4.l=%d ", Regs[REG_D4]);
	printf ("d5.l=%d ", Regs[REG_D5]);
	printf ("d6.l=%d ", Regs[REG_D6]);
	printf ("d7.l=%d ", Regs[REG_D7]);
	printf ("\n");
}

void Call_NotifyOfScrFlip (unsigned long Params)
{
	bScreenContentsChanged = TRUE;
}

/* mouse pos in d3,d4 */
void Call_NotifyMousePos (unsigned long Params)
{
#if 0
	int x, y;
	
	x = Regs[REG_D3] & 0xffff;
	y = Regs[REG_D4] & 0xffff;

	x *= ScreenDraw.MouseScale;
	y *= ScreenDraw.MouseScale;
	
	SDL_EventState (SDL_MOUSEMOTION, SDL_DISABLE);
	SDL_WarpMouse (x, y);
	SDL_EventState (SDL_MOUSEMOTION, SDL_ENABLE);
	SDL_ShowCursor (SDL_ENABLE);	
#endif /* 0 */
}

void Call_DrawQuad (unsigned long Params)
{
	int high, i, j;
	struct Point pts[4];

	pts[0].x = Regs[REG_D0];
	pts[0].y = Regs[REG_D1];
	pts[1].x = Regs[REG_D2];
	pts[1].y = Regs[REG_D3];
	pts[2].x = Regs[REG_D4];
	pts[2].y = Regs[REG_D5];
	pts[3].x = Regs[REG_D6];
	pts[3].y = Regs[REG_D7];
	
	/* the two points with highest y actually seem to be
	 * drawn only to y-1 by the frontier routines. weird. */
	for (i=0; i<4; i++) {
		high = 0;
		for (j=0; j<4; j++) {
			if (pts[i].y > pts[j].y) high++;
		}
		if (high >= 2) pts[i].y--;
	}
	DrawPoly (pts, 4, Regs[REG_A0]/4);
}

void Call_DrawTriangle (unsigned long Params)
{
	DrawTriangle (Regs[REG_D0], Regs[REG_D1],
			Regs[REG_D2], Regs[REG_D3],
			Regs[REG_D4], Regs[REG_D5],
			Regs[REG_A0]/4);
}

void Call_L35ea2 (unsigned long Params)
{
	int d0,d1,d2,max;

	d0 = Regs[REG_D0];
	d1 = Regs[REG_D1];
	d2 = Regs[REG_D2];

	max = (d0 > d1 ? d0 : d1);
	
	if (d2 == 0) {
		printf ("Eeek. zero divide (for real)\n");
		Regs[REG_D0] = 0;
		Regs[REG_D1] = 0;
		return;
	}

		if ((d0 >= (1<<16)) || (d0 <= ((-1)<<16))) {
			Regs[REG_D0] = d0/(d2>>8);
		} else {
			Regs[REG_D0] = (d0<<8)/d2;
		}
		if ((d1 >= (1<<16)) || (d1 <= ((-1)<<16))) {
			Regs[REG_D1] = d1/(d2>>8);
		} else {
			Regs[REG_D1] = (d1<<8)/d2;
		}
	/* with d2=0x2000 the 1st BP  is 0x3e000 */
	/* with d2=0x4000 the 1st BP  is 0x7c010 */
	/* with d2=0x8000 the 1st BP  is 0xf8000 */
	/* with d2=0x10000 the 1st BP is 0x1f0040 */
	/* next cunt point at > 0xf803f */
	//printf ("%d, %d, %d = %d, %d\n", d0, d1, d2, Regs[REG_D0], Regs[REG_D1]);
}

typedef void (*HOSTCALL) (unsigned long);

HOSTCALL hostcalls [] = {
	NULL,
	&Call_Memset,		/* 0x1 */
	&Call_MemsetBlue,		/* 0x2 */
	&Call_BlitCursor,		/* 0x3 */
	&Call_RestoreUnderCursor,	/* 0x4 */
	&Call_BlitBmp,		/* 0x5 */
	&Call_OldHLine,		/* 0x6 */
	NULL,		/* 0x7 */
	&Call_Memcpy,		/* 0x8 */
	&Call_PutPix,		/* 0x9 */
	&Call_BackHLine,		/* 0xa */
	&Call_FillLine,		/* 0xb */
	&Call_SetMainPalette,	/* 0xc */
	&Call_SetCtrlPalette,	/* 0xd */
	&Call_SetScreenBase,		/* 0xe */
	&Screen_Draw,			/* 0xf */
	&Call_DumpRegs,		/* 0x10 */
	&Call_MakeExtPalette,	/* 0x11 */
	&Call_PlaySFX,			/* 0x12 */
	&Call_GetMouseInput,		/* 0x13 */
	&Call_GetKeyboardEvent,		/* 0x14 */
	&Call_L35ea2,			/* 0x15 */
	&Call_HLine,			/* 0x16 */
	&Call_NotifyOfScrFlip,		/* 0x17 */
	&Call_NotifyMousePos,		/* 0x18 */
	&Call_InformScreens,		/* 0x19 */
	&GemDOS_SetDTA,
	&Call_DrawStrShadowed,		/* 0x1b */
	&Call_DrawStr,			/* 0x1c */
	&Call_DrawTriangle,		/* 0x1d */
	&Call_DrawQuad,			/* 0x1e */
	NULL,
	NULL,				/* 0x20 */
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,				/* 0x30 */
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	&GemDOS_Create,
	&GemDOS_Open,
	&GemDOS_Close,
	&GemDOS_Read,
	&GemDOS_Write,			/* 0x40 */
	&GemDOS_UnLink,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	&GemDOS_SFirst,
	&GemDOS_SNext,
	NULL,				/* 0x50 */
};

/*
 * Yay. Calling a C function from the 68k emu.
 */
unsigned long HostCall_OpCode (uae_u32 opcode)
{
	unsigned short int GemDOSCall;
	unsigned long Params;
	
	Params = Regs[REG_A7];
	
	GemDOSCall = STMemory_ReadWord(Params);
	
	(*hostcalls [GemDOSCall]) (Params);
	
	m68k_incpc (2);
	fill_prefetch_0 ();
	return 4;
}

/*
 * Faster hostcall, which takes opcode as immediate
 * 16-bit value, rather than on stack.
 */
unsigned long HCall_OpCode (uae_u32 opcode)
{
	unsigned short int call_idx;
	unsigned long Params;
	
	Params = Regs[REG_A7];
	Params -= SIZE_WORD;
	
	m68k_incpc (2);
	call_idx = STMemory_ReadWord(m68k_getpc());
	
	(hostcalls [call_idx]) (Params);
	
	m68k_incpc (2);
	fill_prefetch_0 ();
	return 4;
}

