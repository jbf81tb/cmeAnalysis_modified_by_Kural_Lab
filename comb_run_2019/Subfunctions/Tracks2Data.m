function Data=Tracks2Data(movie,file,framegap)


load(file,'tracks')
MF=length(imfinfo(movie));
for i=1:MF
    IM(:,:,i)=imread(movie,'Index',i);
end

R=2;

%i=1;
%i2=1;
h=waitbar(0,'Gathering Trace Data');
%T=4422;
%used=find(Decisions(:,1)==T);
L=[];
for i=1:length(tracks)
    L(i)=length(nonzeros(tracks(i).t));
end
used0=find(L(:)>=4);
L=0;
for i=1:length(used0)
    T=used0(i);
    L=L+length(tracks(T).t)+2;
end
events=zeros(L,3);
ind=1;
Cfxyc=cell(length(used0));
for i=1:length(used0)
    T=used0(i);
    Cfxyc{i}=Track2fxyc(tracks(T));
    fxyc=Cfxyc{i};
    if fxyc(1,1)~=1 && max(fxyc(:,1))~=MF
        Fs=[fxyc(1,1)-1 ; fxyc(:,1) ; fxyc(end,1)+1];
        xs=[fxyc(1,2) ; fxyc(:,2) ; fxyc(end,2)];
        ys=[fxyc(1,3) ; fxyc(:,3) ; fxyc(end,3)];
    else
        if fxyc(1,1)==1 && max(fxyc(:,1))~=MF
            Fs=[fxyc(:,1) ; fxyc(end,1)+1];
            xs=[fxyc(:,2) ; fxyc(end,2)];
            ys=[fxyc(:,3) ; fxyc(end,3)];
        else
            if fxyc(1,1)~=1 && max(fxyc(:,1))==MF
                Fs=[fxyc(1,1)-1 ; fxyc(:,1)];
                xs=[fxyc(1,2) ; fxyc(:,2)];
                ys=[fxyc(1,3) ; fxyc(:,3)];
            else
                if fxyc(1,1)==1 && max(fxyc(:,1))==MF
                    Fs=fxyc(:,1);
                    xs=fxyc(:,2);
                    ys=fxyc(:,3);
                end
            end
        end
    end
        
    Xs=round(xs);
    Ys=round(ys);
    for i2=1:length(Fs)
        f=Fs(i2);
        x=Xs(i2);
        y=Ys(i2);
        events(ind,:)=[f x y];
        ind=ind+1;
    end
end
used=find(events(:,1));
events=events(used,:);
[MIs,~]=ManualFitEvents_BackR(events,movie,2,0,'sum');
ind=1;
for i=1:length(used0) %i=used %ceil(rand*2040) %
    waitbar(i/length(used0))
    T=used0(i);
    fxyc=Cfxyc{i};
    A=zeros(1,length(fxyc(:,1)));
    
    if fxyc(1,1)~=1 && max(fxyc(:,1))~=MF
        Fs=[fxyc(1,1)-1 ; fxyc(:,1) ; fxyc(end,1)+1];
        xs=[fxyc(1,2) ; fxyc(:,2) ; fxyc(end,2)];
        ys=[fxyc(1,3) ; fxyc(:,3) ; fxyc(end,3)];
        Hits=0;
    else
        if fxyc(1,1)==1 && max(fxyc(:,1))~=MF
            Fs=[fxyc(:,1) ; fxyc(end,1)+1];
            xs=[fxyc(:,2) ; fxyc(end,2)];
            ys=[fxyc(:,3) ; fxyc(end,3)];
            Hits=1;
        else
            if fxyc(1,1)~=1 && max(fxyc(:,1))==MF
                Fs=[fxyc(1,1)-1 ; fxyc(:,1)];
                xs=[fxyc(1,2) ; fxyc(:,2)];
                ys=[fxyc(1,3) ; fxyc(:,3)];
                Hits=2;
            else
                if fxyc(1,1)==1 && max(fxyc(:,1))==MF
                    Fs=fxyc(:,1);
                    xs=fxyc(:,2);
                    ys=fxyc(:,3);
                    Hits=3;
                end
            end
        end
    end
    
    Xs=round(xs);
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
    Data(i).frame=Fs;
    Data(i).X=xs;
    Data(i).Y=ys;
    Data(i).framegap=framegap;
    Data(i).Hits=Hits;
end
close(h)