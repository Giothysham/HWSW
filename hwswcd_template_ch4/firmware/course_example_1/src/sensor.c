#include "sensor.h"

unsigned int SENSOR_fetch(void) {
    unsigned int pixeldata;
    pixeldata = SENSOR_PIXELDATA;
    SENSOR_CR |= SENSOR_CR_RE; 
    SENSOR_CR &= ~SENSOR_CR_RE; 
    return pixeldata;
}

inline unsigned char SENSOR_get_width(void) {
    return (unsigned char)((SENSOR_SR>>16) & 0xff);
}
inline unsigned char SENSOR_get_height(void) {
    return (unsigned char)((SENSOR_SR>>8) & 0xff);
}
