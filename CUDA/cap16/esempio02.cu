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

__global__ void riempi(float* a, int n, float v)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) a[i] = v;
}

__global__ void scala(float* a, int n, float f)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) a[i] *= f;
}

__global__ void somma(const float* a, const float* b,
                      float* c, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

int main()
{
    const int n = 1 << 20;
    size_t bytes = (size_t)n * sizeof(float);
    float *da, *db, *dc;
    CUDA_CHECK(cudaMalloc(&da, bytes));
    CUDA_CHECK(cudaMalloc(&db, bytes));
    CUDA_CHECK(cudaMalloc(&dc, bytes));

    cudaStream_t s0, s1, s2;
    CUDA_CHECK(cudaStreamCreate(&s0));
    CUDA_CHECK(cudaStreamCreate(&s1));
    CUDA_CHECK(cudaStreamCreate(&s2));

    cudaEvent_t fork, j1, j2;
    unsigned fl = cudaEventDisableTiming;
    CUDA_CHECK(cudaEventCreateWithFlags(&fork, fl));
    CUDA_CHECK(cudaEventCreateWithFlags(&j1, fl));
    CUDA_CHECK(cudaEventCreateWithFlags(&j2, fl));

    int blk = 256, grd = (n + blk - 1) / blk;

    // fase 1: preparazione su s0
    riempi<<<grd, blk, 0, s0>>>(da, n, 1.0f);
    riempi<<<grd, blk, 0, s0>>>(db, n, 2.0f);
    CUDA_CHECK(cudaEventRecord(fork, s0));

    // fase 2: s1 e s2 attendono fork, poi lavorano
    CUDA_CHECK(cudaStreamWaitEvent(s1, fork, 0));
    CUDA_CHECK(cudaStreamWaitEvent(s2, fork, 0));
    scala<<<grd, blk, 0, s1>>>(da, n, 10.0f);
    scala<<<grd, blk, 0, s2>>>(db, n, 100.0f);
    CUDA_CHECK(cudaEventRecord(j1, s1));
    CUDA_CHECK(cudaEventRecord(j2, s2));

    // fase 3: s0 attende entrambi e riunisce
    CUDA_CHECK(cudaStreamWaitEvent(s0, j1, 0));
    CUDA_CHECK(cudaStreamWaitEvent(s0, j2, 0));
    somma<<<grd, blk, 0, s0>>>(da, db, dc, n);
    CUDA_CHECK(cudaGetLastError());

    float h[4];
    CUDA_CHECK(cudaMemcpyAsync(h, dc, sizeof(h),
                               cudaMemcpyDeviceToHost, s0));
    CUDA_CHECK(cudaStreamSynchronize(s0));
    printf("c[0..3] = %.0f %.0f %.0f %.0f (atteso 210)\n",
           h[0], h[1], h[2], h[3]);

    CUDA_CHECK(cudaEventDestroy(fork));
    CUDA_CHECK(cudaEventDestroy(j1));
    CUDA_CHECK(cudaEventDestroy(j2));
    CUDA_CHECK(cudaStreamDestroy(s0));
    CUDA_CHECK(cudaStreamDestroy(s1));
    CUDA_CHECK(cudaStreamDestroy(s2));
    CUDA_CHECK(cudaFree(da));
    CUDA_CHECK(cudaFree(db));
    CUDA_CHECK(cudaFree(dc));
    return 0;
}
