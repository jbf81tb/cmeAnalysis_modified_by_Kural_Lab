function find_thresh_before_submit
wd=pwd;
smd = fullfile(wd,'split_movies');

folderlist = dir(smd);

dirname = cell(length(folderlist)-2,1);
for i = 1:length(dirname)
    dirname{i} = fullfile(smd,folderlist(i+2).name);
end
movies = length(dirname);
sections = zeros(movies,1);
for i = 1:movies
    tmpd = dir(dirname{i});
    tmpd = tmpd([tmpd.isdir]);
    tmpd(strncmp({tmpd.name},'.',1)) = [];
    sections(i) = length(tmpd);
end

moviefol = cell(max(sections),movies);
moviename = cell(max(sections),movies);
paths = cell(max(sections),movies);
SectionSize = zeros(movies,1);
Threshs = cell(movies,1);
for i = 1:movies
    tpath = cell(length(sections(i)),1);
    tname = cell(length(sections(i)),1);
    for i2 = 1:sections(i)
        tmpn = fullfile(dirname{i},['Section',num2str(i2)]);
        tmpd = dir(tmpn);
        moviefol{i2,i} = fullfile(tmpn,tmpd(3).name,'ch1');
        paths{i2,i} = fullfile(moviefol{i2,i},'Tracking','ProcessedTracks.mat');
        tmpd = dir(fullfile(moviefol{i2,i},'*.tif'));
        moviename{i2,i} = fullfile(moviefol{i2,i},tmpd.name);
        if i2==1
            SectionSize(i) = length(imfinfo(moviename{i2,i}));
        end
        tpath{i2} = paths{i2,i};
        tname{i2} = moviename{i2,i};
    end
    
        [Threshs{i}]=LongMovieThreshholdSelection(tpath,tname,SectionSize(i));
end
save(fullfile(smd,'threshs.mat'),'Threshs','sections');
end