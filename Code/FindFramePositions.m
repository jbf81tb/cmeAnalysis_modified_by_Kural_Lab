function [indices,positions]=FindFramePositions(fxyc,frame)

[~,~,a]=size(fxyc);
positions=[];
indices=[];
for i1=1:a
    found=find(fxyc(:,1,i1)==frame);
    if ~isempty(found)
        for i2=1:length(found)
        x=fxyc(found(i2),2,i1);
        y=fxyc(found(i2),3,i1);
        positions=[positions;[x y]];
        indices=[indices;[found(i2) i1]];
        end
    end
end