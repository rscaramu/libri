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

#define T 32

// VAR 0: nessun padding. VAR 1: [T][T+1]. VAR 2: swizzle.
template <int VAR>
__global__ void trasponi(const float* in, float* out,
                         int n) {
    __shared__ float tile[T][VAR == 1 ? T + 1 : T];
    int x = blockIdx.x * T + threadIdx.x;
    int y = blockIdx.y * T + threadIdx.y;
    for (int j = 0; j < T; j += blockDim.y) {
        int r = threadIdx.y + j;
        int c = (VAR == 2) ? (threadIdx.x ^ r) : threadIdx.x;
        tile[r][c] = in[(y + j) * n + x];
    }
    __syncthreads();
    x = blockIdx.y * T + threadIdx.x;
    y = blockIdx.x * T + threadIdx.y;
    for (int j = 0; j < T; j += blockDim.y) {
        int r = threadIdx.y + j;
        int c = (VAR == 2) ? (r ^ threadIdx.x) : r;
        out[(y + j) * n + x] = tile[threadIdx.x][c];
    }
}

template <int VAR>
float misura(const float* d_in, float* d_out, int n) {
    dim3 blocco(T, 8);
    dim3 griglia(n / T, n / T);
    trasponi<VAR><<<griglia, blocco>>>(d_in, d_out, n);
    CUDA_CHECK(cudaGetLastError());
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    for (int i = 0; i < 20; ++i)
        trasponi<VAR><<<griglia, blocco>>>(d_in, d_out, n);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return ms / 20;
}

int main() {
    const int n = 4096;
    size_t bytes = (size_t)n * n * sizeof(float);
    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMemset(d_in, 0, bytes));
    float m[3] = {misura<0>(d_in, d_out, n),
                  misura<1>(d_in, d_out, n),
                  misura<2>(d_in, d_out, n)};
    const char* nome[3] = {"nessuno", "padding", "swizzle"};
    for (int v = 0; v < 3; ++v)
        printf("%-8s %.3f ms (%.0f GB/s)\n", nome[v], m[v],
               2.0 * bytes / 1e9 / (m[v] * 1e-3));
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    return 0;
}
