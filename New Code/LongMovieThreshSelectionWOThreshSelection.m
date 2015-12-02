%Navigate to the folder with all the movies you want to find threshs for
wd=pwd;
folderlist=ls;
for i = 3:size(folderlist,1)
    tempname = '';
    for j = 1:size(folderlist,2)
        if ~strcmp(folderlist(i,j), ' ')
            tempname = strcat(tempname,folderlist(i,j));
        end
    end
    tempfol = dir(tempname);
    dirname{i-2} = strcat(folderlist(i,:));
end
for i = 1:size(dirname,2)
cd(dirname{i})
clear moviename paths dirname2
movies=false;
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
            movies=true;
        end
    end
end
if movies
for i2 = 1:size(dirname2,2)
cd(dirname2{i2})
paths{i2}=strcat(wd2,'\',dirname2{i2},'\ch1\Tracking\ProcessedTracks.mat');
path2=strcat(wd2,'\',dirname2{i2},'\TempTraces.mat');
file=moviename{i2};
frames = length(imfinfo(file));
FrameGap=str2double(dirname2{i2}(end-1));
cd(wd2)
end

%[Threshs{i}]=LongMovieThreshholdSelection(paths,moviename);

end

cd(wd)
end