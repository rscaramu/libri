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

#define BINS 256
#define BLOCK 256

__global__ void hist_global(const unsigned char* in, int n,
                            unsigned int* hist)
{
    int stride = gridDim.x * blockDim.x;
    for (int i = blockIdx.x * blockDim.x + threadIdx.x;
         i < n; i += stride)
        atomicAdd(&hist[in[i]], 1u);
}

__global__ void hist_shared(const unsigned char* in, int n,
                            unsigned int* hist)
{
    __shared__ unsigned int local[BINS];
    for (int b = threadIdx.x; b < BINS; b += blockDim.x)
        local[b] = 0;
    __syncthreads();

    int stride = gridDim.x * blockDim.x;
    for (int i = blockIdx.x * blockDim.x + threadIdx.x;
         i < n; i += stride)
        atomicAdd(&local[in[i]], 1u);
    __syncthreads();

    for (int b = threadIdx.x; b < BINS; b += blockDim.x)
        if (local[b] > 0) atomicAdd(&hist[b], local[b]);
}

int main()
{
    const int n = 1 << 26;
    const int grid = 46 * 8;
    size_t hbytes = BINS * sizeof(unsigned int);
    unsigned char* h_in = (unsigned char*)malloc(n);
    unsigned int h_hist[BINS];
    srand(1);
    for (int i = 0; i < n; i++) {
        int r = rand();
        h_in[i] = (r % 10 != 0) ? 7 : (r / 10) & 255;
    }

    unsigned char* d_in;
    unsigned int* d_hist;
    CUDA_CHECK(cudaMalloc(&d_in, n));
    CUDA_CHECK(cudaMalloc(&d_hist, hbytes));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, n,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemset(d_hist, 0, hbytes));

    hist_shared<<<grid, BLOCK>>>(d_in, n, d_hist);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_hist, d_hist, hbytes,
                          cudaMemcpyDeviceToHost));

    unsigned int total = 0;
    for (int b = 0; b < BINS; b++) total += h_hist[b];
    printf("classe 7: %u  classe 8: %u  totale: %u\n",
           h_hist[7], h_hist[8], total);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_hist));
    free(h_in);
    return 0;
}
