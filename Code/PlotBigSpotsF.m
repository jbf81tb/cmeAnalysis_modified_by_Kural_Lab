function PlotBigSpotsF(selected2,NewMovie2)
path='FlyP2ManualInt175.mat';
movie2='FlyStack2TAv.tif';
frames=308;
load(path);
h=waitbar(0,'');
for i=1:frames
  
    A2=imread(movie2,'Index',i);
 

    B2(:,:,1)=A2;
    B2(:,:,2)=A2;
    B2(:,:,3)=A2;
    found=zeros(length(fxyc(1,1,:)),2);
    iff=1;
    for i2=1:length(fxyc(:,1,1))
        for i3=1:length(fxyc(1,1,:))
            if fxyc(i2,1,i3)==i && ~isempty(find(selected2==i3))
                found(iff,:)=[i2 i3];
                iff=iff+1;
            end
        end
    end
    if ~isempty(found)
    for i2=1:length(found(:,1)) %Color found colocalizations
        %z=min(fxyc(found(i2,1),8,found(i2,2))/norm,1); %Calculate z position by finding where the intensity is centered
       if found(i2,1)~=0
        x2=fxyc(found(i2,1),2,found(i2,2));
        y2=fxyc(found(i2,1),3,found(i2,2));
       
        B2(y2,x2,1)=3000;
        B2(y2,x2,2)=0;
        B2(y2,x2,3)=0;
       end
    end
    end

    imwrite(B2,NewMovie2,'Writemode','append','Compression','none');
    waitbar(i/frames);
end
close(h);