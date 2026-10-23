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

__device__ float warpSum(float v) {
    for (int off = 16; off > 0; off >>= 1) {
        v += __shfl_xor_sync(0xffffffffu, v, off);
    }
    return v;
}

__global__ void sumKernel(const float* in, float* out,
                          int n) {
    __shared__ float part[32];
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    float v = (i < n) ? in[i] : 0.f;
    v = warpSum(v);
    int lane = threadIdx.x & 31;
    int warp = threadIdx.x >> 5;
    if (lane == 0) part[warp] = v;
    __syncthreads();
    if (warp == 0) {
        int nw = blockDim.x >> 5;
        v = (lane < nw) ? part[lane] : 0.f;
        v = warpSum(v);
        if (lane == 0) atomicAdd(out, v);
    }
}

int main() {
    const int n = 1 << 20;
    float* h = (float*)malloc(n * sizeof(float));
    for (int i = 0; i < n; ++i) h[i] = 1.f;
    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_out, sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d_in, h, n * sizeof(float),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemset(d_out, 0, sizeof(float)));
    sumKernel<<<(n + 255) / 256, 256>>>(d_in, d_out, n);
    CUDA_CHECK(cudaGetLastError());
    float res;
    CUDA_CHECK(cudaMemcpy(&res, d_out, sizeof(float),
                          cudaMemcpyDeviceToHost));
    printf("somma = %.0f (attesa %d)\n", res, n);
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    free(h);
    return 0;
}
