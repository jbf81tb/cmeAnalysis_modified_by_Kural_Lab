clear all;
%Parameters that need to be set
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\Josh Spreading Movies\1\Cell1_2s\ch1\Tracking\ProcessedTracks.mat'; %location of Processed traces created by cmeAnalysis
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\DropEx\Cell2_3s\Tracking\ProcessedTracks.mat';
path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\DropEx\Cell8_3s\Tracking\ProcessedTracks.mat';
file='ColdblockShort-Eccentricity.tif'; %The movie you want analyzed
FrameGap=1; %seconds per frame
endsize=4;
enderrors=1;
slopebound=0;
R2Bound=.75;

[FoundSpots]=TrackPartialDecoder(path);
Thresh=ThreshFinderWOTrackWrapper(FoundSpots,file);
SimplifiedTrackWrapperWOTrackSplitter(path,Thresh,file,endsize,enderrors,slopebound,R2Bound);
[IMat,CMat]=SimplifiedMakeInitiationVectorWPositions('TempTraces.mat');