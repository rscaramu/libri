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

__global__ void scala(float* m, size_t pitch, int righe,
                      int cols, float k) {
    int c = blockIdx.x * blockDim.x + threadIdx.x;
    int r = blockIdx.y * blockDim.y + threadIdx.y;
    if (r >= righe || c >= cols) return;
    // la riga r inizia a pitch byte dalla precedente
    float* riga = (float*)((char*)m + r * pitch);
    riga[c] *= k;
}

int main() {
    const int righe = 500, cols = 1000;
    float* d_m;
    size_t pitch;
    CUDA_CHECK(cudaMallocPitch(&d_m, &pitch,
                               cols * sizeof(float), righe));
    printf("larghezza utile %zu byte, pitch %zu byte\n",
           cols * sizeof(float), pitch);
    CUDA_CHECK(cudaMemset2D(d_m, pitch, 0,
                            cols * sizeof(float), righe));
    dim3 blk(32, 8);
    dim3 grd((cols + 31) / 32, (righe + 7) / 8);
    scala<<<grd, blk>>>(d_m, pitch, righe, cols, 2.0f);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    CUDA_CHECK(cudaFree(d_m));
    return 0;
}
