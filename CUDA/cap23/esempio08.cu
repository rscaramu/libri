#include <cstdio>
#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/discard_iterator.h>

struct segmento {
    __host__ __device__ int operator()(int i) const {
        return i / 1024;
    }
};

int main()
{
    const int nseg = 1000, len = 1024, n = nseg * len;
    thrust::device_vector<float> v(n, 0.5f);
    thrust::device_vector<float> somme(nseg);
    auto chiavi = thrust::make_transform_iterator(
        thrust::counting_iterator<int>(0), segmento());
    thrust::reduce_by_key(chiavi, chiavi + n, v.begin(),
                          thrust::make_discard_iterator(),
                          somme.begin());
    printf("somma segmento 0: %.1f, 999: %.1f\n",
           (float)somme[0], (float)somme[999]);
    return 0;
}
