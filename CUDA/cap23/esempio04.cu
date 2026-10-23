#include <cstdio>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/fill.h>
#include <thrust/transform_reduce.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/tuple.h>
#include <thrust/functional.h>

struct energia {
    __host__ __device__
    float operator()(
        const thrust::tuple<float, float, float, float>& t)
        const
    {
        float vx = thrust::get<0>(t), vy = thrust::get<1>(t);
        float vz = thrust::get<2>(t), m = thrust::get<3>(t);
        return 0.5f * m * (vx * vx + vy * vy + vz * vz);
    }
};

int main()
{
    const int n = 1000000;
    thrust::device_vector<float> vx(n), vy(n), vz(n), m(n);
    // inizializzazione con counting_iterator + lambda
    thrust::counting_iterator<int> c0(0);
    thrust::transform(c0, c0 + n, vx.begin(),
        [] __device__ (int i) { return (i % 10) * 0.1f; });
    thrust::fill(vy.begin(), vy.end(), 1.0f);
    thrust::fill(vz.begin(), vz.end(), 0.0f);
    thrust::fill(m.begin(), m.end(), 2.0f);

    auto inizio = thrust::make_zip_iterator(
        thrust::make_tuple(vx.begin(), vy.begin(),
                           vz.begin(), m.begin()));
    float e = thrust::transform_reduce(
        inizio, inizio + n, energia(), 0.0f,
        thrust::plus<float>());
    printf("energia cinetica totale = %.1f\n", e);
    return 0;
}
