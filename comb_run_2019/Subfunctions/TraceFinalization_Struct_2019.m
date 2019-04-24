function TraceFinalization_Struct_2019(fxycS,movie,framegap)


if isempty(fxycS), return; end

fxycS=RedoEndDetection_Struct(fxycS);
[fxycS,Data,used]=RedoEndDetection_Struct_2019(fxycS,movie,framegap);
fxycS=TrackSplitter_2019(fxycS,Data,used,framegap); %Add recommended splits for multi-traces

fxyc_struct=fxycS; %#ok<NASGU>
[save_loc, trace_name, ~] = fileparts(movie);
save(fullfile(save_loc,[trace_name,'.mat']), 'fxyc_struct','-v7.3')

end