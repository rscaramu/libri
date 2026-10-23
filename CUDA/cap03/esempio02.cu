// blocksize.cu - tempo di vecadd al variare del blocco
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

__global__ void vecadd(const float* a, const float* b,
                       float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

int main() {
    const int n = 1 << 24;   // 16 M elementi
    size_t bytes = n * sizeof(float);
    float *d_a, *d_b, *d_c;
    CUDA_CHECK(cudaMalloc(&d_a, bytes));
    CUDA_CHECK(cudaMalloc(&d_b, bytes));
    CUDA_CHECK(cudaMalloc(&d_c, bytes));
    CUDA_CHECK(cudaMemset(d_a, 0, bytes));
    CUDA_CHECK(cudaMemset(d_b, 0, bytes));

    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));

    int sizes[] = {32, 64, 128, 256, 512, 1024};
    for (int s = 0; s < 6; s++) {
        int threads = sizes[s];
        int blocks = (n + threads - 1) / threads;
        vecadd<<<blocks, threads>>>(d_a, d_b, d_c, n);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaEventRecord(t0));
        for (int r = 0; r < 20; r++)
            vecadd<<<blocks, threads>>>(d_a, d_b, d_c, n);
        CUDA_CHECK(cudaEventRecord(t1));
        CUDA_CHECK(cudaEventSynchronize(t1));
        float ms = 0;
        CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
        ms /= 20;
        double gbs = 3.0 * bytes / (ms * 1e6);
        printf("blocco %4d: %.3f ms, %.0f GB/s\n",
               threads, ms, gbs);
    }
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    return 0;
}
