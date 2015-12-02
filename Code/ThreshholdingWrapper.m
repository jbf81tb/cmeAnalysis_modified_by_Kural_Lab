clear all;
file='ColdblockBeginning_300.tif';
[masks, Thresh] = thresholding_development(file);
frames=length(imfinfo(file));
Bx=cell(1,frames);
By=Bx;
for i=1:frames
    J=imread(file,'Index',i);
    [bx,by,~] = thresholding(J,Thresh);
    maxsize=0;
    index=1;
    for j=1:length(bx(1,:))
        si=length(bx{1,j});
        if si>maxsize
            maxsize=si;
            index=j;
        end
    end
    Bx{1,i}=bx{1,index};
    By{1,i}=by{1,index};
end