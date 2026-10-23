int main()
{
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, 0));
    printf("%s (cc %d.%d), %d SM\n", p.name, p.major,
           p.minor, p.multiProcessorCount);
    printf("thread per SM      : %d (%d warp)\n",
           p.maxThreadsPerMultiProcessor,
           p.maxThreadsPerMultiProcessor / 32);
    printf("blocchi per SM     : %d\n",
           p.maxBlocksPerMultiProcessor);
    printf("registri per SM    : %d\n",
           p.regsPerMultiprocessor);
    printf("shared per SM      : %zu KB\n",
           p.sharedMemPerMultiprocessor / 1024);
    printf("shared per blocco  : %zu KB (opt-in %zu KB)\n",
           p.sharedMemPerBlock / 1024,
           p.sharedMemPerBlockOptin / 1024);
    printf("thread per blocco  : %d\n", p.maxThreadsPerBlock);
    return 0;
}
