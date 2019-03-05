function parcancel()
%PARCANCEL Cancels the running parfeval queue.
% Usage:
%   parcancel
% 
% See also: parfeval

p = gcp('nocreate');

if ~isempty(p)
    NQ = numel(p.FevalQueue.QueuedFutures);
    delete(p.FevalQueue.QueuedFutures);
    NF = numel(p.FevalQueue.RunningFutures);
    delete(p.FevalQueue.RunningFutures);
    
    printf('Deleted %d queued and %d running futures.', NQ, NF)
end

end
