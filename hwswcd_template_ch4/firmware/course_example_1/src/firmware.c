//#include <stdio.h>

#include "tcnt.h"
#include "sensor.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED (*(volatile unsigned int *) LED_REG0_ADDRESS)

void irq_handler(unsigned int cause) {

    if (cause & 4) {
        LED = 0xFFFFFFFF;
    }

}

int main(void) {

    SENSOR_fetch();
    SENSOR_CR |= SENSOR_CR_RE; // Start the sensor

    LED = SENSOR_get_width();
    LED = SENSOR_get_height();

    return 0;
}

    
