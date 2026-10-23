__global__ void somma(const float* a, const float* b,
                      float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

int main() {
    const int n = 1 << 22;
    size_t bytes = n * sizeof(float);
    float *a, *b, *c;
    CUDA_CHECK(cudaMallocManaged(&a, bytes));
    CUDA_CHECK(cudaMallocManaged(&b, bytes));
    CUDA_CHECK(cudaMallocManaged(&c, bytes));
    for (int i = 0; i < n; ++i) {
        a[i] = i;
        b[i] = 2.0f * i;
    }
    somma<<<(n + 255) / 256, 256>>>(a, b, c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    double err = 0.0;
    for (int i = 0; i < n; ++i)
        err += fabs(c[i] - 3.0 * i);
    printf("errore totale: %g\n", err);
    CUDA_CHECK(cudaFree(a));
    CUDA_CHECK(cudaFree(b));
    CUDA_CHECK(cudaFree(c));
    return 0;
}
