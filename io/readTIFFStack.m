function volume = readTIFFStack(tifPath)
%READTIFF Read a grayscale TIFF stack.
% Usage:
%   volume = readTIFFStack(tifPath)
%
% See also: saveTIFFStack

info = imfinfo(tifPath);
numSecs = length(info);

volume = cell(numSecs,1);
t = Tiff(tifPath, 'r');
while true
    volume{t.currentDirectory} = t.read();
    if t.lastDirectory
        break;
    end
    t.nextDirectory();
end
volume = cat(3, volume{:});

end

