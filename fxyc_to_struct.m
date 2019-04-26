function fxyc_struct = fxyc_to_struct(fxyc,varargin)
%FXYC_TO_STRUCT Converts Threshfxyc to a structure.
%    After executing comb_run a .mat file will be created containing a
% variable called Threshfxyc which is a 3D array. For some files this
% form of data storage was too memory intense and so this code compresses
% it into a structure. We had developed code which worked with either
% data type and so developed this code and it's foil, struct_to_fxyc, to
% easily switch between them.
%    Something this code does which its foil doesn't is fill in gaps with
% linear interpolation. Comb_run will delete frames of traces if they fall
% below the threshold, and this code will reset those frames using a linear
% interpolation of the frames abutting the gap. If one desires to work with
% the 3D array, it would be prudent to run Threshfxyc through this code and
% then convert it back. Each are very fast. 
%    This also excludes invalid traces (class 4 or "4's") by default. You
% can provide an argument to include them. I have never found them to
% contain biological data.
if nargin==1
    no4s=true;
elseif nargin==2
    if ischar(varargin{1})
        if strcmpi(varargin{1},'no4s')
            no4s = true;
        elseif strcmpi(varargin{1},'w4s')
            no4s = false;
        end
    elseif islogical(varargin{1})
        no4s = varargin{1};
    else
        no4s=true;
        fprintf('Invalid input. Proceeding with removal of 4''s\nRun again with false or "w4s" to include 4"s');
    end
end
fxyc_struct = struct('frame',[],'xpos',[],'ypos',[],'class',[],'int',[],'lt',[]);
if isempty(fxyc), return; end
i = 0; %need to count structure indices different from array indices.
for j = 1:size(fxyc,3)
    during = squeeze(fxyc(:,1,j)>0);
    if isempty(during), continue; end
    if no4s && (fxyc(1,4,j)==4 || fxyc(1,4,j)==7),continue; end
    i = i+1;
    fxyc_struct(i).frame = single(fxyc(during,1,j));%initial filling of structure
    fxyc_struct(i).xpos = single(fxyc(during,2,j));
    fxyc_struct(i).ypos = single(fxyc(during,3,j));
    fxyc_struct(i).class = single(fxyc(1,4,j));
    fxyc_struct(i).int = single(fxyc(during,5,j));
    if any(fxyc_struct(i).int==0) %prime for gap filling
        fixed = fxyc_struct(i).int~=0;
        fxyc_struct(i).frame = fxyc_struct(i).frame(fixed);
        fxyc_struct(i).xpos = fxyc_struct(i).xpos(fixed);
        fxyc_struct(i).ypos = fxyc_struct(i).ypos(fixed);
        fxyc_struct(i).int = fxyc_struct(i).int(fixed);
    end
    %somehow, empty frame still sneak in there. this removes them.
    if isempty(fxyc_struct(i).frame)
        fxyc_struct(i) = [];
        i = i-1;
        continue;
    end
    %also calculate lifetime for easy access later
    fxyc_struct(i).lt = fxyc_struct(i).frame(end)-fxyc_struct(i).frame(1)+1;
    %are there gaps?
    if fxyc_struct(i).lt == length(fxyc_struct(i).frame), continue; end
    %if so, do the gap filling
    gf_frame = zeros(fxyc_struct(i).lt,1);
    gf_int = zeros(fxyc_struct(i).lt,1);
    gf_xpos = zeros(fxyc_struct(i).lt,1);
    gf_ypos = zeros(fxyc_struct(i).lt,1);
    fo = fxyc_struct(i).frame-fxyc_struct(i).frame(1)+1;
    m = 1; %the gap might be more than one frame
    for k = 1:length(fxyc_struct(i).frame)-1
        for count = 0:(fo(k+1)-fo(k)-1)
            gf_frame(m) =fxyc_struct(i).frame(k)+count;
            gf_int(m) = fxyc_struct(i).int(k) + ...
                (fxyc_struct(i).int(k+1)-fxyc_struct(i).int(k))...
                *(count)/(fo(k+1)-fo(k));
            gf_xpos(m) = fxyc_struct(i).xpos(k) + ...
                (fxyc_struct(i).xpos(k+1)-fxyc_struct(i).xpos(k))...
                *(count)/(fo(k+1)-fo(k));
            gf_ypos(m) = fxyc_struct(i).ypos(k) + ...
                (fxyc_struct(i).ypos(k+1)-fxyc_struct(i).ypos(k))...
                *(count)/(fo(k+1)-fo(k));
            m = m+1;
        end
        if m == length(gf_frame)
            gf_frame(m) =fxyc_struct(i).frame(end);
            gf_int(m) = fxyc_struct(i).int(end);
            gf_xpos(m) = fxyc_struct(i).xpos(end);
            gf_ypos(m) = fxyc_struct(i).ypos(end);
        end
    end
    fxyc_struct(i).frame = single(gf_frame);
    fxyc_struct(i).xpos = single(gf_xpos);
    fxyc_struct(i).ypos = single(gf_ypos);
    fxyc_struct(i).int = single(gf_int);
end
end