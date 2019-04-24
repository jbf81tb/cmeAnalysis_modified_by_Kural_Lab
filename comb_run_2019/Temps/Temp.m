movie='E:\CME Superfolder\CME Data\190111_Analysis\50ms\Test4\orig_movies\cell015_C1.tif';
framegap=1;
[fxycS,Data,used]=RedoEndDetection_Struct_2019(fxycSO,movie,framegap);
fxycS=TrackSplitter_2019(fxycS,Data,used,framegap);