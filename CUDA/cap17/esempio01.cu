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

__global__ void leggero(float* a, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) a[i] = a[i] * 2.0f + 1.0f;
}

// Molti valori vivi: il compilatore usa molti registri
__global__ void pesante(const float* in, float* out,
                        int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float v[32];
    for (int k = 0; k < 32; ++k)
        v[k] = in[(i + k * 97) % n];
    float s = 0.0f;
    for (int r = 0; r < 8; ++r)
        for (int k = 0; k < 32; ++k)
            s = s * 0.99f + v[k] * v[(k + r) % 32];
    out[i] = s;
}

template <typename K>
void tabella(const char* nome, K kernel)
{
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, 0));
    cudaFuncAttributes fa;
    CUDA_CHECK(cudaFuncGetAttributes(&fa, kernel));
    int maxWarp = p.maxThreadsPerMultiProcessor / 32;
    printf("%s: %d registri, %zu B shared\n", nome,
           fa.numRegs, fa.sharedSizeBytes);
    for (int bs = 64; bs <= 1024; bs *= 2) {
        int nb;
        CUDA_CHECK(
            cudaOccupancyMaxActiveBlocksPerMultiprocessor(
                &nb, kernel, bs, 0));
        int warp = nb * bs / 32;
        printf("  blocco %4d: %2d blocchi, %2d warp,"
               " occupancy %3.0f%%\n", bs, nb, warp,
               100.0 * warp / maxWarp);
    }
}

int main()
{
    tabella("leggero", leggero);
    tabella("pesante", pesante);
    return 0;
}
