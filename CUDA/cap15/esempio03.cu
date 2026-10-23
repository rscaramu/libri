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

__global__ void work(float* out, int iters) {
    float x = threadIdx.x;
    for (int i = 0; i < iters; ++i) x = x * 0.999f + 0.1f;
    out[blockIdx.x * blockDim.x + threadIdx.x] = x;
}

int main() {
    int lo, hi;
    CUDA_CHECK(cudaDeviceGetStreamPriorityRange(&lo, &hi));
    printf("priorita': bassa %d, alta %d\n", lo, hi);
    cudaStream_t sLow, sHigh;
    CUDA_CHECK(cudaStreamCreateWithPriority(
        &sLow, cudaStreamNonBlocking, lo));
    CUDA_CHECK(cudaStreamCreateWithPriority(
        &sHigh, cudaStreamNonBlocking, hi));
    const int big = 4000, small = 46;
    float *dLow, *dHigh;
    CUDA_CHECK(cudaMalloc(&dLow, big * 256 * 4));
    CUDA_CHECK(cudaMalloc(&dHigh, small * 256 * 4));
    cudaEvent_t tStart, tHigh, tLow;
    CUDA_CHECK(cudaEventCreate(&tStart));
    CUDA_CHECK(cudaEventCreate(&tHigh));
    CUDA_CHECK(cudaEventCreate(&tLow));

    CUDA_CHECK(cudaEventRecord(tStart, sLow));
    work<<<big, 256, 0, sLow>>>(dLow, 200000);   // lungo
    CUDA_CHECK(cudaEventRecord(tLow, sLow));
    work<<<small, 256, 0, sHigh>>>(dHigh, 200000); // breve
    CUDA_CHECK(cudaEventRecord(tHigh, sHigh));
    CUDA_CHECK(cudaEventSynchronize(tLow));
    CUDA_CHECK(cudaEventSynchronize(tHigh));
    float msHigh, msLow;
    CUDA_CHECK(cudaEventElapsedTime(&msHigh, tStart, tHigh));
    CUDA_CHECK(cudaEventElapsedTime(&msLow, tStart, tLow));
    printf("fine kernel alta priorita': %.2f ms\n", msHigh);
    printf("fine kernel bassa priorita': %.2f ms\n", msLow);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventDestroy(tStart));
    CUDA_CHECK(cudaEventDestroy(tHigh));
    CUDA_CHECK(cudaEventDestroy(tLow));
    CUDA_CHECK(cudaStreamDestroy(sLow));
    CUDA_CHECK(cudaStreamDestroy(sHigh));
    CUDA_CHECK(cudaFree(dLow));
    CUDA_CHECK(cudaFree(dHigh));
    return 0;
}
