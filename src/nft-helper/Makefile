all: nft-helper

clean:
	rm nft-helper *.o

distclean: clean
	rm *~

nft-helper: main.c Makefile
	$(CC) -o $@ $(CFLAGS) $< $(LDFLAGS)
