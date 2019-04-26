function [Is,Bs,SDBs]=ManualFitEventsFrame_SDB(Xs,Ys,movie,frame,BackR,maxsum)
%Gives manual intensity (Is) of all locations given by (Xs,Ys) in frame of
%movie
%Back R is the distance from the center pixel in the signal ROI (e.g. if
%BackR=2--the signal ROI is 5x5
%a background (Bs) value is then multiplied by the signal area and
%subtracted from I.  B is given by the median intensity of the square of
%pixels around the signal ROI
%If an X,Y is too close to the edge--I=0 B=-1

IM=imread(movie,'Index',frame);
[A,B]=size(IM);
IM=double(IM);
Is=[];
Bs=[];
SDBs=[];
for i=1:length(Xs)
    Px=[];
    Bpx=[];
    if Xs(i)>=1+BackR && Ys(i)>=1+BackR && Xs(i)<=B-BackR && Ys(i)<=A-BackR
        
        for ix=-BackR:BackR
            for iy=-BackR:BackR
                if abs(ix)==BackR || abs(iy)==BackR
                    Bpx=[Bpx IM(Ys(i)+iy,Xs(i)+ix)];
                else
                    Px=[Px IM(Ys(i)+iy,Xs(i)+ix)];
                end
            end
        end
        [Apixel,Bpixel]=size(Px);
        Bsingle=median(Bpx);
        if strcmp(maxsum,'sum')
            I=sum(Px)-Bsingle*Apixel*Bpixel;
        else
            if strcmp(maxsum,'max')
                 I=max(Px)-Bsingle;
            end
        end
        Bs=[Bs Bsingle];
        Is=[Is I];
        SDBs=[SDBs sqrt(var(Bpx))];
    else
        Is=[Is 0];
        Bs=[Bs -1];
        SDBs=[SDBs -1];
    end
end