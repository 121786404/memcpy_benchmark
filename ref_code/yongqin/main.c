#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>

void *ad_memcpy_neon(void *dest, const void *src, size_t n);
void *ad_memcpy_vfp(void *dest, const void *src, size_t n);
void *ad_memcpy_none(void *dest, const void *src, size_t n);
void *ad_memcpy_glibc217(void *dest, const void *src, size_t n);
void *ad_memcpy_bionic(void *dest, const void *src, size_t n);

#define N_ELEMENTS(x)  (sizeof(x) / sizeof((x)[0]))

struct bench {
    unsigned int len;
    unsigned long long loops;
};

int
main (int argc, char *argv[])
{
    static const struct bench benches[] = {
        { .len = 8,            .loops = 16000000LLU },
        { .len = 81,           .loops = 8000000LLU  },
        { .len = 8192,         .loops = 200000LLU },
        { .len = 131072,       .loops = 5000LLU },
        { .len = 1048576 * 10, .loops = 10LLU },
    };

    for (int iter = 0; iter < N_ELEMENTS (benches); ++iter) {
        const struct bench *bench = &benches[iter];
        unsigned int len = bench->len;
        unsigned long long loops;

        unsigned char *src;
        unsigned char *dst;
        struct timeval start, end;
        double mbps;

        printf ("benchmarking: len: %8u  loops: %llu\n", len, bench->loops);

        src = malloc (len);
        dst = malloc (len);
        memset (src, 0xaa, len);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            ad_memcpy_neon (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (neon)        took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            ad_memcpy_vfp (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (vfp)         took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            ad_memcpy_none (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (none)        took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            ad_memcpy_glibc217 (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (old arm generic)  took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            ad_memcpy_bionic (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (bionic)  took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        gettimeofday (&start, NULL);
        loops = bench->loops + 1;
        while (--loops)
            memcpy (dst, src, len);
        gettimeofday (&end, NULL);
        timersub (&end, &start, &end);
        mbps = (bench->loops * bench->len * 1000000.0d) / (double)(end.tv_sec * 1000000.0d + end.tv_usec) / 1024 / 1024;
        printf ("  memcpy (curr toolchain - dynamic)       took %2ju.%.6ju s  ~ %'.1f MiB/s\n", (uintmax_t)end.tv_sec, (uintmax_t)end.tv_usec, mbps);

        free (dst);
        free (src);

        puts ("");
    }

    return 0;
}
