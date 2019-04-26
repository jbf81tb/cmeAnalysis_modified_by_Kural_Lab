
% used=find(Decisions(:,2)==1);
% Ts=Decisions(used,1);
% r1=ceil(rand*length(Ts));
% % r2=ceil(rand*length(Ts));
% I1=find([Data.T]==Ts(r1));
% T=Data(I1).A;
[Splits,traces,Forig,Fnew]=FindBestMultiSplit(T,3,.95,7);

PlotBestMultiSplit(traces,Fnew,Forig);

%%
STrace=Temp_BestSplitPlot(T,3);
figure
STracet=Temp_BestSplitPlot(STrace{2},3);

%%
clear Splits traces Forig Fnew
used=find([Data.CMED]==3);
h=waitbar(0,'');
for i=1:length(used)
    waitbar(i/length(used))
    T=Data(used(i)).A;
    [Splits{i},traces{i},Forig(i),Fnew{i}]=FindBestMultiSplit(T,3,.95,7);
end
close(h)
%%
for i=1:length(traces)
    L(i)=length(Fnew{i});
end
Ss=find(L>1);
Us=find(L==1);
%%
figure
for i=1:5
    subplot(2,5,i)
    t=Us(ceil(rand*length(Us)));
    PlotBestMultiSplit(traces{t},Fnew{t},Forig(t));
end
for i=1:5
    subplot(2,5,i+5)
    t=Ss(ceil(rand*length(Ss)));
    PlotBestMultiSplit(traces{t},Fnew{t},Forig(t));
end