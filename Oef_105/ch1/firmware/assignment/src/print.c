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
	char buffer[10];
	int i = 0;

	if (val == 0) {
		print_chr('0');
		return;
	}

	while (val > 0) {
		unsigned int temp = val;
		unsigned int divisor = 1;
		while (temp >= 10) {
			temp -= 10;
			divisor++;
		}
		buffer[i++] = temp + '0';
		for(i = 0; i < temp; i++);
		val -= divisor;
	}

	while (i > 0) {
		print_chr(buffer[--i]);
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
