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

__global__ void saxpy(int n, float a, const float* x,
                      float* y) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) y[i] = a * x[i] + y[i];
}

int main() {
    const int n = 1 << 26;
    float *d_x, *d_y;
    CUDA_CHECK(cudaMalloc(&d_x, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_y, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d_x, 0, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d_y, 0, n * sizeof(float)));
    int blocchi = (n + 255) / 256;
    saxpy<<<blocchi, 256>>>(n, 2.0f, d_x, d_y);  // warm-up
    CUDA_CHECK(cudaGetLastError());

    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    const int rip = 20;
    CUDA_CHECK(cudaEventRecord(t0));
    for (int r = 0; r < rip; ++r)
        saxpy<<<blocchi, 256>>>(n, 2.0f, d_x, d_y);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    ms /= rip;
    double byte = 3.0 * n * sizeof(float);
    double gbs = byte / (ms * 1e-3) / 1e9;
    printf("tempo %.3f ms, banda %.1f GB/s, "
           "GFLOP/s %.1f\n", ms, gbs, 2.0 * n / ms / 1e6);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d_x));
    CUDA_CHECK(cudaFree(d_y));
    return 0;
}
