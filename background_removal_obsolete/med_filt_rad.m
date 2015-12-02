function [ res_img ] = med_filt_rad( A, r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ischar(A)
    img = imread(A);
elseif isnumeric(A)&&ismatrix(A)
    img = A;
else
    error('Image must either be filename or 2D matrix');
end

sz1 = size(img,1);
sz2 = size(img,2);
res_img = zeros(sz1,sz2,'uint16');

d = 2*r+1;
filter = make_filter(r);
szf = sum(filter(:));

parfor i = 1:sz1
    for j = 1:sz2
        test_img = zeros(d);
        list = zeros(szf,1);
        for it = -r:r
            for jt = -r:r
                if i + it  <= 0
                    i1 = -(i+it-1);
                elseif i+it > sz1
                    i1 = 2*sz1 - (i+it);
                else
                    i1 = i+it;
                end
                if j + jt <= 0
                    i2 = -(j+jt-1);
                elseif j+jt > sz2
                    i2 = 2*sz2 - (j+jt);
                else
                    i2 = j+jt;
                end
                
                test_img(it+r+1,jt+r+1) = img(i1,i2);
            end
        end
        pz = test_img == 0; % possible zeros
        pz = pz.*filter;
        numz = length(find(pz));
        filt_img = test_img.*filter;
        nz_img = filt_img(filt_img>0);
        for inz = 1:length(nz_img)
            list(inz+numz) = nz_img(inz);
        end
        
        res_img(i,j) = round(median(list));
    end
end

end

function filter = make_filter(r)
d = 2*r+1;
filter = zeros(d);
for i = 1:d
    for j = 1:d
        if sqrt((i-1-r)^2+(j-1-r)^2)<(r+.5)
            filter(i,j) = 1;
        end
    end
end
end


