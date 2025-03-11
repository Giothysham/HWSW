#define OUTPORT 0x80000000


int main(void) {
	int i = 0;
	for (;;) {
		for(int j = 0 ; j <= 4000000; j++){
			if(j == 4000000){
				if(i >= 15){
					i = i + 1;
					*((volatile unsigned int *)OUTPORT) = i;
				} else if(i < 15) {
					i = 0;
					*((volatile unsigned int *)OUTPORT) = i;
				}
			}
		}
	}
	return 0;
}
