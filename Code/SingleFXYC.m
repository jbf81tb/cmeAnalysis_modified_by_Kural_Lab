function fxyc=SingleFXYC(Trace,BigX,BigY,BigF)

lastF=-1;
time=1;
ind=0;
for i=1:length(BigX(Trace,:))
    if BigX(Trace,i)>0
    if BigF(Trace,i)~=lastF+1;
        time=1;
        ind=ind+1;
        fxyc(time,1,ind)=floor(BigF(Trace,i));
        fxyc(time,2,ind)=floor(BigX(Trace,i));
        fxyc(time,3,ind)=floor(BigY(Trace,i));
        fxyc(time,4,ind)=3;
        fxyc(time,5,ind)=1000;
        lastF=BigF(Trace,i);
    else
        time=time+1;
        fxyc(time,1,ind)=floor(BigF(Trace,i));
        fxyc(time,2,ind)=floor(BigX(Trace,i));
        fxyc(time,3,ind)=floor(BigY(Trace,i));
        fxyc(time,4,ind)=3;
        fxyc(time,5,ind)=1000;
        lastF=BigF(Trace,i);
    end
    end
end
