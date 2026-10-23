__global__ void passo(const float* a, float* b, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    if (i == 0 || i == n - 1) b[i] = a[i];
    else b[i] = 0.25f * a[i - 1] + 0.5f * a[i]
              + 0.25f * a[i + 1];
}

void passi_diretti(float* a, float* b, int n, int k,
                   cudaStream_t s)
{
    int bs = 256, grid = (n + bs - 1) / bs;
    for (int p = 0; p < k; ++p) {
        passo<<<grid, bs, 0, s>>>(a, b, n);
        float* t = a; a = b; b = t;
    }
}

int main()
{
    const int n = 1 << 20, k = 100;
    float *a, *b;
    CUDA_CHECK(cudaMalloc(&a, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&b, n * sizeof(float)));
    CUDA_CHECK(cudaMemset(a, 0, n * sizeof(float)));
    cudaStream_t s;
    CUDA_CHECK(cudaStreamCreate(&s));
    cudaEvent_t e0, e1;
    CUDA_CHECK(cudaEventCreate(&e0));
    CUDA_CHECK(cudaEventCreate(&e1));

    // riscaldamento e misura diretta
    passi_diretti(a, b, n, k, s);
    CUDA_CHECK(cudaEventRecord(e0, s));
    passi_diretti(a, b, n, k, s);
    CUDA_CHECK(cudaEventRecord(e1, s));
    CUDA_CHECK(cudaEventSynchronize(e1));
    float tDir;
    CUDA_CHECK(cudaEventElapsedTime(&tDir, e0, e1));

    // cattura del graph
    cudaGraph_t g;
    cudaGraphExec_t ge;
    CUDA_CHECK(cudaStreamBeginCapture(
        s, cudaStreamCaptureModeGlobal));
    passi_diretti(a, b, n, k, s);
    CUDA_CHECK(cudaStreamEndCapture(s, &g));
    CUDA_CHECK(cudaGraphInstantiate(&ge, g, 0));

    CUDA_CHECK(cudaGraphLaunch(ge, s));   // riscaldamento
    CUDA_CHECK(cudaEventRecord(e0, s));
    CUDA_CHECK(cudaGraphLaunch(ge, s));
    CUDA_CHECK(cudaEventRecord(e1, s));
    CUDA_CHECK(cudaEventSynchronize(e1));
    float tGraph;
    CUDA_CHECK(cudaEventElapsedTime(&tGraph, e0, e1));

    size_t nodi;
    CUDA_CHECK(cudaGraphGetNodes(g, nullptr, &nodi));
    printf("graph con %zu nodi\n", nodi);
    printf("%d passi diretti: %.3f ms  graph: %.3f ms\n",
           k, tDir, tGraph);

    CUDA_CHECK(cudaGraphExecDestroy(ge));
    CUDA_CHECK(cudaGraphDestroy(g));
    CUDA_CHECK(cudaEventDestroy(e0));
    CUDA_CHECK(cudaEventDestroy(e1));
    CUDA_CHECK(cudaStreamDestroy(s));
    CUDA_CHECK(cudaFree(a));
    CUDA_CHECK(cudaFree(b));
    return 0;
}
