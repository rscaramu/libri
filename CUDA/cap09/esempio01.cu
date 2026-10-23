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

const int TILE = 32;
const int ROWS = 8;     // righe di thread per blocco

__global__ void trasponi_naive(const float* in, float* out,
                               int n) {
    int c = blockIdx.x * TILE + threadIdx.x;
    int r = blockIdx.y * TILE + threadIdx.y;
    for (int k = 0; k < TILE; k += ROWS)
        out[c * n + r + k] = in[(r + k) * n + c];
}

__global__ void trasponi_tile(const float* in, float* out,
                              int n) {
    __shared__ float tile[TILE][TILE + 1];
    int tx = threadIdx.x, ty = threadIdx.y;
    int c = blockIdx.x * TILE + tx;
    int r = blockIdx.y * TILE + ty;
    for (int k = 0; k < TILE; k += ROWS)
        tile[ty + k][tx] = in[(r + k) * n + c];
    __syncthreads();
    // il blocco (bx, by) scrive nel riquadro (by, bx)
    c = blockIdx.y * TILE + tx;
    r = blockIdx.x * TILE + ty;
    for (int k = 0; k < TILE; k += ROWS)
        out[(r + k) * n + c] = tile[tx][ty + k];
}

template <typename F>
float cronometra(F lancio) {
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    lancio();
    CUDA_CHECK(cudaEventRecord(t0));
    for (int i = 0; i < 10; ++i) lancio();
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaGetLastError());
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return ms / 10;
}

int main() {
    const int n = 4096;
    size_t bytes = (size_t)n * n * sizeof(float);
    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMemset(d_in, 0, bytes));
    dim3 blk(TILE, ROWS), grd(n / TILE, n / TILE);
    double gb = 2.0 * bytes / 1e9;
    float ms1 = cronometra([&] {
        trasponi_naive<<<grd, blk>>>(d_in, d_out, n); });
    float ms2 = cronometra([&] {
        trasponi_tile<<<grd, blk>>>(d_in, d_out, n); });
    printf("naive: %.3f ms  %.0f GB/s\n", ms1,
           gb / ms1 * 1e3);
    printf("tile:  %.3f ms  %.0f GB/s\n", ms2,
           gb / ms2 * 1e3);
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    return 0;
}
