// hello.cu - primo programma con un kernel
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

// Il kernel: una funzione eseguita da ogni thread
__global__ void saluta() {
    printf("Ciao dal thread %d del blocco %d\n",
           threadIdx.x, blockIdx.x);
}

int main() {
    printf("Host: lancio il kernel\n");
    saluta<<<2, 4>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    printf("Host: kernel terminato\n");
    return 0;
}
