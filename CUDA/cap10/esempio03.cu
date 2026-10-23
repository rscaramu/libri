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

__global__ void campiona(cudaTextureObject_t tex,
                         const float2* pts, float* out,
                         int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    out[i] = tex2D<float>(tex, pts[i].x, pts[i].y);
}

int main() {
    const int w = 8, h = 4;
    float h_img[h * w];
    for (int y = 0; y < h; ++y)
        for (int x = 0; x < w; ++x)
            h_img[y * w + x] = x + 10.0f * y;

    cudaChannelFormatDesc fmt =
        cudaCreateChannelDesc<float>();
    cudaArray_t arr;
    CUDA_CHECK(cudaMallocArray(&arr, &fmt, w, h));
    size_t pitch = w * sizeof(float);
    CUDA_CHECK(cudaMemcpy2DToArray(arr, 0, 0, h_img, pitch,
                                   pitch, h,
                                   cudaMemcpyHostToDevice));
    cudaResourceDesc res = {};
    res.resType = cudaResourceTypeArray;
    res.res.array.array = arr;
    cudaTextureDesc td = {};
    td.addressMode[0] = cudaAddressModeClamp;
    td.addressMode[1] = cudaAddressModeClamp;
    td.filterMode = cudaFilterModeLinear;
    td.readMode = cudaReadModeElementType;
    cudaTextureObject_t tex = 0;
    CUDA_CHECK(cudaCreateTextureObject(&tex, &res, &td,
                                       nullptr));
    const int n = 4;
    float2 h_pts[n] = {{0.5f, 0.5f}, {1.25f, 0.5f},
                       {0.5f, 1.0f}, {20.0f, 0.5f}};
    float2* d_pts;
    float* d_out;
    CUDA_CHECK(cudaMalloc(&d_pts, sizeof(h_pts)));
    CUDA_CHECK(cudaMalloc(&d_out, n * sizeof(float)));
    CUDA_CHECK(cudaMemcpy(d_pts, h_pts, sizeof(h_pts),
                          cudaMemcpyHostToDevice));
    campiona<<<1, 32>>>(tex, d_pts, d_out, n);
    CUDA_CHECK(cudaGetLastError());
    float h_out[n];
    CUDA_CHECK(cudaMemcpy(h_out, d_out, n * sizeof(float),
                          cudaMemcpyDeviceToHost));
    for (int i = 0; i < n; ++i)
        printf("(%5.2f, %5.2f) -> %6.3f\n",
               h_pts[i].x, h_pts[i].y, h_out[i]);

    CUDA_CHECK(cudaDestroyTextureObject(tex));
    CUDA_CHECK(cudaFreeArray(arr));
    CUDA_CHECK(cudaFree(d_pts));
    CUDA_CHECK(cudaFree(d_out));
    return 0;
}
