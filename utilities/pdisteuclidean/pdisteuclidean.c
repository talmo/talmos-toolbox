/*=========================================================
 * pdisteuclidean.c -- Computes the pairwise Euclidean
 * distance between rows of the input matrix using BLAS
 * routines.
 *
 * Ref: https://gist.github.com/synapticarbors/5790459
 *=======================================================*/

#if !defined(_WIN32)
#define dgemm dgemm_
#endif

#include "mex.h"
#include "blas.h"
#include "math.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Input:  X: double array of size M x K
    // Output: C: double array of size M x M
    
    mxArray *X_arr = prhs[0];
    double *X = mxGetPr(X_arr);
    
    /* Reference:
     DGEMM  performs one of the matrix-matrix operations

        C := alpha*op( A )*op( B ) + beta*C,

     where  op( X ) is one of

        op( X ) = X   or   op( X ) = X**T,

     alpha and beta are scalars, and A, B and C are matrices, with op( A )
     an m by k matrix,  op( B )  a  k by n matrix and  C an m by n matrix.
     
     Docs: http://www.netlib.org/lapack/explore-html/d1/d54/group__double__blas__level3_gaeda3cbd99c8fb834a60a6412878226e1.html#gaeda3cbd99c8fb834a60a6412878226e1
    */
    
    char *TRANSA = "N"; // no transpose
    char *TRANSB = "T"; // transpose
    
    size_t M = mxGetM(X_arr);
    size_t N = mxGetM(X_arr);
    size_t K = mxGetN(X_arr);
    
    double ALPHA = -2.0;
    double *A = X;
    size_t LDA = M;
    
    double *B = X;
    size_t LDB = M;
    double BETA = 1.0;
    
    plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
    mxArray *C_arr = plhs[0];
    double *C = mxGetPr(C_arr);
    size_t LDC = M;
    
    // C = -2.0 * X * X'
    dgemm(TRANSA, TRANSB, &M, &N, &K, &ALPHA, A, &LDA, B, &LDB, &BETA, C, &LDC);
    
    // sx = sum(X .^ 2, 2)
    size_t i, j, off, idx;
    mxArray *sx_arr = mxCreateDoubleMatrix(M, 1, mxREAL);
    double *sx = mxGetPr(sx_arr);
    for (i = 0; i < M; i++)
    {
        for (size_t j = 0; j < K; j++)
        {
            idx = i + (j * M);
            sx[i] += X[idx] * X[idx];
        }
    }
    
    size_t ii, ij, ji;
    for (i = 0; i < M - 1; i++)
    {
        ii = i + (i * M);
        C[ii] = 0;
        for (j = i+1; j < M; j++)
        {
            ij = i + (j * M);
            ji = j + (i * M);
            
            C[ij] += sx[i] + sx[j]; // C[i,j] += (sx[i] + sx[j])
            C[ij] = sqrt(C[ij]);    // C[i,j] = sqrt(C[i,j])
            C[ji] = C[ij];          // C[j,i] = C[i,j]
        }
    }
    C[(M - 1) + ((M - 1) * M)] = 0;

    // C is returned in plhs[0]
}
