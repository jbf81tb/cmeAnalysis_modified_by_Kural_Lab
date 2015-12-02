function FoundFrames=FindBigSpots(ExCorr12,ExCorr32,frames) %Find spots that are found in all 3 planes because they are likely endozomes and not pits

[A1,A2]=size(ExCorr12);
[A3,~]=size(ExCorr32);
FoundFrames1=zeros(A2,frames);
FoundFrames2=zeros(A2,frames);
h=waitbar(0,'');
for i2=1:A2 %Record frames in which spot i2 is found in both plane 1 and 2
    waitbar(i2/A2)
    for i1=1:A1
        if ~isempty(ExCorr12{i1,i2})
            vect=ExCorr12{i1,i2};
            for i3=1:length(vect)
                FoundFrames1(i2,vect(i3))=1;
            end
        end
    end
end
close(h)
h=waitbar(0,'');
for i2=1:A2 %Record frames in which spot i2 is found in both plane 3 and 2
    waitbar(i2/A2)
    for i1=1:A3
        if ~isempty(ExCorr32{i1,i2})
            vect=ExCorr32{i1,i2};
            for i3=1:length(vect)
                FoundFrames2(i2,vect(i3))=1;
            end
        end
    end
end
close(h)
FoundFrames=and(FoundFrames1,FoundFrames2);