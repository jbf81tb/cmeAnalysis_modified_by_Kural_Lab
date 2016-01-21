function comb_run(exp_name)
% Prior to running this there should be a directory of the form
%  '~/experiment_name/orig_movies'
% and inside the orig_movies folder should be the original tifs
% Also, you must include a background movie even if the background
% has already been removed. If that is the case then the background movie
% will be ignored, but variables still care about it and would error out
% if it weren't there.
% REMINDER: '~' is the home directory, something like '/nfs/##/osu####/'
%           Basically, it's where you start out.

omd = fullfile(exp_name,'orig_movies'); %experiment directory (should use this templating)
smd = fullfile(exp_name,'split_movies');

tmpd = dir(fullfile(omd,'*.tif'));
movies      = cell(length(tmpd),1);
splitmovies = cell(length(tmpd),1);

%%%%%%%% Adjust %%%%%%%%
framegap = 5*ones(length(movies),1);
Threshs = 1000*ones(length(movies),1);
sectionsize = 350;
sections = 1*ones(length(movies),1);
%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(movies)
    movies{i} = fullfile(omd,tmpd(i).name);
    splitmovies{i} = fullfile(smd,tmpd(i).name(1:(end-4)));
    mkdir(splitmovies{i});
end

LongMultiMovieSplitAnalysis(movies,sectionsize,splitmovies,framegap);
LongMoviePostCME_osc(smd,omd,Threshs,sections);
end