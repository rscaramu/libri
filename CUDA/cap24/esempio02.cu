#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cuda_runtime.h>
#include <cufft.h>

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

#define CUFFT_CHECK(call)                                  \
    do {                                                   \
        cufftResult r = (call);                            \
        if (r != CUFFT_SUCCESS) {                          \
            fprintf(stderr, "Errore cuFFT %s:%d: %d\n",    \
                    __FILE__, __LINE__, (int)r);           \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

int main()
{
    const int n = 1000;          // 1 s a 1 kHz
    const int nf = n / 2 + 1;    // coefficienti R2C
    float* hs = (float*)malloc(n * sizeof(float));
    for (int i = 0; i < n; ++i) {
        float t = i / 1000.0f;
        hs[i] = 1.0f * sinf(2 * M_PI * 50 * t)
              + 0.5f * sinf(2 * M_PI * 120 * t);
    }
    cufftReal* ds;
    cufftComplex* dS;
    CUDA_CHECK(cudaMalloc(&ds, n * sizeof(cufftReal)));
    CUDA_CHECK(cudaMalloc(&dS, nf * sizeof(cufftComplex)));
    CUDA_CHECK(cudaMemcpy(ds, hs, n * sizeof(float),
                          cudaMemcpyHostToDevice));

    cufftHandle plan;
    CUFFT_CHECK(cufftPlan1d(&plan, n, CUFFT_R2C, 1));
    CUFFT_CHECK(cufftExecR2C(plan, ds, dS));
    CUDA_CHECK(cudaDeviceSynchronize());

    cufftComplex* hS =
        (cufftComplex*)malloc(nf * sizeof(cufftComplex));
    CUDA_CHECK(cudaMemcpy(hS, dS, nf * sizeof(cufftComplex),
                          cudaMemcpyDeviceToHost));
    // ampiezza normalizzata: 2*|S_k|/n per k > 0
    for (int k = 1; k < nf; ++k) {
        float amp = 2.0f * hypotf(hS[k].x, hS[k].y) / n;
        if (amp > 0.1f)
            printf("picco a %d Hz, ampiezza %.2f\n", k, amp);
    }
    CUFFT_CHECK(cufftDestroy(plan));
    CUDA_CHECK(cudaFree(ds));
    CUDA_CHECK(cudaFree(dS));
    free(hs); free(hS);
    return 0;
}
