static float evaluate(Net& net, const float* x, const int* y,
                      int n, int* correct_out)
{
    const float one = 1.f, zero = 0.f;
    int B = net.B, total_correct = 0;
    double total_loss = 0.0;
    std::vector<float> loss(B);
    for (int off = 0; off + B <= n; off += B) {
        CUBLAS_CHECK(cublasSgemm(net.h, CUBLAS_OP_N,
            CUBLAS_OP_N, HID, B, IN, &one, net.w1, HID,
            x + (size_t)off * IN, IN, &zero, net.a1, HID));
        bias_relu<<<blocks_for((size_t)HID * B), 256>>>(
            net.a1, net.b1, HID, B);
        CUBLAS_CHECK(cublasSgemm(net.h, CUBLAS_OP_N,
            CUBLAS_OP_N, OUT, B, HID, &one, net.w2, OUT,
            net.a1, HID, &zero, net.z2, OUT));
        CUDA_CHECK(cudaMemsetAsync(net.correct, 0,
                                   sizeof(int)));
        softmax_xent<<<blocks_for(B), 256>>>(net.z2, net.b2,
            y + off, net.loss, net.correct, B);
        int c;
        CUDA_CHECK(cudaMemcpy(&c, net.correct, sizeof(int),
                              cudaMemcpyDeviceToHost));
        CUDA_CHECK(cudaMemcpy(loss.data(), net.loss,
            B * sizeof(float), cudaMemcpyDeviceToHost));
        for (float l : loss) total_loss += l;
        total_correct += c;
    }
    int used = (n / B) * B;
    *correct_out = total_correct;
    return (float)(total_loss / used);
}

int main()
{
    std::vector<float> xtr, xte;
    std::vector<int> ytr, yte;
    int ntr, nte;
    if (!load_mnist("train-images-idx3-ubyte",
                    "train-labels-idx1-ubyte", xtr, ytr, ntr)
        || !load_mnist("t10k-images-idx3-ubyte",
                       "t10k-labels-idx1-ubyte", xte, yte,
                       nte)) {
        fprintf(stderr, "file MNIST non trovati\n");
        return 1;
    }
    const int B = 128, epochs = 5;
    const float lr = 0.1f;
    float* d_xtr = dev_alloc(xtr.size(), xtr.data());
    float* d_xte = dev_alloc(xte.size(), xte.data());
    int *d_ytr, *d_yte;
    CUDA_CHECK(cudaMalloc(&d_ytr, ntr * sizeof(int)));
    CUDA_CHECK(cudaMalloc(&d_yte, nte * sizeof(int)));
    CUDA_CHECK(cudaMemcpy(d_ytr, ytr.data(),
        ntr * sizeof(int), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_yte, yte.data(),
        nte * sizeof(int), cudaMemcpyHostToDevice));
    Net net;
    net_init(net, B);
    int nbatch = ntr / B;
    std::vector<int> order(nbatch);
    for (int i = 0; i < nbatch; ++i) order[i] = i;
    std::mt19937 gen(7);
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    for (int ep = 1; ep <= epochs; ++ep) {
        std::shuffle(order.begin(), order.end(), gen);
        CUDA_CHECK(cudaEventRecord(t0));
        for (int bi : order) {
            train_step(net, d_xtr + (size_t)bi * B * IN,
                       d_ytr + bi * B, lr);
        }
        CUDA_CHECK(cudaEventRecord(t1));
        CUDA_CHECK(cudaEventSynchronize(t1));
        float ms = 0.f;
        CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
        int corr;
        float loss = evaluate(net, d_xte, d_yte, nte, &corr);
        printf("epoca %d: %.0f ms, test loss %.4f, "
               "accuratezza %.2f%%\n", ep, ms, loss,
               100.0 * corr / ((nte / B) * B));
    }
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    CUDA_CHECK(cudaFree(d_xtr));
    CUDA_CHECK(cudaFree(d_xte));
    CUDA_CHECK(cudaFree(d_ytr));
    CUDA_CHECK(cudaFree(d_yte));
    CUBLAS_CHECK(cublasDestroy(net.h));
    // libera in un colpo tutti i buffer di net
    CUDA_CHECK(cudaDeviceReset());
    return 0;
}
