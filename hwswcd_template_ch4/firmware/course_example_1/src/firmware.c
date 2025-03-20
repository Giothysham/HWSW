#include "tcnt.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED              (*(volatile unsigned int *) LED_REG0_ADDRESS)


unsigned int i=1, j, bool = 0;

void irq_handler(unsigned int cause) {

    bool = 1;

    TCNT_CR = 0x17;
    TCNT_CR = 0x7;

}


void main(void) {
    
    TCNT_CMP = 0xff;
    TCNT_start();
    

    while(1) {
        if(bool == 1){
            i = i + 1;
            if(i > 16){
                i = 0;
            }
            bool = 0;
        }

            LED = i;
        
    }
}
