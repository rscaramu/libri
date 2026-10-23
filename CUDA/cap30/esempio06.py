# frammento: richiede il Toolkit e un compilatore C++
from torch.utils.cpp_extension import load_inline

cuda_src = r"""
__global__ void relu_k(const float *x, float *y, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) y[i] = x[i] > 0 ? x[i] : 0;
}
torch::Tensor relu_cuda(torch::Tensor x) {
    auto y = torch::empty_like(x);
    int n = x.numel();
    relu_k<<<(n + 255) / 256, 256>>>(
        x.data_ptr<float>(), y.data_ptr<float>(), n);
    return y;
}
"""
cpp_src = "torch::Tensor relu_cuda(torch::Tensor x);"
ext = load_inline(name="mio_relu", cpp_sources=cpp_src,
                  cuda_sources=cuda_src,
                  functions=["relu_cuda"])
