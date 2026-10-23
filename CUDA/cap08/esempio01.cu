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

template <typename F>
float cronometra(F lancio) {
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    lancio();                                  // warm-up
    CUDA_CHECK(cudaEventRecord(t0));
    for (int r = 0; r < 10; ++r) lancio();
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaGetLastError());
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return ms / 10;                           // ms per lancio
}

__global__ void leggi_stride(const float* in, float* out,
                             int n, int stride) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = in[(size_t)i * stride];
}

int main() {
    const int n = 1 << 22;          // 4 M elementi letti
    const int max_stride = 32;
    float *d_in, *d_out;
    size_t in_bytes = (size_t)n * max_stride * sizeof(float);
    CUDA_CHECK(cudaMalloc(&d_in, in_bytes));
    CUDA_CHECK(cudaMalloc(&d_out, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d_in, 0, in_bytes));
    int blk = 256, grd = (n + blk - 1) / blk;
    double gb = 2.0 * n * sizeof(float) / 1e9;  // byte utili
    for (int s = 1; s <= max_stride; s *= 2) {
        float ms = cronometra([&] {
            leggi_stride<<<grd, blk>>>(d_in, d_out, n, s);
        });
        printf("stride %2d: %6.1f GB/s\n", s, gb / ms * 1e3);
    }
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    return 0;
}
