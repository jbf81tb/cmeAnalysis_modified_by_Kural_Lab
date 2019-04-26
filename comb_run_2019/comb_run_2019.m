function comb_run_2019(exp_name,varargin)
%COMB_RUN Run cmeAnalysis on multiple files.
% Takes 5 arguments.
% 1) Path to experiment folder (string). Experiment folder should contain
%    the folder "orig_movies" and that should contain all of the .tif movies
%    you want to run over.
% 2) Framegap of the movies (in seconds). (default 1s)
% 3) Threshold to apply to movies. (default 400)
% 4) Section size. (default 500)
%        This variable exists for memory considerations.
%
% Any argument may be a scalar or vector. Use a scalar if all the movies
% share the necessary properties. Use a vector if you need to specify
% particular properties for particular movies. The movies are run in the
% order of the 'dir' function, which can be different from the order that
% the files are in the file explorer, especially if the filenames end in
% numbers of different digit lengths. (e.g. 8,9,10 vs 08,09,10 <-better)
%
% Josh Ferguson, Kural Group, Ohio State University, ferguson.621@osu.edu
%
%% Find out how many movies there are.
omd = fullfile(exp_name,'orig_movies');
tmpd = dir(fullfile(omd,'*.tif'));
movies = cell(length(tmpd),1);
%% Input checking
switch nargin
    case 1
        framegap = 1*ones(length(movies),1);
        Threshs = 400*ones(length(movies),1);
        sectionsize = 500*ones(length(movies),1);
    case 2
        if length(varargin{1})>1
            framegap = varargin{1};
        elseif  isscalar(varargin{1})
            framegap = varargin{1}*ones(length(movies),1);
        end
        Threshs = 400*ones(length(movies),1);
        sectionsize = 500*ones(length(movies),1);
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
        sectionsize = 500*ones(length(movies),1);
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
            sectionsize = varargin{3};
        elseif  isscalar(varargin{3})
            sectionsize = varargin{3}*ones(length(movies),1);
        end
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
% Actual Execution
sections = LongMultiMovieSplitAnalysis(movies,sectionsize,splitmovies,framegap);
clear functions
 %sections = [2 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];
LongMoviePostCME_osc_Struct_2019(smd,omd,Threshs,sections,framegap);
disp('Finished at:');
disp(datetime('now'));
% disp('***************************************************')
% disp('REMEMBER TO CHANGE IT BACK')
% disp('*************************************************')
end