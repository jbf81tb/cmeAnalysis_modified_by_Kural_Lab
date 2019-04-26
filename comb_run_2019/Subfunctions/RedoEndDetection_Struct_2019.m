function [fxycS,varargout]=RedoEndDetection_Struct_2019(fxycS,movie,framegap)
%Store ML cat in fxyc(:,6,:)
%Store ML F1 in fxyc(:,7,:)


[C,B,E,F1,varargout{1},varargout{2}]=ClassifyTraces_WHit_Struct(fxycS,movie,framegap);
for i=1:length(fxycS)
    fxycS(i).class=C(i);
    fxycS(i).classML=C(i);
    fxycS(i).goodness=F1(i);
end
