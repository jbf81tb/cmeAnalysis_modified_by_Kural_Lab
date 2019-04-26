%fxycS=fxyc_struct;
used2=[];
for i=1:length(fxycS)
    if length(fxycS(i).Splits)>1
        used2=[used2 i];
    end
end
%%
fxycS2=fxycS(used2);
%%
FSFig()
for i0=1:5
    N=ceil(rand*length(fxycS2));
    Ns(i0)=N;
%     N=Ns(i0);
    subplot(5,2,(i0-1)*2+1)
    plot(fxycS2(N).int)
    C=fxycS2(N).class;
    G=fxycS2(N).goodness;
    str=strcat(num2str(C),':',num2str(G),',');
    title(str)
    subplot(5,2,(i0-1)*2+2)
    nsplits=length(fxycS2(N).Splits);
    ss=[1 fxycS2(N).Splits(2:end) length(fxycS2(N).frame)];
    for i=1:nsplits
        plot(fxycS2(N).frame(ss(i):ss(i+1)),fxycS2(N).int(ss(i):ss(i+1)))
        hold on
    end
    str='Classes=';
    SC=fxycS2(N).split_class;
    SG=fxycS2(N).split_goodness;
    for i=1:length(SC)
        str=strcat(str,num2str(SC(i)),':',num2str(SG(i)),',');
    end
    title(str)
end
%%
plot(fxycS2(92).int)
%%
u=find(used==used2(92))
%plot(fxycS(u).int)
%%
F1min=[.5 .95]; %Min trace F1s to override criterion that F1s must increase on splits
                %Both subsections must be above first value or one must be
                %above second.
minL=7;
framegap=1;
Hit=0;
Itrace=[Data(u).A];
[Splits,traces,Forig,Fs,Cs]=FindBestMultiSplit_WH(Itrace,Hit,framegap,F1min,minL);
figure
subplot(1,2,1)
plot(Itrace)
subplot(1,2,2)
t=1;
for i=1:length(traces)
    plot(t:t+length(traces{i})-1,traces{i})
    hold on
    t=t+length(traces{i});
end

