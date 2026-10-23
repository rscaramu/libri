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

// Filtro fittizio: qualche centinaio di operazioni per
// elemento, per avere un calcolo non trascurabile.
__global__ void filter(const float* in, float* out,
                       int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float x = in[i];
    for (int k = 0; k < 400; ++k) x = x * 0.998f + 0.002f;
    out[i] = x;
}

int main() {
    const int n = 50 * 1024 * 1024;   // 200 MB di float
    const size_t bytes = n * sizeof(float);
    const int nStreams = 4, nChunks = 8;
    const int chunk = n / nChunks;
    float *h_in, *h_out, *d_in, *d_out;
    CUDA_CHECK(cudaMallocHost(&h_in, bytes));   // pinned
    CUDA_CHECK(cudaMallocHost(&h_out, bytes));
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    for (int i = 0; i < n; ++i) h_in[i] = (i % 100) * 0.01f;

    cudaStream_t s[nStreams];
    for (int i = 0; i < nStreams; ++i)
        CUDA_CHECK(cudaStreamCreateWithFlags(
            &s[i], cudaStreamNonBlocking));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    float ms;

    // Versione sequenziale.
    CUDA_CHECK(cudaEventRecord(t0, s[0]));
    CUDA_CHECK(cudaMemcpyAsync(d_in, h_in, bytes,
                               cudaMemcpyHostToDevice, s[0]));
    filter<<<(n + 255) / 256, 256, 0, s[0]>>>(d_in, d_out, n);
    CUDA_CHECK(cudaMemcpyAsync(h_out, d_out, bytes,
                               cudaMemcpyDeviceToHost, s[0]));
    CUDA_CHECK(cudaEventRecord(t1, s[0]));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("sequenziale: %.2f ms\n", ms);

    // Pipeline a chunk.
    CUDA_CHECK(cudaDeviceSynchronize());
    CUDA_CHECK(cudaEventRecord(t0, s[0]));
    for (int c = 0; c < nChunks; ++c) {
        cudaStream_t st = s[c % nStreams];
        int off = c * chunk;
        size_t cb = chunk * sizeof(float);
        CUDA_CHECK(cudaMemcpyAsync(d_in + off, h_in + off,
            cb, cudaMemcpyHostToDevice, st));
        filter<<<(chunk + 255) / 256, 256, 0, st>>>(
            d_in + off, d_out + off, chunk);
        CUDA_CHECK(cudaMemcpyAsync(h_out + off, d_out + off,
            cb, cudaMemcpyDeviceToHost, st));
    }
    for (int i = 0; i < nStreams; ++i)
        CUDA_CHECK(cudaStreamSynchronize(s[i]));
    CUDA_CHECK(cudaEventRecord(t1, s[0]));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("pipeline %d stream, %d chunk: %.2f ms\n",
           nStreams, nChunks, ms);
    CUDA_CHECK(cudaGetLastError());

    printf("verifica: out[12345] = %.4f\n", h_out[12345]);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    for (int i = 0; i < nStreams; ++i)
        CUDA_CHECK(cudaStreamDestroy(s[i]));
    CUDA_CHECK(cudaFreeHost(h_in));
    CUDA_CHECK(cudaFreeHost(h_out));
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    return 0;
}
