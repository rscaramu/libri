#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <vector>
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

__global__ void copia(const float* a, float* b, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) b[i] = a[i];
}

template <typename F>
void bench(const char* nome, F lancia, int rip,
           double bytesMossi)
{
    cudaEvent_t e0, e1;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));
    for (int i = 0; i < 3; ++i) lancia();   // riscaldamento
    CUDA_CHECK(cudaDeviceSynchronize());

    std::vector<float> t(rip);
    for (int i = 0; i < rip; ++i) {
        CUDA_CHECK(cudaEventRecord(e0));
        lancia();
        CUDA_CHECK(cudaEventRecord(e1));
        CUDA_CHECK(cudaEventSynchronize(e1));
        CUDA_CHECK(cudaEventElapsedTime(&t[i], e0, e1));
    }
    CUDA_CHECK(cudaGetLastError());
    std::sort(t.begin(), t.end());
    float med = t[rip / 2];
    double gbs = bytesMossi / (med * 1e-3) / 1e9;
    printf("%-12s min %.3f  med %.3f  max %.3f ms"
           "  %.1f GB/s\n", nome, t[0], med, t[rip - 1],
           gbs);
    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
}

int main()
{
    const int n = 1 << 26;
    size_t bytes = (size_t)n * sizeof(float);
    float *da, *db;
    CUDA_CHECK(cudaMalloc(&da, bytes));
    CUDA_CHECK(cudaMalloc(&db, bytes));
    CUDA_CHECK(cudaMemset(da, 0, bytes));
    int blk = 256, grd = (n + blk - 1) / blk;

    bench("kernel", [&] {
        copia<<<grd, blk>>>(da, db, n);
    }, 20, 2.0 * bytes);

    CUDA_CHECK(cudaFree(da));
    CUDA_CHECK(cudaFree(db));
    return 0;
}
