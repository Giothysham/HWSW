#include "sensor.h"

unsigned int SENSOR_fetch(void) {
    unsigned int pixeldata;
    pixeldata = SENSOR_PIXELDATA;
    return pixeldata;
}

void SENSOR_next_pixel(void) {
    SENSOR_CR |= SENSOR_CR_RE; 
    SENSOR_CR &= ~SENSOR_CR_RE; 
}