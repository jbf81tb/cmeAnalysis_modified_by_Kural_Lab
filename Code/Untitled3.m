TraceX=csvread('TraceXtwo.csv');
traceX=csvread('traceX.csv');
totlengtht=0;
totlengthT=0;
t=0;
T=0;
for i=1:3624
    %totlengtht=totlengtht+length(find(traceX(i,:)));
    %totlengthT=totlengthT+length(find(TraceX(i,:)));
    if length(find(traceX(i,:)))~=0
        t=t+1;
    end
    if length(find(TraceX(i,:)))~=0
        T=T+1;
    end
end
t
T