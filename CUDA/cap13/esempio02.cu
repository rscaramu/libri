// Frammento: warp e lane di ciascun thread.
__global__ void showWarps() {
    int lin = threadIdx.y * blockDim.x + threadIdx.x;
    int warp = lin / warpSize;
    int lane = lin % warpSize;
    unsigned smid;
    asm("mov.u32 %0, %%smid;" : "=r"(smid));
    if (lane == 0 || lane == 31) {
        printf("blocco %d thread (%2d,%2d) lin %3d "
               "warp %d lane %2d SM %u\n",
               blockIdx.x, threadIdx.x, threadIdx.y,
               lin, warp, lane, smid);
    }
}

int main() {
    showWarps<<<2, dim3(16, 4)>>>();
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
    return 0;
}
