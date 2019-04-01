export CC = gcc
export CFLAGS = -O2 -g -Wall

VERSION=20040517

default:
	$(MAKE) -C cpu/
	$(MAKE) -C hardware/
	$(MAKE) -C as68k/
	$(MAKE) fe2.bin

fe2clean:
	rm -f fe2.bin

fe2:
	$(MAKE) fe2clean
	$(MAKE) fe2.bin

fe2.bin:
	as68k/as68k fe2.s
	mv aout.prg fe2.bin

clean:
	$(MAKE) -C hardware/ clean
	rm -f cpu/hatari-glue.o cpu/newcpu.o
	rm -f frontier
	$(MAKE) fe2clean

allclean:
	$(MAKE) clean
	$(MAKE) -C as68k/ clean
	$(MAKE) -C dis68k/ clean
	$(MAKE) -C cpu/ clean
	$(MAKE) fe2clean

# To make a nice clean tarball
dist:
	$(MAKE) allclean
	mkdir frontvm-$(VERSION)
	cp -r as68k frontvm-$(VERSION)
	cp -r dis68k frontvm-$(VERSION)
	cp -r hardware frontvm-$(VERSION)
	cp -r cpu frontvm-$(VERSION)
	cp -r sfx frontvm-$(VERSION)
	cp fe2.s frontvm-$(VERSION)
	cp notes.txt frontvm-$(VERSION)
	cp README frontvm-$(VERSION)
	cp font8.bmp frontvm-$(VERSION)
	cp Makefile frontvm-$(VERSION)
	tar cvzf frontvm-$(VERSION).tar.gz frontvm-$(VERSION)
	rm -rf frontvm-$(VERSION)

