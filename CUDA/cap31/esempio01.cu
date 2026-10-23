int main(int argc, char** argv)
{
    int n = (argc > 1) ? atoi(argv[1]) : 16384;
    int steps = 10;
    float dt = 0.001f;
    float eps2 = 0.01f;
    std::vector<float4> h_pos(n), h_vel(n);
    init_bodies(h_pos, h_vel, n);
    size_t bytes = (size_t)n * sizeof(float4);
    float4 *d_pos, *d_vel, *d_acc;
    CUDA_CHECK(cudaMalloc(&d_pos, bytes));
    CUDA_CHECK(cudaMalloc(&d_vel, bytes));
    CUDA_CHECK(cudaMalloc(&d_acc, bytes));
    const char* names[2] = { "naive", "tiled" };
    for (int mode = 0; mode < 2; ++mode) {
        CUDA_CHECK(cudaMemcpy(d_pos, h_pos.data(), bytes,
                              cudaMemcpyHostToDevice));
        CUDA_CHECK(cudaMemcpy(d_vel, h_vel.data(), bytes,
                              cudaMemcpyHostToDevice));
        // riscaldamento: un passo non misurato
        run_steps(mode == 1, d_pos, d_vel, d_acc,
                  n, 1, dt, eps2);
        float ms = run_steps(mode == 1, d_pos, d_vel,
                             d_acc, n, steps, dt, eps2);
        double inter = (double)n * n * steps;
        double gflops = 20.0 * inter / (ms * 1e6);
        printf("%-6s n=%d: %.3f ms/passo, %.1f GFLOPS\n",
               names[mode], n, ms / steps, gflops);
    }
    CUDA_CHECK(cudaMemcpy(h_pos.data(), d_pos, bytes,
                          cudaMemcpyDeviceToHost));
    int nan_count = 0;
    for (int i = 0; i < n; ++i) {
        if (std::isnan(h_pos[i].x)) ++nan_count;
    }
    printf("corpo 0: (%.4f, %.4f, %.4f)  NaN: %d\n",
           h_pos[0].x, h_pos[0].y, h_pos[0].z, nan_count);
    CUDA_CHECK(cudaFree(d_pos));
    CUDA_CHECK(cudaFree(d_vel));
    CUDA_CHECK(cudaFree(d_acc));
    return 0;
}
