
CC = gcc
OBJS = as68k.o dict.o

.c.o:
	$(CC) $(CFLAGS) -c $<

as68k: $(OBJS)
	$(CC) -o as68k $(OBJS)

clean:
	rm -f *.o as68k as68k.exe

as68k.o: dict.h

