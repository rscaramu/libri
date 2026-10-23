#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cuda_runtime.h>
#include <cuda_fp16.h>
#include <mma.h>

using namespace nvcuda;

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

#define WM 16
#define WN 16
#define WK 16

// C (MxN, float) = A (MxK, half) * B (KxN, half).
// Un warp per tile 16x16 di C; M, N, K multipli di 16.
// Blocco di 128 thread = 4 warp, disposti 2x2.
__global__ void gemm_wmma(const half* A, const half* B,
                          float* C, int M, int N, int K) {
    int warp = (threadIdx.x / 32);
    int wr = blockIdx.y * 2 + warp / 2;   // riga di tile
    int wc = blockIdx.x * 2 + warp % 2;   // colonna di tile
    if (wr * WM >= M || wc * WN >= N) return;

    wmma::fragment<wmma::matrix_a, WM, WN, WK, half,
                   wmma::row_major> fa;
    wmma::fragment<wmma::matrix_b, WM, WN, WK, half,
                   wmma::row_major> fb;
    wmma::fragment<wmma::accumulator, WM, WN, WK, float> fc;
    wmma::fill_fragment(fc, 0.0f);

    for (int k = 0; k < K; k += WK) {
        const half* pa = A + (wr * WM) * K + k;
        const half* pb = B + k * N + wc * WN;
        wmma::load_matrix_sync(fa, pa, K);
        wmma::load_matrix_sync(fb, pb, N);
        wmma::mma_sync(fc, fa, fb, fc);
    }
    float* pc = C + (wr * WM) * N + wc * WN;
    wmma::store_matrix_sync(pc, fc, N, wmma::mem_row_major);
}

int main() {
    const int M = 2048, N = 2048, K = 2048;
    size_t ba = (size_t)M * K * sizeof(half);
    size_t bb = (size_t)K * N * sizeof(half);
    size_t bc = (size_t)M * N * sizeof(float);
    half* h_a = (half*)malloc(ba);
    half* h_b = (half*)malloc(bb);
    float* h_c = (float*)malloc(bc);
    for (int i = 0; i < M * K; ++i)
        h_a[i] = __float2half(0.01f * (i % 17));
    for (int i = 0; i < K * N; ++i)
        h_b[i] = __float2half(0.02f * (i % 13));
    half *d_a, *d_b;
    float* d_c;
    CUDA_CHECK(cudaMalloc(&d_a, ba));
    CUDA_CHECK(cudaMalloc(&d_b, bb));
    CUDA_CHECK(cudaMalloc(&d_c, bc));
    CUDA_CHECK(cudaMemcpy(d_a, h_a, ba,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bb,
                          cudaMemcpyHostToDevice));

    dim3 blocco(128);
    dim3 griglia(N / (2 * WN), M / (2 * WM));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    gemm_wmma<<<griglia, blocco>>>(d_a, d_b, d_c, M, N, K);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaMemcpy(h_c, d_c, bc,
                          cudaMemcpyDeviceToHost));
    double flop = 2.0 * M * N * K;
    printf("wmma %.3f ms (%.1f TFLOP/s), "
           "C[1000][777] = %.4f\n",
           ms, flop / (ms * 1e-3) / 1e12,
           h_c[1000 * N + 777]);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
