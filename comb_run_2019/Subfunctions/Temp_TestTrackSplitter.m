load('E:\CME Superfolder\CME Data\190111_Analysis\50ms\Test4\orig_movies\cell015_C1.mat')
movie='E:\CME Superfolder\CME Data\190111_Analysis\50ms\Test4\orig_movies\cell015_C1.tif';
framegap=1;
fxycS=fxyc_struct;
[fxycS,Data,used]=RedoEndDetection_Struct_2019(fxycS,movie,framegap);
fxycS=TrackSplitter_2019(fxycS,Data,used,framegap);