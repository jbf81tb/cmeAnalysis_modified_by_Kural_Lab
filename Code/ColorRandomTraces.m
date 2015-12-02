clear all
load('JoshCell1_600_LaxSignalConstraints.mat')
file='1t.tif';
h=waitbar(0,'Plotting Random Traces');
data=[];
for i=1:20
    waitbar(i/20)
    track=ChooseRandomInterestingTrack(Threshfxyc,1000);
    name=strcat('TTrace',num2str(track),'.tif');
    ColorSingleTrace(Threshfxyc,track,file,name);
    clear Sdata
    Sdata=[track];
    used=find(Threshfxyc(:,1,track));
    for i2=1:length(used) %copy intensity data to be used when reviewing the traces
        Sdata=[Sdata;Threshfxyc(used(i2),5,track)];
    end
    data=AddToData(Sdata,data);
end
save SingleTraceData.mat data
close(h)