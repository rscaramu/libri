__global__ void vuoto() {}

int main()
{
    const int rip = 1000;
    cudaEvent_t e0, e1;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));
    for (int i = 0; i < 10; ++i) vuoto<<<1, 32>>>();
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaEventRecord(e0));
    for (int i = 0; i < rip; ++i) vuoto<<<1, 32>>>();
    CUDA_CHECK(cudaEventRecord(e1));
    CUDA_CHECK(cudaEventSynchronize(e1));
    CUDA_CHECK(cudaGetLastError());

    float ms;
    CUDA_CHECK(cudaEventElapsedTime(&ms, e0, e1));
    printf("%d lanci in %.3f ms: %.2f us per lancio\n",
           rip, ms, ms * 1000.0f / rip);

    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
    return 0;
}
