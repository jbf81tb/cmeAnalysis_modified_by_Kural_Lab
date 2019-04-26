function TraceFinalization_2019(fxyc,file,framegap)


if isempty(fxyc), return; end

%fxyc=TrackSplitter_2019(fxyc); %split any traces that have suspicious drops in intensity in the middle or before the beginning or end
fxyc=RedoEndDetection(fxyc);
fxyc=RedoEndDetection_2019(fxyc,file,framegap);

Threshfxyc=fxyc; %#ok<NASGU>
[save_loc, trace_name, ~] = fileparts(file);
save(fullfile(save_loc,[trace_name,'.mat']), 'Threshfxyc','-v7.3')

end