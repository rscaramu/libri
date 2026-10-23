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

__global__ void contaIngenuo(int* c) {
    *c = *c + 1;
}

__global__ void contaAtomico(int* c) {
    atomicAdd(c, 1);
}

int main() {
    int* d_c;
    int h_c;
    CUDA_CHECK(cudaMalloc(&d_c, sizeof(int)));
    for (int v = 0; v < 2; ++v) {
        CUDA_CHECK(cudaMemset(d_c, 0, sizeof(int)));
        if (v) contaAtomico<<<1024, 256>>>(d_c);
        else contaIngenuo<<<1024, 256>>>(d_c);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaMemcpy(&h_c, d_c, sizeof(int),
                              cudaMemcpyDeviceToHost));
        printf("%s: %d (attesi 262144)\n",
               v ? "atomico" : "ingenuo", h_c);
    }
    CUDA_CHECK(cudaFree(d_c));
    return 0;
}
