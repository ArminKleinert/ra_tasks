#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef union {
  uint32_t i;
  float f;
} float_int_t;

uint32_t ftoi(float f) {
  float_int_t fit;
  fit.f = f;
  return fit.i;
}

float itof(uint32_t i) {
  float_int_t fit;
  fit.i = i;
  return fit.f;
}

uint32_t calc_add(uint32_t f0, uint32_t f1) {
  calc_add_start:
  uint32_t f0_m, f1_m;
  uint32_t f0_ex, f1_ex;
  
  f0_m  = f0 & 0x7FFFFF + 0x800000;
  f1_m  = f0 & 0x7FFFFF + 0x800000;
  f0_ex = (f0 >> 23) & 0xFF;
  f1_ex = (f1 >> 23) & 0xFF;
  
  if (f0_ex > f1_ex) {
    uint32_t temp = f0;
    f0 = f1;
    f1 = temp;
    goto calc_add_start;
  }
  
  while (f1_ex > 0) {
    f0_m >>= 1;
    f1_ex -= 1;
  }
  
  /*
  f0_sign = f0 >> 31;
  f1_sign = f1 >> 31;
  if (f0_sign != f1_sign) {
    if (f0_m > f1_m) {
      f0_m -= f1_m;
    } else {
      f1_m -= f2_m;
    }
  } else {
  */
  
  f0_m += f1_m;
  
  // }
  
  // Hidden bit entfernen
  f0_m &= 0x7FFFFF;
  
  // Normalisieren
  f0_m <<= 8;
  f0_ex += 1;
  while (f0_m <= 0xFFFFFFFF) {
    f0_ex -= 1;
    f0_m <<= 1;
  }
  
  f0_m >>= 9
  r0_ex <<= 23;
  f0_m |= f0_ex;
  
  // xmm0 = f0_m;
  // ret ; xmm0
  return f0_m;
  return (f0_ex << 23) | f0_m
}
