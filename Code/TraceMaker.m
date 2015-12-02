function [TraceX,TraceY,TraceINT,Link,TraceIndex]=TraceMaker(X,Y,INT,ParticleNum,SolOne)
%Takes solution to LAPone and links particles into trajectories

TraceIndex=1; %Keeps track of first empty trace row
[Boy,frames]=size(X); %Boy=max # of spots
h=waitbar(0,'Creating Traces');
TraceX=zeros(ParticleNum(1),frames);
TraceY=zeros(ParticleNum(1),frames);
TraceINT=zeros(ParticleNum(1),frames);
Link=zeros(ParticleNum(1)*frames,frames);
for i=1:ParticleNum(1)
    if X(i,1)~=Inf
        TraceX(TraceIndex,1)=X(i,1);
        TraceY(TraceIndex,1)=Y(i,1);
        TraceINT(TraceIndex,1)=INT(i,1);
        Link(i,1)=TraceIndex;  %Use to Look up which trace a particle went into
        TraceIndex=TraceIndex+1;
    end
end
for k=1:frames-1
    for i=1:ParticleNum(k)+ParticleNum(k+1)
        for j=1:ParticleNum(k)+ParticleNum(k+1)
            if i>ParticleNum(k) && j<=ParticleNum(k+1) && SolOne(i,j,k)==1 && X(j,k+1)~=Inf %Newborn Particles
                TraceX(TraceIndex,k+1)=X(j,k+1);
                TraceY(TraceIndex,k+1)=Y(j,k+1);
                TraceINT(TraceIndex,k+1)=INT(j,k+1);
                Link(j,k+1)=TraceIndex;
                TraceIndex=TraceIndex+1;
            end
            %dead particles take care of themselves (and tell no tales)
            if i<=ParticleNum(k) && j<=ParticleNum(k+1) && SolOne(i,j,k)==1%Linked Particles
                TraceX(Link(i,k),k+1)=X(j,k+1);
                TraceY(Link(i,k),k+1)=Y(j,k+1);
                TraceINT(Link(i,k),k+1)=INT(j,k+1);
                Link(j,k+1)=Link(i,k);
            end
        end
    end
    waitbar(k/frames)
end
close(h)