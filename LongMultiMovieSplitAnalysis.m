function sections = LongMultiMovieSplitAnalysis(movies,MaxSectionSize,newmovies,framegap)
%LONGMULTIMOVIESPLITANALYSIS Analyze multiple long movies at once.
%   Inputs:
%       movies: Cell array of strings of the file path of movies.
%       MaxSectionSize: Largest sections allowed to be analyzed. Movies
%           will be equally dividied into multiple parts such that the size
%           of each is under the MaxSectionSize. Can put 'inf' to just get
%           one section.
%       newmovies: Cell array of strings of the file path of new movies.
%           (Yes, even if movies don't need to be split in parts they are
%           still copied to a new location. This analysis is not friendly
%           to hard drive space.)
%       framegap: A vector containing the frame rates of all the movies.
%           cmeAnalysis supposedly uses this in its analysis.
%   Outputs:
%       sections: A vector of the number of sections for each movie. Used
%           as input for LongMoviePostCME_osc.
% This code will rarely need to be run on its own as comb_run takes care of
% most of the details. Still, if you are used to working with the results
% of cmeAnalysis this can be a tool to run multiple long movies if you don't
% already have a tool for that.
%
% Josh Ferguson, Kural Group, Ohio State University, ferguson.621@osu.edu
%
sections = zeros(1,length(movies));
for im=1:length(movies)
    movie=movies{im};
    frames=length(imfinfo(movie));
    if isinf(MaxSectionSize(im))
        sections(im)=1;
    else
        sections(im)=ceil(frames/(MaxSectionSize(im)-1));
    end
    SectionSize=ceil(frames/sections(im));
    start=zeros(sections(im),1);
    stop=zeros(sections(im),1);
    nmd = cell(sections(im),1);
    nmn = cell(sections(im),1);
    frame_rate = framegap(im);
    save(fullfile(newmovies{im},'frame_rate.mat'),'frame_rate');
    for i=1:sections(im)
        if i==1
            start(i)=1;
        else
            %Make a frame of overlap so that the traces in different
            %sections can be put together
            start(i)=(i-1)*SectionSize; 
        end
        stop(i)=min(i*SectionSize,frames);
        nmd{i} = fullfile(newmovies{im},...          %new movie directory
                       ['Section',num2str(i)],...
                       ['Cell1_',num2str(frame_rate)],...
                       'ch1');
        mkdir(nmd{i});
        nmn{i} = fullfile(nmd{i},['section',num2str(i),'.tif']); %new movie name
        MovieShortenerF(movie,nmn{i},start(i),stop(i))
        %after years of working with cmeAnalysis we finally realized there
        %was a better way to do this, but as it is, cmeAnalysis has been
        %lightly edited to allow this kind of input, so this will not work
        %with other builds of cmeAnalysis. There is documentation to run
        %cmeAnalysis without the prompts provided with the code as
        %distributed by Danuser Lab, if you would like to modify this code
        %to work the way it was meant to. As it is, it works with all the
        %files included here.
        cmeAnalysis('Parameters', [1.45, 100, 16], 'condDir', fullfile(newmovies{im},['Section',num2str(i)]), 'chNames', {'ch1'}, 'markers', {'egfp'}, 'Master', 1);
%         disp('REMEMBER TO CHANGE BACK CMEANALYSIS')
    end
end
end
