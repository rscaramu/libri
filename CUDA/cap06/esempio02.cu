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

template <typename F>
__global__ void mappa(float* v, int n, F f) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] = f(v[i]);
}

int main() {
    const int n = 8;
    float h_v[n];
    for (int i = 0; i < n; ++i) h_v[i] = (float)i;

    float* d_v;
    CUDA_CHECK(cudaMalloc((void**)&d_v, n * sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d_v, h_v, n * sizeof(float),
                          cudaMemcpyHostToDevice));

    float a = 3.0f, b = 1.0f;
    auto affine = [=] __device__ (float x) {
        return a * x + b;
    };
    mappa<<<1, n>>>(d_v, n, affine);
    CUDA_CHECK(cudaGetLastError());

    mappa<<<1, n>>>(d_v, n, [] __device__ (float x) {
        return x * x;
    });
    CUDA_CHECK(cudaGetLastError());

    CUDA_CHECK(cudaMemcpy(h_v, d_v, n * sizeof(float),
                          cudaMemcpyDeviceToHost));
    for (int i = 0; i < n; ++i) printf("%.0f ", h_v[i]);
    printf("\n");
    CUDA_CHECK(cudaFree(d_v));
    return 0;
}
