function TraceFinalizationWOConnector(fxyc,Thresh,file,endsize2,~,slopebound,R2Bound)

% frames=length(imfinfo(file));
% %Thresh=0; %Run first with a conservative number (~200 maybe) then manually find minimum intensity you can see.
% dThresh=20; %Max distance in an already formed track
% dThresh2=2; %Max distance between connecting tracks
% aThresh=2;
% aThresh2=1.5;
% fThresh=2;
% fade=.5;
% startfade=.5;
% endfade=.5;
% endsize=2;


fxyc=CalculateNNOptimized(fxyc);
%[fxyc,num]=TrackConnectorWNNConsiderations(fxyc,Thresh,dThresh2,aThresh2,fThresh);
fxyc=Holefillerfxyc(fxyc);
BackgroundSample=[];
for i1=1:length(fxyc(1,1,:)) %Estimate background intensity by averaging the min intensity of traces
    used=fxyc(:,1,i1)>0;
    Ints=fxyc(used,5,i1);
    if min(Ints)~=0
    BackgroundSample=[BackgroundSample min(Ints)]; %#ok<AGROW>
    end
end
background=mean(BackgroundSample);
backgroundSD=sqrt(var(BackgroundSample));
fxyc=TrackSplitter(fxyc,Thresh,slopebound,R2Bound,endsize2,background,backgroundSD); %split any traces that have suspicious drops in intensity in the middle or before the beginning or end
fxyc=RedoEndDetection(fxyc);



fxyc=CalculateFutureNNOptimized(fxyc); %Calculate NN distances for use in end decision
for i1=1:size(fxyc,3) %Make end detection more lax if there is nothing around for the spot the be confused with
    if ~isempty(find(fxyc(:,1,i1),1))
    used=find(fxyc(:,1,i1));
    if fxyc(used(1),4,i1)==2
        if fxyc(used(1),12,i1)>7 && fxyc(used(1),13,i1)>5
            for i2=1:length(used)
                fxyc(used(i2),4,i1)=3;
            end
        end
    end
    if fxyc(used(length(used)),4,i1)==1
        if fxyc(used(length(used)),12,i1)>7 && fxyc(used(length(used)),13,i1)>5
            for i2=1:length(used)
                fxyc(used(i2),4,i1)=3;
            end
        end
    end
    end
end
i = 0;
fxyc_struct = struct('frame',[],'xpos',[],'ypos',[],'class',0,'int',[]);
for j = 1:size(fxyc,3)
    during = squeeze(fxyc(:,1,j)>0);
    if isempty(during), continue; end
    i = i+1;
    fxyc_struct(i).frame = fxyc(during,1,j);
    fxyc_struct(i).xpos = fxyc(during,2,j);
    fxyc_struct(i).ypos = fxyc(during,3,j);
    fxyc_struct(i).class = fxyc(1,4,j);
    fxyc_struct(i).int = fxyc(during,5,j);
    fxyc_struct(i).lt = fxyc_struct(i).frame(end)-fxyc_struct(i).frame(1)+1;
end
    

Threshfxyc=fxyc; %#ok<NASGU>
% [TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,3); %If non green traces are mostly correct use 3, if mostly only green are use 2
% [TraceX,TraceY,TraceZ,TraceINT]=HoleFiller(TraceX,TraceY,TraceZ,TraceINT);
%save Comp2Traces.mat TraceX TraceY TraceZ TraceINT
[save_loc, trace_name, ~] = fileparts(file);
save(fullfile(save_loc,[trace_name,'.mat']), 'Threshfxyc','fxyc_struct','-v7.3')
end
