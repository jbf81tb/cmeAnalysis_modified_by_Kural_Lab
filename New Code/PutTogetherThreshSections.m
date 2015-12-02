load('IndividualThreshs.mat')
Threshfxyc=zeros(max(SizeArray(:,1)),max(SizeArray(:,2)),sum(SizeArray(:,3)));%Initialize Threshfxyc with appropriate array size
index=1; %Keeps track of first open slot in Threshfxyc(~,~,:)
% h=waitbar(0,'Compiling Trace Sections');
sections=length(array);
maxfree=10;
for i=1:sections-1 %Go through all adjacent pairs of sections looking for corresponding trace ends
%     waitbar(i/(sections-1))
    fxyc1=array{i}; %Check structure syntax
    fxyc2=array{i+1};
    [A1,A2,A3]=size(fxyc1);
    [B1,B2,B3]=size(fxyc2);
    if i==1
        routingnew=zeros(A3,1);
    end
    for i2=1:A3
        used=find(fxyc1(:,1,i2));
        for i3=1:length(used)
            fxyc1(used(i3),1,i2)=fxyc1(used(i3),1,i2)+start(i)-1;
        end
        if i==1 %i==1 is special because it is never in fxyc2, so it must be saved now
            for i3=1:A1
                for i4=1:A2
                    Threshfxyc(i3,i4,index)=fxyc1(i3,i4,i2);
                end
            end
            routingnew(i2)=index; %Keeps track of where entries in this fxyc go so that corresponding entries in next one go to the right place
            index=index+1;
        end
    end
    routingold=routingnew;
    routingnew=zeros(B3,1); %Make room so routing numbers from this section can be recorded while keeping the ones from the last section
    for i2=1:B3
        used=find(fxyc2(:,1,i2));
        for i3=1:length(used)
            fxyc2(used(i3),1,i2)=fxyc2(used(i3),1,i2)+start(i+1)-1; %Change section frame numbers to full movie frame numbers
        end
        firstframe=find(fxyc2(:,1,i2)==start(i+1)); %Look for pits in the first frame
        found=0;
        if ~isempty(firstframe)
            for i3=1:A3 %Look for corresponding pits in the last frame of the previous section
                found1=find(fxyc1(:,1,i3)==start(i+1));
                found2=find(fxyc1(:,2,i3)==fxyc2(firstframe(1),2,i2));
                found3=find(fxyc1(:,3,i3)==fxyc2(firstframe(1),3,i2));
                f=intersect(found1,intersect(found2,found3));
                if ~isempty(f)
                    found=i3;
                    break
                end
            end
        end
        if found==0 %No corresponding pit was found
            for i3=1:length(used)
                for i4=1:A2
                    Threshfxyc(i3,i4,index)=fxyc2(used(i3),i4,i2);
                    
                end
            end
            routingnew(i2)=index;
            index=index+1;
        else %corresponding pit was found
            free=find(Threshfxyc(:,1,routingold(found))==0,1,'first'); %Where new trace data can be put
            if isempty(free)
                [C1,~,~]=size(Threshfxyc);
                free=C1+1;
            end
            for i3=2:length(used)
                for i4=1:A2
                    Threshfxyc(free(1),i4,routingold(found))=fxyc2(used(i3),i4,i2);
                    
                end
                free(1)=free(1)+1;
                if free(1)>300  %Cut off super long traces--this was put in as a simple fix to a memory error--if problems occur, this should be revisited
                    break
                end
            end
            if free(1)>maxfree
                maxfree=free(1)   %Display max dimension to check why a certain error happened
            end
            routingnew(i2)=routingold(found);
            
        end
        
    end
end
% close(h)
if i9==1
    movie='150220_3s_100p_50ms_1.tif';
end
if i9==2
    movie='150220_4s_100p_50ms_1.tif';
end
if i9==3
    movie='150220_4s_100p_60ms_1.tif';
end
if i9==4
    movie='150222_3s_100p_50ms_1001.tif';
end
if i9==5
    movie='150222_4s_100p_50ms.tif';
end
if i9==6
    movie='150222_4s_100p_60ms_1.tif';
end
save('tempdata.mat', 'Threshfxyc', 'Thresh', 'movie', 'wd', 'wdW','-v7.3')
clear all
load('tempdata.mat')
TraceFinalizationWOConnector(Threshfxyc,Thresh,movie,4,1,0,.75);
cd(wd)
%save TempTraces.mat Threshfxyc

    cd(wdW)
    %end
