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

__device__ unsigned laneMaskLt() {
    unsigned m;
    asm("mov.u32 %0, %%lanemask_lt;" : "=r"(m));
    return m;
}

// Copia in out gli elementi pari di in, compattati.
__global__ void compactEven(const int* in, int* out,
                            int* counter, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    bool keep = (i < n) && ((in[i] & 1) == 0);
    unsigned ballot = __ballot_sync(0xffffffffu, keep);
    int total = __popc(ballot);
    int rank = __popc(ballot & laneMaskLt());
    int base = 0;
    if ((threadIdx.x & 31) == 0 && total > 0) {
        base = atomicAdd(counter, total);
    }
    base = __shfl_sync(0xffffffffu, base, 0);
    if (keep) out[base + rank] = in[i];
}

int main() {
    const int n = 1000;
    int* h = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; ++i) h[i] = i * 7 + 3;
    int *d_in, *d_out, *d_cnt;
    CUDA_CHECK(cudaMalloc(&d_in, n * sizeof(int)));
    CUDA_CHECK(cudaMalloc(&d_out, n * sizeof(int)));
    CUDA_CHECK(cudaMalloc(&d_cnt, sizeof(int)));
    CUDA_CHECK(cudaMemcpy(d_in, h, n * sizeof(int),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemset(d_cnt, 0, sizeof(int)));
    compactEven<<<(n + 127) / 128, 128>>>(d_in, d_out,
                                          d_cnt, n);
    CUDA_CHECK(cudaGetLastError());
    int cnt;
    CUDA_CHECK(cudaMemcpy(&cnt, d_cnt, sizeof(int),
                          cudaMemcpyDeviceToHost));
    CUDA_CHECK(cudaMemcpy(h, d_out, cnt * sizeof(int),
                          cudaMemcpyDeviceToHost));
    int bad = 0;
    for (int i = 0; i < cnt; ++i) if (h[i] & 1) ++bad;
    printf("pari trovati: %d, dispari in uscita: %d\n",
           cnt, bad);
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    CUDA_CHECK(cudaFree(d_cnt));
    free(h);
    return 0;
}
