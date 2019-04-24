function TrackWrapper2019(path,movie)
%This program takes the tracks produces by cmeAnalysis and separates the likely good ones from the bad ones and converts them
%into the format we use.  You'll have to run this twice--first with
%Thresh=0, then run ThreshFinder, then run it again with the Thresh you
%found.

%Parameters to set
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell4_1s\Tracking\ProcessedTracks.mat';
%Thresh=0;
%optional
load(path,'tracks');
MF=length(imfinfo(movie));
Threshfxyc=zeros(MF,5,length(tracks));
pa=MF;
pb=5;
for i=1:length(tracks)
    fxyc=Track2fxyc(tracks(i));
    [a,b]=size(fxyc);
    if a<pa
        fxyc(pa,pb)=0;
    end
    Threshfxyc(:,:,i)=fxyc;
end
[save_loc, ~, ~] = fileparts(path);
save(fullfile(save_loc, 'TempTraces.mat'), 'Threshfxyc','-v7.3');
