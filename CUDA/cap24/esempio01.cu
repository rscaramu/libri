#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <cublas_v2.h>

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

#define CUBLAS_CHECK(call)                                 \
    do {                                                   \
        cublasStatus_t st = (call);                        \
        if (st != CUBLAS_STATUS_SUCCESS) {                 \
            fprintf(stderr, "Errore cuBLAS %s:%d: %d\n",   \
                    __FILE__, __LINE__, (int)st);          \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

int main()
{
    const int n = 4, m = 3, k = 2;
    // column-major: X(i,j) = hX[i + j*n]
    float hX[n * m], hP[n * k], hY[m * k];
    for (int j = 0; j < m; ++j)
        for (int i = 0; i < n; ++i)
            hX[i + j * n] = (float)(i + 1) * (j + 1);
    for (int j = 0; j < k; ++j)
        for (int i = 0; i < n; ++i)
            hP[i + j * n] = (j == 0) ? 1.0f : (float)i;

    float *dX, *dP, *dY;
    CUDA_CHECK(cudaMalloc(&dX, sizeof(hX)));
    CUDA_CHECK(cudaMalloc(&dP, sizeof(hP)));
    CUDA_CHECK(cudaMalloc(&dY, sizeof(hY)));
    cublasHandle_t h;
    CUBLAS_CHECK(cublasCreate(&h));
    CUBLAS_CHECK(cublasSetMatrix(n, m, sizeof(float),
                                 hX, n, dX, n));
    CUBLAS_CHECK(cublasSetMatrix(n, k, sizeof(float),
                                 hP, n, dP, n));

    // Y (m x k) = X^T (m x n) * P (n x k)
    const float alpha = 1.0f, beta = 0.0f;
    CUBLAS_CHECK(cublasSgemm(h, CUBLAS_OP_T, CUBLAS_OP_N,
                             m, k, n, &alpha, dX, n,
                             dP, n, &beta, dY, m));
    CUBLAS_CHECK(cublasGetMatrix(m, k, sizeof(float),
                                 dY, m, hY, m));
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < k; ++j)
            printf("%8.1f", hY[i + j * m]);
        printf("\n");
    }
    CUBLAS_CHECK(cublasDestroy(h));
    CUDA_CHECK(cudaFree(dX));
    CUDA_CHECK(cudaFree(dP));
    CUDA_CHECK(cudaFree(dY));
    return 0;
}
