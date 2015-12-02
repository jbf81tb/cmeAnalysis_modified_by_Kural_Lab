function Nathans_LongMultiMovieSplitAnalysis(movies,MaxSectionSize,newmovies,GroupName,framegap)

wd0=pwd;
for im=1:length(movies)
    movie=movies{im};
    MaxSectionSize0=MaxSectionSize;
frames=length(imfinfo(movie));
sections=ceil(frames/(MaxSectionSize0-1));
SectionSize=ceil(frames/sections);
start=zeros(sections,1);
stop=zeros(sections,1);
for i=1:sections
    if i==1
        start(i)=1;
    else
        start(i)=(i-1)*SectionSize; %Make a frame of overlap so that the traces in different sections can be put together
    end
    stop(i)=min(i*SectionSize,frames);
    sectionname=strcat(newmovies{im},'_',num2str(i),'.tif');
    MovieShortenerF(movie,sectionname,start(i),stop(i));
    folder=strcat(GroupName,'/',newmovies{im},'/Section',num2str(i));
    intstr=strcat('/Cell1_',num2str(framegap(im)),'s/ch1');
    folder2=strcat(folder,intstr);
    mkdir(folder,intstr);
    movefile(sectionname,folder2);
end
cd(GroupName)
folderlist = ls;
wd = pwd;
% for i = 3:size(folderlist,1)
%     tempname = '';
%     for j = 1:size(folderlist,2)
%         if ~strcmp(folderlist(i,j), ' ')
%             tempname = strcat(tempname,folderlist(i,j));
%         end
%     end
%     tempfol = dir(tempname);
%     dirname{i-2} = strcat(folderlist(i,:),'\',tempfol(end).name);
%     file = dir(strcat(dirname{i-2},'\ch1\'));
%     for j = size(file,1):-1:1
%         if ~isempty(regexp(file(j).name,'.tif', 'once'))
%             moviename{i-2} = strcat('ch1\',file(j).name);
%         end
%     end
%     paths{im}=strcat(wd,'\',dirname{i},'\TempTraces.mat');
% end



cd(wd0)
end
cd(GroupName)
cmeanalysis_auto;

% Threshs=FindThresholds(movies,paths);
% for i=1:length(movies)
%     LongMovieSplitAnalysisWThresh(movie,MaxSectionSize,newmovie,framegap,Threshs(i))
% end