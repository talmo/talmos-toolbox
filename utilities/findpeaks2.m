function [peaks] = findpeaks2(time,data,threshold,lengthAP)
numpeaks = 0;
for i = 1:length(time)
    if data(i) > threshold
        numpeaks = numpeaks + 1;
    end
end
peaksdata = zeros(2,numpeaks);
count = 1;
for i = 1:length(time)
    if data(i) > threshold
        peaksdata(1,count) = time(i);
        peaksdata(2,count) = data(i);
        count = count + 1;
    end
end
time = 0;
height = 0;
peaks = zeros(2,numpeaks);
peaknum = 0;
for i = 1:numpeaks
    if i == 1
        time = peaksdata(1,i);
        height = peaksdata(2,i);
    else
        temptime = peaksdata(1,i);
        tempheight = peaksdata(2,i);
        dif = temptime - time;
        if dif < lengthAP
            if tempheight > height
                time = temptime;
                height = tempheight;
            end
        elseif dif > lengthAP
            peaknum = peaknum + 1;
            peaks(1,peaknum) = time;
            peaks(2,peaknum) = height;
            time = temptime;
            height = tempheight;
        end
        if i == numpeaks
            peaknum = peaknum + 1;
            peaks(1,peaknum) = time;
            peaks(2,peaknum) = height;
            time = temptime;
            height = tempheight;
        end
    end
end
zerocolumns = any(peaks==0, 1);
peaks(:, zerocolumns) = [];
end