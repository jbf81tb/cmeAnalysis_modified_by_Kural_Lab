function post_run
% Prior to running this there should be a directory of the form
%  '~/experiment_name/split_movies'
% and inside the split_movies folder should be the split movies run
% on the LongMultiMovieSplitAnalysis code.
% REMINDER: '~' is the home directory, something like '/nfs/##/osu####/'
%           Basically, it's where you start out.

gen_dir = pwd;
addpath(genpath(fullfile(gen_dir,'Matlab_stuff'))); %%% Adjust based on personal OSC directory setup

%%%%%%% Adjust %%%%%%%
exp_name = 'suction2rerun';
%%%%%%%%%%%%%%%%%%%%%%
smd = fullfile(gen_dir,exp_name,'split_movies'); %experiment directory should use this templating
omd = fullfile(gen_dir,exp_name,'orig_movies');

LongMoviePostCME_osc(smd,omd);

end
