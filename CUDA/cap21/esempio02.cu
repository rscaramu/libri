#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <thrust/scan.h>
#include <thrust/device_ptr.h>

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

__global__ void mark_even(const int* in, int* flags, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) flags[i] = (in[i] % 2 == 0) ? 1 : 0;
}

__global__ void scatter_kept(const int* in, const int* flags,
                             const int* pos, int* out, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n && flags[i]) out[pos[i]] = in[i];
}

int main()
{
    const int n = 1 << 20;
    size_t bytes = n * sizeof(int);
    int* h_in = (int*)malloc(bytes);
    int* h_out = (int*)malloc(bytes);
    for (int i = 0; i < n; i++) h_in[i] = (i * 7919LL) % 1000;

    int *d_in, *d_flags, *d_pos, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_flags, bytes));
    CUDA_CHECK(cudaMalloc(&d_pos, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, bytes,
                          cudaMemcpyHostToDevice));

    int block = 256, grid = (n + block - 1) / block;
    mark_even<<<grid, block>>>(d_in, d_flags, n);
    thrust::device_ptr<int> f(d_flags), p(d_pos);
    thrust::exclusive_scan(f, f + n, p);
    scatter_kept<<<grid, block>>>(d_in, d_flags, d_pos,
                                  d_out, n);
    CUDA_CHECK(cudaGetLastError());

    // superstiti = ultimo scan + ultimo flag
    int last[2];
    CUDA_CHECK(cudaMemcpy(&last[0], d_pos + n - 1, 4,
                          cudaMemcpyDeviceToHost));
    CUDA_CHECK(cudaMemcpy(&last[1], d_flags + n - 1, 4,
                          cudaMemcpyDeviceToHost));
    int count = last[0] + last[1];
    CUDA_CHECK(cudaMemcpy(h_out, d_out, count * sizeof(int),
                          cudaMemcpyDeviceToHost));
    printf("superstiti: %d su %d\n", count, n);
    printf("primi: %d %d %d %d\n", h_out[0], h_out[1],
           h_out[2], h_out[3]);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_flags));
    CUDA_CHECK(cudaFree(d_pos));
    CUDA_CHECK(cudaFree(d_out));
    free(h_in);
    free(h_out);
    return 0;
}
