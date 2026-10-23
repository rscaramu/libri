#include <cstdio>
#include <cstdlib>
#include <vector>
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

__global__ void riempi(float *v, int n, float val) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] = val;
}

int main() {
    int ndev = 0;
    CUDA_CHECK(cudaGetDeviceCount(&ndev));
    printf("device disponibili: %d\n", ndev);
    const int n = 1 << 20;
    std::vector<float *> buf(ndev);
    std::vector<cudaStream_t> st(ndev);

    for (int d = 0; d < ndev; d++) {
        CUDA_CHECK(cudaSetDevice(d));
        CUDA_CHECK(cudaMalloc(&buf[d], n * sizeof(float)));
        CUDA_CHECK(cudaStreamCreate(&st[d]));
        riempi<<<(n + 255) / 256, 256, 0, st[d]>>>(
            buf[d], n, (float)d);
        CUDA_CHECK(cudaGetLastError());
    }
    // tutti i device lavorano insieme; ora si attende
    for (int d = 0; d < ndev; d++) {
        CUDA_CHECK(cudaSetDevice(d));
        CUDA_CHECK(cudaStreamSynchronize(st[d]));
        float x;
        CUDA_CHECK(cudaMemcpy(&x, buf[d] + n - 1,
                              sizeof(float),
                              cudaMemcpyDeviceToHost));
        printf("  device %d: ultimo valore %.1f\n", d, x);
        CUDA_CHECK(cudaStreamDestroy(st[d]));
        CUDA_CHECK(cudaFree(buf[d]));
    }
    return 0;
}
