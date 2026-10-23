#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

__global__ void riempi(float* v, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    v[i] = (float)i;
}

__global__ void riempi_ok(float* v, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] = (float)i;
}

int main() {
    const int n = 1000;
    float* d_v = nullptr;
    cudaMalloc((void**)&d_v, n * sizeof(float));

    riempi<<<1 << 16, 256>>>(d_v, n);
    printf("dopo il lancio: %s\n",
           cudaGetErrorName(cudaGetLastError()));
    printf("dopo la sync: %s\n",
           cudaGetErrorName(cudaDeviceSynchronize()));

    cudaFree(d_v);
    return 0;
}
