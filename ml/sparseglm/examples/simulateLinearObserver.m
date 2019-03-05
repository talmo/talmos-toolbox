function [noisefields, N, rawsignals, responses,v] = simulateLinearObserver(numtrials,signal,template)

    signal = signal(:);
    template = template(:);
    targetpc = 0.81;
    targetpcs = 0.75;
    
    %Simulate numtrials trials
    noisefields = randn(numtrials,numel(signal));
    rawsignals = (sign(randn(numtrials,1)) + 1)/2; %+- 1
    
    %Now create signal matrix
    signals = outer(rawsignals,signal,1);
    
    %Now adjust alpha so that observer is performing at 81% before
    %the addition of noise

    v = noisefields*template;
    stdv = std(v);
    offset1 = norminv(targetpc);
    offset2 = norminv(targetpcs);
    stdn = sqrt((1/offset2)^2-(1/offset1)^2);
    v = 1/stdn*((v - mean(v))/stdv/offset1 + (rawsignals*2-1));
    
    responses = sign(v + randn(size(v)));
    
    N = noisefields/stdv/offset1 + signals;
    
    rawsignals = 2*rawsignals - 1;
end