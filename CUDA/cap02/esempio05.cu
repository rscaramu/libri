// buffer.cu - dimensione del buffer di printf
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

__global__ void stampa() {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    printf("riga del thread globale numero %6d\n", id);
}

int main(int argc, char** argv) {
    size_t mib = (argc > 1) ? atol(argv[1]) : 1;
    CUDA_CHECK(cudaDeviceSetLimit(
        cudaLimitPrintfFifoSize, mib << 20));
    stampa<<<256, 256>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    return 0;
}
