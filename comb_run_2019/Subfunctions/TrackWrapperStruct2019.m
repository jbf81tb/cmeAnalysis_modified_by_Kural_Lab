function TrackWrapperStruct2019(path)
%This program takes the tracks produces by cmeAnalysis and separates the likely good ones from the bad ones and converts them
%into the format we use.  You'll have to run this twice--first with
%Thresh=0, then run ThreshFinder, then run it again with the Thresh you
%found.

%Parameters to set
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\Fly\Cell4_1s\Tracking\ProcessedTracks.mat';
%Thresh=0;
%optional
load(path,'tracks');
fxyc_struct=tracks2fxycstruct(tracks);
[save_loc, ~, ~] = fileparts(path);
save(fullfile(save_loc, 'TempTraces.mat'), 'fxyc_struct','-v7.3');

