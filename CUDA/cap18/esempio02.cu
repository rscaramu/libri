#include <cstdio>
#include <cstdlib>
#include <cooperative_groups.h>
#include <cuda_runtime.h>

namespace cg = cooperative_groups;

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

__global__ void diffusione(float* a, float* b, int n,
                           int passi)
{
    cg::grid_group grid = cg::this_grid();
    int stride = gridDim.x * blockDim.x;
    int start = blockIdx.x * blockDim.x + threadIdx.x;
    for (int p = 0; p < passi; ++p) {
        for (int i = start; i < n; i += stride) {
            if (i == 0 || i == n - 1) b[i] = a[i];
            else b[i] = 0.25f * a[i - 1] + 0.5f * a[i]
                      + 0.25f * a[i + 1];
        }
        grid.sync();
        float* t = a; a = b; b = t;
    }
}

int main()
{
    const int n = 1 << 20, passi = 1000, bs = 256;
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, 0));
    if (!p.cooperativeLaunch) {
        fprintf(stderr, "lancio cooperativo assente\n");
        return 1;
    }
    int perSM = 0;
    CUDA_CHECK(cudaOccupancyMaxActiveBlocksPerMultiprocessor(
        &perSM, diffusione, bs, 0));
    int grid = perSM * p.multiProcessorCount;

    float *a, *b;
    CUDA_CHECK(cudaMalloc(&a, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&b, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(a, 0, n * sizeof(float)));
    float caldo = 100.0f;
    CUDA_CHECK(cudaMemcpy(a + n / 2, &caldo, sizeof(float),
                          cudaMemcpyHostToDevice));

    int np = n, npassi = passi;
    void* args[] = {&a, &b, &np, &npassi};
    CUDA_CHECK(cudaLaunchCooperativeKernel(
        (void*)diffusione, grid, bs, args, 0, 0));
    CUDA_CHECK(cudaDeviceSynchronize());

    float* fin = (passi % 2 == 0) ? a : b;
    float v[3];
    CUDA_CHECK(cudaMemcpy(v, fin + n / 2 - 1, sizeof(v),
                          cudaMemcpyDeviceToHost));
    printf("griglia %d blocchi (%d per SM)\n", grid, perSM);
    printf("centro dopo %d passi: %.4f %.4f %.4f\n",
           passi, v[0], v[1], v[2]);
    CUDA_CHECK(cudaFree(a));
    CUDA_CHECK(cudaFree(b));
    return 0;
}
