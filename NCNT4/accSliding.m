clear;
% I = imread('tire.tif');
%            imshow(I)
%            I2 = uint8(colfilt(I,[5 5],'sliding',@mean));
%            figure, imshow(I2)
%            
%        
img = imread('0156.jpg');
imshow(img);
img2 = colfilt(img, [6,6], 'sliding', @mean);
imshow(uint8(img2));