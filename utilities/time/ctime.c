#include <mex.h>
#include <time.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    time_t seconds_past_epoch = time(0);
    plhs[0] = mxCreateDoubleScalar((double)seconds_past_epoch);
}