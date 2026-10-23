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

__global__ void saxpy(int n, float a, const float* x,
                      float* y)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) y[i] = a * x[i] + y[i];
}

int main()
{
    const int n = 1 << 24;
    size_t bytes = (size_t)n * sizeof(float);
    float* hx = (float*)malloc(bytes);
    float* hy = (float*)malloc(bytes);
    for (int i = 0; i < n; ++i) {
        hx[i] = 1.0f;
        hy[i] = 2.0f;
    }

    float *dx, *dy;
    CUDA_CHECK(cudaMalloc(&dx, bytes));
    CUDA_CHECK(cudaMalloc(&dy, bytes));

    cudaEvent_t e0, e1, e2, e3;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));
    CUDA_CHECK(cudaEventCreate(&e2));
    CUDA_CHECK(cudaEventCreate(&e3));

    CUDA_CHECK(cudaEventRecord(e0));
    CUDA_CHECK(cudaMemcpy(dx, hx, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dy, hy, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaEventRecord(e1));

    int block = 256;
    int grid = (n + block - 1) / block;
    saxpy<<<grid, block>>>(n, 3.0f, dx, dy);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventRecord(e2));

    CUDA_CHECK(cudaMemcpy(hy, dy, bytes,
                          cudaMemcpyDeviceToHost));
    CUDA_CHECK(cudaEventRecord(e3));
    CUDA_CHECK(cudaEventSynchronize(e3));

    float tH2D, tKer, tD2H;
    CUDA_CHECK(cudaEventElapsedTime(&tH2D, e0, e1));
    CUDA_CHECK(cudaEventElapsedTime(&tKer, e1, e2));
    CUDA_CHECK(cudaEventElapsedTime(&tD2H, e2, e3));

    printf("H2D: %.3f ms  kernel: %.3f ms  D2H: %.3f ms\n",
           tH2D, tKer, tD2H);
    printf("controllo: y[0] = %.1f (atteso 5.0)\n", hy[0]);

    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
    CUDA_CHECK(cudaEventDestroy(e2));
    CUDA_CHECK(cudaEventDestroy(e3));
    CUDA_CHECK(cudaFree(dx));
    CUDA_CHECK(cudaFree(dy));
    free(hx);
    free(hy);
    return 0;
}
