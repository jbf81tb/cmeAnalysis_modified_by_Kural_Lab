function SimplifiedTrackWrapperNewEndDetectionNoRounding(path,Thresh,file,endsize2,enderrors,slopebound,R2Bound,maskfile)
%This program takes the tracks produces by cmeAnalysis and separates the likely good ones from the bad ones and converts them
%into the format we use.  You'll have to run this twice--first with
%Thresh=0, then run ThreshFinder, then run it again with the Thresh you
%found.

%Parameters to set
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell4_1s\Tracking\ProcessedTracks.mat';
%Thresh=0;
%optional
newfile='FlyExpansionCropColor150.tif'; %File for traced movie to be saved to
%file='ExpansionStack400.tif'; %File to trace on
mode=3; %mode 1 means everything is colored, mode 2 means just ends are colored, mode 3 nothing is colored: only necessary if you want to see how accurate the traces are
%--------Lastly, make sure you change the name of the file for the data to be saved
%to: line 628
EndDetection=2; %EndDetection=2 uses linear regression



%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\DropEx\Cell2_3s\Tracking\ProcessedTracks.mat';
%Cell dropping tracks
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell1_6s\Tracking\ProcessedTracks.mat';
%Osmoshock Control tracks
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell3_5.4s\Tracking\ProcessedTracks.mat';
%80% Osmoshock tracks
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell2_3.7s\Tracking\ProcessedTracks.mat';
%40% Osmoshock tracks
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell4_3s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 4
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell5_3s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 5
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell6_3s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 6
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell7_3s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 7
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell8_5.56s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 8
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell9_5.36s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 9
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell10_3.57s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 10
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell11_5.45s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 11
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell12_5.36s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 12
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell13_5.56s\Tracking\ProcessedTracks.mat';
%Osmoshock cell 13
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Osmoshock\Cell14_3s\Tracking\ProcessedTracks.mat';

%Osmoshock cell 14
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell1_1s\Tracking\ProcessedTracks.mat';
%Fly stack 2 TAv

%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell5_2s\Tracking\ProcessedTracks.mat';
%Expansion crop
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell6_2s\Tracking\ProcessedTracks.mat';
%Expansion crop 2
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell7_1s\Tracking\ProcessedTracks.mat';
%Expansion crop 2 non TAv
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell8_1s\Tracking\ProcessedTracks.mat';
%Fly Expansion Crop

%REMEMBER TO CHANGE MATRIX TO SAVE TRACES TO

frames=length(imfinfo(file));
%Thresh=0; %Run first with a conservative number (~200 maybe) then manually find minimum intensity you can see.
dThresh=20; %Max distance in an already formed track
dThresh2=2; %Max distance between connecting tracks
aThresh=2;
aThresh2=1.5;
fThresh=2;
fade=.5;
startfade=.5;
endfade=.5;
endsize=2;

MaxBlankFrac=3/4; %If there are more than this fraction of points under the Thresh after a certain point, the rest of the trace is discarded
%Set at 3/4 as a guess
Stracks(1)=445;
singlemode=false;
if singlemode==false
[TraceX,TraceY,TraceINT,TraceF]=TrackDecoder(path,frames,Thresh,dThresh,aThresh,maskfile);
else
[TraceX,TraceY,TraceINT]=TrackDecoderS(path,frames,Thresh,dThresh,aThresh,Stracks);
end
[TraceNum,~]=size(TraceX);
T=0;
minlength1=1;
minlength2=2;
summation=0;
index=1;
index2=1;
spotIndex=1;
track=1;
fxyc = [];
for i=1:TraceNum
    clear inds
    
    inds=find(TraceINT(i,:));
    if length(inds)>minlength1
        for j=1:length(inds)
            intHist(index2)=TraceINT(i,inds(j));
            index2=index2+1;
        end
        T=T+1;
        summation=summation+length(find(TraceINT(i,:)));
        life(index)=max(find(TraceINT(i,:)))-min(find(TraceINT(i,:)));
        f=find(TraceX(i,:)); 
        %clear intf intf2
        %for j=1:length(f)
        %    intf(j)=TraceINT(i,f(j));
        %    if j<=6 %needs to be changed if time between frames~=1s
        %        intf2(j)=TraceINT(i,f(j));
        %    end
        %end
        %s6MaxInt(index)=max(intf2); %cohort things
        %MaxInt(index)=max(intf);
        %index=index+1;
        
            clear firstint lastint ints
            fi=find(TraceINT(i,:));
            maxi=find(TraceINT(i,:)==max(TraceINT(i,:)));
            maxii=find(fi==maxi(1));
            if length(fi)>=3
            if maxii~=1 && maxii~=length(fi) && length(inds)>6
                maxis=[fi(maxii-1) fi(maxii+1)];
            else
                if maxii==1
                    maxis=[fi(1) fi(2) fi(3)];
                end
                if maxii==length(fi)
                    maxis=[fi(length(fi)-2) fi(length(fi)-1) fi(length(fi))];
                end
            end
            end
            if length(inds)<=6 || length(fi)<3
                maxis=[fi(maxii) fi(maxii) fi(maxii)];
            end
            
            for j=1:length(maxis)
                maxints(j)=TraceINT(i,maxis(j));
            end
            for j=1:length(fi)
                ints(j)=TraceINT(i,fi(j));
            end
            firsts=find(TraceINT(i,:),endsize,'first');
            lasts=find(TraceINT(i,:),endsize,'last');
            for j=1:length(firsts)
                firstint(j)=TraceINT(i,firsts(j));
            end
            for j=1:length(lasts)
                lastint(j)=TraceINT(i,lasts(j));
            end
            beginning=mean(firstint);
            middle=mean(maxints);
            finish=mean(lastint);
            ends=0;
            if beginning<middle*fade && middle>=0 %middle clause not important with new threshlod
                ends=1;
            end
             if  middle>=0 && finish<middle*fade && find(TraceX(i,:),1,'last')~=frames %clause to make sure the end isn't cut off by the end of the movie
                ends=ends+2;
             end
            if ends==0
                start=1;
                for j=1:length(f)
                    Blank=0;
                    Tot=j;
                    for k=1:j
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                        start=j;
                    end
                end
                if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                    fxyc(j,4,track)=4;
                    fxyc(j,1,track)=f(j);
                    fxyc(j,2,track)=(TraceX(i,f(j)));
                    fxyc(j,3,track)=(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=i;
                end
                track=track+1;
                end
            end
            if ends==1
                start=1;
                for j=1:length(f)
                    Blank=0;
                    Tot=j;
                    for k=1:j
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                        start=j;
                    end
                end
                if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                    fxyc(j,4,track)=1;
                    fxyc(j,1,track)=f(j);
                    fxyc(j,2,track)=(TraceX(i,f(j)));
                    fxyc(j,3,track)=(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=i;
                end
                track=track+1;
                end
            end
            if ends==2
                start=1;
                for j=1:length(f)
                    Blank=0;
                    Tot=j;
                    for k=1:j
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                        start=j;
                    end
                end
                if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                        fxyc(j,4,track)=2;
                        fxyc(j,1,track)=f(j);
                        fxyc(j,2,track)=(TraceX(i,f(j)));
                        fxyc(j,3,track)=(TraceY(i,f(j)));
                        fxyc(j,5,track)=TraceINT(i,f(j));
                        fxyc(j,6,track)=middle;
                        fxyc(j,7,track)=i;
                end
                track=track+1;
                end
            end
            if ends==3
                start=1;
                for j=1:length(f)
                    Blank=0;
                    Tot=j;
                    for k=1:j
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                        start=j;
                    end
                end
                if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break;
                    end
                    if f(j)>1 && TraceX(i,f(j)-1)~=0 && sqrt((TraceX(i,f(j))-TraceX(i,f(j)-1))^2+(TraceY(i,f(j))-TraceY(i,f(j)-1))^2)>dThresh
                        break
                    end
                    fxyc(j-start+1,4,track)=3;
                    fxyc(j-start+1,1,track)=f(j);
                    fxyc(j-start+1,2,track)=(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j,7,track)=i;
                end
                track=track+1;
                end
            end
    end
end
fxyc=CalculateNNOptimized(fxyc);
[fxyc,num]=TrackConnectorWNNConsiderations(fxyc,Thresh,dThresh2,aThresh2,fThresh);
fxyc=Holefillerfxyc(fxyc);
if isempty(fxyc)
    [save_loc, ~, ~] = fileparts(path);
    Threshfxyc = fxyc;
    save(fullfile(save_loc, 'TempTraces.mat'), 'Threshfxyc');
    return; 
end
BackgroundSample=[];
for i1=1:length(fxyc(1,1,:)) %Estimate background intensity by averaging the min intensity of traces
    used=find(fxyc(:,1,i1));
    Ints=fxyc(used,5,i1);
    if min(Ints)~=0
    BackgroundSample=[BackgroundSample min(Ints)];
    end
end
background=mean(BackgroundSample);
backgroundSD=sqrt(var(BackgroundSample));
fxyc=TrackSplitter(fxyc,Thresh,slopebound,R2Bound,endsize2,background,backgroundSD); %split any traces that have suspicious drops in intensity in the middle or before the beginning or end
[TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,5); %Once tracks are connected, we need to redo the color choosing so we convert to TraceX then back to fxyc
%[TraceX,TraceY,TraceINT]=TraceFiller(TraceX,TraceY,TraceINT);
fxyc = [];
[TraceNum,~]=size(TraceX);
T=0;
minlength=5;
summation=0;
index=1;
index2=1;
spotIndex=1;
track=1;

% h=waitbar(0,'Finalizing Traces');
for i=1:TraceNum
%     waitbar(i/TraceNum)
    clear inds
    
    inds=find(TraceINT(i,:));
    if length(inds)>minlength2
        for j=1:length(inds)
            intHist(index2)=TraceINT(i,inds(j));
            index2=index2+1;
        end
        T=T+1;
        summation=summation+length(find(TraceINT(i,:)));
        life(index)=max(find(TraceINT(i,:)))-min(find(TraceINT(i,:)));
        f=find(TraceX(i,:));
        %clear intf intf2
        %for j=1:length(f)
        %    intf(j)=TraceINT(i,f(j));
        %    if j<=6 %needs to be changed if time between frames~=1s
        %        intf2(j)=TraceINT(i,f(j));
        %    end
        %end
        %s6MaxInt(index)=max(intf2); %cohort things
        %MaxInt(index)=max(intf);
        %index=index+1;
        
        clear firstint lastint ints
        fi=find(TraceINT(i,:));
        Ints=TraceINT(i,fi);
        
            MaxIntInd=find(Ints==max(Ints),1,'first');
        
        clear PreInts PostInts
        for im=1:MaxIntInd
            PreInts(im)=Ints(im);
        end
        for im=MaxIntInd:length(Ints)
            PostInts(im-MaxIntInd+1)=Ints(im);
        end
        maxi=find(TraceINT(i,:)==max(TraceINT(i,:)));
        maxii=find(fi==maxi(1));
        if length(fi)>=3
        if maxii~=1 && maxii~=length(fi) && length(inds)>8
            maxis=[fi(maxii-1) fi(maxii) fi(maxii+1)];
        else
            if maxii==1
                maxis=[fi(1) fi(2) fi(3)];
            end
            if maxii==length(fi)
                maxis=[fi(length(fi)-2) fi(length(fi)-1) fi(length(fi))];
            end
        end
        end
        if length(inds)<=8 || length(fi)<3
            maxis=[fi(maxii) fi(maxii) fi(maxii)];
        end
        
        for j=1:length(maxis)
            maxints(j)=TraceINT(i,maxis(j));
        end
        for j=1:length(fi)
            ints(j)=TraceINT(i,fi(j));
        end
        firsts=find(TraceINT(i,:),endsize,'first');
        lasts=find(TraceINT(i,:),endsize,'last');
        for j=1:length(firsts)
            firstint(j)=TraceINT(i,firsts(j));
        end
        for j=1:length(lasts)
            lastint(j)=TraceINT(i,lasts(j));
        end
        beginning=mean(firstint);
        middle=mean(maxints);
        finish=mean(lastint);
        ends=0;
%         if beginning<middle*fade && middle>=0 && find(TraceX(i,:),1,'first')~=1 %middle clause not important with new threshlod
%             ends=1;
%         end
%         if  middle>=0 && finish<middle*fade && find(TraceX(i,:),1,'last')~=frames %clause to make sure the end isn't cut off by the end of the movie
%             ends=ends+2;
%         end

if length(Ints)>10
        [BegPL,FinPL]=EndDecisionLinearRegression(Ints,slopebound,R2Bound,endsize2,background,backgroundSD);
        
%         start=min(BegPL);  %Attempted improvement on the end detection of
%         long traces that I haven't gotten to work out
%         finish=min(FinPL)+endsize2-1;
%         if finish-start>20
%             for i2=start:finish
%                 TempInts(i2-start+1)=Ints(i2);
%             end
%             [BegPL2,foundB]=LongTraceInitiationDetection(TempInts,slopebound,R2Bound,endsize,background,backgroundSD);
%             [FinPL2,foundF]=LongTraceConclusionDetection(TempInts,slopebound,R2Bound,endsize,background,backgroundSD);
%             if foundB
%                 BegPL=BegPL2;
%             end
%             if foundF
%                 FinPL=FinPL2;
%             end
%         end
else
    [BegPL,FinPL]=EndDecisionLinearRegression(Ints,slopebound,R2Bound*1.2,endsize2-1,background,backgroundSD); %The shortest traces won't have long enough ends, so we decrease endsize and increase the required R^2 value
end
rsqb=0;
rsqf=0;
        if ~isempty(BegPL) && find(TraceX(i,:),1,'first')~=1 && (min(nonzeros(PreInts))<=max(Ints)*startfade)% || min(nonzeros(PreInts))<=background+backgroundSD)
            ends=1;
            rsqb=max(BegPL(:,2));
        end
        if ~isempty(FinPL) && find(TraceX(i,:),1,'last')~=frames && (min(nonzeros(PostInts))<=max(Ints)*endfade)% || min(nonzeros(PostInts))<=background+backgroundSD)
            ends=ends+2;
            rsqf=max(FinPL(:,2));
        end
        if find(TraceX(i,:),1,'last')==frames
          ends=ends+8;
        end
        if find(TraceX(i,:),1,'first')==1
            ends=ends+4;
        end
        if ends==0
            start=1;
            for j=1:length(f)
                Blank=0;
                Tot=j;
                for k=1:j
                    if TraceINT(i,f(k))==0
                        Blank=Blank+1;
                    end
                end
                if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                    start=j;
                end
            end
            if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                    fxyc(j,4,track)=4;
                    fxyc(j,1,track)=f(j);
                    fxyc(j,2,track)=(TraceX(i,f(j)));
                    fxyc(j,3,track)=(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
                    fxyc(j,8,track)=rsqb;
                    fxyc(j,9,track)=rsqf;
                end
                track=track+1;
            end
        end
        if ends==1
            start=1;
            for j=1:length(f)
                Blank=0;
                Tot=j;
                for k=1:j
                    if TraceINT(i,f(k))==0
                        Blank=Blank+1;
                    end
                end
                if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                    start=j;
                end
            end
            if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                    fxyc(j,4,track)=1;
                    fxyc(j,1,track)=f(j);
                    fxyc(j,2,track)=(TraceX(i,f(j)));
                    fxyc(j,3,track)=(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
                    fxyc(j,8,track)=rsqb;
                    fxyc(j,9,track)=rsqf;
                end
                track=track+1;
            end
        end
        if ends==2
            start=1;
            for j=1:length(f)
                Blank=0;
                Tot=j;
                for k=1:j
                    if TraceINT(i,f(k))==0
                        Blank=Blank+1;
                    end
                end
                if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                    start=j;
                end
            end
            if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break
                    end
                    fxyc(j,4,track)=2;
                    fxyc(j,1,track)=f(j);
                    fxyc(j,2,track)=(TraceX(i,f(j)));
                    fxyc(j,3,track)=(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
                    fxyc(j,8,track)=rsqb;
                    fxyc(j,9,track)=rsqf;
                end
                track=track+1;
            end
        end
        if ends==3
            start=1;
            for j=1:length(f)
                Blank=0;
                Tot=j;
                for k=1:j
                    if TraceINT(i,f(k))==0
                        Blank=Blank+1;
                    end
                end
                if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                    start=j;
                end
            end
            if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break;
                    end
                    if f(j)>1 && TraceX(i,f(j)-1)~=0 && sqrt((TraceX(i,f(j))-TraceX(i,f(j)-1))^2+(TraceY(i,f(j))-TraceY(i,f(j)-1))^2)>dThresh
                        break
                    end
                    fxyc(j-start+1,4,track)=3;
                    fxyc(j-start+1,1,track)=f(j);
                    fxyc(j-start+1,2,track)=(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j-start+1,7,track)=TraceZ(i,f(j));
                    fxyc(j-start+1,8,track)=rsqb;
                    fxyc(j-start+1,9,track)=rsqf;
                end
                track=track+1;
            end
        end
        if ends>3
            start=1;
            for j=1:length(f)
                Blank=0;
                Tot=j;
                for k=1:j
                    if TraceINT(i,f(k))==0
                        Blank=Blank+1;
                    end
                end
                if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))~=0
                    start=j;
                end
            end
            if length(f)>=start
                for j=start:length(f)
                    Blank=0;
                    Tot=length(f)-j+1;
                    for k=j:length(f)
                        if TraceINT(i,f(k))==0
                            Blank=Blank+1;
                        end
                    end
                    if Blank/Tot>=MaxBlankFrac && TraceINT(i,f(j))==0
                        break;
                    end
                    if f(j)>1 && TraceX(i,f(j)-1)~=0 && sqrt((TraceX(i,f(j))-TraceX(i,f(j)-1))^2+(TraceY(i,f(j))-TraceY(i,f(j)-1))^2)>dThresh
                        break
                    end
                    if ends==9 %has a start but hits end of movie: Useful for initiation histogram
                        fxyc(j-start+1,4,track)=5;
                    elseif ends==6 %has an end but hits the beginning of movie
                        fxyc(j-start+1,4,track)=6;
                    elseif ends==12
                        fxyc(j-start+1,4,track)=8;
                    else
                        fxyc(j-start+1,4,track)=7; %Likely useless combinations of hitting a movie end and having a beginning or end
                    end
                    fxyc(j-start+1,1,track)=f(j);
                    fxyc(j-start+1,2,track)=(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j-start+1,7,track)=TraceZ(i,f(j));
                    fxyc(j-start+1,8,track)=rsqb;
                    fxyc(j-start+1,9,track)=rsqf;
                end
                track=track+1;
            end
        end
    end
end
if isempty(fxyc)
    [save_loc, ~, ~] = fileparts(path);
    Threshfxyc = fxyc;
    save(fullfile(save_loc, 'TempTraces.mat'), 'Threshfxyc');
    return; 
end
fxyc=CalculateFutureNNOptimized(fxyc); %Calculate NN distances for use in end decision
[a,b,c]=size(fxyc);
for i1=1:c %Make end detection more lax if there is nothing around for the spot the be confused with
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
Endsfxyc=[];
% if 1==1 %use EndDecision function to find ends
%     index=1;
%     for i=1:c
%         slots=find(fxyc(:,5,c));
%         Ints=zeros(1,length(slots));
%         
%         for j=1:length(slots)
%             Ints(j)=fxyc(slots(j),5,i);
%         end
%         [BegPL,FinPL]=EndDecision(Ints,fade,Thresh);
%         [d,e]=size(BegPL);
%         for j=1:d
%             for k=1:BegPL(j,2)
%               
%                 Endsfxyc(k,:,index)=fxyc(slots(BegPL(j,1)+k-1),:,i);
%                 Endsfxyc(k,4,index)=1;
%                 
%             end
%             index=index+1;
%         end
%         [d,e]=size(FinPL);
%         for j=1:d
%             for k=1:FinPL(j,2)
%                 Endsfxyc(k,:,index)=fxyc(slots(FinPL(j,1)+k-1),:,i);
%                 Endsfxyc(k,4,index)=2;
%                 
%             end
%             index=index+1;
%         end
%     end
% end
% close(h)
Threshfxyc=fxyc;
% [TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,3); %If non green traces are mostly correct use 3, if mostly only green are use 2
% [TraceX,TraceY,TraceZ,TraceINT]=HoleFiller(TraceX,TraceY,TraceZ,TraceINT);
Threshfxyc=CalculateLinRegParameters(endsize2,Threshfxyc);
%save Comp2Traces.mat TraceX TraceY TraceZ TraceINT
[save_loc, ~, ~] = fileparts(path);
save(fullfile(save_loc, 'TempTraces.mat'), 'Threshfxyc','-v7.3');
%save Flyfxyc.mat fxyc
if mode==1
    ColorSpots(fxyc,file,newfile);
end
if mode==2
    ColorEnds(Endsfxyc,file,newfile);
end
end