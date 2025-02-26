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
	if (val == 0) {
        print_chr('0');
        return;
    }
    
    char digits[10];
    int i = 0;
    
    while (val > 0) {
        unsigned int temp = val;
        unsigned int digit = 0;
        
        while (temp >= 1) {
            temp -= 1;
            digit++;
        }
        
        digits[i++] = digit + '0';
        val = temp;
    }
    
    while (i > 0) {
        print_chr(digits[--i]);
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
