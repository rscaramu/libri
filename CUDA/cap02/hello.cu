// ultimo.cu - una riga per blocco dall'ultimo thread
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

__global__ void ultimo() {
    if (threadIdx.x == blockDim.x - 1) {
        int totale = gridDim.x * blockDim.x;
        printf("Blocco %d: ultimo thread %d, "
               "totale %d thread\n",
               blockIdx.x, threadIdx.x, totale);
    }
}

int main() {
    ultimo<<<4, 64>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    return 0;
}
