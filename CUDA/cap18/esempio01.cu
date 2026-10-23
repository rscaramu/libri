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

template <typename G>
__device__ float riduci_gruppo(G g, float v)
{
    for (int d = g.size() / 2; d > 0; d /= 2)
        v += g.shfl_down(v, d);
    return v;
}

__global__ void somma_blocchi(const float* in, float* out,
                              int n)
{
    cg::thread_block blk = cg::this_thread_block();
    auto w = cg::tiled_partition<32>(blk);
    __shared__ float parz[32];

    int i = blockIdx.x * blockDim.x + threadIdx.x;
    float v = (i < n) ? in[i] : 0.0f;
    v = riduci_gruppo(w, v);
    if (w.thread_rank() == 0)
        parz[w.meta_group_rank()] = v;
    blk.sync();

    if (w.meta_group_rank() == 0) {
        int nw = blk.size() / 32;
        v = (w.thread_rank() < nw) ? parz[w.thread_rank()]
                                    : 0.0f;
        v = riduci_gruppo(w, v);
        if (w.thread_rank() == 0) out[blockIdx.x] = v;
    }
}

int main()
{
    const int n = 1 << 20, bs = 256;
    int grid = (n + bs - 1) / bs;
    float* h = (float*)malloc(n * sizeof(float));
    for (int i = 0; i < n; ++i) h[i] = 1.0f;
    float *din, *dout;
    CUDA_CHECK(cudaMalloc(&din, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dout, grid * sizeof(float)));
    CUDA_CHECK(cudaMemcpy(din, h, n * sizeof(float),
                          cudaMemcpyHostToDevice));
    somma_blocchi<<<grid, bs>>>(din, dout, n);
    CUDA_CHECK(cudaGetLastError());
    float* hp = (float*)malloc(grid * sizeof(float));
    CUDA_CHECK(cudaMemcpy(hp, dout, grid * sizeof(float),
                          cudaMemcpyDeviceToHost));
    double tot = 0.0;
    for (int b = 0; b < grid; ++b) tot += hp[b];
    printf("somma = %.0f (atteso %d)\n", tot, n);
    CUDA_CHECK(cudaFree(din));
    CUDA_CHECK(cudaFree(dout));
    free(h);
    free(hp);
    return 0;
}
