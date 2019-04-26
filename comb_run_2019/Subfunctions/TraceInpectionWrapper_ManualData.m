clear
Temp_LoadManualData
file='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\orig_movies\cell006_Stack1.mat';
load(file)
movie='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1.tif';
for i=1:length(imfinfo(movie))
    IM(:,:,i)=imread(movie,'Index',i);
end

%%

t=ceil(rand*36);
T=DataVal(t).T;
D=DataVal(t).Dec;
CME=DataVal(t).CMED;
C=DataVal(t).ML;
tit=strcat('(Decision,CME,LR)=(',num2str(D),',',num2str(CME),',',num2str(C),')');

trace=Threshfxyc(:,:,T);
Fs=DataVal(t).frame;
As=DataVal(t).A;
u=find(trace(:,1));
trace=trace(u,:);
TraceInspection(trace,IM,tit,Fs,As);
