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

#define BLOCK 256

__device__ __forceinline__ float warp_sum(float v)
{
    for (int off = 16; off > 0; off >>= 1)
        v += __shfl_down_sync(0xffffffff, v, off);
    return v;
}

__global__ void reduce_sum(const float* in, float* out,
                           int n)
{
    __shared__ float part[BLOCK / 32];
    int tid = threadIdx.x;
    int stride = gridDim.x * blockDim.x;

    // ogni thread accumula piu elementi in un registro
    float v = 0.0f;
    for (int i = blockIdx.x * blockDim.x + tid; i < n;
         i += stride)
        v += in[i];

    // riduzione dentro il warp
    v = warp_sum(v);
    if (tid % 32 == 0) part[tid / 32] = v;
    __syncthreads();

    // il primo warp riduce le somme parziali dei warp
    if (tid < 32) {
        v = (tid < BLOCK / 32) ? part[tid] : 0.0f;
        v = warp_sum(v);
        if (tid == 0) out[blockIdx.x] = v;
    }
}

int main()
{
    const int n = 1 << 24;
    const int grid = 256;
    size_t bytes = n * sizeof(float);
    float* h_in = (float*)malloc(bytes);
    double expected = 0.0;
    for (int i = 0; i < n; i++) {
        h_in[i] = (i % 4) * 0.25f;
        expected += h_in[i];
    }

    float *d_in, *d_part, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_part, grid * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_out, sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, bytes,
                          cudaMemcpyHostToDevice));

    reduce_sum<<<grid, BLOCK>>>(d_in, d_part, n);
    reduce_sum<<<1, BLOCK>>>(d_part, d_out, grid);
    CUDA_CHECK(cudaGetLastError());

    float result;
    CUDA_CHECK(cudaMemcpy(&result, d_out, sizeof(float),
                          cudaMemcpyDeviceToHost));
    printf("somma GPU: %.1f  attesa: %.1f\n",
           result, expected);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_part));
    CUDA_CHECK(cudaFree(d_out));
    free(h_in);
    return 0;
}
