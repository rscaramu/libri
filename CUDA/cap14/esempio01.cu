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

__device__ float heavyA(float x) {
    for (int i = 0; i < 1000; ++i) x = x * 0.999f + 0.001f;
    return x;
}

__device__ float heavyB(float x) {
    for (int i = 0; i < 1000; ++i) x = x * 1.001f - 0.001f;
    return x;
}

// mode 0: nessuna divergenza (per blocco)
// mode 1: divergenza per warp (lane pari/dispari)
__global__ void branchTest(float* out, int mode) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    bool cond = (mode == 0) ? (blockIdx.x & 1)
                            : (threadIdx.x & 1);
    float x = (float)i;
    if (cond) x = heavyA(x);
    else      x = heavyB(x);
    out[i] = x;
}

int main() {
    const int n = 1 << 22;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, n * sizeof(float)));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    for (int mode = 0; mode < 2; ++mode) {
        branchTest<<<n / 256, 256>>>(d, mode);
        CUDA_CHECK(cudaDeviceSynchronize());
        CUDA_CHECK(cudaEventRecord(t0));
        branchTest<<<n / 256, 256>>>(d, mode);
        CUDA_CHECK(cudaEventRecord(t1));
        CUDA_CHECK(cudaEventSynchronize(t1));
        float ms;
        CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
        printf("mode %d: %.3f ms\n", mode, ms);
    }
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
