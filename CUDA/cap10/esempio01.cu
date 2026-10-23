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

__global__ void poly(const float* x, float* y, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float v = x[i];
    float a = v * v;
    float b = a * v;
    y[i] = 1.0f + v - 0.5f * a + 0.25f * b;
}

int main() {
    const int n = 1 << 20;
    size_t bytes = n * sizeof(float);
    float* h_x = (float*)malloc(bytes);
    float* h_y = (float*)malloc(bytes);
    for (int i = 0; i < n; ++i) h_x[i] = i * 1e-6f;
    float *d_x, *d_y;
    CUDA_CHECK(cudaMalloc(&d_x, bytes));
    CUDA_CHECK(cudaMalloc(&d_y, bytes));
    CUDA_CHECK(cudaMemcpy(d_x, h_x, bytes,
                          cudaMemcpyHostToDevice));
    poly<<<(n + 255) / 256, 256>>>(d_x, d_y, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_y, d_y, bytes,
                          cudaMemcpyDeviceToHost));
    printf("y[%d] = %f\n", n - 1, h_y[n - 1]);
    CUDA_CHECK(cudaFree(d_x));
    CUDA_CHECK(cudaFree(d_y));
    free(h_x);
    free(h_y);
    return 0;
}
