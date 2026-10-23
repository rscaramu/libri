#include <cstdio>
#include <cstdlib>
#include <vector>
#include <cuda_runtime.h>
#include <nccl.h>

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

#define NCCL_CHECK(call)                                   \
    do {                                                   \
        ncclResult_t r = (call);                           \
        if (r != ncclSuccess) {                            \
            fprintf(stderr, "Errore NCCL %s:%d: %s\n",     \
                    __FILE__, __LINE__,                    \
                    ncclGetErrorString(r));                \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

// stesso kernel della sezione 29.1
__global__ void riempi(float *v, int n, float val) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] = val;
}

int main() {
    int ndev = 0;
    CUDA_CHECK(cudaGetDeviceCount(&ndev));
    const int n = 1 << 24;   // 16 M float = 64 MiB
    std::vector<int> devs(ndev);
    std::vector<float *> buf(ndev);
    std::vector<cudaStream_t> st(ndev);
    std::vector<ncclComm_t> comm(ndev);

    for (int d = 0; d < ndev; d++) {
        devs[d] = d;
        CUDA_CHECK(cudaSetDevice(d));
        CUDA_CHECK(cudaMalloc(&buf[d], n * sizeof(float)));
        CUDA_CHECK(cudaStreamCreate(&st[d]));
        riempi<<<(n + 255) / 256, 256, 0, st[d]>>>(
            buf[d], n, (float)d);
        CUDA_CHECK(cudaGetLastError());
    }
    NCCL_CHECK(ncclCommInitAll(comm.data(), ndev,
                               devs.data()));

    // le chiamate vanno raggruppate: una per device
    NCCL_CHECK(ncclGroupStart());
    for (int d = 0; d < ndev; d++) {
        NCCL_CHECK(ncclAllReduce(buf[d], buf[d], n,
                                 ncclFloat, ncclSum,
                                 comm[d], st[d]));
    }
    NCCL_CHECK(ncclGroupEnd());

    float attesa = ndev * (ndev - 1) / 2.0f;
    for (int d = 0; d < ndev; d++) {
        float x;
        CUDA_CHECK(cudaSetDevice(d));
        CUDA_CHECK(cudaStreamSynchronize(st[d]));
        CUDA_CHECK(cudaMemcpy(&x, buf[d], sizeof(float),
                              cudaMemcpyDeviceToHost));
        printf("rank %d: %.1f (attesa %.1f)\n",
               d, x, attesa);
        NCCL_CHECK(ncclCommDestroy(comm[d]));
        CUDA_CHECK(cudaStreamDestroy(st[d]));
        CUDA_CHECK(cudaFree(buf[d]));
    }
    return 0;
}
