#include <inttypes.h>
#include <stdio.h>

void arrprint(int64_t* arr, size_t s) {
  for (size_t i = 0; i < s; i++) {
    printf("%ld\n", arr[i]);
  }
}

size_t fn(int64_t* inp, size_t size, int64_t* outp) {
  size_t i = 0;
  size_t j = 0;

  if (size==0) {
    return 0;
  }

  outp[0] = inp[0];
  i++;

  while (i < size) {
    int64_t rcx = inp[i];
    if (rcx > outp[j]) {
      j++;
      outp[j] = rcx;
    }

    i++;
  }

  return j+1;
}

int main() {
  int64_t inp[8] = {1,2,5,3,10,8,12,8};
  size_t s = 8;
  int64_t outp[8] = {0};
  
  size_t res = fn(inp, s, outp);
  arrprint(outp, res);
  
  return 0;
}
