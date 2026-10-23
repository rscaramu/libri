__global__ void rilassa(const float* in, float* out,
                        int n, float soglia, int* flag) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i <= 0 || i >= n - 1) return;
    float v = 0.5f * (in[i - 1] + in[i + 1]);
    out[i] = v;
    if (fabsf(v - in[i]) > soglia) *flag = 1;
}

int main() {
    const int n = 1 << 16;
    size_t bytes = n * sizeof(float);
    float *d_a, *d_b;
    CUDA_CHECK(cudaMalloc(&d_a, bytes));
    CUDA_CHECK(cudaMalloc(&d_b, bytes));
    float* h = (float*)malloc(bytes);
    for (int i = 0; i < n; ++i) h[i] = (float)i / (n - 1);
    h[n / 2] += 0.01f;
    CUDA_CHECK(cudaMemcpy(d_a, h, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, d_a, bytes,
                          cudaMemcpyDeviceToDevice));
    int* h_flag;
    int* d_flag;
    CUDA_CHECK(cudaHostAlloc(&h_flag, sizeof(int),
                             cudaHostAllocMapped));
    CUDA_CHECK(cudaHostGetDevicePointer(&d_flag, h_flag, 0));
    int iter = 0;
    do {
        *h_flag = 0;
        rilassa<<<(n + 255) / 256, 256>>>(d_a, d_b, n,
                                          1e-3f, d_flag);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaDeviceSynchronize());
        float* t = d_a; d_a = d_b; d_b = t;
    } while (*h_flag && ++iter < 100000);
    printf("convergenza dopo %d iterazioni\n", iter + 1);
    CUDA_CHECK(cudaFreeHost(h_flag));
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    free(h);
    return 0;
}
