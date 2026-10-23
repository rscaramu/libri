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

// Ogni thread segue una catena: idx = next[idx].
// Le letture sono dipendenti: nessun ILP possibile.
__global__ void chase(const int* next, int* out,
                      int steps, int n) {
    int idx = (blockIdx.x * blockDim.x + threadIdx.x) % n;
    for (int s = 0; s < steps; ++s) {
        idx = next[idx];
    }
    out[blockIdx.x * blockDim.x + threadIdx.x] = idx;
}

int main() {
    const int n = 1 << 24;          // 16M elementi, 64 MB
    const int steps = 256;
    const int blockSize = 64;       // 2 warp per blocco
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, 0));
    int sms = p.multiProcessorCount;

    int* h_next = (int*)malloc(n * sizeof(int));
    // Salto grande, multiplo di 32: il warp legge sempre
    // 128 byte contigui; ogni passo dipende dal precedente.
    for (int i = 0; i < n; ++i) {
        h_next[i] = (int)(((long long)i + 1000032LL) % n);
    }
    int *d_next, *d_out;
    CUDA_CHECK(cudaMalloc(&d_next, n * sizeof(int)));
    size_t outN = (size_t)sms * 24 * blockSize;
    CUDA_CHECK(cudaMalloc(&d_out, outN * sizeof(int)));
    CUDA_CHECK(cudaMemcpy(d_next, h_next, n * sizeof(int),
                          cudaMemcpyHostToDevice));
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));

    int perSM[] = {1, 2, 4, 8, 16, 24};
    for (int k = 0; k < 6; ++k) {
        int blocks = sms * perSM[k];
        chase<<<blocks, blockSize>>>(d_next, d_out,
                                     steps, n); // warm-up
        CUDA_CHECK(cudaDeviceSynchronize());
        CUDA_CHECK(cudaEventRecord(t0));
        chase<<<blocks, blockSize>>>(d_next, d_out,
                                     steps, n);
        CUDA_CHECK(cudaEventRecord(t1));
        CUDA_CHECK(cudaEventSynchronize(t1));
        float ms = 0.f;
        CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
        double lat = ms * 1e6 / steps;   // ns per passo
        double perSm = lat / (perSM[k] * 2);
        printf("warp/SM %2d  tempo %5.3f ms  "
               "passo %6.1f ns  per SM %5.1f ns\n",
               perSM[k] * 2, ms, lat, perSm);
    }
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d_next));
    CUDA_CHECK(cudaFree(d_out));
    free(h_next);
    return 0;
}
