%Navigate to the folder with all the movies you want to find threshs for
wd=pwd;
folderlist = dir(wd);
dirname = cell(size(folderlist,1)-2,1);
for i = 3:length(folderlist)
    dirname{i-2} = strcat(wd,'/',folderlist(i).name,'/');
end
movies = length(dirname);
SectionSize = cell(movies,1);
Threshs = cell(movies,1);
for i = 1:movies
    folderlist2 = dir(dirname{i});
    sections = length(folderlist2)-2;
    
    cellnum = cell(sections,1);
    moviename = cell(sections,1);
    paths = cell(sections,1);
    
    for i2 = 1:sections
        tmp = dir(strcat(dirname{i},'Section',num2str(i2),'/'));
        cellnum{i2} = strcat(dirname{i},'Section',num2str(i2),'/',tmp(3).name,'/ch1/');
        paths{i2} = strcat(cellnum{i2},'Tracking/ProcessedTracks.mat');
        tmp = dir(strcat(cellnum{i2},'*.tif'));
        moviename{i2} = tmp.name;
        if i2==1
            SectionSize{i} = length(imfinfo(moviename{i2}));
        end
    end
    
    [Threshs{i}]=LongMovieThreshholdSelection(paths,moviename);
end
cd(wd)