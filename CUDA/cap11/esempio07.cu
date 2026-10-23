__global__ void sommaBlocchi(const float* x, size_t n,
                             double* parz) {
    size_t i = blockIdx.x * (size_t)blockDim.x + threadIdx.x;
    size_t passo = (size_t)gridDim.x * blockDim.x;
    double s = 0.0;
    for (; i < n; i += passo) s += x[i];
    atomicAdd(&parz[blockIdx.x % 64], s);
}

int main() {
    const size_t gb = 2;
    const size_t n = gb * (1u << 28);
    size_t bytes = n * sizeof(float);
    float* x;
    double* parz;
    CUDA_CHECK(cudaMallocManaged(&x, bytes));
    CUDA_CHECK(cudaMalloc(&parz, 64 * sizeof(double)));
    CUDA_CHECK(cudaMemset(parz, 0, 64 * sizeof(double)));
    for (size_t i = 0; i < n; ++i) x[i] = 1.0f;
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    sommaBlocchi<<<1024, 256>>>(x, n, parz);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    float ms = 0.0f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("%.1f ms\n", ms);
    CUDA_CHECK(cudaFree(x));
    CUDA_CHECK(cudaFree(parz));
    return 0;
}
