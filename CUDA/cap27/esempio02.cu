#include <cstdio>
#include <cuda_fp16.h>
#include <cuda_bf16.h>

int main() {
    const float v[] = {0.1f, 10.0f, 1000.0f, 10000.0f};
    printf("%10s %12s %12s\n", "valore", "ulp FP16",
           "ulp BF16");
    for (float x : v) {
        half h = __float2half(x);
        unsigned short hb = __half_as_ushort(h);
        half h1 = __ushort_as_half(hb + 1);
        float uh = __half2float(h1) - __half2float(h);
        __nv_bfloat16 b = __float2bfloat16(x);
        unsigned short bb = __bfloat16_as_ushort(b);
        __nv_bfloat16 b1 = __ushort_as_bfloat16(bb + 1);
        float ub = __bfloat162float(b1) - __bfloat162float(b);
        printf("%10.1f %12.6f %12.6f\n", x, uh, ub);
    }
    return 0;
}
