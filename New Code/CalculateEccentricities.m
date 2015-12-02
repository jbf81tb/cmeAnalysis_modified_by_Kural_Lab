function fxyc=CalculateEccentricities(movie,fxyc) %eccentricities are stored in slot 10

windowradius=2; %side length would be 2*radius+1
[A,B,C]=size(fxyc);
frames=length(imfinfo(movie));
h=waitbar(0,'Finding Eccentricities');
for frame=1:frames
    waitbar(frame/frames)
    FIMG=imread(movie,'Index',frame);
    for i=1:C
        used=find(fxyc(:,1,i)==frame);
        for i2=1:length(used)
            x=fxyc(used(i2),2,i);
            y=fxyc(used(i2),3,i);
            IMG=zeros(2*windowradius+1);
            for i3=-windowradius:windowradius
                for i4=-windowradius:windowradius
                    IMG(i3+windowradius+1,i4+windowradius+1)=FIMG(y+i3,x+i4);
                end
            end
            try
            [c,R2] = twoDgaussianFitting(IMG);
            [ecc,area]=ConvertEllipticalParameters(c(5),c(6),c(7));
            catch
                ecc=-1; %Fitting didn't work -- -1 is the signal for an error to be used later
                area=-1;
                R2=-1;
            end
            
            fxyc(used(i2),10,i)=ecc;
            fxyc(used(i2),11,i)=area;
            fxyc(used(i2),9,i)=R2;
        end
    end
end
close(h)

