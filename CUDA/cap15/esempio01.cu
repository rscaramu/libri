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

// Kernel piccolo (pochi blocchi) e lungo: lascia
// SM liberi per un altro kernel concorrente.
__global__ void slowKernel(float* out, int iters) {
    float x = threadIdx.x;
    for (int i = 0; i < iters; ++i) x = x * 0.999f + 0.1f;
    out[blockIdx.x * blockDim.x + threadIdx.x] = x;
}

int main() {
    const int blocks = 8, threads = 256;
    const int iters = 2000000;
    float *d0, *d1;
    CUDA_CHECK(cudaMalloc(&d0, blocks * threads * 4));
    CUDA_CHECK(cudaMalloc(&d1, blocks * threads * 4));
    cudaStream_t s0, s1;
    CUDA_CHECK(cudaStreamCreate(&s0));
    CUDA_CHECK(cudaStreamCreate(&s1));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    float ms;

    // Sequenziale: entrambi nello stream di default.
    CUDA_CHECK(cudaEventRecord(t0));
    slowKernel<<<blocks, threads>>>(d0, iters);
    slowKernel<<<blocks, threads>>>(d1, iters);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("stream di default: %.2f ms\n", ms);

    // Concorrente: uno per stream.
    CUDA_CHECK(cudaEventRecord(t0));
    slowKernel<<<blocks, threads, 0, s0>>>(d0, iters);
    slowKernel<<<blocks, threads, 0, s1>>>(d1, iters);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("due stream:        %.2f ms\n", ms);

    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaStreamDestroy(s0));
    CUDA_CHECK(cudaStreamDestroy(s1));
    CUDA_CHECK(cudaFree(d0));
    CUDA_CHECK(cudaFree(d1));
    return 0;
}
