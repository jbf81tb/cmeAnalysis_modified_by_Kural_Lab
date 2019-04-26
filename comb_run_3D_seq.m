function comb_run_3D_seq(exp_name,tstacks,zstacks,num_seq,varargin)
%COMB_RUN_3D Perform cmeAnalysis on multiple 3D movies taken over time.
%{
Movies should be designed in the following fashion.
Sequence 1:
frame_1: time 1, zpos 1
frame_2: time 1, zpos 2
frame_3: time 1, zpos 3
...
frame_zsize: time 1, zpos zsize
frame_zsize+1: time 2, zpos 1
frame_zsize+2: time 2, zpos 2
...
etc... until the next section, where the pattern repeats.

This is the default output of NIS-Elemtents Viewer when making a multi-page
    tif from a 3Dt sequence.

Required Arguments:
exp_name: a string to the path where movies are. should contain a 'movies'
   folder and in that folder should be all the .tif files.
tstacks and zstacks: can be a vector if they're different or a scalar if
   they're all the same. If one is an empty vector, the other will be
   automatically generated.
num_seq: the number of sequences in each movie. As before, can be a vector or scalar if
the movies have different numbers.

Variable Arguments:
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
if length(tstacks)==1
    tstacks = tstacks*ones(nm,1);
end
if length(zstacks)==1
    zstacks = zstacks*ones(nm,1);
end
if length(num_seq)==1
    num_seq = num_seq*ones(nm,1);
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

mlps = zeros(nm,1);
zlps = zeros(nm,1);
for mov = 1:nm
    for seq = 1:num_seq(mov)
        
        mov_fol = fullfile(md,[mdir(mov).name(1:end-4) '_Sequence_' sprintf('%03u',seq)]);
        mkdir(mov_fol);
        omd = fullfile(mov_fol,'orig_movies');
        mkdir(omd)
        smd = fullfile(mov_fol,'split_movies');
        mkdir(smd);
        if isempty(tstacks)
            mlps(mov) = length(imfinfo(fullfile(md,mdir(mov).name)))/zstacks(mov)/num_seq(mov);
            zlps(mov) = zstacks(mov);
        elseif isempty(zstacks)
            zlps(mov) = length(imfinfo(fullfile(md,mdir(mov).name)))/tstacks(mov)/num_seq(mov);
            mlps(mov) = tstacks(mov);
        else
            mlps(mov) = tstacks(mov);
            zlps(mov) = zstacks(mov);
        end
        
        
        for st = 1:zlps(mov)
            fname = ['Sequence_' num2str(seq) '_Stack_' num2str(st) '.tif'];
            if exist(fullfile(omd,fname),'file'), continue; end
            for fr = 1:mlps(mov)
                frame = imread(fullfile(md,mdir(mov).name),...
                    (seq-1)*zlps(mov)*mlps(mov)+(fr-1)*zlps(mov)+st);
                imwrite(frame,fullfile(omd,fname),'tif','writemode','append');
            end
        end
        
        
        if length(fg)==1
            framegap = fg*ones(zlps(mov),1);
        else
            framegap = fg(mov)*ones(zlps(mov),1);
        end
        if length(Th)==1
            Threshs = Th*ones(zlps(mov),1);
        else
            Threshs = Th(mov)*ones(zlps(mov),1);
        end
        if length(sectionsize)==1
            secs = sectionsize*ones(zlps(mov),1);
        else
            secs = sectionsize(mov)*ones(zlps(mov),1);
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
    end
    disp('Progress at:')
    disp(datetime('now'))
    disp('is ')
    fprintf('%03u %%',mov/nm*100)
end
end
