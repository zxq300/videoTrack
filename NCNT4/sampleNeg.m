function negTemp = sampleNeg(img, param1, imgSize, n, opt, width)
c = 1;
geom = affparam2geom(param1);

h = round(imgSize(2) * geom(3));
w = round(imgSize(1) * geom(3) * geom(5));

negTemp = zeros(prod(imgSize), n);
for i = 1 : n
    a = randn() * h / width;
    b = randn() * w / width;
    while abs(a) < h / 4 && abs(b) < w / 4
        a = randn() * h / width;
        b = randn() * w / width;
    end
    
%     offset = opt.offset .* randn(1, 6);
%     offset(1) = a;
%     offset(2) = b;
    temp = warpimg(img, affparam2mat(geom + [a b 0 0 0 0]), imgSize);
    negTemp(:, c) = temp(:);
    c = c + 1;
end

end