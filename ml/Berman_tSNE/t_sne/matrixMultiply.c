/*=========================================================
 * matrixMultiply.c - Example for illustrating how to use 
 * BLAS within a C MEX-file. matrixMultiply calls the 
 * BLAS function dgemm.
 *
 * C = matrixMultiply(A,B) computes the product of A*B,
 *     where A, B, and C are matrices.
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2009-2010 The MathWorks, Inc.
 *=======================================================*/

#if !defined(_WIN32)
#define dgemm dgemm_
#endif

#include "mex.h"
#include "blas.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
//     double *A, *B, *C; /* pointers to input & output matrices*/
//     size_t m,n,p;      /* matrix dimensions */
//     /* form of op(A) & op(B) to use in matrix multiplication */
//     char *chn = "N";
//     /* scalar values to use in dgemm */
//     double one = 1.0, zero = 0.0;
// 
//     A = mxGetPr(prhs[0]); /* first input matrix */
//     B = mxGetPr(prhs[1]); /* second input matrix */
//     /* dimensions of input matrices */
//     m = mxGetM(prhs[0]);  
//     p = mxGetN(prhs[0]);
//     n = mxGetN(prhs[1]);
// 
//     if (p != mxGetM(prhs[1])) {
//         mexErrMsgIdAndTxt("MATLAB:matrixMultiply:matchdims",
//                 "Inner dimensions of matrix multiply do not match.");
//     }

    /* create output matrix C */
//     plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
//     C = mxGetPr(plhs[0]);
    
    mxArray *X_arr = prhs[0];
    double *X = mxGetPr(X_arr);
    
    char *TRANSA = "N";
    char *TRANSB = "T";
    
    size_t M = mxGetM(X_arr);
    size_t N = mxGetM(X_arr);
    size_t K = mxGetN(X_arr);
    
    double ALPHA = 1.0;
    double *A = X; // mxGetPr(X_arr);
    size_t LDA = M;
    
    double *B = X; // mxGetPr(X_arr);
    size_t LDB = M;
    double BETA = 0.0;
    
    // double *C
    plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
    double *C = mxGetPr(plhs[0]);
    size_t LDC = M;

    /* Pass arguments to Fortran by reference */
//     dgemm(chn, chn, &m, &n, &p, &one, A, &m, B, &p, &zero, C, &m);
    dgemm(TRANSA, TRANSB, &M, &N, &K, &ALPHA, A, &LDA, B, &LDB, &BETA, C, &LDC);
}

