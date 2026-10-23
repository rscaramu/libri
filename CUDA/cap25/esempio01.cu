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

// Somma le righe di una matrice n x n: un thread per riga.
// Ogni thread legge con passo n: accesso non coalescente.
__global__ void somma_righe_lenta(const float* m, float* out,
                                  int n) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    if (r >= n) return;
    float acc = 0.0f;
    for (int c = 0; c < n; ++c) acc += m[r * n + c];
    out[r] = acc;
}

__global__ void scala(float* v, int n, float k) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] *= k;
}

int main() {
    const int n = 4096;
    const size_t bytes = (size_t)n * n * sizeof(float);
    float* h_m = (float*)malloc(bytes);
    float* h_out = (float*)malloc(n * sizeof(float));
    for (size_t i = 0; i < (size_t)n * n; ++i)
        h_m[i] = 1.0f;

    float *d_m, *d_out;
    CUDA_CHECK(cudaMalloc(&d_m, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, n * sizeof(float)));

    for (int iter = 0; iter < 5; ++iter) {
        CUDA_CHECK(cudaMemcpy(d_m, h_m, bytes,
                              cudaMemcpyHostToDevice));
        somma_righe_lenta<<<(n + 255) / 256, 256>>>(
            d_m, d_out, n);
        CUDA_CHECK(cudaGetLastError());
        scala<<<(n + 255) / 256, 256>>>(d_out, n, 0.5f);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaMemcpy(h_out, d_out, n * sizeof(float),
                              cudaMemcpyDeviceToHost));
    }
    printf("out[0] = %.1f, out[n-1] = %.1f\n",
           h_out[0], h_out[n - 1]);
    CUDA_CHECK(cudaFree(d_m));
    CUDA_CHECK(cudaFree(d_out));
    free(h_m);
    free(h_out);
    return 0;
}
