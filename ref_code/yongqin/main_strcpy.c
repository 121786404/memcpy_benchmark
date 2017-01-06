#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/time.h>

// need to be defined without [ extern "C" ] when compile with gcc
void *strcpy_google(void *dest, const void *src);
void *strcpy_linaro(void *dest, const void *src);

#define START gettimeofday(&tv1, 0);
#define END(x) gettimeofday(&tv2, 0); t1 = ((double)tv1.tv_sec)+((double)tv1.tv_usec)/1000000.0; t2 = ((double)tv2.tv_sec)+((double)tv2.tv_usec)/1000000.0; printf("%s: %f seconds\n", x, t2-t1)

int main() {
	struct timeval tv1, tv2;
	double t1, t2;
	char * const s = (char * const) malloc(16);
	char * const l = (char * const) malloc(15001);
	char * const tmp = (char * const) malloc(15001);

    memset(s, 'a', 15);
	s[15]=0;
    memset(l, 'a', 15000);
	l[15000]=0;

	START;
	for(int i=0; i<1000000; i++) {
		strcpy_google(tmp, l);
	}
	END("1000000 * strcpy_google of 15000 bytes");

	START;
	for(int i=0; i<1000000; i++) {
		strcpy_linaro(tmp, l);
	}
	END("1000000 * strcpy_linaro of 15000 bytes");

	START;
	for(int i=0; i<100000000; i++) {
		strcpy_google(tmp, s);
	}
	END("100000000 * strcpy_google of 15 bytes");

	START;
	for(int i=0; i<100000000; i++) {
		strcpy_linaro(tmp, s);
	}
	END("100000000 * strcpy_linaro of 15 bytes");
	return 0;
}
