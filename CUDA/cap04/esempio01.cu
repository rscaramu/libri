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

__global__ void scala(float* v, float k, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] *= k;
}

int main() {
    const int n = 1 << 20;
    const size_t bytes = n * sizeof(float);

    float* h_v = (float*)malloc(bytes);
    for (int i = 0; i < n; ++i) h_v[i] = (float)i;

    float* d_v = nullptr;
    CUDA_CHECK(cudaMalloc((void**)&d_v, bytes));
    CUDA_CHECK(cudaMemcpy(d_v, h_v, bytes,
                          cudaMemcpyHostToDevice));

    int blocco = 256;
    int griglia = (n + blocco - 1) / blocco;
    scala<<<griglia, blocco>>>(d_v, 2.0f, n);
    CUDA_CHECK(cudaGetLastError());

    CUDA_CHECK(cudaMemcpy(h_v, d_v, bytes,
                          cudaMemcpyDeviceToHost));

    printf("h_v[0]=%.1f h_v[1]=%.1f h_v[%d]=%.1f\n",
           h_v[0], h_v[1], n - 1, h_v[n - 1]);

    CUDA_CHECK(cudaFree(d_v));
    free(h_v);
    return 0;
}
