function LongMoviePostCME_osc_Struct_2019(smd,omd,Threshs,sections,framegap)
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
    for i = 1:sections(i9)
        SS(i,i9)=length(imfinfo(moviename{i,i9}));
        if ~exist(fullfile(fileparts(paths{i,i9}),'TempTraces.mat'),'file')
            %this is the meat of the analysis
            TrackWrapperStruct2019(paths{i,i9});
        end
    end
%% combine adjacent sections
    fxyc_struct=CombineTimeSections({paths{:,i9}},SS(:,i9));
    
    TraceFinalization_Struct_2019(fxyc_struct,orig_movies{i9},framegap(i9));
end
end