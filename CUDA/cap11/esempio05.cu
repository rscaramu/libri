int main() {
    const size_t maxb = 256u << 20;
    void* h;
    void* d;
    CUDA_CHECK(cudaMallocHost(&h, maxb));
    CUDA_CHECK(cudaMalloc(&d, maxb));
    for (size_t b = 4096; b <= maxb; b *= 2)
        printf("%10zu byte: %6.2f GB/s\n", b,
               misura(h, d, b));
    CUDA_CHECK(cudaFreeHost(h));
    CUDA_CHECK(cudaFree(d));
    return 0;
}
