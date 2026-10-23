#include <cstdio>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/sequence.h>

struct pari {
    __host__ __device__ bool operator()(int v) const {
        return v % 2 == 0;
    }
};

int main()
{
    const int n = 1000;
    thrust::device_vector<int> in(n), out(n);
    thrust::sequence(in.begin(), in.end(), 1);   // 1..1000
    auto fine = thrust::copy_if(in.begin(), in.end(),
                                out.begin(), pari());
    int k = fine - out.begin();
    printf("pari trovati: %d, primi tre: %d %d %d\n",
           k, (int)out[0], (int)out[1], (int)out[2]);
    return 0;
}
