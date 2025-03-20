#include "tcnt.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED              (*(volatile unsigned int *) LED_REG0_ADDRESS)


unsigned int i=1, j;

void irq_handler(unsigned int cause) {

    if (0<=i<8) {
        i = i + 1;
        LED = i;
    } else {
        i = 0;
        LED = i;
    }

    TCNT_CR = 0x17;
    TCNT_CR = 0x7;

}


void main(void) {
    
    

    TCNT_CMP = 0xC65D40;
    TCNT_start();
    

    while(1) {
        
    }
}
