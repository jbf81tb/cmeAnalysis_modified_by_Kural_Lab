clear
movie='SingleOsmoshockControl.tif';
newmovie='AutoTest6';
framegap=3;
MaxSectionSize=20;
frames=length(imfinfo(movie));
sections=ceil(frames/(MaxSectionSize-1));
SectionSize=ceil(frames/sections);
start=zeros(sections,1);
stop=zeros(sections,1);
for i=1:sections
    if i==1
        start(i)=1;
    else
        start(i)=(i-1)*SectionSize; %Make a frame of overlap so that the traces in different sections can be put together
    end
    stop(i)=min(i*SectionSize,frames);
    sectionname=strcat(newmovie,'_',num2str(i),'.tif');
    %MovieShortenerF(movie,sectionname,start(i),stop(i));
    %folder=strcat(newmovie,'/Section',num2str(i));
    %intstr=strcat('/Cell1_',num2str(framegap),'s/ch1');
    %folder2=strcat(folder,intstr);
    %mkdir(folder,intstr);
    %movefile(sectionname,folder2);
end
folderlist = ls;
wd = pwd;
for i = 3:size(folderlist,1)
    tempname = '';
    for j = 1:size(folderlist,2)
        if ~strcmp(folderlist(i,j), ' ')
            tempname = strcat(tempname,folderlist(i,j));
        end
    end
    tempfol = dir(tempname);
    dirname{i-2} = strcat(folderlist(i,:),'\',tempfol(end).name);
    file = dir(strcat(dirname{i-2},'\ch1\'));
    for j = size(file,1):-1:1
        if ~isempty(regexp(file(j).name,'.tif', 'once'))
            moviename{i-2} = strcat('ch1\',file(j).name);
        end
    end
end
array=cell(size(dirname,2),1);
SizeArray=zeros(size(dirname,2),3);
for i = 1:size(dirname,2) %Access all the TempTraces files and make the Threshfxyc's into a stucture array
    cd(dirname{i})
    
    path2=strcat(wd,'\',dirname{i},'\TempTraces.mat');
    load(path2)
    array{i}=Threshfxyc;
    SizeArray(i,:)=size(Threshfxyc);
    cd(wd)
end

Threshfxyc=zeros(max(SizeArray(:,1)),max(SizeArray(:,2)),sum(SizeArray(:,3)));%Initialize Threshfxyc with appropriate array size
index=1; %Keeps track of first open slot in Threshfxyc(~,~,:)
h=waitbar(0,'Compiling Trace Sections');
for i=1:sections-1 %Go through all adjacent pairs of sections looking for corresponding trace ends
    waitbar(i/(sections-1))
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
            end
            routingnew(i2)=routingold(found);
            
        end
        
    end
end
close(h)
TraceFinalization(Threshfxyc,300,movie,4,1,0,.75);
save Threshfxyc.mat Threshfxyc
