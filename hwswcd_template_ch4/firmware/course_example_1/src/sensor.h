#ifndef SENSOR_H
#define SENSOR_H

#define SENSOR_BASEADDRESS              0x82000000

#define SENSOR_REG0_ADDRESS             (SENSOR_BASEADDRESS + 0*4)
#define SENSOR_REG1_ADDRESS             (SENSOR_BASEADDRESS + 1*4)
#define SENSOR_REG2_ADDRESS             (SENSOR_BASEADDRESS + 2*4)

#define SENSOR_CR                       (*(volatile unsigned int *) SENSOR_REG0_ADDRESS)
#define SENSOR_PIXELDATA                (*(volatile unsigned int *) SENSOR_REG1_ADDRESS)
#define SENSOR_SR                       (*(volatile unsigned int *) SENSOR_REG2_ADDRESS)

#define SENSOR_CR_RE                    0x1
#define SENSOR_SR_FIRST                 0x3

unsigned int SENSOR_get_width();              
unsigned int SENSOR_get_height();             

unsigned int SENSOR_fetch(void);

#endif