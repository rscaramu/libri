#include <cstdio>
#include <cstdlib>
#include <cstring>
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

static float misura(void* h, void* d, size_t bytes) {
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    for (int r = 0; r < 10; ++r)
        CUDA_CHECK(cudaMemcpy(d, h, bytes,
                              cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms = 0.0f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return bytes * 10.0f / (ms * 1e6f);
}

int main() {
    const size_t bytes = 256u << 20;
    void* d;
    CUDA_CHECK(cudaMalloc(&d, bytes));
    void* pag = malloc(bytes);
    void* pin;
    CUDA_CHECK(cudaMallocHost(&pin, bytes));
    memset(pag, 1, bytes);
    memset(pin, 1, bytes);
    printf("paginabile: %6.1f GB/s\n", misura(pag, d, bytes));
    printf("pinned:     %6.1f GB/s\n", misura(pin, d, bytes));
    CUDA_CHECK(cudaFreeHost(pin));
    free(pag);
    CUDA_CHECK(cudaFree(d));
    return 0;
}
