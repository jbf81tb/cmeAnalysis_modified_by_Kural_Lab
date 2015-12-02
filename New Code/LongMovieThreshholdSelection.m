function [Threshs]=LongMovieThreshholdSelection(paths,movies,SectionSize) 
FoundSpotsC = cell(2,1);
for i=1:length(paths)
    if i==1 || i==length(paths)
        path=paths{i};
        [FoundSpots]=TrackPartialDecoder(path);
        FoundSpotsC{i}=FoundSpots;
    end
end

movie=movies{1};
ApC=ThreshFinderWOTrackWrapper(FoundSpotsC{1},movie,ceil(SectionSize/4));

movie=movies{length(paths)};
C=ThreshFinderWOTrackWrapper(FoundSpotsC{length(paths)},movie,ceil(SectionSize*3/4));

    Threshs=min(ApC,C);
end