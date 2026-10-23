#define NB 256

__global__ void histGlobale(const unsigned char* d, int n,
                            unsigned* h) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int passo = gridDim.x * blockDim.x;
    for (; i < n; i += passo) atomicAdd(&h[d[i]], 1u);
}

__global__ void histPrivato(const unsigned char* d, int n,
                            unsigned* h) {
    __shared__ unsigned loc[NB];
    for (int k = threadIdx.x; k < NB; k += blockDim.x)
        loc[k] = 0;
    __syncthreads();
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int passo = gridDim.x * blockDim.x;
    for (; i < n; i += passo) atomicAdd(&loc[d[i]], 1u);
    __syncthreads();
    for (int k = threadIdx.x; k < NB; k += blockDim.x)
        if (loc[k]) atomicAdd(&h[k], loc[k]);
}

static float tempo(void (*k)(const unsigned char*, int,
                             unsigned*),
                   const unsigned char* d, int n,
                   unsigned* h) {
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaMemset(h, 0, NB * sizeof(unsigned)));
    CUDA_CHECK(cudaEventRecord(t0));
    k<<<46 * 6, 256>>>(d, n, h);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms = 0.0f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return ms;
}

int main(int argc, char** argv) {
    const int n = 64 << 20;
    int sbil = (argc > 1) ? atoi(argv[1]) : 0;
    unsigned char* h_d = (unsigned char*)malloc(n);
    for (int i = 0; i < n; ++i) {
        int r = (i * 2654435761u) >> 24;
        h_d[i] = (r < sbil) ? 7 : (unsigned char)r;
    }
    unsigned char* d_d;
    unsigned* d_h;
    CUDA_CHECK(cudaMalloc(&d_d, n));
    CUDA_CHECK(cudaMalloc(&d_h, NB * sizeof(unsigned)));
    CUDA_CHECK(cudaMemcpy(d_d, h_d, n,
                          cudaMemcpyHostToDevice));
    printf("globale: %.2f ms  privato: %.2f ms\n",
           tempo(histGlobale, d_d, n, d_h),
           tempo(histPrivato, d_d, n, d_h));
    CUDA_CHECK(cudaFree(d_d));
    CUDA_CHECK(cudaFree(d_h));
    free(h_d);
    return 0;
}
