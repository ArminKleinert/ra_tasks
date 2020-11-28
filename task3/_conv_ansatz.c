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
    return 0;
  if (base > 36)
    return 0;

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
      return 0;
    
    c -= 48; // Make 0-based
    
    if (c >= base)
      return 0;
    
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
}

// -----------------------------------------------

#include <stdbool.h>

void reverse(char arr[], size_t n) {
    for (int low = 0, high = n - 1; low < high; low++, high--) {
        int temp = arr[low];
        arr[low] = arr[high];
        arr[high] = temp;
    }
}

size_t intToStr(int64_t num, uint8_t base, char* str, size_t buf_len) { 
  char* buffer = str;
  size_t bytes_written = 0; 
  bool isNegative = false; 
  int64_t rem = 0;
  
  // Error cases
  if (base <= 1)
    return 0;
  if (base > 36)
    return 0;
  if (buf_len < 2)
    return 0;
  if (buffer == NULL)
    return 0;

  // Number is 0
  if (num == 0) {
      *buffer = '0'; // =48
      buffer++;
      *buffer = '\0'; // =0
      return 1; 
  } 

  // Number is negative
  if (num < 0) {
      isNegative = true; 
      num = -num; 
  }

  // Process individual digits
  while (num > 0) {
    if (bytes_written >= buf_len-1)
      return bytes_written;

    rem = num % base;

    if (rem > 9) {
      // Need letter
      rem -= 10;
      rem += 'A'; // +65
      *buffer = rem;
    } else {
      // Need digit
      rem += '0'; // +48
      *buffer = rem;
    }
    
    buffer ++;
    bytes_written ++;
    num = num / base;
  }

  // If number is negative, append '-'
  if (isNegative) {
    *buffer = '-';
    buffer ++;
    bytes_written ++;
  }

  *buffer = '\0'; // Append string terminator

  // Reverse the string 
  reverse(str, bytes_written); 

  return bytes_written; 
}

int main() {
  //printf("%ld\r\n", strToInt("+64", 10));
  char s0[15]; 
  char s1[15]; 
  char s2[15]; 
  char s3[15]; 
  char s4[15]; 
  char s5[15]; 
  char s6[2]; 
  char s7[15]; 
  char s8[15]; 
  
  printf("%lu\r\n", intToStr(24, 10, s0, 15));
  printf("%s\r\n", s0);
  printf("%lu\r\n", intToStr(-24, 10, s1, 15));
  printf("%s\r\n", s1);
  printf("\r\n");
  printf("%lu\r\n", intToStr(11, 2, s2, 15));
  printf("%s\r\n", s2);
  printf("%lu\r\n", intToStr(-11, 2, s3, 15));
  printf("%s\r\n", s3);
  printf("\r\n");
  printf("%lu\r\n", intToStr(15, 8, s4, 15));
  printf("%s\r\n", s4);
  printf("%lu\r\n", intToStr(-15, 8, s5, 15));
  printf("%s\r\n", s5);
  printf("\r\n");
  printf("%lu\r\n", intToStr(-15, 16, s6, 2));
  printf("%s\r\n", s6);
  printf("%lu\r\n", intToStr(22570, 36, s7, 15));
  printf("%s\r\n", s7);
  printf("\r\n");
  printf("%lu\r\n", intToStr(0, 10, s8, 10));
  printf("%s\r\n", s8);
  
  /*
  printf("%ld\r\n", strToInt("1111", 2));
  printf("%ld\r\n", strToInt("1111", 1));
  printf("%ld\r\n", strToInt("1111", 37));
  */
  return 0;
}
