#include <mex.h>
#include <windows.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Ref:
    // https://msdn.microsoft.com/en-us/library/windows/desktop/hh706895(v=vs.85).aspx
    // https://msdn.microsoft.com/en-us/library/windows/desktop/dn553408(v=vs.85).aspx
    
    FILETIME preciseTime;
    ULONGLONG t;
    
    // Get time in 0.1 ns ticks from 00:00:00 UTC, 1/1/1601
    GetSystemTimePreciseAsFileTime(&preciseTime);
    
    // Convert to long long
    t = ((ULONGLONG)preciseTime.dwHighDateTime << 32) | (ULONGLONG)preciseTime.dwLowDateTime;
    
    // Return in seconds
    plhs[0] = mxCreateDoubleScalar(t / 10000000.0);
}