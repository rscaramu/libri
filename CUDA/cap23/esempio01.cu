#include <cstdio>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>
#include <thrust/sequence.h>

int main()
{
    thrust::host_vector<int> h(10);
    for (int i = 0; i < 10; ++i) h[i] = (i * 7) % 10;

    thrust::device_vector<int> d = h;      // copia H->D
    int somma = thrust::reduce(d.begin(), d.end(), 0);
    thrust::sort(d.begin(), d.end());
    h = d;                                 // copia D->H

    printf("somma = %d\nordinato:", somma);
    for (int i = 0; i < 10; ++i) printf(" %d", h[i]);
    printf("\n");
    return 0;
}
