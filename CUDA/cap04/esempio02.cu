#include <cstdio>
#include <cuda_runtime.h>

int main() {
    size_t libera = 0, totale = 0;
    cudaMemGetInfo(&libera, &totale);
    printf("Memoria device: %zu MiB liberi su %zu MiB\n",
           libera >> 20, totale >> 20);

    float* d_p = nullptr;
    size_t troppo = totale * 4;
    cudaError_t err = cudaMalloc((void**)&d_p, troppo);
    printf("cudaMalloc di %zu MiB:\n  %s (%s)\n",
           troppo >> 20, cudaGetErrorName(err),
           cudaGetErrorString(err));
    printf("puntatore dopo il fallimento: %p\n",
           (void*)d_p);

    err = cudaGetLastError();
    printf("errore pendente: %s\n", cudaGetErrorName(err));
    err = cudaGetLastError();
    printf("seconda lettura: %s\n", cudaGetErrorName(err));
    return 0;
}
