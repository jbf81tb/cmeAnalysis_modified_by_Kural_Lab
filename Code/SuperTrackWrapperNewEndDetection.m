clear all;
%Parameters that need to be set
%path='\\phypcs.physics.ohio-state.edu\kural\Scott\Josh Spreading Movies\1\Cell1_2s\ch1\Tracking\ProcessedTracks.mat'; %location of Processed traces created by cmeAnalysis
path='E:\Scott Matlab Stuff\cmeAnalysisPackage\MovieParent\Mitosis2\Cell4_4s\Tracking\ProcessedTracks.mat';
file='josh_mitosis_50ms_4s004_crop_substack.tif'; %The movie you want analyzed
FrameGap=4; %seconds per frame
endsize=4;
enderrors=1;
slopebound=0;
R2Bound=.75;

[FoundSpots]=TrackPartialDecoder(path);
Thresh=ThreshFinderWOTrackWrapper(FoundSpots,file,200);
SimplifiedTrackWrapperNewEndDetection(path,Thresh,file,endsize,enderrors,slopebound,R2Bound);
%[IMat,CMat]=SimplifiedMakeInitiationVectorWPositions('TempTraces.mat');