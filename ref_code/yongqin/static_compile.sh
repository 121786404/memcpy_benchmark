#!/bin/bash
BASE="/home/liuyq/data/armv8/marshmallow/"
NDK="/SATA3/android-ndk-r10e/"
NDK_21_ARM64="${NDK}/platforms/android-21/arch-arm64/"
TOOLCHAIN_GOOGLE_64="${BASE}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/"
LIBGCC_GOOGLE=${TOOLCHAIN_GOOGLE_64}/lib/gcc/aarch64-linux-android/4.9.x-google/libgcc.a

TOOLCHAIN_LINARO_64="${BASE}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-5.3-linaro/"
LIBGCC_LINARO=${TOOLCHAIN_LINARO_64}/lib/gcc/aarch64-linux-android/5.3.0/libgcc.a

function compile(){
    local toolchain=$1
    local libgcc=$2
    local output=$3
    if [ ! -x "${toolchain}/bin/aarch64-linux-android-gcc" ]; then
        echo "gcc command does not exist under: ${toolchain}"
        exit 1
    fi
    if [ ! -f "${libgcc}" ]; then
        echo "file libgcc.a does not exist under: ${toolchain}"
        exit 1
    fi
    if [ -z "${output}" ]; then
        echo "Please specify the name for output file"
        exit 1
    fi
    rm -vfr "${output}" main_strcpy.o string_copy_google_wrapper.o string_copy_linaro_wrapper.o

    cflags_include="-isystem ${BASE}/bionic/libc/arch-arm64/include \
                    -isystem ${BASE}/bionic/libc/include \
                    -isystem ${BASE}/bionic/libc/kernel/uapi \
                    -isystem ${BASE}/bionic/libc/kernel/uapi/asm-arm64 \
                    -isystem ${BASE}/bionic/libm/include \
                    -isystem ${BASE}/bionic/libm/include/arm64 \
                    -include ${BASE}/build/core/combo/include/arch/linux-arm64/AndroidConfig.h \
                    -I ${BASE}/build/core/combo/include/arch/linux-arm64/"

    cflags_foptions="-fno-exceptions \
                     -fno-strict-aliasing \
                     -fstack-protector \
                     -ffunction-sections \
                     -fdata-sections \
                     -funwind-tables \
                     -fno-short-enums \
                     -fno-canonical-system-headers \
                     -fno-strict-volatile-bitfields \
                     -fmessage-length=0 \
                     -fgcse-after-reload \
                     -frerun-cse-after-loop \
                     -frename-registers"

    cflags_Woptions="-Wno-multichar \
                     -Wa,--noexecstack \
                     -Werror=format-security \
                     -Werror=pointer-to-int-cast \
                     -Werror=int-to-pointer-cast \
                     -Werror=implicit-function-declaration \
                     -W \
                     -Wall \
                     -Wno-unused \
                     -Winit-self \
                     -Wpointer-arith \
                     -Werror=return-type \
                     -Werror=non-virtual-dtor \
                     -Werror=address \
                     -Werror=sequence-point \
                     -Wno-psabi \
                     -Wstrict-aliasing=2"

    cflags_Doptions="-D_FORTIFY_SOURCE=2 \
                     -DANDROID \
                     -DNDEBUG \
                     -UDEBUG"
    cflags_misc="-c \
                 -O2 \
                 -g \
                 -no-canonical-prefixes \
                 -mcpu=cortex-a53"

    cflags_misc2="-O2 \
                 -g \
                 -no-canonical-prefixes \
                 -mcpu=cortex-a53"

    cflags_common="${cflags_include} \
                   ${cflags_misc} \
                   ${cflags_foptions} \
                   ${cflags_Woptions} \
                   ${cflags_Doptions}"

    cflags_common2="${cflags_include} \
                   ${cflags_misc2} \
                   ${cflags_foptions} \
                   ${cflags_Woptions} \
                   ${cflags_Doptions}"

    ldflag_options="-nostdlib -Bstatic -static \
        -Wl,--gc-sections \
        -Wl,-z,noexecstack \
        -Wl,-z,relro -Wl,-z,now \
        -Wl,--build-id=md5 \
        -Wl,--warn-shared-textrel \
        -Wl,--fatal-warnings \
        -Wl,-maarch64linux \
        -Wl,--hash-style=gnu \
        -Wl,--fix-cortex-a53-843419  \
        -Wl,--allow-shlib-undefined    \
        -Wl,--no-undefined   \
        -Wl,--whole-archive   \
        -Wl,--no-whole-archive  \
        "

if false; then
    ${toolchain}/bin/aarch64-linux-android-gcc \
        ${cflags_common} \
        -D__ASSEMBLY__ \
        -o string_copy_google_wrapper.o \
        string_copy_google_wrapper.S

    ${toolchain}/bin/aarch64-linux-android-gcc \
        ${cflags_common} \
        -D__ASSEMBLY__ \
        -o string_copy_linaro_wrapper.o \
        string_copy_linaro_wrapper.S

    ${toolchain}/bin/aarch64-linux-android-gcc \
        ${cflags_common} \
        -D_USING_LIBCXX   \
        -std=c11 \
        -fpie \
        -Werror=int-to-pointer-cast -Werror=pointer-to-int-cast \
        -o main_strcpy.o \
        main_strcpy.c

    ${toolchain}/bin/aarch64-linux-android-gcc \
        ${ldflag_options} \
        -o "${output}" \
        string_copy_linaro_wrapper.o \
        string_copy_google_wrapper.o \
        main_strcpy.o \
        ${NDK_21_ARM64}/usr/lib/crtbegin_static.o  \
        -Wl,--start-group \
        ${NDK_21_ARM64}/usr/lib/libc.a     \
        ${libgcc} \
        -Wl,--end-group \
        ${NDK_21_ARM64}/usr/lib/crtend_android.o
fi
    ${toolchain}/bin/aarch64-linux-android-gcc \
        ${cflags_common2} -std=c11 -D_USING_LIBCXX \
        ${ldflag_options} \
        -o "${output}" \
        string_copy_linaro_wrapper.S \
        string_copy_google_wrapper.S \
        main_strcpy.c \
        ${NDK_21_ARM64}/usr/lib/crtbegin_static.o  \
        -Wl,--start-group ${NDK_21_ARM64}/usr/lib/libc.a ${libgcc} \
        -Wl,--end-group ${NDK_21_ARM64}/usr/lib/crtend_android.o

    ls -l "${output}"
    file "${output}"
}

function main(){
    rm -fr bin
    compile "${TOOLCHAIN_GOOGLE_64}" "${LIBGCC_GOOGLE}" "strcpy_google_static"
    compile "${TOOLCHAIN_LINARO_64}" "${LIBGCC_LINARO}" "strcpy_linaro_static"
    mkdir -p bin
    mv -v "strcpy_google_static" "strcpy_linaro_static" bin
    rm -fr main_strcpy.o string_copy_google_wrapper.o string_copy_linaro_wrapper.o
}

main "$@"
