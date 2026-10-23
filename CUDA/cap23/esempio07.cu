#include <cstdio>
#include <thrust/device_vector.h>
#include <thrust/inner_product.h>
#include <thrust/functional.h>

int main()
{
    const int n = 10000000;
    thrust::device_vector<float> a(n, 0.1f), b(n, 3.0f);
    double d = thrust::inner_product(
        a.begin(), a.end(), b.begin(), 0.0,
        thrust::plus<double>(), thrust::multiplies<double>());
    float f = thrust::inner_product(
        a.begin(), a.end(), b.begin(), 0.0f);
    printf("double: %.3f\nfloat : %.3f\n", d, f);
    return 0;
}
