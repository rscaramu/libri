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

const int W = 64;      // ampiezza della finestra
const int BLK = 256;

__global__ void media_globale(const float* x, float* y,
                              int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float s = 0.0f;
    for (int k = 0; k < W; ++k) {
        int j = i - k;
        if (j >= 0) s += x[j];
    }
    y[i] = s / W;
}

__global__ void media_condivisa(const float* x, float* y,
                                int n) {
    __shared__ float tile[BLK + W - 1];
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int base = blockIdx.x * blockDim.x - (W - 1);
    // ogni thread carica uno o due elementi del tile
    for (int t = threadIdx.x; t < BLK + W - 1; t += BLK) {
        int j = base + t;
        tile[t] = (j >= 0 && j < n) ? x[j] : 0.0f;
    }
    __syncthreads();
    if (i >= n) return;
    float s = 0.0f;
    for (int k = 0; k < W; ++k)
        s += tile[threadIdx.x + W - 1 - k];
    y[i] = s / W;
}

typedef void (*Kern)(const float*, float*, int);

float misura(Kern k, float* x, float* y, int n, int grd) {
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    k<<<grd, BLK>>>(x, y, n);              // warm-up
    CUDA_CHECK(cudaEventRecord(t0));
    k<<<grd, BLK>>>(x, y, n);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaGetLastError());
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return ms;
}

int main() {
    const int n = 1 << 24;
    float *d_x, *d_y;
    CUDA_CHECK(cudaMalloc(&d_x, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_y, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d_x, 0, n * sizeof(float)));
    int grd = (n + BLK - 1) / BLK;
    printf("solo globale:  %.2f ms\n",
           misura(media_globale, d_x, d_y, n, grd));
    printf("con condivisa: %.2f ms\n",
           misura(media_condivisa, d_x, d_y, n, grd));
    CUDA_CHECK(cudaFree(d_x));
    CUDA_CHECK(cudaFree(d_y));
    return 0;
}
