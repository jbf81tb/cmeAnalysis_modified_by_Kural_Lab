clear all;
path='FlyP2ManualInt175.mat';
movie2='FlyStack2TAv.tif';
frames=308;
NewMovie2='FlyManualInt2.tif';
load(path);
dist=[];
for i2=1:length(fxyc(:,1,1))
    for i3=1:length(fxyc(1,1,:))
        if fxyc(i2,8,i3)~=0
            dist=[dist fxyc(i2,8,i3)];
        end
    end
end
norm=prctile(dist,90);
for i=1:frames
  
    A2=imread(movie2,'Index',i);
 

    B2(:,:,1)=A2;
    B2(:,:,2)=A2;
    B2(:,:,3)=A2;
    found=[];
    for i2=1:length(fxyc(:,1,1))
        for i3=1:length(fxyc(1,1,:))
            if fxyc(i2,1,i3)==i
                found=[found;[i2 i3]];
            end
        end
    end

    for i2=1:length(found(:,1)) %Color found colocalizations
        z=min(fxyc(found(i2,1),8,found(i2,2))/norm,1); %Calculate z position by finding where the intensity is centered
       
        x2=fxyc(found(i2,1),2,found(i2,2));
        y2=fxyc(found(i2,1),3,found(i2,2));
       
        B2(y2,x2,1)=2000*(z);
        B2(y2,x2,2)=2000*(1-z);
        B2(y2,x2,3)=0;
        
    end

    imwrite(B2,NewMovie2,'Writemode','append','Compression','none');
    waitbar(i/frames);
end
close(h);