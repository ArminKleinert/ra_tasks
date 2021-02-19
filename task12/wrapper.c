#include <inttypes.h>
#include <limits.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern uint8_t* function(size_t, uint8_t*);

void prarray(size_t len, uint8_t* arr) {
  for (size_t i = 0; i < len; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}

int main() {
  uint8_t array[] = {1,2,3,4,5,6,7,8};
  prarray(8, array);
  function(8, array);
  prarray(8, array);
  return 0;
}
