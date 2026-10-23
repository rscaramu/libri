// vecadd.cu - somma di due vettori sulla GPU
#include <cstdio>
#include <cstdlib>
#include <cmath>
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

__global__ void vecadd(const float* a, const float* b,
                       float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main(int argc, char** argv) {
    int n = (argc > 1) ? atoi(argv[1]) : 1000000;
    size_t bytes = n * sizeof(float);

    // Dati sull'host
    float* h_a = (float*)malloc(bytes);
    float* h_b = (float*)malloc(bytes);
    float* h_c = (float*)malloc(bytes);
    for (int i = 0; i < n; i++) {
        h_a[i] = (float)i;
        h_b[i] = 2.0f * i;
    }

    // Memoria sul device e copia in ingresso
    float *d_a, *d_b, *d_c;
    CUDA_CHECK(cudaMalloc(&d_a, bytes));
    CUDA_CHECK(cudaMalloc(&d_b, bytes));
    CUDA_CHECK(cudaMalloc(&d_c, bytes));
    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bytes,
                          cudaMemcpyHostToDevice));

    // Configurazione e lancio
    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    printf("n = %d, %d blocchi da %d thread\n",
           n, blocks, threads);
    vecadd<<<blocks, threads>>>(d_a, d_b, d_c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copia del risultato e verifica
    CUDA_CHECK(cudaMemcpy(h_c, d_c, bytes,
                          cudaMemcpyDeviceToHost));
    int errori = 0;
    for (int i = 0; i < n; i++) {
        if (fabsf(h_c[i] - 3.0f * i) > 1e-3f * i) errori++;
    }
    printf("c[0] = %.1f, c[%d] = %.1f, errori: %d\n",
           h_c[0], n - 1, h_c[n - 1], errori);

    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
