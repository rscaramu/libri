// scegli.cu - selezione del dispositivo e attributi
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

__global__ void prova() {
    if (threadIdx.x == 0)
        printf("Kernel in esecuzione sul blocco %d\n",
               blockIdx.x);
}

int main() {
    int count = 0;
    CUDA_CHECK(cudaGetDeviceCount(&count));
    if (count == 0) {
        fprintf(stderr, "Nessuna GPU CUDA\n");
        return 1;
    }

    int best = 0, bestSM = 0;
    for (int d = 0; d < count; d++) {
        int sm = 0;
        CUDA_CHECK(cudaDeviceGetAttribute(
            &sm, cudaDevAttrMultiProcessorCount, d));
        if (sm > bestSM) { bestSM = sm; best = d; }
    }
    CUDA_CHECK(cudaSetDevice(best));

    int major = 0, minor = 0, clock = 0;
    CUDA_CHECK(cudaDeviceGetAttribute(
        &major, cudaDevAttrComputeCapabilityMajor, best));
    CUDA_CHECK(cudaDeviceGetAttribute(
        &minor, cudaDevAttrComputeCapabilityMinor, best));
    CUDA_CHECK(cudaDeviceGetAttribute(
        &clock, cudaDevAttrClockRate, best));
    printf("Uso il dispositivo %d: cc %d.%d, %d SM, "
           "%.2f GHz\n",
           best, major, minor, bestSM, clock / 1.0e6);

    if (major < 8) {
        fprintf(stderr,
                "Serve compute capability >= 8.0\n");
        return 1;
    }

    size_t libera = 0, totale = 0;
    CUDA_CHECK(cudaMemGetInfo(&libera, &totale));
    printf("Memoria: %.1f GiB liberi su %.1f GiB\n",
           libera / 1073741824.0,
           totale / 1073741824.0);

    prova<<<3, 32>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    return 0;
}
