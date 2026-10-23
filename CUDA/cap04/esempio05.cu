#include <cstdio>
#include <cstdlib>
#include <vector>
#include <cuda_runtime.h>

int main() {
    const size_t blocco = 256u << 20;
    std::vector<void*> blocchi;
    for (;;) {
        void* p = nullptr;
        cudaError_t err = cudaMalloc(&p, blocco);
        if (err != cudaSuccess) {
            printf("fallito al blocco %zu: %s\n",
                   blocchi.size() + 1,
                   cudaGetErrorName(err));
            break;
        }
        blocchi.push_back(p);
    }
    printf("ottenuti %zu blocchi (%zu MiB)\n",
           blocchi.size(), blocchi.size() * 256);

    cudaError_t pendente = cudaGetLastError();
    printf("errore azzerato: %s\n",
           cudaGetErrorName(pendente));

    for (void* p : blocchi) cudaFree(p);
    blocchi.clear();

    void* q = nullptr;
    cudaError_t err = cudaMalloc(&q, blocco);
    printf("nuova allocazione: %s\n",
           cudaGetErrorName(err));
    cudaFree(q);
    return 0;
}
