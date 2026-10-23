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

__global__ void quadrato(float* a, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) a[i] = a[i] * a[i];
}

struct Info {
    float* h;
    int n;
};

void CUDART_CB pronto(void* dati)
{
    Info* c = (Info*)dati;
    double s = 0.0;
    for (int i = 0; i < c->n; ++i) s += c->h[i];
    printf("callback: dati pronti, somma = %.0f\n", s);
}

int main()
{
    const int n = 1 << 16;
    size_t bytes = (size_t)n * sizeof(float);
    float* hp;
    CUDA_CHECK(cudaMallocHost(&hp, bytes));
    for (int i = 0; i < n; ++i) hp[i] = 2.0f;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, bytes));
    cudaStream_t s;
    CUDA_CHECK(cudaStreamCreate(&s));

    CUDA_CHECK(cudaMemcpyAsync(d, hp, bytes,
                               cudaMemcpyHostToDevice, s));
    quadrato<<<(n + 255) / 256, 256, 0, s>>>(d, n);
    CUDA_CHECK(cudaMemcpyAsync(hp, d, bytes,
                               cudaMemcpyDeviceToHost, s));
    Info info{hp, n};
    CUDA_CHECK(cudaLaunchHostFunc(s, pronto, &info));
    printf("host: tutto accodato, attendo\n");
    CUDA_CHECK(cudaStreamSynchronize(s));

    CUDA_CHECK(cudaStreamDestroy(s));
    CUDA_CHECK(cudaFree(d));
    CUDA_CHECK(cudaFreeHost(hp));
    return 0;
}
