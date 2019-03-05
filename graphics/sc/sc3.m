function sc3(volume)
%SC3 Wrapper for sc that auto-permutes 3-D volumes.

if ndims(volume) == 3
    volume = permute(volume, [1 2 4 3]);
end

sc(volume)

end

