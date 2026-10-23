__global__ void figlio(float* seg, int len, int id)
{
    int i = threadIdx.x;
    if (i < len) seg[i] = seg[i] * 2.0f;
    if (i == 0)
        printf("figlio %d: segmento di %d elementi\n",
               id, len);
}

__global__ void padre(float* a, const float* soglia,
                      int nseg, int len)
{
    int s = blockIdx.x * blockDim.x + threadIdx.x;
    if (s >= nseg) return;
    float somma = 0.0f;
    for (int i = 0; i < len; ++i) somma += a[s * len + i];
    if (somma > *soglia) {
        figlio<<<1, len, 0, cudaStreamFireAndForget>>>(
            a + s * len, len, s);
    }
}

int main()
{
    const int nseg = 8, len = 64, n = nseg * len;
    float* h = (float*)malloc(n * sizeof(float));
    for (int s = 0; s < nseg; ++s)
        for (int i = 0; i < len; ++i)
            h[s * len + i] = (s % 3 == 0) ? 1.0f : 0.1f;
    float *d, *dsoglia;
    float soglia = 10.0f;
    CUDA_CHECK(cudaMalloc(&d, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dsoglia, sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d, h, n * sizeof(float),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dsoglia, &soglia, sizeof(float),
                          cudaMemcpyHostToDevice));

    padre<<<1, nseg>>>(d, dsoglia, nseg, len);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaMemcpy(h, d, n * sizeof(float),
                          cudaMemcpyDeviceToHost));
    printf("seg 0: %.1f  seg 1: %.1f  seg 3: %.1f\n",
           h[0], h[len], h[3 * len]);
    CUDA_CHECK(cudaFree(d));
    CUDA_CHECK(cudaFree(dsoglia));
    free(h);
    return 0;
}
