for i9=1:6
    if i9==1
    movie='150220_3s_100p_50ms_1.tif';
end
if i9==2
    movie='150220_4s_100p_50ms_1.tif';
end
if i9==3
    movie='150220_4s_100p_60ms_1.tif';
end
if i9==4
    movie='150222_3s_100p_50ms_1001.tif';
end
if i9==5
    movie='150222_4s_100p_50ms.tif';
end
if i9==6
    movie='150222_4s_100p_60ms_1.tif';
end
MaxSectionSize0=500;
frames=length(imfinfo(movie));
sections=ceil(frames/(MaxSectionSize0-1));
SectionSize(i9)=ceil(frames/sections);
end