int main()
{
    const int n = 1 << 22;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, (size_t)n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d, 0, (size_t)n * sizeof(float)));
    cudaStream_t s;
    CUDA_CHECK(cudaStreamCreate(&s));
    cudaEvent_t fine;
    CUDA_CHECK(cudaEventCreate(&fine));

    lento<<<(n + 255) / 256, 256, 0, s>>>(d, n, 20000);
    CUDA_CHECK(cudaEventRecord(fine, s));

    long tentativi = 0;
    cudaError_t st;
    while ((st = cudaEventQuery(fine)) == cudaErrorNotReady)
        ++tentativi;
    CUDA_CHECK(st);
    printf("completato dopo %ld interrogazioni\n", tentativi);

    CUDA_CHECK(cudaEventDestroy(fine));
    CUDA_CHECK(cudaStreamDestroy(s));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
