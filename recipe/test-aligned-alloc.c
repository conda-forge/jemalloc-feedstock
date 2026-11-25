#include <stdlib.h>

int main() {
  // aligned_alloc and free must both come from jemalloc
  void* a = aligned_alloc(64, 4096);
  free(a);
}
