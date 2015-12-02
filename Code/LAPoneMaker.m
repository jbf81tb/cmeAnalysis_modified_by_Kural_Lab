function [SolOne,ParticleNum]=LAPoneMaker(X,Y,INT)

%code used to form frame to frame linking optimization matrices
b=20; %temporary values for test (initial costs of births and deaths)
d=20;

dt=5; %initial distance threshold
maxcost=20/1.05;
[Boy,frames]=size(X); %Boy=max # of spots
for j=1:frames
    for i=1:Boy
        ParticleNum(j)=Boy;
        if X(Boy-i+1,j)==Inf
            ParticleNum(j)=Boy-i;
        end
    end
end
h=waitbar(0,'Linking Particles in Adjacent Frames');
for k=1:frames-1
    b=maxcost*1.05;
    d=maxcost*1.05;
    ULblock=Inf(ParticleNum(k),ParticleNum(k+1));
    for i=1:ParticleNum(k)
        for j=1:ParticleNum(k+1) 
            dist=sqrt((X(i,k)-X(j,k+1))^2+(Y(i,k)-Y(j,k+1))^2);
            INTchange=INT(i,k)/INT(j,k+1);
            if INTchange<1
                INTchange=INTchange^(-1);
            end
            if dist<dt
                ULblock(i,j)=dist^2*INTchange;
            else
                ULblock(i,j)=Inf;
            end
        end
    end
    LRblock(:,:)=transpose(ULblock(:,:));
    URblock=Inf(ParticleNum(k));
    LLblock=Inf(ParticleNum(k+1));
    for i=1:ParticleNum(k)
        URblock(i,i)=d;
    end
    for j=1:ParticleNum
        LLblock(j,j)=b;
    end
    LAPone(:,:)=[[ULblock URblock]; [LLblock LRblock]];
    
    clear Sola SolOneFrame
    [Sola,~,~,~,~]=lapjv(LAPone(:,:));
    n=length(Sola);
    SolOneFrame=zeros(ParticleNum(k)+ParticleNum(k+1),ParticleNum(k)+ParticleNum(k+1));
    for i=1:n
        SolOneFrame(i,Sola(i))=1;
        costs(i)=LAPone(i,Sola(i));
    end
    SolOne(:,:,k)=SolOneFrame;
    mcost=max(costs);
    maxcost=max(maxcost,mcost);
    clear LAPone costs
    waitbar(k/frames)
end
close(h);