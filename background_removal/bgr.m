function img_bgr = bgr(A,avg_bg)
mbg = uint16(A - avg_bg); %MINUS BACKGROUND (depends on imaging condition)
med_img = med_filt_rad(A,20); %MEDIAN IMAGE
img_bgr = uint16(mbg) - med_img; % IMAGE, BACKGROUND REMOVED
end