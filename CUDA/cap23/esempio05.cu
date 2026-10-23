#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <thrust/execution_policy.h>
#include <thrust/device_ptr.h>
#include <thrust/reduce.h>
#include <thrust/system_error.h>

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

__global__ void quadrati(float* v, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] = (float)(i % 100) * (float)(i % 100);
}

int main()
{
    const int n = 1 << 20;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, n * sizeof(float)));
    cudaStream_t s;
    CUDA_CHECK(cudaStreamCreate(&s));

    quadrati<<<(n + 255) / 256, 256, 0, s>>>(d, n);
    CUDA_CHECK(cudaGetLastError());

    float somma = 0.0f;
    try {
        thrust::device_ptr<float> p(d);
        somma = thrust::reduce(thrust::cuda::par.on(s),
                               p, p + n, 0.0f);
    } catch (thrust::system_error& e) {
        fprintf(stderr, "Errore Thrust: %s\n", e.what());
        return EXIT_FAILURE;
    }
    CUDA_CHECK(cudaStreamSynchronize(s));
    printf("somma dei quadrati = %.0f\n", somma);
    CUDA_CHECK(cudaStreamDestroy(s));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
