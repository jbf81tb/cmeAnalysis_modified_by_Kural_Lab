function comb_run(exp_name,varargin)
%COMB_RUN Run cmeAnalysis on multiple files.
% Takes 5 arguments.
% 1) Path to experiment folder (string). Experiment folder should contain the folder
% "orig_movies" and that should contain all of the movies you want to run
% over.
% 2) Framegap of the movies.
% 3) Threshold to apply to movies.
% 4) Number of sections the movie will be divided into. Default section
% size is 500, so if the movie is longer than 500 frames it will be more
% than 1 section.
% 4) Section size. This variable exists for memory considerations.
%
% Any argument may be a scalar or vector. Use a scalar if all the movies
% share the necessary properties. Use a vector if you need to specify
% particular properties for particular movies. The movies work in the order
% of the 'dir' function, which can be different from the order that the
% files are in the file explorer, especially if the filenames end in
% numbers of different digit lengths.
%% Find out how many movies there are.
omd = fullfile(exp_name,'orig_movies');
tmpd = dir(fullfile(omd,'*.tif'));
movies      = cell(length(tmpd),1);
%% Input checking
switch nargin
    case 1
        framegap = 1*ones(length(movies),1);
        Threshs = 400*ones(length(movies),1);
        sections = 1*ones(length(movies),1);
        sectionsize = 500;
    case 2
        if length(varargin{1})>1
            framegap = varargin{1};
        elseif  isscalar(varargin{1})
            framegap = varargin{1}*ones(length(movies),1);
        end
        Threshs = 400*ones(length(movies),1);
        sections = 1*ones(length(movies),1);
        sectionsize = 500;
    case 3
        if length(varargin{1})>1
            framegap = varargin{1};
        elseif  isscalar(varargin{1})
            framegap = varargin{1}*ones(length(movies),1);
        end
        if length(varargin{2})>1
            Threshs = varargin{2};
        elseif  isscalar(varargin{2})
            Threshs = varargin{2}*ones(length(movies),1);
        end
        sections = 1*ones(length(movies),1);
        sectionsize = 500;
    case 4
        if length(varargin{1})>1
            framegap = varargin{1};
        elseif  isscalar(varargin{1})
            framegap = varargin{1}*ones(length(movies),1);
        end
        if length(varargin{2})>1
            Threshs = varargin{2};
        elseif  isscalar(varargin{2})
            Threshs = varargin{2}*ones(length(movies),1);
        end
        if length(varargin{3})>1
            sections = varargin{3};
        elseif  isscalar(varargin{3})
            sections = varargin{3}*ones(length(movies),1);
        end
        sectionsize = 500;
    case 5
        if length(varargin{1})>1
            framegap = varargin{1};
        elseif  isscalar(varargin{1})
            framegap = varargin{1}*ones(length(movies),1);
        end
        if length(varargin{2})>1
            Threshs = varargin{2};
        elseif  isscalar(varargin{2})
            Threshs = varargin{2}*ones(length(movies),1);
        end
        if length(varargin{3})>1
            sections = varargin{3};
        elseif  isscalar(varargin{3})
            sections = varargin{3}*ones(length(movies),1);
        end
        sectionsize = varargin{4};
end
%% Making folders
smd = fullfile(exp_name,'split_movies');
if ~exist(smd,'dir')
    mkdir(smd);
end
splitmovies = cell(length(tmpd),1);

for i = 1:length(movies)
    movies{i} = fullfile(omd,tmpd(i).name);
    splitmovies{i} = fullfile(smd,tmpd(i).name(1:(end-4)));
    mkdir(splitmovies{i});
end
%% Actual Execution
% LongMultiMovieSplitAnalysis(movies,sectionsize,splitmovies,framegap);
% clear functions
LongMoviePostCME_osc(smd,omd,Threshs,sections);
end