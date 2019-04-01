/* 
 * scandir() for win32 
 * this tool should make life easier for people writing for both unix 
and wintel 
 * written by Tom Torfs, 2002/10/31 
 * donated to the public domain; use this code for anything you like 
as long as 
 * it is understood there are absolutely *NO* warranties of any kind, 
even implied 
 */ 
#ifndef _WIN32 
#error scandir() for win32 can only be compiled for win32 
#endif 
#include "scandir.h" 
#include <windows.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
int scandir(const char *dirname, 
            struct dirent ***namelist, 
            int (*select)(const struct dirent *), 
            int (*compar)(const struct dirent **, 
                          const struct dirent **)) 
{ 
        WIN32_FIND_DATA wfd; 
        HANDLE hf; 
        struct dirent **plist, **newlist; 
        struct dirent d; 
        int numentries = 0; 
        int allocentries = 255; 
        int i; 
        char path[FILENAME_MAX]; 
        i = strlen(dirname); 
        if (i > sizeof path - 5) 
                return -1; 
    strcpy(path, dirname); 
        if (i>0 && dirname[i-1]!='\\' && dirname[i-1]!='/') 
                strcat(path, "\\"); 
        strcat(path, "*.*"); 
        hf = FindFirstFile(path, &wfd); 
        if (hf == INVALID_HANDLE_VALUE) 
                return -1; 
    plist = malloc(sizeof *plist * allocentries); 
        if (plist==NULL) 
        { 
                FindClose(hf); 
                return -1; 
        } 
    do 
        { 
                if (numentries==allocentries) 
                { 
                        allocentries *= 2; 
                        newlist = realloc(plist, sizeof *plist * allocentries); 
                        if (newlist==NULL) 
                        { 
                            for (i=0; i<numentries; i++) 
                                   free(plist[i]); 
                            free(plist); 
                            FindClose(hf); 
                            return -1; 
                        } 
                        plist = newlist; 
                } 
                strncpy(d.d_name, wfd.cFileName, sizeof d.d_name); 
                d.d_ino = 0; 
                d.d_namlen = strlen(wfd.cFileName); 
                d.d_reclen = sizeof d; 
                if (select==NULL || select(&d)) 
                { 
                   plist[numentries] = malloc(sizeof d); 
                   if (plist[numentries]==NULL) 
                   { 
                       for (i=0; i<numentries; i++) 
                                  free(plist[i]); 
                           free(plist); 
                           FindClose(hf); 
                           return -1; 
                   }; 
                   memcpy(plist[numentries], &d, sizeof d); 
                   numentries++; 
                } 
        } 
        while (FindNextFile(hf, &wfd)); 
        FindClose(hf); 
    if (numentries==0) 
        { 
                free(plist); 
                *namelist = NULL; 
        } 
        else 
        { 
                newlist = realloc(plist, sizeof *plist * numentries); 
                if (newlist!=NULL) 
                        plist = newlist; 
                if (compar!=NULL) 
                        qsort(plist, numentries, sizeof *plist, compar); 
                *namelist = plist; 
        } 
        return numentries; 
} 

int alphasort(const struct dirent **d1, 
              const struct dirent **d2) 
{ 
   return istrcmp((*d1)->d_name, (*d2)->d_name); 
} 

int istrcmp(const char *s1, const char *s2) 
{ 
        int d; 
        for (;;) 
        { 
           d = tolower(*s1) - tolower(*s2); 
           if (d!=0 || *s1=='\0' || *s2=='\0') 
             return d; 
           s1++; 
           s2++; 
        } 
}
