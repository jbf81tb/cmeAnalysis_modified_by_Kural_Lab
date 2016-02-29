function comb_run_3D(exp_name,fg,tstacks,zstacks,varargin)
%COMB_RUN_3D Perform cmeAnalysis on multiple 3D movies taken over time.
%exp_name: folder where movies are. should have a 'background' folder and
%a 'movies' folder
%fg: frame gap for the movies. can be a vector if the movies have different
%frame gaps. can be a scalar if they're all the same.
%tstacks and zstacks: one should be there an integer, the other should be
%empty
%make: if not all the movies are good, you make have to 'make' without doing
%so you can delete some before you 'do' without making
%do: the main purpose of the function. usually true, unless for reasons
%seen above
%The last argument can be a threshold value. 400 is usually good, but can
%be changed to something like 1000 if the movie is particularly bright.

if nargin<5
    Th = 400;
elseif nargin == 5
    Th = varargin{1};
end
sectionsize = 500;
md = fullfile(exp_name,'movies');
mdir = dir(fullfile(md,'*.tif'));
nm = length(mdir);
for mov = 1:nm
    mov_fol = fullfile(md,mdir(mov).name(1:end-4));
    mkdir(mov_fol);
    omd = fullfile(mov_fol,'orig_movies');
    mkdir(omd)
    smd = fullfile(mov_fol,'split_movies');
    mkdir(smd);
    if isempty(tstacks)
        mlps = length(imfinfo(fullfile(md,mdir(mov).name)))/zstacks;
        zlps = zstacks;
    elseif isempty(zstacks)
        zlps = length(imfinfo(fullfile(md,mdir(mov).name)))/tstacks;
        mlps = tstacks;
    else
        mlps = tstacks;
        zlps = zstacks;
    end
    
    for st = 1:zlps
        if exist(fullfile(omd,['Stack_' num2str(st) '.tif']),'file'), continue; end
        for fr = 1:mlps
            frame = imread(fullfile(md,mdir(mov).name),(fr-1)*zlps+st);
            imwrite(frame,fullfile(omd,['Stack_' num2str(st) '.tif']),'tif','writemode','append');
        end
    end
    
    if length(fg)==1
        framegap = fg*ones(zlps,1);
    else
        framegap = fg(mov)*ones(zlps,1);
    end
    if length(Th)==1
        Threshs = Th*ones(zlps,1);
    else
        Threshs = Th(mov)*ones(zlps,1);
    end
    sections = ones(zlps,1);
    
    tmpd = dir(fullfile(omd,'*.tif'));
    movies      = cell(length(tmpd),1);
    splitmovies = cell(length(tmpd),1);
    
    for i = 1:length(movies)
        movies{i} = fullfile(omd,tmpd(i).name);
        splitmovies{i} = fullfile(smd,tmpd(i).name(1:(end-4)));
        if ~exist(splitmovies{i},'dir'), mkdir(splitmovies{i}); end
    end

    LongMultiMovieSplitAnalysis(movies,sectionsize,splitmovies,framegap);
    LongMoviePostCME_osc(smd,omd,Threshs,sections);
end
end
