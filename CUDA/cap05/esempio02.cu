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

__host__ __device__ __forceinline__
int idx3(int z, int y, int x, int h, int w) {
    return (z * h + y) * w + x;
}

__global__ void stencil7(const float* in, float* out,
                         int d, int h, int w) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    int z = blockIdx.z * blockDim.z + threadIdx.z;
    if (x < 1 || x >= w - 1 || y < 1 || y >= h - 1 ||
        z < 1 || z >= d - 1) return;
    float s = in[idx3(z, y, x, h, w)]
            + in[idx3(z, y, x - 1, h, w)]
            + in[idx3(z, y, x + 1, h, w)]
            + in[idx3(z, y - 1, x, h, w)]
            + in[idx3(z, y + 1, x, h, w)]
            + in[idx3(z - 1, y, x, h, w)]
            + in[idx3(z + 1, y, x, h, w)];
    out[idx3(z, y, x, h, w)] = s / 7.0f;
}

int main() {
    const int d = 64, h = 64, w = 64;
    const size_t n = (size_t)d * h * w;
    const size_t bytes = n * sizeof(float);
    float* h_in = (float*)malloc(bytes);
    float* h_out = (float*)malloc(bytes);
    for (size_t i = 0; i < n; ++i) h_in[i] = 0.0f;
    h_in[idx3(32, 32, 32, h, w)] = 7.0f;

    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc((void**)&d_in, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_out, bytes));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemset(d_out, 0, bytes));

    dim3 blocco(16, 8, 4);
    dim3 griglia((w + 15) / 16, (h + 7) / 8, (d + 3) / 4);
    stencil7<<<griglia, blocco>>>(d_in, d_out, d, h, w);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_out, d_out, bytes,
                          cudaMemcpyDeviceToHost));

    printf("centro: %.2f  vicino x: %.2f  diag: %.2f\n",
           h_out[idx3(32, 32, 32, h, w)],
           h_out[idx3(32, 32, 33, h, w)],
           h_out[idx3(33, 33, 32, h, w)]);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    free(h_in); free(h_out);
    return 0;
}
