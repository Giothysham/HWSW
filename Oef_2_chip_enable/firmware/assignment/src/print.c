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

unsigned int Multiply(unsigned int a, unsigned int b) {
    unsigned int result = 0;

    while (b > 0) {
        if (b & 1) { // Check if the least significant bit of b is 1
            result += a;
        }
        a <<= 1; // Left shift a (multiply by 2)
        b >>= 1; // Right shift b (divide by 2)
    }

    return result;
}

int Power(int x,int n){
    if (n == 0) {
        return 1;
    }
    
    int result = x;
    for (int i = 1; i < n; i++) {
        result = Multiply(result, x);
    }
    
    return(result);
}

void print_dec(unsigned int val) {
    unsigned int dividend = val;
    char x;
  
    if (dividend == 0) {
        x = '0';
        *((volatile unsigned int*)OUTPORT) = x;  // Print the '0'
        return;
    }

    unsigned int divisor = 10;
    unsigned int buffer = 0;
    unsigned int number = val;
    unsigned int quotient = 0;
    unsigned int msb = 0;

    unsigned int divisor_power = 1;
    
    while(number >= divisor){
            if(dividend >= divisor){
                quotient = quotient + 1;
                number = 0;
            }
            
            while(dividend >= divisor){
                dividend = dividend - divisor;
                number = number + 1;
            }
            dividend = number;
            
        }
    
    divisor_power = Power(divisor, quotient);
    dividend = val;

    while (divisor_power > 0) {
         while(dividend >= divisor_power){
            dividend = dividend - divisor_power;
            msb = msb + 1;
        }
        x = "0123456789"[msb]; 
        *((volatile unsigned int*)OUTPORT) = x;  // Output the digit
        msb = 0;
        
        while(dividend >= divisor_power){
            dividend = dividend - divisor_power;
        }

        while(divisor_power >= divisor){
            divisor_power = divisor_power - divisor;
            buffer = buffer + 1;
        }
        divisor_power = buffer;
        buffer = 0;
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
