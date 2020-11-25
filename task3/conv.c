#include <string.h>
#include <stdint.h>
#include <stdio.h>

int64_t pow1 (int64_t n, int64_t m) {
  int64_t res = 1;
  while (m > 0) {
    res *= n;
    m --;
  }
  return res;
}

size_t length1 (char *s){
  size_t len = 0;
  while (*s) {
    len += 1;
    s++;
  }
  return len;
}

int64_t strToInt (char* str, int base) { // Check for valid base
  if (base <= 1)
    goto error;
  if (base > 36)
    goto error;

  // Set initial sign
  int sign = 1;

  // Check for sign
  if (*str == '+') {
    str ++;
  }
  if (*str == '-') {
    sign = -1;
    str++;
  }
    
  char c = *str;
  int64_t res = 0;

  size_t remaining_len = length1(str);
  size_t base_mul = remaining_len;
  base_mul --; // Used as a multiplier for the base later

  while (remaining_len) {
    c = *str;
    
    if (c >= 97 && c <= 122) // char is in 'a'..'z'
      c -= 32; // Make uppercase
      
    // Adjust range if c is a letter
    if (c >= 65 && c <= 90) // Make 'A' follow '9'
      c -= 7;
    
    if (c < 48) // char < '0', thus always invalid
      goto error;
    
    c -= 48; // Make 0-based
    
    if (c >= base)
      goto error;
    
    int64_t temp64 = c; // Expand c to 64 bit
    
    int temp = base;
    
    
    temp = pow1(base, base_mul);
    temp64 *= temp;
    
    res += temp64;

    base_mul --;
    remaining_len --;
    str ++;
  }

  res *= sign;
  return res;
  
  error:
  res = 0;
  return res;
}

//
//finalres = 0
//return finalres

int main() {
  //printf("%ld\r\n", strToInt("+64", 10));
  printf("%ld\r\n", strToInt("FF", 16));
  /*
  printf("%ld\r\n", strToInt("1111", 2));
  printf("%ld\r\n", strToInt("1111", 1));
  printf("%ld\r\n", strToInt("1111", 37));
  */
  return 0;
}
