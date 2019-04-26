function T=CombineTraces(traces,delay)

T=[];
for i=1:length(traces)
    L(i)=length(traces{i});
    for i2=1:L(i)
        t=i2+(i-1)*delay;
        if t>length(T)
            T(t)=traces{i}(i2);
        else
            T(t)=T(t)+traces{i}(i2);
        end
    end
end