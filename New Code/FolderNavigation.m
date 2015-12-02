clear
folderlist2 = ls;
wd2 = pwd;
for i2 = 3:size(folderlist2,1)
    tempname2 = '';
    for j = 1:size(folderlist2,2)
        if ~strcmp(folderlist2(i2,j), ' ')
            tempname2 = strcat(tempname2,folderlist2(i2,j));
        end
    end
    tempfol2 = dir(tempname2);
    dirname2{i2-2} = strcat(folderlist2(i2,:),'\',tempfol2(end).name);
    file = dir(strcat(dirname2{i2-2},'\ch1\'));
    for j = size(file,1):-1:1
        if ~isempty(regexp(file(j).name,'.tif', 'once'))
            moviename{i2-2} = strcat(file(j).name);
        end
    end
end
for i2 = 1:size(dirname2,2)
cd(dirname2{i2})
paths{i2}=strcat(wd2,'\',dirname2{i2},'\ch1\Tracking\ProcessedTracks.mat');
path2=strcat(wd2,'\',dirname2{i2},'\TempTraces.mat');
file=moviename{i2};
frames = length(imfinfo(file));
FrameGap=str2double(dirname2{i2}(end-1));
cd(wd2)
end