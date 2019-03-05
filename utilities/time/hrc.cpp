#include <mex.h>
#include <chrono>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    typedef std::chrono::high_resolution_clock Clock;
    //typedef std::chrono::time_point<std::chrono::system_clock> TimePoint;
    typedef std::chrono::duration<double> Seconds;
    
    auto clockStamp = Clock::now();
    Seconds secsSinceEpoch = clockStamp.time_since_epoch();
    double t = t.count();
    
    //double t = (double)std::chrono::duration_cast<std::chrono::nanoseconds>(clockStamp.time_since_epoch()).count() / 1e9;
    
    plhs[0] = mxCreateDoubleScalar(t);
    
    //typedef std::chrono::high_resolution_clock Time;
    //typedef std::chrono::duration<double> sec;
    
    //auto t = Time::now();
    //sec t_sec = t.time_since_epoch();
    
//     unsigned long milliseconds_since_epoch = 
//     std::chrono::duration_cast<std::chrono::nanoseconds>
//         (std::chrono::system_clock::now().time_since_epoch()).count();
    //std::chrono::time_point<std::chrono::system_clock> t = std::chrono::high_resolution_clock::now().time_since_epoch();
    //plhs[0] = mxCreateDoubleScalar((double)std::chrono::duration_cast<chrono::nanoseconds>(t).count() / 1e9);
    //plhs[0] = mxCreateDoubleScalar(t_sec.count());
}