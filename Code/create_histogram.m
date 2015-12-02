function [ x, y ] = create_histogram (J)
%Creating a log-scaled histogram of image intensities.
[why,ex] = hist(double(J(:)),single(max(max(J))));
y = why(2:length(why));
x = ex(2:length(ex));
y = log(y+1);