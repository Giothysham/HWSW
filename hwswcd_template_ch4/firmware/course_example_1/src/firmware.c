#include "tcnt.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED              (*(volatile unsigned int *) LED_REG0_ADDRESS)


unsigned int i=1, j;

void irq_handler(unsigned int cause) {

    if (i < 4) {
        i = i + 1;
        LED = 1 << i;
    } else {
        i = 0;
        LED = 0;
    }

    TCNT_CR = 0x17;
    TCNT_CR = 0x7;

}


void main(void) {
    
    

    TCNT_CMP = 0xff;
    TCNT_start();
    

    while(1) {
        for(int j=0; j<0xC65D40; j++);
        if(i == ) {
            LED = i | 0b1000;
        }
        
        
    }
}
