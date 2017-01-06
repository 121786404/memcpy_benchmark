BASE=/data/armv8/marshmallow/
NDK=$(BASE)/android/android-ndk-r10e
TOOLCHAIN=$(BASE)/tcwg/bin/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux

TOOLCHAIN_LINARO_64=${BASE}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-5.3-linaro/bin/aarch64-linux-android-gcc
TOOLCHAIN_LINARO_32=${BASE}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-5.3-linaro/bin/arm-linux-androideabi-gcc
TOOLCHAIN_LINARO=$(NDK)/toolchains/android-toolchain-eabi-4.8-2014.04-x86

TOOLCHAIN_NDK=$(NDK)/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64

SYSROOT_LINUX=$(TOOLCHAIN)/arm-linux-gnueabihf/libc
SYSROOT=$(NDK)/platforms/android-21/arch-arm
#SYSROOT=$(NDK)/platforms/android-16/arch-arm

# Do NOT use double quotes around CC, i.e. CC="bla bla"
CC_google=$(TOOLCHAIN_NDK)/bin/arm-linux-androideabi-gcc-4.8 --sysroot=$(SYSROOT)

#if android-16
#rename android-ndk-r10e/toolchains/android-toolchain-eabi-4.8-2014.04-x86/arm-linux-androideabi/lib/crtbegin_static.o 2 stg else, else get multp def err f atexit wif android-ndk-r10e/platforms/android-21/arch-arm/usr/lib/libc.a
#CC_linaro=$(TOOLCHAIN_LINARO)/bin/arm-linux-androideabi-gcc --sysroot=$(SYSROOT) -I$(NDK)/platforms/android-16/arch-arm/usr/include

#if android-21
CC_linaro=$(TOOLCHAIN_LINARO)/bin/arm-linux-androideabi-gcc --sysroot=$(SYSROOT) -I$(NDK)/platforms/android-21/arch-arm/usr/include

#using linaro src tree hdr stead o ndk sysroot
#CC_linaro=$(TOOLCHAIN_LINARO)/bin/arm-linux-androideabi-gcc -I$(BASE)/tkts/1491/bionic_linaro/libc/include -I$(BASE)/tkts/1491/bionic_linaro/libc/kernel/uapi -I$(BASE)/tkts/1491/bionic_linaro/libc/kernel/uapi/asm-arm

CC=$(TOOLCHAIN)/bin/arm-linux-gnueabihf-gcc -I$(SYSROOT_LINUX)/usr/include

FILTER=$(filter-out Makefile memcpy_impl.S memcpy_base.S, $^)


all: memcpy_test_static \
     memcpy_test_static_hf \
     memcpy_test_linaro \
     memcpy_test_linaro_hf \
     memcpy_test_google \
     memcpy_test_google_hf \
     move
#all: memcpy_test memcpy_test_static memcpy_test_hf memcpy_test_static_hf memcpy_test_linaro memcpy_test_linaro_static memcpy_test_linaro_hf memcpy_test_linaro_static_hf memcpy_test_google memcpy_test_google_static memcpy_test_google_hf memcpy_test_google_static_hf move

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

#memcpy_test_linaro_static: $(wildcard *.c *.S) Makefile
#	$(CC_linaro) $(CFLAGS) $(CFLAGS2) -v -Wl,--verbose -static -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_linaro_static: $(wildcard *.c *.S) Makefile
	$(CC_linaro) $(CFLAGS) $(CFLAGS2) -static -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_linaro: $(wildcard *.c *.S) Makefile
	$(CC_linaro) $(CFLAGS) $(CFLAGS2) -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_linaro_static_hf: $(wildcard *.c *.S) Makefile
	$(CC_linaro) $(CFLAGS) $(CFLAGS2) -static -mhard-float\
	    $(FILTER) -o $@

memcpy_test_linaro_hf: $(wildcard *.c *.S) Makefile
	$(CC_linaro) $(CFLAGS) $(CFLAGS2) -mhard-float\
	    $(FILTER) -o $@

memcpy_test_google_static: $(wildcard *.c *.S) Makefile
	$(CC_google) $(CFLAGS) $(CFLAGS2) -static -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_google: $(wildcard *.c *.S) Makefile
	$(CC_google) $(CFLAGS) $(CFLAGS2) -mfloat-abi=softfp\
	    $(FILTER) -o $@

memcpy_test_google_static_hf: $(wildcard *.c *.S) Makefile
	$(CC_google) $(CFLAGS) $(CFLAGS2) -static -mhard-float\
	    $(FILTER) -o $@

memcpy_test_google_hf: $(wildcard *.c *.S) Makefile
	$(CC_google) $(CFLAGS) $(CFLAGS2) -mhard-float\
	    $(FILTER) -o $@

move:
	@mv memcpy_test* bin/

clean:
	rm -f bin/memcpy_test*
