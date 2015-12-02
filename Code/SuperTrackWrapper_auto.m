%clear
%Parameters that need to be set
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
for i = 1:1
cd(dirname{i})
path1=strcat(wd,'\',dirname{i},'\ch1\Tracking\ProcessedTracks.mat');
path2=strcat(wd,'\',dirname{i},'\TempTraces.mat');
file=moviename{i};
frames = length(imfinfo(file));
FrameGap=str2double(dirname{i}(end-1));

[FoundSpots]=TrackPartialDecoder(path1);
Thresh=ThreshFinderWOTrackWrapper(FoundSpots,file);
cd(wd)
end
for i = 1:size(dirname,2)
cd(dirname{i})
path1=strcat(wd,'\',dirname{i},'\ch1\Tracking\ProcessedTracks.mat');
path2=strcat(wd,'\',dirname{i},'\TempTraces.mat');
file=moviename{i};
frames = length(imfinfo(file));
FrameGap=str2double(dirname{i}(end-1));


SimplifiedTrackWrapperNewEndDetection(path1,Thresh,file, 4,1,0,.75);
%L{i}=SimplifiedMakeLifetimeVector(path2,FrameGap);
%life{i}=SimplifiedLifetimeVFrameFinder(path2,frames,FrameGap);
cd(wd)
end