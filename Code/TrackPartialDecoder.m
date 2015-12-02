function [FoundSpots]=TrackPartialDecoder(path)
%Creates FoundSpots matrix out of ProcessedTracks file where
%FoundSpots(i,1(2)([3]) ([{4]])) is the frame (x [y] coordinate)([{intensity}]) of the ith spot


load(path) %automate file detection
[~,TOTtraces]=size(tracks);
TOTspots=0;
tracksx=table({tracks.x}.','VariableNames',{'x'});
tracksy=table({tracks.y}.','VariableNames',{'y'});
tracksf=table({tracks.f}.','VariableNames',{'f'});
tracksA=table({tracks.A}.','VariableNames',{'A'});
h=waitbar(0,'Counting Spots');
for i=1:TOTtraces
    waitbar(i/TOTtraces)
    x=tracksx.x{i,1};
    TOTspots=TOTspots+length(find(x));
end
close(h)
FoundSpots=zeros(TOTspots,4);
i=1;
h=waitbar(0,'Processing Traces');
for k=1:TOTtraces
    waitbar(k/TOTtraces)
    x=tracksx.x{k,1};
    y=tracksy.y{k,1};
    f=tracksf.f{k,1};
    A=tracksA.A{k,1};
    NonEmpty=find(x);
    for j=1:length(NonEmpty)
        FoundSpots(i,1)=f(NonEmpty(j));
        FoundSpots(i,2)=x(NonEmpty(j));
        FoundSpots(i,3)=y(NonEmpty(j));
        FoundSpots(i,4)=A(NonEmpty(j));
        i=i+1;
    end
end
close(h)
            