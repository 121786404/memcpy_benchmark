CC=arm-linux-gnueabihf-gcc
CFLAGS=-Wall -Wl,--no-warn-mismatch -std=gnu99 -O2 -mcpu=cortex-a9 -mfpu=neon
FILTER=$(filter-out Makefile memcpy_impl.S memcpy_base.S, $^)

all: memcpy_test_static memcpy_test_static_hf  memcpy_test memcpy_test_hf change_mode

memcpy_test_static: $(wildcard *.c *.S) Makefile
	$(CC) $(CFLAGS) -static -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test: $(wildcard *.c *.S) Makefile
	$(CC) $(CFLAGS) -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_static_hf: $(wildcard *.c *.S) Makefile
	$(CC) $(CFLAGS) -static -mfloat-abi=hard\
	    $(FILTER) -o $@

memcpy_test_hf: $(wildcard *.c *.S) Makefile
	$(CC) $(CFLAGS) -mfloat-abi=hard\
	    $(FILTER) -o $@

change_mode:
	sudo chmod 777 memcpy_test_*

clean:
	rm -f memcpy_test_*
