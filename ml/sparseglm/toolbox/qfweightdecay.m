function [qf] = qfweightdecay(numels)
    %[qf] = qfweightdecay(numels)
    %Get the quadratic form associated with the weigth-decay regularizer/prior
    %Create a quadratic form for weight decay
    qf = eye(numels);