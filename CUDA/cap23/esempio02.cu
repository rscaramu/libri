#include <cstdio>
#include <cmath>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/transform_reduce.h>
#include <thrust/functional.h>

struct saxpy_functor {
    float a;
    saxpy_functor(float a_) : a(a_) {}
    __host__ __device__
    float operator()(float x, float y) const {
        return a * x + y;
    }
};

int main()
{
    const int n = 1 << 20;
    thrust::device_vector<float> x(n, 1.0f);
    thrust::device_vector<float> y(n, 2.0f);

    // y = 3*x + y con un functor
    thrust::transform(x.begin(), x.end(), y.begin(),
                      y.begin(), saxpy_functor(3.0f));

    // norma di y: somma dei quadrati con una lambda
    float ss = thrust::transform_reduce(
        y.begin(), y.end(),
        [] __device__ (float v) { return v * v; },
        0.0f, thrust::plus<float>());

    printf("y[0] = %.1f  norma = %.1f\n",
           (float)y[0], sqrtf(ss));
    return 0;
}
