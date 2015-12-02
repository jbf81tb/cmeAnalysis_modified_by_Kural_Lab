function Thresh=MultiSectionThreshFinder(FoundSpotsC,movies,FitA,FitC)

frames=length(imfinfo(movies{1}));
done=false;
frame=ceil(frames/2);
Thresh=0; %Just need to initialize the variable for the next line--value unimportant
while done==false
    lastThresh=Thresh;
    Thresh=input('Percent Decay Between Sections= (0 when satisfied) ');
    close
    FitB=-1*log(1-Thresh/100)/frames;
    if Thresh==0
        Thresh=lastThresh;
        return
    end
    for i=1:length(movies)
        FThresh=FitA*exp(-1*FitB*(i-.5))+FitC;
        A=imread(movies{i},'Index',frame);
        [b,c]=size(A);
        B(:,:,1)=A;
        B(:,:,2)=A;
        B(:,:,3)=A;
        inds=[];
        FoundSpots=FoundSpotsC{i};
        ind=find(FoundSpots(:,1)==frame);
        bright=max(max(A))/1;
        [L]=length(ind);
        Bim=zeros(b,c);
        for j=1:L
            if FoundSpots(ind(j),4)>=FThresh
                x=floor(FoundSpots(ind(j),2));
                y=floor(FoundSpots(ind(j),3));
                Bim(y,x)=1;
                singles=bwboundaries(Bim(:,:),'noholes');
            end
        end
        for i2=1:length(singles)
            y(i2)=singles{i2,1}(1,1);
            x(i2)=singles{i2,1}(1,2);
            B(y(i2),x(i2),1)=bright;
            B(y(i2),x(i2),2)=0;
            B(y(i2),x(i2),3)=0;
        end
        colormap(gray);
        maximum=65535;
        subplot(2,3,i);
        C=B*(maximum/bright);
        image(C);
    end
end