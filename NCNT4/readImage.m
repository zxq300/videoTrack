function [p, imgSize, param1, img, opt] = readImage(rect, para, s_frames)

p = [rect(1) + rect(3)/2, rect(2) + rect(4)/2, rect(3), rect(4), 0];
imgSize = para.size;
param1 = [p(1), p(2), p(3)/imgSize(1), p(5), p(4)/p(3), 0];
param1 = affparam2mat(param1);
opt = para.opt;
opt.size = para.size;

img_color = imread(s_frames{1});

if size(img_color,3)==3
    img	= double(rgb2gray(img_color));
else
    img	= double(img_color);
end

end