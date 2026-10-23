// devquery.cu - interroga le GPU presenti nel sistema
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
    int count = 0;
    CUDA_CHECK(cudaGetDeviceCount(&count));
    printf("GPU trovate: %d\n", count);

    int drv = 0, rt = 0;
    CUDA_CHECK(cudaDriverGetVersion(&drv));
    CUDA_CHECK(cudaRuntimeGetVersion(&rt));
    printf("Driver CUDA %d.%d, runtime %d.%d\n",
           drv / 1000, (drv % 1000) / 10,
           rt / 1000, (rt % 1000) / 10);

    for (int d = 0; d < count; d++) {
        cudaDeviceProp p;
        CUDA_CHECK(cudaGetDeviceProperties(&p, d));
        printf("\nDispositivo %d: %s\n", d, p.name);
        printf("  Compute capability: %d.%d\n",
               p.major, p.minor);
        printf("  SM: %d\n", p.multiProcessorCount);
        printf("  Memoria globale: %.1f GiB\n",
               p.totalGlobalMem / (1024.0 * 1024 * 1024));
        printf("  Clock: %.2f GHz\n",
               p.clockRate / 1.0e6);
        printf("  Larghezza bus: %d bit\n",
               p.memoryBusWidth);
        printf("  Clock memoria: %.2f GHz\n",
               p.memoryClockRate / 1.0e6);
        printf("  Thread max per blocco: %d\n",
               p.maxThreadsPerBlock);
        printf("  Thread max per SM: %d\n",
               p.maxThreadsPerMultiProcessor);
        printf("  Warp: %d thread\n", p.warpSize);
        printf("  Shared per blocco: %zu KiB\n",
               p.sharedMemPerBlock / 1024);
        printf("  Registri per blocco: %d\n",
               p.regsPerBlock);
        printf("  Cache L2: %d KiB\n",
               p.l2CacheSize / 1024);
    }
    return 0;
}
