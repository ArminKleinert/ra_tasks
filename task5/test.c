#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <sys/time.h>

uint64_t c_fib_it(uint64_t n) {
	uint64_t x_1 = 0;
	uint64_t x_2 = 1;
	uint64_t k = 0;

	while (n > 0) {
		x_1 = x_2;
		x_2 = k;
		k = x_1 + x_2;
		n--;
	}

	return k;
}

int main(int argc, char** argv) {
  printf("%lu\n", c_fib_it(25));
}

