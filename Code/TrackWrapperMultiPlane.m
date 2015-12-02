clear all;
%This program takes the tracks produces by cmeAnalysis and separates the likely good ones from the bad ones and converts them
%into the format we use.  You'll have to run this twice--first with
%Thresh=0, then run ThreshFinder, then run it again with the Thresh you
%found.

%Parameters to set
path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell1_1s\Tracking\ProcessedTracks.mat';
MultiPlanePath='FlyPlane2FoundSpotsMP.mat';
Thresh=125;
%optional
newfile='FlyPlane2MultiPlaneA0Color125.tif'; %File for traced movie to be saved to
file='FlyStack2TAv.tif'; %File to trace on
mode=1; %mode 1 means everything is colored, mode 2 means just ends are colored, mode 3 nothing is colored: only necessary if you want to see how accurate the traces are
%--------Lastly, make sure you change the name of the file for the data to be saved
%to: line 628




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
dThresh=4; %Max distance in an already formed track
dThresh2=3; %Max distance between connecting tracks
aThresh=2;
aThresh2=1.5;
fThresh=2;
fade=.5;
endsize=2;

MaxBlankFrac=3/4; %If there are more than this fraction of points under the Thresh after a certain point, the rest of the trace is discarded
%Set at 3/4 as a guess
Stracks(1)=445;
singlemode=false;
if singlemode==false
[TraceX,TraceY,TraceINT,TraceF]=TrackDecoderMultiPlane(path,MultiPlanePath,frames,Thresh,dThresh,aThresh);
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
clear fxyc
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
            if maxii~=1 && maxii~=length(fi) && length(inds)>8
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
                    fxyc(j,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j,3,track)=floor(TraceY(i,f(j)));
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
                    fxyc(j,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j,3,track)=floor(TraceY(i,f(j)));
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
                        fxyc(j,2,track)=floor(TraceX(i,f(j)));
                        fxyc(j,3,track)=floor(TraceY(i,f(j)));
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
                    fxyc(j-start+1,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j,7,track)=i;
                end
                track=track+1;
                end
            end
    end
end
[fxyc,num]=TrackConnector(fxyc,Thresh,dThresh2,aThresh2,fThresh);
[TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,5); %Once tracks are connected, we need to redo the color choosing so we convert to TraceX then back to fxyc
%[TraceX,TraceY,TraceINT]=TraceFiller(TraceX,TraceY,TraceINT);
clear fxyc
[TraceNum,~]=size(TraceX);
T=0;
minlength=5;
summation=0;
index=1;
index2=1;
spotIndex=1;
track=1;

for i=1:TraceNum
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
        if beginning<middle*fade && middle>=0 %middle clause not important with new threshlod
            ends=1;
        end
        if  middle>=0 && finish<middle*fade && find(TraceX(i,:),1,'last')~=frames %clause to make sure the end isn't cut off by the end of the movie
            ends=ends+2;
        end
        if find(TraceX(i,:),1,'last')==frames || find(TraceX(i,:),1,'first')==1
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
                    fxyc(j,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
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
                    fxyc(j,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
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
                    fxyc(j,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j,5,track)=TraceINT(i,f(j));
                    fxyc(j,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
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
                    fxyc(j-start+1,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
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
                    fxyc(j-start+1,4,track)=5;
                    fxyc(j-start+1,1,track)=f(j);
                    fxyc(j-start+1,2,track)=floor(TraceX(i,f(j)));
                    fxyc(j-start+1,3,track)=floor(TraceY(i,f(j)));
                    fxyc(j-start+1,5,track)=TraceINT(i,f(j));
                    fxyc(j-start+1,6,track)=middle;
                    fxyc(j,7,track)=TraceZ(i,f(j));
                end
                track=track+1;
            end
        end
    end
end
[a,b,c]=size(fxyc);
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
Threshfxyc=fxyc;
[TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,3); %If non green traces are mostly correct use 3, if mostly only green are use 2
[TraceX,TraceY,TraceZ,TraceINT]=HoleFiller(TraceX,TraceY,TraceZ,TraceINT);
%save Comp2Traces.mat TraceX TraceY TraceZ TraceINT
save FlyPlane2MultiPlanefxycA0125.mat Threshfxyc
%save Flyfxyc.mat fxyc
if mode==1
    ColorSpots(fxyc,file,newfile);
end
if mode==2
    ColorEnds(Endsfxyc,file,newfile);
end


%save Traces3.mat TraceX TraceY TraceZ TraceINT;