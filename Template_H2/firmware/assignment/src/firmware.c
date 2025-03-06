#define OUTPORT 0x80000000


int main(void) {
	int i;
	for (i = 0; i < 10; i++) {
		*((volatile unsigned int *)OUTPORT) = i;
	}
	return 0;
}
