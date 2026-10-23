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

int main() {
    int dev = 0;
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, dev));
    printf("GPU: %s (cc %d.%d)\n", p.name, p.major, p.minor);
    printf("SM: %d\n", p.multiProcessorCount);
    printf("Warp size: %d\n", p.warpSize);
    printf("Thread max per SM: %d\n",
           p.maxThreadsPerMultiProcessor);
    printf("Blocchi max per SM: %d\n",
           p.maxBlocksPerMultiProcessor);
    printf("Registri per SM: %d\n", p.regsPerMultiprocessor);
    printf("Shared per SM: %zu KB\n",
           p.sharedMemPerMultiprocessor / 1024);
    int khz = 0;
    CUDA_CHECK(cudaDeviceGetAttribute(
        &khz, cudaDevAttrClockRate, dev));
    printf("Clock SM: %.2f GHz\n", khz / 1.0e6);
    int warps = p.maxThreadsPerMultiProcessor / p.warpSize;
    printf("Warp residenti max per SM: %d\n", warps);
    return 0;
}
