
SDLLIB = $(shell sdl-config --libs)
SDLFLAGS = $(shell sdl-config --cflags)

INCFLAGS = -I../cpu

CPUOBJS = ../cpu/hatari-glue.o ../cpu/memory.o ../cpu/newcpu.o \
  ../cpu/readcpu.o ../cpu/cpustbl.o ../cpu/cpudefs.o \
  ../cpu/cpuemu1.o ../cpu/cpuemu2.o ../cpu/cpuemu3.o \
  ../cpu/cpuemu4.o ../cpu/cpuemu5.o ../cpu/cpuemu6.o \
  ../cpu/cpuemu7.o ../cpu/cpuemu8.o

SRCS = disasm.c audio.c configuration.c dialog.c \
  file.c hostcall.c int.c keymap.c \
  m68000.c main.c memAlloc.c misc.c \
  reset.c stMemory.c screen.c screenConvert.c \
  sdlgui.c shortcut.c scalebit.c \
  loadfe2.c video.c input.c fe2.c

OBJS = $(SRCS:.c=.o)

.c.o:
	$(CC) $(CFLAGS) $(INCFLAGS) $(SDLFLAGS) -c $<

../frontier: $(OBJS)
	$(CC) $(OBJS) $(CPUOBJS) $(SDLLIB) $(LIBFLAGS) -o ../frontier

clean:
	rm -f *.o

# Use "make depend" to generate file dependencies:
depend: $(SRCS)
	$(CC) -MM $(CFLAGS) $(SRCS) > Makefile.dep

ifneq (,$(wildcard Makefile.dep))
include Makefile.dep
endif

