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

// scan esclusivo di un blocco; sums riceve la somma totale
__global__ void scan_block(const float* in, float* out,
                           float* sums, int n)
{
    __shared__ float s[BLOCK];
    int tid = threadIdx.x;
    int gi = blockIdx.x * BLOCK + tid;
    s[tid] = (gi < n) ? in[gi] : 0.0f;

    // fase di salita
    for (int off = 1; off < BLOCK; off <<= 1) {
        __syncthreads();
        int i = (tid + 1) * off * 2 - 1;
        if (i < BLOCK) s[i] += s[i - off];
    }
    __syncthreads();
    if (tid == 0) {
        sums[blockIdx.x] = s[BLOCK - 1];
        s[BLOCK - 1] = 0.0f;
    }
    // fase di discesa
    for (int off = BLOCK / 2; off > 0; off >>= 1) {
        __syncthreads();
        int i = (tid + 1) * off * 2 - 1;
        if (i < BLOCK) {
            float t = s[i - off];
            s[i - off] = s[i];
            s[i] += t;
        }
    }
    __syncthreads();
    if (gi < n) out[gi] = s[tid];
}

__global__ void add_offsets(float* out, const float* offs,
                            int n)
{
    int gi = blockIdx.x * BLOCK + threadIdx.x;
    if (gi < n) out[gi] += offs[blockIdx.x];
}

int main()
{
    const int n = BLOCK * BLOCK;   // 65536 elementi
    const int grid = n / BLOCK;    // 256 blocchi
    size_t bytes = n * sizeof(float);
    float* h = (float*)malloc(bytes);
    for (int i = 0; i < n; i++) h[i] = 1.0f;

    float *d_in, *d_out, *d_sums, *d_offs, *d_tot;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMalloc(&d_sums, grid * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_offs, grid * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_tot, sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d_in, h, bytes,
                          cudaMemcpyHostToDevice));

    scan_block<<<grid, BLOCK>>>(d_in, d_out, d_sums, n);
    scan_block<<<1, BLOCK>>>(d_sums, d_offs, d_tot, grid);
    add_offsets<<<grid, BLOCK>>>(d_out, d_offs, n);
    CUDA_CHECK(cudaGetLastError());

    CUDA_CHECK(cudaMemcpy(h, d_out, bytes,
                          cudaMemcpyDeviceToHost));
    printf("out[0]=%.0f out[255]=%.0f out[256]=%.0f\n",
           h[0], h[255], h[256]);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    CUDA_CHECK(cudaFree(d_sums));
    CUDA_CHECK(cudaFree(d_offs));
    CUDA_CHECK(cudaFree(d_tot));
    free(h);
    return 0;
}
