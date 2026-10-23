// arch.cu - confronto fra scheda e architettura compilata
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

__device__ int arch_compilata;

__global__ void leggi_arch() {
#ifdef __CUDA_ARCH__
    arch_compilata = __CUDA_ARCH__;
#endif
}

int main() {
    int major = 0, minor = 0;
    CUDA_CHECK(cudaDeviceGetAttribute(
        &major, cudaDevAttrComputeCapabilityMajor, 0));
    CUDA_CHECK(cudaDeviceGetAttribute(
        &minor, cudaDevAttrComputeCapabilityMinor, 0));
    int scheda = major * 100 + minor * 10;

    leggi_arch<<<1, 1>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    int compilata = 0;
    CUDA_CHECK(cudaMemcpyFromSymbol(
        &compilata, arch_compilata, sizeof(int)));

    printf("Scheda: sm_%d  Binario: sm_%d\n",
           scheda / 10, compilata / 10);
    if (scheda != compilata)
        printf("Attenzione: compilato per"
               " un'altra architettura\n");
    else
        printf("Codice nativo per questa scheda\n");
    return 0;
}
