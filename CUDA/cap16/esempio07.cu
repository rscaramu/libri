int main()
{
    const int n = 1 << 22;
    float* d;
    CUDA_CHECK(cudaMalloc(&d, (size_t)n * sizeof(float)));
    CUDA_CHECK(cudaMemset(d, 0, (size_t)n * sizeof(float)));
    cudaEvent_t e0, e1;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));
    lento<<<(n + 255) / 256, 256>>>(d, n, 100);
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaEventRecord(e0));
    CUDA_CHECK(cudaEventRecord(e1));       // prima volta
    lento<<<(n + 255) / 256, 256>>>(d, n, 5000);
    CUDA_CHECK(cudaEventRecord(e1));       // seconda volta
    CUDA_CHECK(cudaEventSynchronize(e1));
    CUDA_CHECK(cudaGetLastError());
    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, e0, e1));
    printf("intervallo e0-e1: %.3f ms\n", ms);

    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
