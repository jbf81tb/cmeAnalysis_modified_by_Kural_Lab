function comb_run_seq(exp_name,tstacks,num_seq,varargin)
%COMB_RUN_SEQ Perform cmeAnalysis on sequential movies taken over time.
%{
Movies should be designed in the following fashion.
frame_1: sequence 1, time 1
frame_2: sequence 1, time 2
frame_3: sequence 1, time 3
...
frame_zsize: sequence 1, time tstacks
frame_zsize+1: sequence 2, time 1
frame_zsize+2: sequence 2, time 2
...
...
...

This is the default output of NIS-Elemtents Viewer when making a multi-page
    tif from a sequence movie.

required arguments:

exp_name: a string to the path where movies are. should contain a 'movies'
   folder and in that folder should be all the .tif files.
num_seq and tstacks: can be a vector if they're different or a scalar if
   they're all the same. If one is an empty vector, the other will be
   automatically generated.

varargins:

fg: frame gap for the movies. can be a vector if the movies have different
   frame gaps. can be a scalar if they're all the same.
Th: A threshold value. 400 is usually good, but can be changed
   to something like 1000 if the movie is particularly bright.
sectionsize: can be adjusted for memory considerations. Usually not
   needed.
%}

md = fullfile(exp_name,'movies');
mdir = dir(fullfile(md,'*.tif'));
nm = length(mdir);
if length(num_seq)==1
    num_seq = num_seq*ones(nm,1);
end
if length(tstacks)==1
    tstacks = tstacks*ones(nm,1);
end

switch nargin
    case 3
        fg = 1;
        Th = 400;
        sectionsize = 500;
    case 4
        fg = varargin{1};
        Th = 400;
        sectionsize = 500;
    case 5
        fg = varargin{1};
        Th = varargin{2};
        sectionsize = 500;
    case 6
        fg = varargin{1};
        Th = varargin{2};
        sectionsize = varargin{3};
end

mlps = zeros(nm,1); % movie length per sequence
nspm = zeros(nm,1); % number of squences per movie
for mov = 1:nm
    mov_fol = fullfile(md,mdir(mov).name(1:end-4));
    mkdir(mov_fol);
    omd = fullfile(mov_fol,'orig_movies');
    mkdir(omd)
    smd = fullfile(mov_fol,'split_movies');
    mkdir(smd);
    if isempty(num_seq)
        mlps(mov) = length(imfinfo(fullfile(md,mdir(mov).name)))/tstacks(mov);
        nspm(mov) = tstacks(mov);
    elseif isempty(tstacks)
        nspm(mov) = length(imfinfo(fullfile(md,mdir(mov).name)))/num_seq(mov);
        mlps(mov) = num_seq(mov);
    else
        mlps(mov) = num_seq(mov);
        nspm(mov) = tstacks(mov);
    end
    
    for st = 1:nspm(mov)
        if exist(fullfile(omd,['Sequence_' num2str(st) '.tif']),'file'), continue; end
        for fr = 1:mlps(mov)
            frame = imread(fullfile(md,mdir(mov).name),(fr-1)*nspm(mov)+st);
            imwrite(frame,fullfile(omd,['Sequence_' num2str(st) '.tif']),'tif','writemode','append');
        end
    end

    if length(fg)==1
        framegap = fg*ones(nspm(mov),1);
    else
        framegap = fg(mov)*ones(nspm(mov),1);
    end
    if length(Th)==1
        Threshs = Th*ones(nspm(mov),1);
    else
        Threshs = Th(mov)*ones(nspm(mov),1);
    end
    if length(sectionsize)==1
        secs = sectionsize*ones(nspm(mov),1);
    else
        secs = sectionsize(mov)*ones(nspm(mov),1);
    end

    tmpd = dir(fullfile(omd,'*.tif'));
    movies      = cell(length(tmpd),1);
    splitmovies = cell(length(tmpd),1);

    for i = 1:length(movies)
        movies{i} = fullfile(omd,tmpd(i).name);
        splitmovies{i} = fullfile(smd,tmpd(i).name(1:(end-4)));
        if ~exist(splitmovies{i},'dir'), mkdir(splitmovies{i}); end
    end

    sections = LongMultiMovieSplitAnalysis(movies,secs,splitmovies,framegap);
    LongMoviePostCME_osc(smd,omd,Threshs,sections);
    disp('Progress at:')
    disp(datetime('now'))
    fprintf('%03u %%',mov/nm*100)
end
end
