#include "tcnt.h"
#include "print.h"

#define OUTPORT 0x80000000

int tcnt = 0;

int main(void) {
	int i = 0;
	for (;;) {
		for(int j = 0 ; j <= 40; j++){
			TCNT_start();
			if(j == 40){
				if(i <= 15){
					i = i + 1;
					*((volatile unsigned int *)OUTPORT) = i;
				} else if(i > 15) {
					i = 0;
					*((volatile unsigned int *)OUTPORT) = i;
				}
			}
			TCNT_stop();
			tcnt = TCNT_VAL;
			print_dec(tcnt);
		}
	}
	return 0;
}
