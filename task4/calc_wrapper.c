#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 33

extern float calc_add(float, float);

typedef union {
  int i;
  float f;
} float_int_t;

char *int2bin(int a, char *buffer, int buf_size) {
    buffer += (buf_size - 1);

    for (int i = 31; i >= 0; i--) {
        *buffer-- = (a & 1) + '0';

        a >>= 1;
    }

    return buffer;
}

int main(int argc, char** argv) {
	// Check if enough arguments are provided
	if (argc < 3) {
		fprintf(stderr, "Not enough arguments! Try ./calc 1.2 3.4\n");
		return EXIT_FAILURE;
	}

	// Read operands from command line
	float operand1 = (float)atof(argv[1]);
	float operand2 = (float)atof(argv[2]);

	// Perform addition
	printf("%f \t+ \t%f \t= \t", operand1, operand2);
	float result = calc_add(operand1, operand2);
	printf("%f\n", result);
	
	return EXIT_SUCCESS;
}
