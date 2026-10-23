__global__ void contaPositivi(const float* x, int n,
                              int* cont) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n && x[i] > 0.0f) atomicAdd(cont, 1);
}

int main() {
    const int n = 1 << 20;
    float* h_x;
    int* h_cont;
    CUDA_CHECK(cudaHostAlloc(&h_x, n * sizeof(float),
                             cudaHostAllocMapped));
    CUDA_CHECK(cudaHostAlloc(&h_cont, sizeof(int),
                             cudaHostAllocMapped));
    for (int i = 0; i < n; ++i) h_x[i] = (i % 3) - 1.0f;
    *h_cont = 0;
    float* d_x;
    int* d_cont;
    CUDA_CHECK(cudaHostGetDevicePointer(&d_x, h_x, 0));
    CUDA_CHECK(cudaHostGetDevicePointer(&d_cont, h_cont, 0));
    contaPositivi<<<(n + 255) / 256, 256>>>(d_x, n, d_cont);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    printf("positivi: %d su %d\n", *h_cont, n);
    CUDA_CHECK(cudaFreeHost(h_x));
    CUDA_CHECK(cudaFreeHost(h_cont));
    return 0;
}
