#include <stdio.h>
#include <inttypes.h>
#include <immintrin.h>

extern void vcalcw(__m128i *a, __m128i *b, __m128i *c, char op);

int main(void)
{
	__attribute__ ((aligned (16)))
	uint16_t a[] = { 1, 2, 3, 4, 5, 6, 7, 8 };
	__attribute__ ((aligned (16)))
	uint16_t plus[8];
	__attribute__ ((aligned (16)))
	uint16_t mul[8];
	__attribute__ ((aligned (16)))
	uint16_t mulsub[8];
	__attribute__ ((aligned (16)))
	uint16_t equal[8];

	printf("a[] =\t\t\t\t%6hd %6hd %6hd %6hd %6hd %6hd %6hd %6hd\n",
	       a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);

	vcalcw((__m128i*)a, (__m128i*)a, (__m128i*)plus, '+');
	printf("a[] + a[] =\t\t\t%6hd %6hd %6hd %6hd %6hd %6hd %6hd %6hd\n",
	       plus[0], plus[1], plus[2], plus[3], plus[4], plus[5], plus[6],
	       plus[7]);

	vcalcw((__m128i*)a, (__m128i*)a, (__m128i*)mul, '*');
	printf("a[] * a[] =\t\t\t%6hd %6hd %6hd %6hd %6hd %6hd %6hd %6hd\n",
	       mul[0], mul[1], mul[2], mul[3], mul[4], mul[5], mul[6], mul[7]);

	vcalcw((__m128i*)mul, (__m128i*)a, (__m128i*)mulsub, '-');
	printf("a[] * a[] - a[] =\t\t%6hd %6hd %6hd %6hd %6hd %6hd %6hd %6hd\n",
	       mulsub[0], mulsub[1], mulsub[2], mulsub[3], mulsub[4], mulsub[5],
	       mulsub[6], mulsub[7]);

	vcalcw((__m128i*)plus, (__m128i*)mul, (__m128i*)equal, '=');
	printf("a[] * a[] - a[] == a[] =\t0x%.4hx 0x%.4hx 0x%.4hx 0x%.4hx "
	       "0x%.4hx 0x%.4hx 0x%.4hx 0x%.4hx\n",
	       equal[0], equal[1], equal[2], equal[3], equal[4], equal[5],
	       equal[6], equal[7]);
}
