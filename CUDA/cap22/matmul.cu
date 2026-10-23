#include <cstdio>
#include <cstdlib>
#include <cmath>
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

// ... qui vanno i tre kernel delle sezioni precedenti ...

static float max_diff(const float* a, const float* b, int n)
{
    float m = 0.0f;
    for (int i = 0; i < n; ++i)
        m = fmaxf(m, fabsf(a[i] - b[i]));
    return m;
}

int main()
{
    const int M = 2048, N = 2048, K = 2048;
    size_t nA = (size_t)M * K, nB = (size_t)K * N;
    size_t nC = (size_t)M * N;
    float* hA = (float*)malloc(nA * sizeof(float));
    float* hB = (float*)malloc(nB * sizeof(float));
    float* hC = (float*)malloc(nC * sizeof(float));
    float* hR = (float*)malloc(nC * sizeof(float));
    for (size_t i = 0; i < nA; ++i) hA[i] = rand() % 7 - 3;
    for (size_t i = 0; i < nB; ++i) hB[i] = rand() % 7 - 3;

    float *dA, *dB, *dC;
    CUDA_CHECK(cudaMalloc(&dA, nA * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dB, nB * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dC, nC * sizeof(float)));
    CUDA_CHECK(cudaMemcpy(dA, hA, nA * sizeof(float),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dB, hB, nB * sizeof(float),
                          cudaMemcpyHostToDevice));

    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    double flop = 2.0 * M * N * K;
    float ms;

    // riferimento: cuBLAS
    cublasHandle_t h;
    cublasCreate(&h);
    const float one = 1.0f, zero = 0.0f;
    cublasSgemm(h, CUBLAS_OP_N, CUBLAS_OP_N, N, M, K,
                &one, dB, N, dA, K, &zero, dC, N);
    CUDA_CHECK(cudaDeviceSynchronize());
    CUDA_CHECK(cudaEventRecord(t0));
    cublasSgemm(h, CUBLAS_OP_N, CUBLAS_OP_N, N, M, K,
                &one, dB, N, dA, K, &zero, dC, N);
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("cuBLAS : %8.3f ms  %8.1f GFLOPS\n",
           ms, flop / ms / 1e6);
    CUDA_CHECK(cudaMemcpy(hR, dC, nC * sizeof(float),
                          cudaMemcpyDeviceToHost));

    dim3 b2(TILE, TILE);
    dim3 g2((N + TILE - 1) / TILE, (M + TILE - 1) / TILE);
    dim3 g3(N / BN, M / BM);
    const char* names[3] = {"naive", "tiled", "reg"};
    for (int v = 0; v < 3; ++v) {
        CUDA_CHECK(cudaMemset(dC, 0, nC * sizeof(float)));
        CUDA_CHECK(cudaEventRecord(t0));
        if (v == 0)
            matmul_naive<<<g2, b2>>>(dA, dB, dC, M, N, K);
        else if (v == 1)
            matmul_tiled<<<g2, b2>>>(dA, dB, dC, M, N, K);
        else
            matmul_reg<<<g3, 256>>>(dA, dB, dC, M, N, K);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaEventRecord(t1));
        CUDA_CHECK(cudaEventSynchronize(t1));
        CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
        CUDA_CHECK(cudaMemcpy(hC, dC, nC * sizeof(float),
                              cudaMemcpyDeviceToHost));
        printf("%-7s: %8.3f ms  %8.1f GFLOPS  err %.1e\n",
               names[v], ms, flop / ms / 1e6,
               max_diff(hC, hR, (int)nC));
    }
    cublasDestroy(h);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(dA));
    CUDA_CHECK(cudaFree(dB));
    CUDA_CHECK(cudaFree(dC));
    free(hA); free(hB); free(hC); free(hR);
    return 0;
}
