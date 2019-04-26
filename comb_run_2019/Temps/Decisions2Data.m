function Data=Decisions2Data(Decisions,movie,file,framegap)


load(file,'Threshfxyc')

for i=1:length(imfinfo(movie))
    IM(:,:,i)=imread(movie,'Index',i);
end

R=2;

%i=1;
%i2=1;
h=waitbar(0,'Gathering Trace Data');
%T=4422;
%used=find(Decisions(:,1)==T);

used0=[Decisions.T];
L=0;
for i=1:length(used0)
    T=used0(i);
    L=L+length(Threshfxyc(:,1,T))+2;
end
events=zeros(L,3);
ind=1;
for i=1:length(used0)
    T=used0(i);
    fxyc=Threshfxyc(:,:,T);
    used=find(fxyc(:,1));
    fxyc=fxyc(used,:);
    A=zeros(1,length(used));
    Fs=[fxyc(1,1)-1 ; fxyc(:,1) ; fxyc(end,1)+1];
    xs=[fxyc(1,2) ; fxyc(:,2) ; fxyc(end,2)];
    Xs=round(xs);
    ys=[fxyc(1,3) ; fxyc(:,3) ; fxyc(end,3)];
    Ys=round(ys);
    for i2=1:length(Fs)
        f=Fs(i2);
        x=Xs(i2);
        y=Ys(i2);
        events(ind,:)=[f x y];
        ind=ind+1;
    end
end
[MIs,~]=ManualFitEvents_BackR(events,movie,2,0,'sum');
ind=1;
for i=1:length(used0) %i=used %ceil(rand*2040) %
    waitbar(i/length(used0))
    T=used0(i);
    fxyc=Threshfxyc(:,:,T);
    used=find(fxyc(:,1));
    fxyc=fxyc(used,:);
    A=zeros(1,length(used));
    Fs=[fxyc(1,1)-1 ; fxyc(:,1) ; fxyc(end,1)+1];
    xs=[fxyc(1,2) ; fxyc(:,2) ; fxyc(end,2)];
    Xs=round(xs);
    ys=[fxyc(1,3) ; fxyc(:,3) ; fxyc(end,3)];
    Ys=round(ys);
    for i2=1:length(Fs)
        f=Fs(i2);
        x=Xs(i2);
        y=Ys(i2);
        A(i2)=MIs(ind);
        ind=ind+1;
    end
    Data(i).A=A;
    Data(i).T=T;
    Data(i).CMED=fxyc(1,4);
    Data(i).frame=Fs;
    Data(i).X=xs;
    Data(i).Y=ys;
    Data(i).Dec=Decisions(i).D;
end
medI=median([Data.A]);
for i=1:length(used0)
    Data(i).medI=medI;
    Data(i).framegap=framegap;
end
close(h)