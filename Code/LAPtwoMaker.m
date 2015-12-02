function [totalmiddle,SolTwo,middleindex2trace,middleindex2frame]=LAPtwoMaker(traceX,traceY,traceINT)
dt=5;
ft=9; %frame threshold
b=20;
d=20;
[TraceNum,frames]=size(traceX);
totalmiddle=0; %used to initialize middle blocks later
avdist=zeros(1,TraceNum); %used to estimate max displacement guess later
start=zeros(1,TraceNum);
finish=zeros(1,TraceNum);
h=waitbar(0,'initial');
for i=1:TraceNum
    start(i)=find(traceX(i,:),1,'first');
    finish(i)=find(traceX(i,:),1,'last');
    if finish(i)-start(i)>1
        for j=1:finish(i)-start(i)-1
            totalmiddle=totalmiddle+1;
            middleindex2trace(totalmiddle)=i; %keeps trace of where middle indices come from
            middleindex2frame(totalmiddle)=start(i)+j;
            traceframe2middleindex(i,start(i)+j)=totalmiddle;
        end
        for k=1:finish(i)-start(i)
            avdist(i)=avdist(i)+sqrt((traceX(i,start(i)+k)-traceX(i,start(i)+k-1))^2+(traceY(i,start(i)+k)-traceY(i,start(i)+k-1))^2);
        end
        avdist(i)=avdist(i)/(finish(i)-start(i));
    else
        avdist(i)=dt;
    end
    waitbar(i/TraceNum)
end
close(h)
ULblock=single(Inf(TraceNum));
h=waitbar(0,'ULblock');
for i=1:TraceNum %end index
    for j=1:TraceNum %start index
        if start(j)-finish(i)<=ft && start(j)-finish(i)>1
            dist=sqrt((traceX(i,finish(i))-traceX(j,start(j)))^2+(traceY(i,finish(i))-traceY(j,start(j)))^2);
            if dist<dt
                ULblock(i,j)=single(dist^2);
            end
        end
    end
    waitbar(i/TraceNum)
end
close(h)
UMblock=single(Inf(TraceNum,totalmiddle));

h=waitbar(0,'UMblock');

for i=1:TraceNum %end index
    for j=1:TraceNum %start index
        if finish(i)+1<=frames && traceX(j,finish(i)+1)~=0 && traceX(j,finish(i))~=0 && finish(i)+1~=finish(j)
            dist=sqrt((traceX(i,finish(i))-traceX(j,finish(i)+1))^2+(traceY(i,finish(i))-traceY(j,finish(i)+1))^2);
            if dist < avdist(i)*2
                rho=traceINT(j,finish(i)+1)/(traceINT(j,finish(i))+traceINT(i,finish(i)));
                if rho>1
                    UMblock(i,traceframe2middleindex(j,finish(i)+1))=single(dist^2*rho);
                else
                    UMblock(i,traceframe2middleindex(j,finish(i)+1))=single(dist^2*rho^(-2));
                end
            end
        end
        
    end
    waitbar(i/TraceNum)
end
close(h)
MLblock=single(Inf(totalmiddle,TraceNum));
middleindex=1;
h=waitbar(0,'MLblock');
for j=1:TraceNum %start index
    for i=1:TraceNum %middle index
       
        if start(j)-1>0 && traceX(i,start(j)-1)~=0 && traceX(i,start(j))~=0 && start(j)-1~=start(i)
            dist=sqrt((traceX(i,start(j)-1)-traceX(j,start(j)))^2+(traceY(i,start(j)-1)-traceY(j,start(j)))^2);
            if dist < avdist(j)*2
                rho=traceINT(i,start(j)-1)/(traceINT(j,start(j))+traceINT(i,start(j)-1));
                if rho>1
                    MLblock(traceframe2middleindex(i,start(j)-1),j)=single(dist^2*rho);
                else
                    MLblock(traceframe2middleindex(i,start(j)-1),j)=single(dist^2*rho^(-2));
                end
            end
        end
    end
    waitbar(j/TraceNum)
end
close(h)
MMblock=single(Inf(totalmiddle));
LLblock=single(Inf(TraceNum+totalmiddle,TraceNum));
for i=1:TraceNum
    LLblock(i,i)=single(b);
end
URblock=single(Inf(TraceNum,TraceNum+totalmiddle));
for i=1:TraceNum
    URblock(i,i)=single(d);
end
LMblock=single(Inf(TraceNum+totalmiddle,totalmiddle));
MRblock=single(Inf(totalmiddle,TraceNum+totalmiddle));
for i=1:totalmiddle
    rho=traceINT(middleindex2trace(i),middleindex2frame(i))/traceINT(middleindex2trace(i),middleindex2frame(i)-1);
    if rho<1
        rho=rho^(-2);
    end
    LMblock(TraceNum+i,i)=single(avdist(middleindex2trace(i))^2*rho);
end
for i=1:totalmiddle
    rho=traceINT(middleindex2trace(i),middleindex2frame(i))/traceINT(middleindex2trace(i),middleindex2frame(i)-1);
    rho=rho^(-1);
    if rho<1
        rho=rho^(-2);
    end
    MRblock(i,TraceNum+i)=single(avdist(middleindex2trace(i))^2);
end

Block=single([[ULblock UMblock];[MLblock MMblock]]);
LRblock=single(transpose(Block));
LAPtwo=single([[Block [URblock;MRblock]];[LLblock LMblock LRblock]]);
clear Sola SolOneFrame LRblock LLblock URblock MMblock MLblock MRblock Block LMblock UMblock ULblock
    [Sola,~,~,~,~]=lapjv(LAPtwo,.1);
    clear LAPtwo
    n=length(Sola);
    SolTwoFrame=zeros(n);
    for i=1:n
        SolTwoFrame(i,Sola(i))=1;
    end
    SolTwo=SolTwoFrame;