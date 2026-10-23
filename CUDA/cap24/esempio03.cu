#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <curand_kernel.h>

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

// ogni thread genera i propri punti con la device API
__global__ void conta_punti(int per_thread,
                            unsigned long long seed,
                            unsigned long long* dentro)
{
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    curandStatePhilox4_32_10_t st;
    curand_init(seed, id, 0, &st);
    unsigned long long c = 0;
    for (int k = 0; k < per_thread; ++k) {
        float x = curand_uniform(&st);
        float y = curand_uniform(&st);
        if (x * x + y * y <= 1.0f) ++c;
    }
    atomicAdd(dentro, c);
}

int main()
{
    // 65536 thread x 256 punti = 16 milioni di punti
    const int n = 65536 * 256;
    unsigned long long* dc;
    CUDA_CHECK(cudaMalloc(&dc, sizeof(unsigned long long)));
    CUDA_CHECK(cudaMemset(dc, 0, sizeof(unsigned long long)));
    conta_punti<<<256, 256>>>(256, 2024ULL, dc);
    CUDA_CHECK(cudaGetLastError());
    unsigned long long hc;
    CUDA_CHECK(cudaMemcpy(&hc, dc, sizeof(hc),
                          cudaMemcpyDeviceToHost));
    printf("pi ~ %.5f\n", 4.0 * hc / n);
    CUDA_CHECK(cudaFree(dc));
    return 0;
}
