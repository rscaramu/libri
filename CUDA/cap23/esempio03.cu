#include <cstdio>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/iterator/constant_iterator.h>

int main()
{
    const int n = 1 << 22;      // 4 milioni di letture
    thrust::host_vector<int> hpos(n), hq(n);
    unsigned s = 12345;
    for (int i = 0; i < n; ++i) {
        s = s * 1103515245u + 12345u;
        hpos[i] = (s >> 8) % 100000;    // posizione
        hq[i] = (s >> 4) % 60;          // qualita 0..59
    }
    thrust::device_vector<int> pos = hpos, q = hq;

    // ordina per posizione, portando dietro la qualita
    thrust::sort_by_key(pos.begin(), pos.end(), q.begin());

    // regione = posizione / 1000
    thrust::device_vector<int> reg(n);
    thrust::transform(pos.begin(), pos.end(), reg.begin(),
        [] __device__ (int p) { return p / 1000; });

    // conteggio per regione: reduce_by_key con valori 1
    thrust::device_vector<int> rkey(n), rcnt(n);
    auto fine = thrust::reduce_by_key(
        reg.begin(), reg.end(),
        thrust::constant_iterator<int>(1),
        rkey.begin(), rcnt.begin());
    int nreg = fine.first - rkey.begin();

    printf("regioni trovate: %d\n", nreg);
    for (int i = 0; i < 3; ++i)
        printf("regione %d: %d letture\n",
               (int)rkey[i], (int)rcnt[i]);
    return 0;
}
