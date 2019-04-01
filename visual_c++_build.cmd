@REM command line build for visual c++ tools.
@REM very messy. no error testing.
@REM tested with vc2003/vc2005
cd cpu
del *.obj
del *.exe
del cpudefs.c
del cpuemu.c
del cpustbl.c
cl /MT build68k.c -I..\sdl -I..\sdl\include
build68k < table68k > cpudefs.c
cl /MT gencpu.c readcpu.c cpudefs.c -I..\sdl -I..\sdl\include
gencpu
cl /MT /O2 -I..\sdl -I..\sdl\include /c cpuemu.c
cl /MT /O2 -I..\sdl -I..\sdl\include /c hatari-glue.c
cl /MT /O2 /Dinline=_inline -I..\sdl -I..\sdl\include /c newcpu.c
cl /MT /O2 /Dinline=_inline -I..\sdl -I..\sdl\include /c memory.c
cl /MT /O2 /Dinline=_inline -I..\sdl\include  -I..\cpu /c cpustbl.c
del build68k.obj
del gencpu.obj
del cpudefs.c
del cpuemu.c
del cpustbl.c
cd ..\hardware
cl /MT /O2 -I..\sdl\include -I..\cpu /Dinline=_inline /Dmain=SDL_main /c *.c
cl /MT *.obj ..\cpu\*.obj ..\sdl\lib\SDLmain.lib ..\sdl\lib\sdl.lib  /Fe..\vc.exe
cd ..
cd as68k
cl /MT -I..\sdl\include *.c
cd ..
as68k\as68k fe2.s
del /f cpu\*.obj as68k\*.obj hardware\*.obj
del /F as68k\as68k.exe cpu\build68k.exe cpu\gencpu.exe
move /Y aout.prg fe2.bin