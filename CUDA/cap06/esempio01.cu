#include <cstdio>
#include <cstdlib>
#include <cmath>
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

struct Vec3 {
    float x, y, z;
    __host__ __device__ Vec3() : x(0), y(0), z(0) {}
    __host__ __device__ Vec3(float a, float b, float c)
        : x(a), y(b), z(c) {}
    __host__ __device__ Vec3 operator+(Vec3 o) const {
        return Vec3(x + o.x, y + o.y, z + o.z);
    }
    __host__ __device__ Vec3 operator*(float k) const {
        return Vec3(x * k, y * k, z * k);
    }
};

__host__ __device__ Vec3 passo_eulero(Vec3 p, Vec3 v,
                                      float dt) {
    return p + v * dt;
}

__global__ void integra(Vec3* pos, const Vec3* vel,
                        float dt, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) pos[i] = passo_eulero(pos[i], vel[i], dt);
}

int main() {
    const int n = 1 << 20;
    const size_t bytes = n * sizeof(Vec3);
    Vec3* h_pos = (Vec3*)malloc(bytes);
    Vec3* h_vel = (Vec3*)malloc(bytes);
    Vec3* h_ref = (Vec3*)malloc(bytes);
    for (int i = 0; i < n; ++i) {
        h_pos[i] = Vec3((float)i, 0.0f, 1.0f);
        h_vel[i] = Vec3(1.0f, 2.0f, -1.0f);
        h_ref[i] = passo_eulero(h_pos[i], h_vel[i], 0.5f);
    }

    Vec3 *d_pos, *d_vel;
    CUDA_CHECK(cudaMalloc((void**)&d_pos, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_vel, bytes));
    CUDA_CHECK(cudaMemcpy(d_pos, h_pos, bytes,
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_vel, h_vel, bytes,
                          cudaMemcpyHostToDevice));

    integra<<<(n + 255) / 256, 256>>>(d_pos, d_vel,
                                      0.5f, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_pos, d_pos, bytes,
                          cudaMemcpyDeviceToHost));

    int errori = 0;
    for (int i = 0; i < n; ++i)
        if (h_pos[i].x != h_ref[i].x ||
            h_pos[i].y != h_ref[i].y ||
            h_pos[i].z != h_ref[i].z) ++errori;
    printf("pos[10] = (%.1f, %.1f, %.1f), errori %d\n",
           h_pos[10].x, h_pos[10].y, h_pos[10].z, errori);

    CUDA_CHECK(cudaFree(d_pos));
    CUDA_CHECK(cudaFree(d_vel));
    free(h_pos); free(h_vel); free(h_ref);
    return 0;
}
