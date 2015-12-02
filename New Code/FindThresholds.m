function Threshs=FindThresholds(movies,paths) %Give it a cell array of the movie names you want to run and the cmeAnalysis results and it will prompt you to choose thresholds 

for i=1:length(movies)
    path=paths{i};
    movie=movies{i};
    [FoundSpots]=TrackPartialDecoder(path);
    Thresh(i)=ThreshFinderWOTrackWrapper(FoundSpots,movie);
end