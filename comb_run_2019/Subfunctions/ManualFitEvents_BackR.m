function [Is,Bs,varargout]=ManualFitEvents_BackR(events,movie,BackR,SD,maxsum)
%Gives manual intensity (Is) of all locations given by events (FXY)
%Back R is the distance+1 from the center pixel in the signal ROI (e.g. if
%BackR=2--the signal ROI is 3x3
%a background (Bs) value is then multiplied by the signal area and
%subtracted from I.  B is given by the median intensity of the square of
%pixels around the signal ROI
%If an X,Y is too close to the edge--I=0 B=-1


%BackR=2; %Distance+1 from center to outside box of area of interst %Found 3 is better than 4 (10/11/17)
F=length(imfinfo(movie));
%h=waitbar(0,'Performing Manual Pixel Sums');
if ~SD
    for i=1:F
        %waitbar(i/F)
        FrameEvents=find(events(:,1)==i);
        Xs=round(events(FrameEvents,2));
        Ys=round(events(FrameEvents,3));
        [FIs,FBs]=ManualFitEventsFrame(Xs,Ys,movie,i,BackR,maxsum);
        Is(FrameEvents)=FIs;
        Bs(FrameEvents)=FBs;
    end
else
    for i=1:F
        %waitbar(i/F)
        FrameEvents=find(events(:,1)==i);
        Xs=round(events(FrameEvents,2));
        Ys=round(events(FrameEvents,3));
        [FIs,FBs,FSDBs]=ManualFitEventsFrame_SDB(Xs,Ys,movie,i,BackR,maxsum);
        Is(FrameEvents)=FIs;
        Bs(FrameEvents)=FBs;
        SDBs(FrameEvents)=FSDBs;
    end
    varargout{1}=SDBs;
end
%close(h)