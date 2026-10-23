#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <cusparse.h>

#define CUDA_CHECK(call)                                   \
    do {                                                   \
        cudaError_t err = (call);                          \
        if (err != cudaSuccess) {                          \
            fprintf(stderr, "Errore CUDA %s:%d: %s\n",     \
                    __FILE__, __LINE__,                    \
                    cudaGetErrorString(err));              \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

#define CUSPARSE_CHECK(call)                               \
    do {                                                   \
        cusparseStatus_t st = (call);                      \
        if (st != CUSPARSE_STATUS_SUCCESS) {               \
            fprintf(stderr, "Errore cuSPARSE %s:%d: %s\n", \
                    __FILE__, __LINE__,                    \
                    cusparseGetErrorString(st));           \
            exit(EXIT_FAILURE);                            \
        }                                                  \
    } while (0)

int main()
{
    // laplaciano 1D 4x4 (-1 2 -1) in CSR, x = i^2
    const int n = 4, nnz = 10;
    int hptr[n + 1] = {0, 2, 5, 8, 10};
    int hcol[nnz] = {0, 1, 0, 1, 2, 1, 2, 3, 2, 3};
    float hval[nnz] = {2, -1, -1, 2, -1, -1, 2, -1, -1, 2};
    float hx[n] = {0, 1, 4, 9}, hy[n];

    int *dptr, *dcol;
    float *dval, *dx, *dy;
    CUDA_CHECK(cudaMalloc(&dptr, (n + 1) * sizeof(int)));
    CUDA_CHECK(cudaMalloc(&dcol, nnz * sizeof(int)));
    CUDA_CHECK(cudaMalloc(&dval, nnz * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dx, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dy, n * sizeof(float)));
    CUDA_CHECK(cudaMemcpy(dptr, hptr, (n + 1) * sizeof(int),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dcol, hcol, nnz * sizeof(int),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dval, hval, nnz * sizeof(float),
                          cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dx, hx, n * sizeof(float),
                          cudaMemcpyHostToDevice));

    cusparseHandle_t h;
    CUSPARSE_CHECK(cusparseCreate(&h));
    cusparseSpMatDescr_t A;
    cusparseDnVecDescr_t vx, vy;
    CUSPARSE_CHECK(cusparseCreateCsr(
        &A, n, n, nnz, dptr, dcol, dval,
        CUSPARSE_INDEX_32I, CUSPARSE_INDEX_32I,
        CUSPARSE_INDEX_BASE_ZERO, CUDA_R_32F));
    CUSPARSE_CHECK(cusparseCreateDnVec(&vx, n, dx,
                                       CUDA_R_32F));
    CUSPARSE_CHECK(cusparseCreateDnVec(&vy, n, dy,
                                       CUDA_R_32F));

    const float alpha = 1.0f, beta = 0.0f;
    size_t bufsize = 0;
    void* buf = nullptr;
    CUSPARSE_CHECK(cusparseSpMV_bufferSize(
        h, CUSPARSE_OPERATION_NON_TRANSPOSE, &alpha, A, vx,
        &beta, vy, CUDA_R_32F, CUSPARSE_SPMV_ALG_DEFAULT,
        &bufsize));
    CUDA_CHECK(cudaMalloc(&buf, bufsize));
    CUSPARSE_CHECK(cusparseSpMV(
        h, CUSPARSE_OPERATION_NON_TRANSPOSE, &alpha, A, vx,
        &beta, vy, CUDA_R_32F, CUSPARSE_SPMV_ALG_DEFAULT,
        buf));
    CUDA_CHECK(cudaMemcpy(hy, dy, n * sizeof(float),
                          cudaMemcpyDeviceToHost));
    printf("y =");
    for (int i = 0; i < n; ++i) printf(" %.0f", hy[i]);
    printf("\n");

    CUSPARSE_CHECK(cusparseDestroySpMat(A));
    CUSPARSE_CHECK(cusparseDestroyDnVec(vx));
    CUSPARSE_CHECK(cusparseDestroyDnVec(vy));
    CUSPARSE_CHECK(cusparseDestroy(h));
    CUDA_CHECK(cudaFree(buf));
    CUDA_CHECK(cudaFree(dptr));
    CUDA_CHECK(cudaFree(dcol));
    CUDA_CHECK(cudaFree(dval));
    CUDA_CHECK(cudaFree(dx));
    CUDA_CHECK(cudaFree(dy));
    return 0;
}
