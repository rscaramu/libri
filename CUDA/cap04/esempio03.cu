#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

__global__ void innocuo(float* v) {
    v[threadIdx.x] = 1.0f;
}

__global__ void colpevole(float* v) {
    float* p = (float*)0x10;
    *p = v[0];
}

int main() {
    float* d_v = nullptr;
    cudaMalloc((void**)&d_v, 32 * sizeof(float));

    innocuo<<<1, 2048>>>(d_v);
    cudaError_t e1 = cudaGetLastError();
    printf("lancio con 2048 thread: %s\n",
           cudaGetErrorName(e1));

    colpevole<<<1, 1>>>(d_v);
    cudaError_t e2 = cudaGetLastError();
    printf("subito dopo il lancio: %s\n",
           cudaGetErrorName(e2));
    cudaError_t e3 = cudaDeviceSynchronize();
    printf("dopo la sincronizzazione: %s\n",
           cudaGetErrorName(e3));

    cudaError_t e4 = cudaFree(d_v);
    printf("cudaFree successiva: %s\n",
           cudaGetErrorName(e4));
    return 0;
}
