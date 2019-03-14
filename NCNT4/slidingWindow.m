function [data, patch] = slidingWindow(image, patchSize, patchNum)
patch = zeros(prod(patchSize), prod(patchNum));
blockSize = size(image);

x = patchSize(2)/2;
y = patchSize(1)/2;

centx = x : 1 : (blockSize(2) - x);
centy = y : 1 : (blockSize(1) - y);

i = 1;
for j = 1 : patchNum(1)
    for k = 1 : patchNum(2)
        data = image(centy(j) - y + 1 : centy(j) + y, centy(k) - x + 1 : centy(k) + x);
        patch(:, i) = reshape(data, numel(data), 1);
        i = i + 1;
    end
end
end