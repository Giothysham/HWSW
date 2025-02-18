// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "print.h"

void print_chr(char ch) {
	*((volatile unsigned int*)OUTPORT) = ch;
}

void print_str(const char *p) {
	while (*p != 0)
		*((volatile unsigned int*)OUTPORT) = *(p++);
}


void print_dec(unsigned int val) {
	int i = 0;
    int j;
    char temp;
	char* buffer;

    if (val == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    while (val != 0) {
        // Simulate modulo 10
        unsigned int remainder = val;
        unsigned int divisor = 10;
        while (remainder >= divisor) {
            remainder = remainder - divisor;
        }
        buffer[i++] = remainder + '0';

        // Simulate division by 10
        unsigned int tempNum = val;
        unsigned int divisorDiv = 10;
        val = 0;
        while (tempNum >= divisorDiv) {
            tempNum = tempNum - divisorDiv;
            val++;
        }
    }

    // Reverse the string
    for (j = 0; j < i / 2; j++) {
        temp = buffer[j];
        buffer[j] = buffer[i - 1 - j];
        buffer[i - 1 - j] = temp;
    }

    buffer[i] = '\0';

	for (int k = 0; buffer[k] != '\0'; k++) {
		print_chr(buffer[k]);
	}
}

void print_hex(unsigned int val, int digits) {
	unsigned int index, max;
	int i; /* !! must be signed, because of the check 'i>=0' */
	char x;

	if(digits == 0)
		return;

	max = digits << 2;

	for (i = max-4; i >= 0; i -= 4) {
		index = val >> i;
		index = index & 0xF;
		x="0123456789ABCDEF"[index];
		*((volatile unsigned int*)OUTPORT) = x;
	}
	print_str("\n");
}
