#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

#define CUDA_CHECK(call)                                   \
    do {                                                   \
        cudaError_t err = (call);                          \
        if (err != cudaSuccess) {                          \
            fprintf(stderr, "Errore CUDA %s:%d: %s\n",     \
                    __FILE__, __LINE__,                    \
                    cudaGetErrorString(err));              \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

__device__ int warpScanInclusive(int v) {
    int lane = threadIdx.x & 31;
    for (int d = 1; d < 32; d <<= 1) {
        int up = __shfl_up_sync(0xffffffffu, v, d);
        if (lane >= d) v += up;
    }
    return v;
}

__global__ void scanTest(int* out) {
    int v = threadIdx.x + 1;        // 1, 2, ..., 32
    out[threadIdx.x] = warpScanInclusive(v);
}

int main() {
    int h[32];
    int* d;
    CUDA_CHECK(cudaMalloc(&d, 32 * sizeof(int)));
    scanTest<<<1, 32>>>(d);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h, d, 32 * sizeof(int),
                          cudaMemcpyDeviceToHost));
    printf("scan[0]=%d scan[3]=%d scan[31]=%d\n",
           h[0], h[3], h[31]);
    CUDA_CHECK(cudaFree(d));
    return 0;
}
