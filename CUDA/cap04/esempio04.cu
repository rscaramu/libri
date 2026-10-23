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
    const int n = 1000;
    const size_t bytes = n * sizeof(int);
    int* h_a = (int*)malloc(bytes);
    int* h_b = (int*)malloc(bytes);
    for (int i = 0; i < n; ++i) h_a[i] = i;

    int *d_a = nullptr, *d_b = nullptr;
    CUDA_CHECK(cudaMalloc((void**)&d_a, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_b, bytes));
    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, d_a, bytes,
                          cudaMemcpyDeviceToDevice));
    CUDA_CHECK(cudaMemcpy(h_b, d_b, bytes,
                          cudaMemcpyDeviceToHost));

    int errori = 0;
    for (int i = 0; i < n; ++i)
        if (h_b[i] != i) ++errori;
    printf("elementi errati: %d\n", errori);

    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    free(h_a);
    free(h_b);
    return errori == 0 ? 0 : 1;
}
