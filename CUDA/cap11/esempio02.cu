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

__global__ void elabora(float* x, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float v = x[i];
    for (int k = 0; k < 3000; ++k) v = v * 0.999f + 0.001f;
    x[i] = v;
}

int main(int argc, char** argv) {
    const int n = 1 << 24;
    int nchunk = (argc > 1) ? atoi(argv[1]) : 4;
    int cn = n / nchunk;
    size_t cbytes = cn * sizeof(float);
    float* h;
    CUDA_CHECK(cudaMallocHost(&h, n * sizeof(float)));
    for (int i = 0; i < n; ++i) h[i] = 1.0f;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, n * sizeof(float)));
    cudaStream_t* s = new cudaStream_t[nchunk];
    for (int c = 0; c < nchunk; ++c)
        CUDA_CHECK(cudaStreamCreate(&s[c]));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    for (int c = 0; c < nchunk; ++c) {
        float* hc = h + c * cn;
        float* dc = d + c * cn;
        CUDA_CHECK(cudaMemcpyAsync(dc, hc, cbytes,
                                   cudaMemcpyHostToDevice,
                                   s[c]));
        elabora<<<(cn + 255) / 256, 256, 0, s[c]>>>(dc, cn);
        CUDA_CHECK(cudaMemcpyAsync(hc, dc, cbytes,
                                   cudaMemcpyDeviceToHost,
                                   s[c]));
    }
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms = 0.0f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("%d blocchi: %.2f ms, h[0] = %f\n",
           nchunk, ms, h[0]);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    for (int c = 0; c < nchunk; ++c)
        CUDA_CHECK(cudaStreamDestroy(s[c]));
    delete[] s;
    CUDA_CHECK(cudaFreeHost(h));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
