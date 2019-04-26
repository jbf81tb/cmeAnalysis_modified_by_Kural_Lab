tic
F1min=0;
MinL=7;
for i=1:length(DataTrain)
    framegap=DataTrain(i).framegap;
    Itrace=DataTrain(i).A;
    [Split(i),Forig(i),Fnew(i,:)]=FindBestSplit(Itrace,framegap,F1min);
    if Split(i)<=MinL || Split(i)>=length(Itrace)-MinL+1
        Split(i)=0;
    end
end
Fmins=min(Fnew,[],2);
Fmaxs=max(Fnew,[],2);
toc
%%
used=find(Split==0 );%& [DataTrain.CMED]==3);
figure
for i=1:10
    subplot(4,5,i)
    I=used(ceil(rand*length(used)));
    Itrace=DataTrain(I).A;
    Temp_PlotSplit(Split(I),Itrace);
    title(strcat(num2str(Forig(I)),',',num2str(Fmaxs(I))))
end
used=find(Split~=0);% & [DataTrain.CMED]==3);
for i=1:10
    subplot(4,5,i+10)
    I=used(ceil(rand*length(used)));
    Itrace=DataTrain(I).A;
    Temp_PlotSplit(Split(I),Itrace);
    title(strcat(num2str(Forig(I)),',',num2str(Fmaxs(I))))
end