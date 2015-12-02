function [BigX, BigY, BigF, BigA]=FullTrackDecoder(path)

clear BigX BigY BigF BigA
load(path) %automate file detection
[~,TOTtraces]=size(tracks);

tracksx=table({tracks.x}.','VariableNames',{'x'});
tracksy=table({tracks.y}.','VariableNames',{'y'});
tracksf=table({tracks.f}.','VariableNames',{'f'});
tracksA=table({tracks.A}.','VariableNames',{'A'});
i=1;
h=waitbar(0,'Processing Traces');

for k=1:TOTtraces
    waitbar(k/TOTtraces)
    if max(tracks(k).A)>600 %need to change later
        x=tracksx.x{k,1};
        y=tracksy.y{k,1};
        f=tracksf.f{k,1};
        A=tracksA.A{k,1};
        for j=1:length(x)
            if x(j)>0
                BigX(i,j)=x(j);
                BigY(i,j)=y(j);
                BigF(i,j)=f(j);
                BigA(i,j)=A(j);
            end
        end
        i=i+1;
    end
end
close(h)