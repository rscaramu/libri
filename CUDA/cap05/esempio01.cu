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

__global__ void somma_mat(const float* a, const float* b,
                          float* c, int h, int w) {
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int riga = blockIdx.y * blockDim.y + threadIdx.y;
    if (riga < h && col < w) {
        int i = riga * w + col;
        c[i] = a[i] + b[i];
    }
}

int main() {
    const int h = 1000, w = 700;
    const size_t bytes = (size_t)h * w * sizeof(float);
    float* h_a = (float*)malloc(bytes);
    float* h_b = (float*)malloc(bytes);
    float* h_c = (float*)malloc(bytes);
    for (int r = 0; r < h; ++r)
        for (int c = 0; c < w; ++c) {
            h_a[r * w + c] = (float)r;
            h_b[r * w + c] = (float)c;
        }

    float *d_a, *d_b, *d_c;
    CUDA_CHECK(cudaMalloc((void**)&d_a, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_b, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_c, bytes));
    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bytes,
                          cudaMemcpyHostToDevice));

    dim3 blocco(16, 16);
    dim3 griglia((w + blocco.x - 1) / blocco.x,
                 (h + blocco.y - 1) / blocco.y);
    printf("griglia %u x %u, blocco %u x %u\n",
           griglia.x, griglia.y, blocco.x, blocco.y);
    somma_mat<<<griglia, blocco>>>(d_a, d_b, d_c, h, w);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_c, d_c, bytes,
                          cudaMemcpyDeviceToHost));

    int errori = 0;
    for (int r = 0; r < h; ++r)
        for (int c = 0; c < w; ++c)
            if (h_c[r * w + c] != (float)(r + c)) ++errori;
    printf("c[999][699] = %.0f, errori = %d\n",
           h_c[999 * w + 699], errori);

    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    free(h_a); free(h_b); free(h_c);
    return 0;
}
