function fxycS=RedoEndDetection_Struct(fxycS)

dThresh=20; %Max distance in an already formed track
dThresh2=2; %Max distance between connecting tracks
aThresh=2;
aThresh2=1.5;
fThresh=2;
fade=.5;
startfade=.5;
endfade=.5;
endsize=2;
minlength=5;
summation=0;
index=1;
index2=1;
spotIndex=1;
track=1;
minlength1=1;
minlength2=2;
MaxBlankFrac=3/4;
slopebound=0;
R2Bound=.75;
endsize2=4;

BackgroundSample=[];
for i1=1:length(fxycS) %Estimate background intensity by averaging the min intensity of traces
    Ints=fxycS(i1).int;
    if min(Ints)~=0
    BackgroundSample=[BackgroundSample min(Ints)];
    end
end
background=mean(BackgroundSample);
backgroundSD=sqrt(var(BackgroundSample));
frames=max([fxycS.frame]); %may cause problems if nothing is found on last frame
% h=waitbar(0,'Finalizing Traces');
for i=1:length(fxycS)
%     waitbar(i/length(fxyc(1,1,:)))
    Ints=nonzeros(fxycS(i).int);
    if ~isempty(Ints)
        MaxIntInd=find(Ints==max(Ints),1,'first');
        clear PreInts PostInts
        for im=1:MaxIntInd
            PreInts(im)=Ints(im);
        end
        for im=MaxIntInd:length(Ints)
            PostInts(im-MaxIntInd+1)=Ints(im);
        end
        if length(Ints)>10
            [BegPL,FinPL]=EndDecisionLinearRegression(Ints,slopebound,R2Bound,endsize2,background,backgroundSD);
        else
            [BegPL,FinPL]=EndDecisionLinearRegression(Ints,slopebound,R2Bound*1.2,endsize2-1,background,backgroundSD); %The shortest traces won't have long enough ends, so we decrease endsize and increase the required R^2 value
        end
        ends=0;
        if ~isempty(BegPL) && isempty(find(fxycS(i).frame==1)) && (min(nonzeros(PreInts))<=max(Ints)*startfade || min(nonzeros(PreInts))<=background+backgroundSD)
            ends=ends+1;
            
        end
        if ~isempty(FinPL) && isempty(find(fxycS(i).frame==frames)) && (min(nonzeros(PostInts))<=max(Ints)*endfade || min(nonzeros(PostInts))<=background+backgroundSD)
            ends=ends+2;
            
        end
        if ~isempty(find(fxycS(i).frame==frames))
            ends=ends+8;
        end
        if ~isempty(find(fxycS(i).frame==1))
            ends=ends+4;
        end
        c=0;
        if ends==0 
            c=4; %No beginning or end
        end
        if ends==1 || ends==2 || ends==3
            c=ends; %At least one beginning or end and doesn't hit either end of the movie
        end
        if ends==9
            c=5; %has a start but hits end of movie
        end
        if ends==6
            c=6; %has an end but hits the beginning of movie
        end
        if c==0
            c=7; %Nothing usefull--hits at least one end of the movie and has no usefull initiation/conclusion data
        end
        fxycS(i).classCME=c;
    end
end
% close(h)