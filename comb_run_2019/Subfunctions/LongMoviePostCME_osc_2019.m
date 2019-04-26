function LongMoviePostCME_osc_2019(smd,omd,Threshs,sections,framegap)
% LONGMOVIEPOSTCME_OSC Analyze results of cmeAnalysis
%   Input:
%       smd: split movie directory. String to the directory containing the
%           split movies.
%       omd: original movie directory. String to the directory containing
%           original movies.
%       Threshs: Vector containing thresholds for each movie. Usually 400.
%       sections: A vector containing the number of sections each movie is
%           broken into.
% We found that the output from cmeAnalysis contains a lot of things we
% didn't like, so we developed code to run over the data and do some
% filtering, classification, and restructuring for us. This code also
% recombines movies which have been broken into sections for memory
% considerations. In the end, a giant 3D array still needs to be created,
% so we recommended using a computer with at least 16GB of RAM, and more
% might be necessary for especially long movies.
%
% Originally created by:
% Scott Huber, Kural Group, Ohio State University,
% huber.288@buckeyemail.osu.edu
% Modified by:
% Josh Ferguson, Kural Group, Ohio State University, ferguson.621@osu.edu
%

%% some file management
tmpd = dir(fullfile(omd,'*.tif'));
orig_movies = cell(length(tmpd),1);
for i = 1:length(tmpd)
    orig_movies{i} = fullfile(omd,tmpd(i).name);
end
tmpd = dir(smd);
tmpd = tmpd([tmpd.isdir]);
tmpd(strncmp({tmpd.name},'.',1)) = [];
movies = length(tmpd);
dirname = cell(movies,1);
for i = 1:movies
    dirname{i} = fullfile(smd,tmpd(i).name);
end
%create paths to all the data
SectionSize = zeros(movies,1);
moviefol = cell(max(sections),movies);
moviename = cell(max(sections),movies);
paths = cell(max(sections),movies);
for i = 1:movies
    for i2 = 1:sections(i)
        tmpn = fullfile(dirname{i},['Section',num2str(i2)]);
        tmpd = dir(tmpn);
        moviefol{i2,i} = fullfile(tmpn,tmpd(3).name,'ch1');
        paths{i2,i} = fullfile(moviefol{i2,i},'Tracking','ProcessedTracks.mat');
        if ~exist(paths{i2,i},'file')
            tracks = [];
            processingInfo = [];
            save(paths{i2,i},'tracks','processingInfo')
        end
        tmpd = dir(fullfile(moviefol{i2,i},'*.tif'));
        moviename{i2,i} = fullfile(moviefol{i2,i},tmpd.name);
        if i2==1
            SectionSize(i) = length(imfinfo(moviename{i2,i}));
        end
    end
end
%% perform secondary analysis
for i9=1:movies
    [save_loc, trace_name, ~] = fileparts(orig_movies{i9});
    if exist(fullfile(save_loc,[trace_name,'.mat']),'file')
        continue;
    end
    Thresh=Threshs(i9);
    for i = 1:sections(i9)
        if ~exist(fullfile(fileparts(paths{i,i9}),'TempTraces.mat'),'file')
            %this is the meat of the analysis
            TrackWrapper2019(paths{i,i9},moviename{i,i9});
        end
    end
%% combine adjacent sections
    array=cell(sections(i9),1);
    SizeArray=zeros(sections(i9),3);
    start = zeros(sections(i9),1);
    for i = 1:sections(i9) %Access all the TempTraces files and make the Threshfxyc's into a stucture array
        load(fullfile(fileparts(paths{i,i9}),'TempTraces.mat'))
        if i==1
            start(i)=1;
        else
            start(i)=(i-1)*SectionSize(i9); %Make a frame of overlap so that the traces in different sections can be put together
        end
        array{i}=Threshfxyc;
        if length(size(Threshfxyc))==2
            SizeArray(i,:)=[size(Threshfxyc,1), size(Threshfxyc,2), 0];
        elseif length(size(Threshfxyc))==3
            SizeArray(i,:)=size(Threshfxyc);
        else
            SizeArray(i,:)=[1,1,1];
        end
    end
    Threshfxyc=zeros(max(SizeArray(:,1)),max(SizeArray(:,2)),sum(SizeArray(:,3)),'single');%Initialize Threshfxyc with appropriate array size
    index=1; %Keeps track of first open slot in Threshfxyc(~,~,:)
    maxfree=10;
    if sections(i9)>1
        for i=1:sections(i9)-1 %Go through all adjacent pairs of sections looking for corresponding trace ends
            fxyc1=array{i}; %Check structure syntax
            fxyc2=array{i+1};
            [A1,A2,A3]=size(fxyc1);
            if A1==0 && A2==0, A3=0; end
            [B1,B2,B3]=size(fxyc2);
            if B1==0 && B2==0, B3=0; end
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
                        for i4=1:max(A2,B2)
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
                        for i4=1:max(A2,B2)
                            Threshfxyc(free(1),i4,routingold(found))=fxyc2(used(i3),i4,i2);
                            
                        end
                        free(1)=free(1)+1;
                        %                 if free(1)>300  %Cut off super long traces--this was put in as a simple fix to a memory error--if problems occur, this should be revisited
                        %                     break
                        %                 end
                    end
                    if free(1)>maxfree
                        maxfree=free(1);
                        disp(maxfree);   %Display max dimension to check why a certain error happened
                    end
                    routingnew(i2)=routingold(found);
                    
                end
                
            end
        end
    else
        Threshfxyc=single(array{1});
    end
    
    TraceFinalization_2019(Threshfxyc,orig_movies{i9},framegap(i9));
end
end