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

int mul(int x, int y){
    int result = 0;
    for(int i = 0; i < x; i++){
        result = result + y;
    }
    return result;
}

int Pow(int x,int n){
    int i;
    int number = 1;

    for (i = 0; i < n; ++i){
        number = mul(number,x);
    }
    return(number);
}

void print_dec(unsigned int val) {
    unsigned int dividend = val;
    unsigned int divided = 0;
    unsigned int quotient = 0;
    unsigned int divisor = 10; 
    unsigned int buffer = 10;
    unsigned int rem = 0;
    unsigned int order = 0;
    
    if(divided < divisor){
        rem = val;
    }
    while(dividend >= divisor){
        while(buffer >= divisor){
            if(dividend >= divisor){
                quotient = quotient + 1;
                buffer = 0;
            }
            
            while(dividend >= divisor){
                dividend = dividend - divisor;
                buffer = buffer + 1;
            }
            rem = dividend;
            dividend = buffer;
            
        }
        print_chr(buffer + '0');
        order = 10 * quotient;
        buffer = mul(buffer, order);
        divided = divided + buffer;
        dividend = val - divided;
        quotient = 0;
    }
    print_chr(rem + '0');
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


