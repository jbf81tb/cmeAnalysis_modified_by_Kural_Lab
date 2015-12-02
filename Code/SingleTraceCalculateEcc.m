movie='ColdblockShort-Eccentricity.tif';
frames=length(imfinfo(movie));
FIMG=imread(movie,'Index',1);
[ymax,xmax]=size(FIMG);
eccV=zeros(1,frames);
R2V=zeros(1,frames);
areaV=zeros(1,frames);
for i=1:frames
    FIMG=imread(movie,'Index',i);
    maximum=max(max(FIMG));
    ind=find(Threshfxyc(:,1,1)==i);
    if ~isempty(ind)
    x=Threshfxyc(ind,2,1);
    y=Threshfxyc(ind,3,1);
    x=max(4,min(xmax-3,x(1))); %make sure you can make a 7x7 box around the point
    y=max(4,min(ymax-3,y(1)));
    IMG=zeros(7);
    for i2=-3:3
        for i3=-3:3
            IMG(i2+4,i3+4)=FIMG(y+i2,x+i3);
        end
    end
    try
        [c,R2] = twoDgaussianFittingPlot(IMG);
        [ecc,area]=ConvertEllipticalParameters(c(5),c(6),c(7));
    catch
        ecc=-1; %Fitting didn't work -- -1 is the signal for an error to be used later
        area=-1;
    end
    eccV(i)=ecc;
    R2V(i)=R2;
    aveaV(i)=area;
    area
    ecc
    R2
    pause
    
    end
end