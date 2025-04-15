#include <stdio.h>
#include <stdint.h>

#define C_WIDTH 8
#define C_HEIGHT 8

struct qoi_header {
    char     magic[4];   // magic bytes "qoif"
    uint32_t width;      // image width in pixels (BE)
    uint32_t height;     // image height in pixels (BE)
    uint8_t  channels;   // 3 = RGB, 4 = RGBA
    uint8_t  colorspace; // 0 = sRGB with linear alpha
                         // 1 = all channels linear
};

void initialise(uint8_t r[C_WIDTH][C_HEIGHT], uint8_t g[C_WIDTH][C_HEIGHT], uint8_t b[C_WIDTH][C_HEIGHT], uint8_t a[C_WIDTH][C_HEIGHT]) {
    uint8_t w, h;

    for(h=0;h<C_HEIGHT/2;h++) {
        for(w=0;w<C_WIDTH/2;w++) {
            r[h][w] = 255; g[h][w] = 0; b[h][w] = 0; a[h][w] = 255;
        }
        for(w=C_WIDTH/2;w<C_WIDTH;w++) {
            r[h][w] = 0; g[h][w] = 255; b[h][w] = 0; a[h][w] = 255;
        }
    }
    for(h=C_HEIGHT/2;h<C_HEIGHT;h++) {
        for(w=0;w<C_WIDTH/2;w++) {
            r[h][w] = 0; g[h][w] = 0; b[h][w] = 255; a[h][w] = 255;
        }
        for(w=C_WIDTH/2;w<C_WIDTH;w++) {
            r[h][w] = 127; g[h][w] = 127; b[h][w] = 127; a[h][w] = 255;
        }
    }
}

int HashFunction(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    return (r * 3 + g * 5 + b * 7 + a * 11) % 64;
}

uint8_t closest_difference(uint8_t current, uint8_t prev) {
    signed char diff = (current >= prev) ? current - prev : 256 - (prev - current);
    return diff;
}

int main(void) {

    uint8_t r[C_HEIGHT][C_WIDTH];
    uint8_t g[C_HEIGHT][C_WIDTH];
    uint8_t b[C_HEIGHT][C_WIDTH];
    uint8_t a[C_HEIGHT][C_WIDTH];

    uint8_t r_prev = 0;
    uint8_t g_prev = 0;
    uint8_t b_prev = 0;
    uint8_t a_prev = 255;

    signed char dr, dg, db; //difference between current and previous pixel


    int8_t rle = -1; //counting identical pixels in a row 
    uint32_t running_array[64]; //memory of previous pixels
    uint8_t rv; //temporary storage
    uint8_t index; //index for running array
    uint32_t value; //value of current pixel (8*3bit RGB + 8bit A)
    uint32_t value_prev; //value of previous pixel (8*3bit RGB + 8bit A)

    /* Sanity check */
    if((C_WIDTH % 2) || (C_HEIGHT % 2)) {
        printf("ERROR: W or H not even");
        return 1;
    }

    /* Initialisation */
    initialise(r, g, b, a);
    for(uint8_t i=0;i<64;i++) {
        running_array[i] = 0;
    }
    value_prev = 0;
    r_prev = 0;
    g_prev = 0;
    b_prev = 0;
    a_prev = 255;
    rle = -1;
    

    /* Header */
    struct qoi_header header = {
        .magic = {'q', 'o', 'i', 'f'},
        .width = C_WIDTH,
        .height = C_HEIGHT,
        .channels = 3,
        .colorspace = 0
    };
    printf("Header: 0x%0*X%0*X%0*X%0*X%0*X%0*X%0*X%0*X", 2, header.magic[0], 2, header.magic[1], 2, header.magic[2], 2, header.magic[3], 8, header.width, 8, header.height, 2, header.channels, 2, header.colorspace);

    /* Loop over pixels */
    for(uint8_t h=0;h<C_HEIGHT;h++) {
        for(uint8_t w=0;w<C_WIDTH;w++) {

            if(header.channels == 4) {
                value = (r[h][w] << 24) | (g[h][w] << 16) | (b[h][w] << 8) | a[h][w];
            } else {
                value = (r[h][w] << 16) | (g[h][w] << 8) | b[h][w];
            }
            

            if(value == value_prev) {
                rle++;
            } else {

                if(rle > -1 || rle == 62) {
                    printf("%X", 0b11000000 + rle);
                    rle = -1;
                }
            
                index = HashFunction(r[h][w], g[h][w], b[h][w], a[h][w]);

                if(running_array[index] == value) {
                    printf("%X", 0b00000000 + index);
                } else {
                    running_array[index] = value;
                    dr = closest_difference(r[h][w], r_prev);
                    dg = closest_difference(g[h][w], g_prev);
                    db = closest_difference(b[h][w], b_prev);

                    if(dr >= -2 && dr <= 1 && dg >= -2 && dg <= 1 && db >= -2 && db <= 1 && a[h][w] == a_prev) {
                        uint8_t result = 0b01000000
                                        | ((dr + 2) << 4)
                                        | ((dg + 2) << 2)
                                        | (db + 2);
                        printf("%X", result);
                    } else if (dg >= -32 && dg <= 31 && (dr - dg) >= -8 && (dr - dg) <= 7 && (db - dg) >= -4 && (db - dg) <= 4 && a[h][w] == a_prev) {
                        uint16_t result = 0b1000000000000000
                                        | ((dg + 32) << 8)
                                        | ((dr - dg + 8) << 4)
                                        | (db - dg + 8);
                        printf("%X", result);
                    } else {
                        if(header.channels == 4){
                            printf("%X%X", 0xFF, value);
                        }
                        else{
                            printf("%X%X", 0xFE, value);
                        }
                        
                    }
                }
                
            } 

            value_prev = value;
            r_prev = r[h][w];
            g_prev = g[h][w];
            b_prev = b[h][w];
            a_prev = a[h][w];
        }
    }

    if(rle > -1 || rle == 62) {
        printf("%X", 0b11000000 + rle);
        rle = -1;
    }

    printf("%0*X", 16, 1);

    return 0;
}

    
