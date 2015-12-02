function [IVect,CVect]=CountEndsByFrame(fxyc,WindowRadius) %WindowRadius=0 only counts ends exactly on the specified frame

frames=max(max(fxyc(:,1,:)));
IVect=zeros(1,frames);
CVect=zeros(1,frames);
IPos=[];
CPos=[];
for i1=1:length(fxyc(1,1,:))
    used=find(fxyc(:,1,i1));
    framess=fxyc(used,1,i1);
    if ~isempty(framess)
    fi=framess(1);
    ii=find(fxyc(:,1,i1)==fi);
    xi=fxyc(ii(1),2,i1);
    yi=fxyc(ii(1),3,i1);
    ff=framess(length(framess));
    iff=find(fxyc(:,1,i1)==ff);
    xf=fxyc(iff(1),2,i1);
    yf=fxyc(iff(1),3,i1);
    if (fxyc(1,4,i1)==1 || fxyc(1,4,i1)==3 || fxyc(1,4,i1)==5) && (isempty(IPos) || ~ismember([fi xi yi],IPos,'rows'))
        IPos=[IPos;[fi xi yi]];
        for i2=-WindowRadius:WindowRadius
            if framess(1)+i2>0 && framess(1)+i2<=frames
                IVect(framess(1)+i2)=IVect(framess(1)+i2)+1;
                
            end
        end
    end
    if (fxyc(1,4,i1)==2 || fxyc(1,4,i1)==3 || fxyc(1,4,i1)==6) && (isempty(CPos) || ~ismember([ff xf yf],CPos,'rows'))
        CPos=[CPos;[ff xf yf]];
        for i2=-WindowRadius:WindowRadius
            if framess(1)+i2>0 && framess(1)+i2<=frames
                CVect(framess(1)+i2)=CVect(framess(1)+i2)+1;
            end
        end
    end
    end
end