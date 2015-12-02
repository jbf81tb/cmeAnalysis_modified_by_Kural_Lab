function LongMultiMovieSplitAnalysis(movies,MaxSectionSize,newmovies,framegap,bg_movie)
if strcmp(bg_movie((end-7):end),'none.tif'), 
    no_remove = true; 
else
    no_remove=false;
    bg = imread(bg_movie);
end
for im=1:length(movies)
    movie=movies{im};
    frames=length(imfinfo(movie));
    sections=ceil(frames/(MaxSectionSize-1));
    SectionSize=ceil(frames/sections);
    start=zeros(sections,1);
    stop=zeros(sections,1);
    nmd = cell(sections,1);
    nmn = cell(sections,1);
    frame_rate = framegap(im);
    save(fullfile(newmovies{im},'frame_rate.mat'),'frame_rate');
    for i=1:sections
        if i==1
            start(i)=1;
        else
            start(i)=(i-1)*SectionSize; %Make a frame of overlap so that the traces in different sections can be put together
        end
        stop(i)=min(i*SectionSize,frames);
        nmd{i} = fullfile(newmovies{im},...              %new movie directory
                       ['Section',num2str(i)],...
                       ['Cell1_',num2str(frame_rate)],...
                       'ch1');
        mkdir(nmd{i});
        nmn{i} = fullfile(nmd{i},['section',num2str(i),'.tif']); %new movie name
        
        if ~exist(nmn{i},'file')
            if strcmp(movie(end-6:end-4),'bgr') || no_remove
                MovieShortenerF(movie,nmn{i},start(i),stop(i))
            else
                MovieShortenerF_bgr(movie,nmn{i},start(i),stop(i),bg);
            end
        end
        
        cmeAnalysis('Parameters', [1.45, 100, 16], 'condDir', fullfile(newmovies{im},['Section',num2str(i)]), 'chNames', {'ch1'}, 'markers', {'egfp'}, 'Master', 1);
        
    end
end
end
