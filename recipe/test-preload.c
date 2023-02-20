#include <stdlib.h>

int main(void) {

  for (size_t i = 0; i < 1000; i++) {
    // Leak some memory
    malloc(i * 1000);
  }
}
