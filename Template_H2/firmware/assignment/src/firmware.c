#include "tcnt.h"
#include "print.h"

#define OUTPORT 0x80000000

struct matrix_t{
	unsigned int a00;
	unsigned int a10;
	unsigned int a01;
	unsigned int a11;
};


struct matrix_t m, n, o;

void matrix_mult(struct matrix_t * z, struct matrix_t * x, struct matrix_t * y) {
	z->a00 = sw_mult(x->a00, y->a00) + sw_mult(x->a10, y->a01);
	z->a10 = sw_mult(x->a00, y->a10) + sw_mult(x->a10, y->a11);
	z->a01 = sw_mult(x->a01, y->a00) + sw_mult(x->a11, y->a01);
	z->a11 = sw_mult(x->a01, y->a10) + sw_mult(x->a11, y->a11);
}

int main(void) {

	int tcnt = 0;

	m.a00 = 1; n.a00 = 5;
	m.a10 = 2; n.a10 = 6;
	m.a01 = 3; n.a01 = 7;
	m.a11 = 4; n.a11 = 8;

	TCNT_start();
	matrix_mult(&o, &m, &n);
	TCNT_stop();
	tcnt = TCNT_VAL;
	print_dec(tcnt);

	return 0;
}
