__global__ void axpy(int n, float a, const float* x,
                     float* y)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) y[i] = a * x[i] + y[i];
}

template <typename F>
float mediana(F lancia, int rip)
{
    cudaEvent_t e0, e1;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));
    for (int i = 0; i < 3; ++i) lancia();
    CUDA_CHECK(cudaDeviceSynchronize());
    std::vector<float> t(rip);
    for (int i = 0; i < rip; ++i) {
        CUDA_CHECK(cudaEventRecord(e0));
        lancia();
        CUDA_CHECK(cudaEventRecord(e1));
        CUDA_CHECK(cudaEventSynchronize(e1));
        CUDA_CHECK(cudaEventElapsedTime(&t[i], e0, e1));
    }
    CUDA_CHECK(cudaGetLastError());
    std::sort(t.begin(), t.end());
    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
    return t[rip / 2];
}

int main()
{
    const int n = 1 << 26;
    size_t bytes = (size_t)n * sizeof(float);
    float *x, *y;
    CUDA_CHECK(cudaMalloc(&x, bytes));
    CUDA_CHECK(cudaMalloc(&y, bytes));
    CUDA_CHECK(cudaMemset(x, 0, bytes));
    CUDA_CHECK(cudaMemset(y, 0, bytes));
    for (int bs = 32; bs <= 1024; bs *= 2) {
        int grid = (n + bs - 1) / bs;
        float ms = mediana([&] {
            axpy<<<grid, bs>>>(n, 2.0f, x, y);
        }, 20);
        printf("blocco %4d: %.3f ms  %.0f GB/s\n", bs, ms,
               3.0 * bytes / (ms * 1e-3) / 1e9);
    }
    CUDA_CHECK(cudaFree(x));
    CUDA_CHECK(cudaFree(y));
    return 0;
}
