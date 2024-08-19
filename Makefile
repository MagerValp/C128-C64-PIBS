EXIT ?= 64738

TARGET=c64
CC=cl65
AS=ca65
LD=ld65
C1541=c1541
CFLAGS=-DEXIT=$(EXIT) -Oirs -t $(TARGET)
AFLAGS=-DEXIT=$(EXIT) -t $(TARGET)
LDFLAGS=



%.o: %.c
	$(CC) -c $(CFLAGS) $<

%.o: %.s
	$(AS) $(AFLAGS) $<


all: pibs.d64


OBJS = \
	pibs.o


pibs.d64: pibs.prg
	@rm -f $@ tmp.d64
	@c1541 -format 'genesis*project,24' d64 tmp.d64
	@c1541 -attach tmp.d64 -write pibs.prg 'pibs'
	@mv tmp.d64 $@

pibs.prg: $(OBJS) pibs.cfg
	$(LD) -m pibs.map -C pibs.cfg -o $@ $(LDFLAGS) $(OBJS)


clean:
	rm -f *.o
	rm -f pibs.prg pibs.map
	rm -f pibs.d64


distclean: clean
	rm -f *~
