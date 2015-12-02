ExCorr12=Excorrespondences;
[A1,A2]=size(ExCorr12);

FoundFrames1=[];
h=waitbar(0,'');
for i2=1:A2 %Record frames in which spot i2 is found in both plane 1 and 2
    waitbar(i2/A2)
    for i1=1:A1
        if ~isempty(ExCorr12{i1,i2})
            vect=ExCorr12{i1,i2};
            for i3=1:length(vect)
                FoundFrames1=[FoundFrames1 vect(i3)];
            end
        end
    end
end