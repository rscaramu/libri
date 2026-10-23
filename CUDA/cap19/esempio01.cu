#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

#define CUDA_CHECK(call)                                   \
    do {                                                   \
        cudaError_t err = (call);                          \
        if (err != cudaSuccess) {                          \
            fprintf(stderr, "Errore CUDA %s:%d: %s\n",     \
                    __FILE__, __LINE__,                    \
                    cudaGetErrorString(err));              \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

#define R 4
#define BLOCK 256

__global__ void stencil1d_shared(const float* in, float* out,
                                 int n)
{
    __shared__ float tile[BLOCK + 2 * R];
    int gi = blockIdx.x * blockDim.x + threadIdx.x;
    int li = threadIdx.x + R;

    // celle centrali
    tile[li] = (gi < n) ? in[gi] : 0.0f;
    // halo sinistro e destro, caricati dai primi R thread
    if (threadIdx.x < R) {
        int gl = gi - R;
        int gr = gi + blockDim.x;
        tile[li - R] = (gl >= 0) ? in[gl] : 0.0f;
        tile[li + blockDim.x] =
            (gr < n) ? in[gr] : 0.0f;
    }
    __syncthreads();

    if (gi >= n) return;
    float acc = 0.0f;
    for (int k = -R; k <= R; k++) acc += tile[li + k];
    out[gi] = acc / (2 * R + 1);
}

int main()
{
    const int n = 1 << 20;
    size_t bytes = n * sizeof(float);
    float* h_in = (float*)malloc(bytes);
    float* h_out = (float*)malloc(bytes);
    for (int i = 0; i < n; i++) h_in[i] = (i % 17) * 0.5f;

    float *d_in, *d_out;
    CUDA_CHECK(cudaMalloc(&d_in, bytes));
    CUDA_CHECK(cudaMalloc(&d_out, bytes));
    CUDA_CHECK(cudaMemcpy(d_in, h_in, bytes,
                          cudaMemcpyHostToDevice));

    int grid = (n + BLOCK - 1) / BLOCK;
    stencil1d_shared<<<grid, BLOCK>>>(d_in, d_out, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_out, d_out, bytes,
                          cudaMemcpyDeviceToHost));

    printf("out[0]=%.4f out[100]=%.4f\n",
           h_out[0], h_out[100]);

    CUDA_CHECK(cudaFree(d_in));
    CUDA_CHECK(cudaFree(d_out));
    free(h_in);
    free(h_out);
    return 0;
}
