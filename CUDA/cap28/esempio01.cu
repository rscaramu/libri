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

__global__ void scrivi_oltre(int *buf, int n, int extra) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    // scrive n + extra elementi: gli ultimi extra sono
    // fuori dal buffer allocato
    if (i < n + extra) buf[i] = i;
}

int main(int argc, char **argv) {
    int extra = (argc > 1) ? atoi(argv[1]) : 0;
    const int n = 1024;
    int *d_buf = nullptr;
    CUDA_CHECK(cudaMalloc(&d_buf, n * sizeof(int)));

    // errore sincrono: configurazione di lancio invalida
    scrivi_oltre<<<1, 2048>>>(d_buf, n, 0);
    cudaError_t e = cudaGetLastError();
    printf("lancio con 2048 thread: %s\n",
           cudaGetErrorString(e));

    // errore asincrono: emerge solo alla sincronizzazione
    int tot = n + extra;
    scrivi_oltre<<<(tot + 255) / 256, 256>>>(d_buf, n, extra);
    e = cudaGetLastError();
    printf("subito dopo il lancio: %s\n",
           cudaGetErrorString(e));
    e = cudaDeviceSynchronize();
    printf("dopo la sincronizzazione: %s\n",
           cudaGetErrorString(e));

    // se l'errore e' permanente, anche questa fallisce
    e = cudaFree(d_buf);
    printf("cudaFree: %s\n", cudaGetErrorString(e));
    return 0;
}
