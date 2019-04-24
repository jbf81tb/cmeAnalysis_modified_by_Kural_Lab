clear
file='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\orig_movies\cell006_Stack1.mat';
movie='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1.tif';
framegap=3;
Data=FXYC2Data(movie,file,framegap);
load('E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1_MultiHumpCategorization_190226.mat')
%%
clear INT1
T=[];
lag=2;
for i=1:2
    used=find(Decisions(:,2)==1);
    Ts=Decisions(used,1);
    r1=ceil(rand*length(Ts));
    % r2=ceil(rand*length(Ts));
    I1=find([Data.T]==Ts(r1));
    INT1{i}=Data(I1).A;
    if i==1
        lag2=0;
    else
        lag2=lag;
    end
    T=CombineTraces({T,INT1{i}},length(T)-lag2);

end
S=length(INT1{1});

figure
subplot(3,2,1)
plot(INT1{1})
subplot(3,2,2)
plot(INT1{2})
subplot(3,1,2)
plot(T)
[Splits,traces,Forig,Fnew]=FindBestMultiSplit(T,3,.95,7);
subplot(3,1,3)
PlotBestMultiSplit(traces,Fnew,Forig);
title(strcat('GT=',num2str(S),' ; Split=',num2str(Splits(end))))

