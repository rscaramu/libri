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

#define K 7
__constant__ float c_coef[K];

__global__ void conv1d(const float* in, float* out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float acc = 0.0f;
    for (int k = 0; k < K; ++k) {
        int j = i + k - K / 2;
        if (j >= 0 && j < n) acc += c_coef[k] * in[j];
    }
    out[i] = acc;
}

int main() {
    const int n = 1024;
    size_t bytes = n * sizeof(float);
    float h_coef[K] = {1, 6, 15, 20, 15, 6, 1};
    for (int k = 0; k < K; ++k) h_coef[k] /= 64.0f;
    CUDA_CHECK(cudaMemcpyToSymbol(c_coef, h_coef,
                                  sizeof(h_coef)));
    float* h_in = (float*)malloc(bytes);
    float* h_out = (float*)malloc(bytes);
    for (int i = 0; i < n; ++i) h_in[i] = 1.0f;
    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, bytes,
                          cudaMemcpyHostToDevice));
    conv1d<<<(n + 255) / 256, 256>>>(d_in, d_out, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_out, d_out, bytes,
                          cudaMemcpyDeviceToHost));
    printf("out[0] = %f  out[512] = %f\n",
           h_out[0], h_out[512]);
    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    free(h_in);
    free(h_out);
    return 0;
}
