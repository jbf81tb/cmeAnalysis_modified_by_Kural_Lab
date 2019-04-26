function [Data,varargout]=FXYCStruct2Data_Minimal(movie,fxycS,framegap,varargin)

if length(varargin)==0
    Cls=7;
    R=2;
else
    Cls=varargin{1};
    if length(varargin)==1
        R=2;
    else
        R=varargin{2};
    end
end

MF=length(imfinfo(movie));
for i=1:MF
    IM(:,:,i)=imread(movie,'Index',i);
end

R=2;  %Radius of pixel sum window: R=2 means 3x3 window with 5x5 ring for background

%i=1;
%i2=1;
h=waitbar(0,'Gathering Trace Data');
%T=4422;
%used=find(Decisions(:,1)==T);
L=[fxycS.lt];

used0=find(L(:)>=4);
varargout{1}=used0;
L2=sum(L(used0))+2*length(L(used0));
events=zeros(L2,3);
ind=1;
for i=1:length(used0)
    T=used0(i);
    if fxycS(T).frame(1)~=1 && max(fxycS(T).frame)~=MF
        Fs=[fxycS(T).frame(1)-1 fxycS(T).frame fxycS(T).frame(end)+1];
        xs=[fxycS(T).xpos(1) fxycS(T).xpos fxycS(T).xpos(end)];
        ys=[fxycS(T).ypos(1) fxycS(T).ypos fxycS(T).ypos(end)];
    else
        if fxycS(T).frame(1)==1 && max(fxycS(T).frame)~=MF
            Fs=[fxycS(T).frame fxycS(T).frame(end)+1];
            xs=[fxycS(T).xpos fxycS(T).xpos(end)];
            ys=[fxycS(T).ypos fxycS(T).ypos(end)];
        else
            if fxycS(T).frame(1)~=1 && max(fxycS(T).frame)==MF
                Fs=[fxycS(T).frame(1)-1 fxycS(T).frame];
                xs=[fxycS(T).xpos(1) fxycS(T).xpos];
                ys=[fxycS(T).ypos(1) fxycS(T).ypos];
            else
                if fxycS(T).frame(1)==1 && max(fxycS(T).frame)==MF
                    Fs=[fxycS(T).frame];
                    xs=[fxycS(T).xpos];
                    ys=[fxycS(T).ypos];
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
[MIs,~]=ManualFitEvents_BackR(events,movie,R,0,'sum');
ind=1;
for i=1:length(used0) %i=used %ceil(rand*2040) %
    waitbar(i/length(used0))
    T=used0(i);

    
    
    if fxycS(T).frame(1)~=1 && max(fxycS(T).frame)~=MF
        Fs=[fxycS(T).frame(1)-1 fxycS(T).frame fxycS(T).frame(end)+1];
        xs=[fxycS(T).xpos(1) fxycS(T).xpos fxycS(T).xpos(end)];
        ys=[fxycS(T).ypos(1) fxycS(T).ypos fxycS(T).ypos(end)];
        Hits=0;
    else
        if fxycS(T).frame(1)==1 && max(fxycS(T).frame)~=MF
            Fs=[fxycS(T).frame fxycS(T).frame(end)+1];
            xs=[fxycS(T).xpos fxycS(T).xpos(end)];
            ys=[fxycS(T).ypos fxycS(T).ypos(end)];
            Hits=1;
        else
            if fxycS(T).frame(1)~=1 && max(fxycS(T).frame)==MF
                Fs=[fxycS(T).frame(1)-1 fxycS(T).frame];
                xs=[fxycS(T).xpos(1) fxycS(T).xpos];
                ys=[fxycS(T).ypos(1) fxycS(T).ypos];
                Hits=2;
            else
                if fxycS(T).frame(1)==1 && max(fxycS(T).frame)==MF
                    Fs=[fxycS(T).frame];
                    xs=[fxycS(T).xpos];
                    ys=[fxycS(T).ypos];
                    Hits=3;
                end
            end
        end
    end
    
    Xs=round(xs);
    Ys=round(ys);
    A=zeros(1,length(Fs));
    for i2=1:length(Fs)
        f=Fs(i2);
        x=Xs(i2);
        y=Ys(i2);
        A(i2)=MIs(ind);
        ind=ind+1;
    end
    Data(i).A=A;
    Data(i).T=T;
    %Data(i).CMED=fxycS(T).classCME;
    Data(i).frame=Fs;
    Data(i).X=xs;
    Data(i).Y=ys;
    Data(i).framegap=framegap;
    Data(i).Hits=Hits;
end
close(h)